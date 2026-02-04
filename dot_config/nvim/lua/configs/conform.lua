local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt", "goimports" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
