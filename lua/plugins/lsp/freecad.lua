-- Map FreeCAD extensions to proper filetypes
vim.filetype.add({
	extension = {
		FCMacro = "python", -- FreeCAD macro (Python code)
		FCScript = "python", -- FreeCAD script (Python code)
		FCMat = "yaml", -- FreeCAD material card
		FCParam = "xml", -- FreeCAD parameter file
		fctb = "json", -- CAM tool bit file (JSON format)
		fctl = "json", -- CAM tool library file (JSON format)
	},
})

-- FreeCAD ships its Python API as compiled modules in lib/, and each workbench
-- (Draft, Import/importDXF, Part, ...) lives in its own Mod/<Name>/ directory --
-- exactly how FreeCAD itself assembles sys.path. pyright needs every one of
-- those dirs on extraPaths, so we enumerate Mod/* instead of hard-coding them.
local freecad_root = "/usr/lib/freecad"

local extra_paths = {
	freecad_root .. "/lib", -- FreeCAD.so, FreeCADGui.so, Part.so, ...
	freecad_root .. "/Ext", -- PySide alias for PySide6
}

local mod_dir = freecad_root .. "/Mod"
if vim.fn.isdirectory(mod_dir) == 1 then
	for _, entry in ipairs(vim.fn.readdir(mod_dir)) do
		local full = mod_dir .. "/" .. entry
		if vim.fn.isdirectory(full) == 1 then
			table.insert(extra_paths, full)
		end
	end
end

-- Native LSP config, matching the rest of this config's LSP files.
-- (This setup is NOT the LazyVim distro, so `opts.servers` is never read.)
--
-- mason-lspconfig auto-enables whichever python server is installed. On this
-- machine that's `basedpyright`, which reads `basedpyright.analysis.*`; plain
-- `pyright` reads `python.analysis.*`. Register both so the settings land
-- regardless of which one mason installed.
local analysis = {
	extraPaths = extra_paths,
	useLibraryCodeForTypes = true, -- infer types from compiled modules
	-- basedpyright defaults to "recommended", which turns on the reportUnknown*
	-- family. FreeCAD's compiled modules carry no type info, so every call
	-- through them is "Unknown" -> hundreds of useless warnings. "standard" is
	-- stock-pyright behaviour: keeps real errors, drops the Unknown firehose.
	typeCheckingMode = "standard",
	-- Don't nag about missing .pyi stubs for first-party scripts (hershey_font)
	-- or the compiled FreeCAD modules.
	diagnosticSeverityOverrides = {
		reportMissingTypeStubs = "none",
	},
}

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = { analysis = analysis },
		python = { analysis = analysis },
	},
})

vim.lsp.config("pyright", {
	settings = {
		python = { analysis = analysis },
	},
})

-- Only enable the one that's actually installed; enabling a server whose `cmd`
-- isn't on PATH just logs a noisy warning. mason-lspconfig also auto-enables it.
vim.lsp.enable("basedpyright")

return {}
