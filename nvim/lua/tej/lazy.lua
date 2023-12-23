local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  {
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
      opts = {},
    },
    {
      'numToStr/Comment.nvim', opts = {}
    },
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
          untracked = { text = '▎' },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          map('n', ']h', gs.next_hunk, 'Next Hunk')
          map('n', '[h', gs.prev_hunk, 'Prev Hunk')
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
        end,
      },
    },
    {
      "kdheepak/lazygit.nvim",
      -- optional for floating window border decoration
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        local configs = require('nvim-treesitter.configs')

        configs.setup({
          ensure_installed = {
            'c',
            'lua',
            'vim',
            'vimdoc',
            'html',
            'python',
            'csv',
            'css',
            'json',
            'latex',
            'markdown',
            'markdown_inline',
            'php',
            'r',
            'sql',
            'tsv',
            'yaml',
          },

          sync_install = true,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
        })
      end,
    },
    {
      'mbbill/undotree',
    },
    {
      'jpalardy/vim-slime',
    },
    -- LSP
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      lazy = true,
      config = false,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
      }
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        { 'L3MON4D3/LuaSnip' }
      },
    },
  },
  {
    checker = { enabled = true }, -- Check for updates
  }
)

---
-- LSP setup
---
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({
    buffer = bufnr,
    omit = { '^n', '^p' },
  })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'pyright',
    'ruff_lsp',
  },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      -- (Optional) configure lua language server
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

---
-- Autocompletion config
---
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
