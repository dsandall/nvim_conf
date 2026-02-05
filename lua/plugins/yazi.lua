return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- 👇 choose your own key mappings
    {
      "<leader>y",
      function()
        require("yazi").yazi()
      end,
      desc = "Open yazi at the current file",
    },
    {
      "<leader>Y",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open yazi at the current working directory",
    },
  },
  opts = {
    -- if you want to open yazi when nvim starts up, set this to `true`
    open_for_directories = false,
    -- enable these if you are using the latest version of yazi
    use_ya_for_events_reading = true,
    use_yazi_client_id_flag = true,
    -- reveal the file under the cursor when opening yazi
    open_file_function = function(chosen_file, config)
      -- change cwd to the directory of the selected file
      local dir = vim.fn.fnamemodify(chosen_file.path, ":h")
      vim.cmd("cd " .. dir)
      -- open the file
      vim.cmd("edit " .. chosen_file.path)
    end,
  },
}