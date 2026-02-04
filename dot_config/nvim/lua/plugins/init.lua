return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "go", "gomod", "gosum",
        "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "bash", "fish",
      },
    },
  },
}
