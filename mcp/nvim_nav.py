#!/usr/bin/env python3
"""nvim-nav: a tiny MCP server that lets Claude Code drive the user's live Neovim.

Claude Code's IDE integration only exposes `getDiagnostics` to the model, so it
cannot open a file / jump to a line on its own. This server fills that gap by
exposing an `open_in_nvim` tool that talks to the running Neovim over its RPC
socket (via `nvim --server <sock> --remote-send`).

Neovim publishes its socket path to a pointer file on startup (see the
claudecode.lua plugin config). No third-party packages required -- this speaks
newline-delimited JSON-RPC 2.0 over stdio directly.
"""

import json
import os
import subprocess
import sys

CACHE = os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache"))
NAV_DIR = os.path.join(CACHE, "nvim", "claude-nav")

TOOL = {
    "name": "open_in_nvim",
    "description": (
        "Open a file in the user's live Neovim and jump to a line/region so they "
        "can look at it. Use this to show the user code you're referring to. "
        "Prefer absolute paths. If line and end_line are both given, the range is "
        "visually highlighted; with only line, the cursor jumps there and centers."
    ),
    "inputSchema": {
        "type": "object",
        "properties": {
            "path": {
                "type": "string",
                "description": "Path to the file to open (absolute preferred).",
            },
            "line": {
                "type": "integer",
                "description": "1-based line to jump to and center.",
            },
            "end_line": {
                "type": "integer",
                "description": "Optional end line; with `line`, highlights the range.",
            },
        },
        "required": ["path"],
    },
}


def hash_str(s):
    """djb2, 32-bit -- MUST match hash_str() in lua/plugins/all/claudecode.lua."""
    h = 5381
    for b in s.encode("utf-8"):
        h = (h * 33 + b) % 4294967296
    return "%08x" % h


def project_root():
    """This Claude's project root: git toplevel of its cwd, else the cwd.

    Claude Code launches MCP servers with the project cwd, so this identifies
    which Neovim to drive when several projects are open at once.
    """
    cwd = os.getcwd()
    try:
        out = subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            timeout=3,
        )
        if out.returncode == 0 and out.stdout.strip():
            return out.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        pass
    return cwd


def _read(path):
    try:
        with open(path, "r") as f:
            return f.read().strip() or None
    except OSError:
        return None


def read_socket():
    # Prefer the pointer for this Claude's own project root.
    sock = _read(os.path.join(NAV_DIR, hash_str(project_root())))
    if sock:
        return sock
    # Fallback: the most recently written pointer (covers the single-project case
    # and any cwd mismatch between Claude and Neovim).
    try:
        files = [os.path.join(NAV_DIR, f) for f in os.listdir(NAV_DIR)]
        files = [f for f in files if os.path.isfile(f)]
        if files:
            return _read(max(files, key=os.path.getmtime))
    except OSError:
        pass
    return None


def open_in_nvim(args):
    path = args.get("path")
    if not path:
        return "Error: `path` is required."
    line = args.get("line")
    end_line = args.get("end_line")

    sock = read_socket()
    if not sock:
        return (
            "Error: no Neovim socket found under %s. Is Neovim running (in this "
            "project) with the claudecode.lua config loaded?" % NAV_DIR
        )

    epath = path.replace(" ", r"\ ")  # escape spaces for the Ex command line
    keys = "<C-\\><C-N>"  # ensure normal mode
    if isinstance(line, int) and line > 0:
        keys += ":edit +%d %s<CR>" % (line, epath)
        if isinstance(end_line, int) and end_line > line:
            keys += "V%dGzz" % end_line  # visual-line select the region, center
        else:
            keys += "zz"
    else:
        keys += ":edit %s<CR>" % epath

    try:
        proc = subprocess.run(
            ["nvim", "--server", sock, "--remote-send", keys],
            capture_output=True,
            text=True,
            timeout=5,
        )
    except FileNotFoundError:
        return "Error: `nvim` not found on PATH."
    except subprocess.TimeoutExpired:
        return "Error: timed out talking to Neovim at %s." % sock

    if proc.returncode != 0:
        return "Error from nvim (%s): %s" % (sock, (proc.stderr or "").strip())

    where = path if line is None else "%s:%d" % (path, line)
    if isinstance(end_line, int) and isinstance(line, int) and end_line > line:
        where = "%s-%d" % (where, end_line)
    return "Opened %s in Neovim." % where


def respond(id_, result=None, error=None):
    msg = {"jsonrpc": "2.0", "id": id_}
    if error is not None:
        msg["error"] = error
    else:
        msg["result"] = result
    sys.stdout.write(json.dumps(msg) + "\n")
    sys.stdout.flush()


def handle(msg):
    method = msg.get("method")
    id_ = msg.get("id")

    if method == "initialize":
        client_proto = (msg.get("params") or {}).get("protocolVersion", "2024-11-05")
        respond(
            id_,
            {
                "protocolVersion": client_proto,
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "nvim-nav", "version": "0.1.0"},
            },
        )
    elif method == "tools/list":
        respond(id_, {"tools": [TOOL]})
    elif method == "tools/call":
        params = msg.get("params") or {}
        name = params.get("name")
        if name == "open_in_nvim":
            text = open_in_nvim(params.get("arguments") or {})
            respond(id_, {"content": [{"type": "text", "text": text}]})
        else:
            respond(id_, error={"code": -32602, "message": "Unknown tool: %s" % name})
    elif method == "ping":
        respond(id_, {})
    elif id_ is not None:
        # Unknown request -> method not found. Notifications (no id) are ignored.
        respond(id_, error={"code": -32601, "message": "Method not found: %s" % method})


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        try:
            handle(msg)
        except Exception as e:  # never crash the server on one bad message
            if msg.get("id") is not None:
                respond(msg["id"], error={"code": -32603, "message": str(e)})


if __name__ == "__main__":
    main()
