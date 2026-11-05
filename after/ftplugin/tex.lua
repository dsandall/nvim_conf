-- Prose-first tex buffers. Source style (thesis STYLE.md): one sentence per line, <100 chars,
-- blank line = paragraph. That makes paragraphs hard to see, so mark where each one starts,
-- and fold comment runs + llmnotes blocks out of the way (za toggles, zR opens all).

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0 -- never hard-wrap while typing
vim.opt_local.colorcolumn = "100"
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.signcolumn = "yes:2"
vim.opt_local.concealcursor = "" -- the line under the cursor always shows raw source

local ns = vim.api.nvim_create_namespace("tex_prose")
vim.api.nvim_set_hl(0, "TexParaStart", { link = "Special", default = true })

local function is_comment(l)
	return l:match("^%s*%%") ~= nil
end
local function is_blank(l)
	return l:match("^%s*$") ~= nil
end
-- lines that are structure, not prose: \section, \begin{..}, \label, \caption, \item, ...
local function is_structure(l)
	return l:match("^%s*\\%a+") ~= nil and not l:match("^%s*\\llm{") and not l:match("^%s*\\texttt")
		and not l:match("^%s*\\textbf") and not l:match("^%s*\\emph")
end

-- fold level per line: comment lines and llmnotes bodies are 1, prose is 0
local function fold_levels(lines)
	local folds, in_notes = {}, false
	for i, l in ipairs(lines) do
		if l:match("^%s*\\begin{llmnotes}") then
			in_notes = true
		end
		folds[i] = (in_notes or is_comment(l)) and 1 or 0
		if l:match("^%s*\\end{llmnotes}") then
			in_notes = false
		end
	end
	return folds
end

local function mark_paragraphs(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local folds, prev_prose_break, in_table = fold_levels(lines), true, false
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	for i, l in ipairs(lines) do
		if l:match("\\begin{tabular") then
			in_table = true
		elseif l:match("\\end{tabular") then
			in_table = false
		end
		if folds[i] == 1 or in_table then
			-- comments and table rows are invisible to paragraph structure
		elseif is_blank(l) or is_structure(l) then
			prev_prose_break = true
		else
			if prev_prose_break then
				vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { sign_text = "¶", sign_hl_group = "TexParaStart" })
			end
			prev_prose_break = false
		end
	end
end

-- foldexpr runs per line; rescan only when the buffer changed (keyed on changedtick), so
-- folds track edits without re-closing the ones you opened
local fold_cache = {}
function _G.TexProseFold(lnum)
	local buf = vim.api.nvim_get_current_buf()
	local tick = vim.b[buf].changedtick
	local c = fold_cache[buf]
	if not c or c.tick ~= tick then
		c = { tick = tick, folds = fold_levels(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) }
		fold_cache[buf] = c
	end
	return c.folds[lnum] or 0
end

function _G.TexProseFoldText()
	local first = vim.fn.getline(vim.v.foldstart):gsub("^%s*", "")
	local n = vim.v.foldend - vim.v.foldstart + 1
	return ("  ⋯ %d lines: %s"):format(n, first:sub(1, 70))
end

local buf = vim.api.nvim_get_current_buf()
mark_paragraphs(buf)
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.TexProseFold(v:lnum)"
vim.opt_local.foldtext = "v:lua.TexProseFoldText()"
vim.opt_local.foldlevel = 0
vim.opt_local.fillchars:append({ fold = " " })

local group = vim.api.nvim_create_augroup("tex_prose_" .. buf, { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufEnter" }, {
	group = group,
	buffer = buf,
	callback = function()
		mark_paragraphs(buf)
	end,
})
