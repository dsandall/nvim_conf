local function is_ssh()
  -- true if operating over SSH (remote connection)
  return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
end

-- Sync clipboard between OS and Neovim.
if is_ssh() then
  -- osc52 is a non-standard, but widely implemented terminal control
  -- sequence which allows applications to write data into the system clipboard
  -- by sending special escape-codes to the terminal emulator.
  --
  -- Use this to enable the ability to provide system-clipboard
  -- interaction with neovim over remote SSH connections
  local osc52 = require("vim.ui.clipboard.osc52")
  local copy_to_unnamedplus = osc52.copy("+")
  local copy_to_unnamed = osc52.copy("*")

  -- Create autocmd to copy yanked text to system clipboard
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      -- Only handle yank operations, not delete or change
      if vim.v.event.operator == "y" then
        copy_to_unnamedplus(vim.v.event.regcontents)
        copy_to_unnamed(vim.v.event.regcontents)
      end
    end,
  })
end

vim.opt.clipboard = "unnamedplus"
