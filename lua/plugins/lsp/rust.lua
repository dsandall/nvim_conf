-- Explicitly enable rust-analyzer. We use the rustup-provided binary now that
-- Mason's rust-analyzer package/link is disabled/removed.
vim.lsp.enable("rust_analyzer")

return {}
