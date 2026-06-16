return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = true,
              check = {
                command = 'clippy',
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
              assist = {
                importGranularity = 'module',
                importPrefix = 'by_crate',
              },
            },
          },
        },
      }
    end,
  },
}
