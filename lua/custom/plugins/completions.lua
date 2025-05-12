-- Inside a file like lua/plugins/completion.lua

return {
  {
    -- Shorten messages
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.opt.shortmess:append 'c'
      end,
    },

    -- Update time for CursorHold
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.api.nvim_set_option('updatetime', 300)
      end,
    },

    -- Diagnostics configuration
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.cmd 'set signcolumn=yes'
        vim.api.nvim_create_autocmd('CursorHold', {
          pattern = '*',
          callback = function()
            vim.diagnostic.open_float(nil, { focusable = false })
          end,
        })
      end,
    },

    'hrsh7th/nvim-cmp',
    -- Load nvim-cmp lazily, only when needed (e.g., entering insert mode)
    event = 'InsertEnter',
    -- Define dependencies: these are the cmp sources and the snippet engine
    dependencies = {
      -- Sources
      'hrsh7th/cmp-nvim-lsp', -- LSP source
      'hrsh7th/cmp-nvim-lua', -- nvim Lua source
      'hrsh7th/cmp-nvim-lsp-signature-help', -- LSP signature help source
      'hrsh7th/cmp-vsnip', -- Snippet source for vsnip
      'hrsh7th/cmp-path', -- Path source
      'hrsh7th/cmp-buffer', -- Buffer source

      -- Snippet Engine
      'hrsh7th/vim-vsnip', -- Snippet engine compatible with cmp-vsnip
    },
    -- Configuration function: This is essential for nvim-cmp
    config = function()
      local cmp = require 'cmp'
      local types = require 'cmp.types.cmp' -- For formatting kind

      -- Setup nvim-cmp.
      cmp.setup {
        snippet = {
          -- REQUIRED - you must specify a snippet engine integration
          -- This tells nvim-cmp how to expand snippets from cmp-vsnip
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body) -- Use vim-vsnip expansion
          end,
        },
        window = {
          -- Add borders to the completion and documentation windows
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          -- Standard nvim-cmp mappings (feel free to customize)
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger completion
          ['<C-e>'] = cmp.mapping.abort(), -- Close completion window
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Confirm selection (select=true accepts highlighted)

          -- Example: Use Tab for navigation or confirmation if desired
          -- ['<Tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   -- You could add vsnip jump integration here if needed
          --   -- elseif vim.fn["vsnip#available"](1) == 1 then
          --   --  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true), "")
          --   else
          --     fallback() -- Fallback to default Tab behavior
          --   end
          -- end, { "i", "s" }), -- Apply mapping in insert and select modes
          -- ['<S-Tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   -- elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          --   --  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
          --   else
          --     fallback() -- Fallback to default Shift-Tab behavior
          --   end
          -- end, { "i", "s" }),
        },
        -- Define the sources to use for completion, in order of priority
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'vsnip' }, -- Use the vsnip source
          { name = 'path' },
        }, {
          -- Buffer source is usually lower priority
          { name = 'buffer', keyword_length = 5 }, -- Only show buffer completion for words >= 5 chars
        }),

        -- Optional: Add custom formatting with icons (requires a Nerd Font)
        formatting = {
          format = function(entry, vim_item)
            -- Define icons for different completion kinds (requires Nerd Fonts)
            local icons = {
              Text = '',
              Method = '',
              Function = '',
              Constructor = '',
              Field = '',
              Variable = '',
              Class = 'ﴯ',
              Interface = '',
              Module = '',
              Property = 'ﰠ',
              Unit = '',
              Value = '',
              Enum = '',
              Keyword = '',
              Snippet = '',
              Color = '',
              File = '',
              Reference = '',
              Folder = '',
              EnumMember = '',
              Constant = '',
              Struct = '',
              Event = '',
              Operator = '',
              TypeParameter = '',
              Default = '',
            }
            vim_item.kind = string.format('%s %s', icons[vim_item.kind] or icons.Default, vim_item.kind)
            -- Optional: Add source name to menu
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
              vsnip = '[Snp]',
              buffer = '[Buf]',
              path = '[Pth]',
              nvim_lsp_signature_help = '[Sig]',
            })[entry.source.name]
            return vim_item
          end,
        },
      }
    end,

    opts = function(_, opts)
      vim.list_extend(opts.completion.completeopt, { 'menuone', 'noselect', 'noinsert' })
      return opts
    end,
  },
}
