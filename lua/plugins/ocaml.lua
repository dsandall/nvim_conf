-- requires opam, ocmllsp, ocamlformat

-- query current bin path for current switch (version/env) of ocaml
local handle = io.popen("opam var bin")
local opam_bin = handle:read("*a"):gsub("%s+", "") -- remove newline
handle:close()

return {
  require("lspconfig").ocamllsp.setup({

    -- load the lsp from the bin directory
    cmd = { opam_bin .. "/ocamllsp" },

    -- attach function runs when LSP starts for a buffer
    on_attach = function(client, bufnr)
      -- enable formatting if the server supports it
      if client.server_capabilities.documentFormattingProvider then
        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  }),
}
