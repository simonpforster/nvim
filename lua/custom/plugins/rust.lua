return {
    { "neovim/nvim-lspconfig" },

  -- Configure rust-tools
    {
      "simrat39/rust-tools.nvim",
    -- Specify dependencies explicitly if not handled elsewhere
    dependencies = { "neovim/nvim-lspconfig" },
    -- Lazy-load only when a rust file is opened
    ft = { "rust" },
    -- Basic configuration example (refer to rust-tools docs for options)
    opts = {
      tools = { -- rust-tools options
       -- Example: Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- Other rust-tools specific settings...
      },
      server = { -- Options passed to nvim-lspconfig's setup for rust_analyzer
        -- Example: Ensure crates extension is enabled in rust-analyzer
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
            assist = {
                importGranularity = "module",
                importPrefix = "by_crate",
            },
          },
        },
        -- Add capabilities if needed, often handled by LazyVim's LSP setup
        -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
        -- on_attach = function(client, bufnr) ... end,
      },
    },
    -- Or use a config function for more complex setup
    -- config = function(_, opts)
    --   require('rust-tools').setup(opts)
    -- end,
  }
}

