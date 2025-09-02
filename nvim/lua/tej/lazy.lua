-- BM@lazy-head
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
    "kana/vim-textobj-user",
    "tpope/vim-repeat",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "tpope/vim-speeddating",
    "samjwill/nvim-unception",
    "numToStr/Comment.nvim",
    "jpalardy/vim-slime",
    "chrisbra/csv.vim",
    "mbbill/undotree",
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      opts = {
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      },
      config = function(_, opts)
        local tokyonight = require "tokyonight"
        tokyonight.setup(opts)
        tokyonight.load()
      end,
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function()
        require("lazy").load { plugins = { "markdown-preview.nvim" } }
        vim.fn["mkdp#util#install"]()
      end,
    },
    {
      "shortcuts/no-neck-pain.nvim",
      version = "*",
    },
    {
      'stevearc/oil.nvim',
      opts = {
        extra_scp_args = { '-O' },
        silence_scp_warning = true,
        default_file_explorer = false,
        view_options = {
          show_hidden = true,
        },
        win_options = {
          signcolumn = "yes:2",
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = false,
          ["<C-h>"] = false,
          ["<C-t>"] = false,
          ["<C-p>"] = false,
          ["<C-c>"] = false,
          ["<C-l>"] = false,
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gi"] = "actions.copy_entry_path",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      },
      -- Optional dependencies
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "refractalize/oil-git-status.nvim",
      dependencies = {
        "stevearc/oil.nvim",
      },
      config = true,
    },
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        -- numhl = true,
        -- linehl = true,
        -- word_diff = true,
        -- show_deleted = true,
        current_line_blame = true,
        signs = {
          add = { text = 'A' },
          change = { text = 'C' },
          delete = { text = 'D' },
          topdelete = { text = 'T' },
          changedelete = { text = 'C' },
          untracked = { text = 'U' },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          -- Navigate hunks
          map('n', ']h', gs.next_hunk, 'Next Hunk')
          map('n', '[h', gs.prev_hunk, 'Prev Hunk')

          -- Text object
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
      'nvim-telescope/telescope.nvim',
      tag = '0.1.5',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-symbols.nvim',
      },
      opts = {
        defaults = {
          initial_mode = 'normal',
          layout_strategy = 'vertical',
          preview_cutoff = 0,
          -- https://github.com/nvim-telescope/telescope.nvim/issues/855
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--smart-case",
            '--glob', -- this flag allows you to hide exclude these files and folders from your search 👇
            '!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock}',
          },
        },
      },
    },
  },
  {
    checker = { enabled = true }, -- Check for updates
  }
)

require("no-neck-pain").setup({
  buffers = {
    colors = {
      blend = -1,
      background = "#ffffff",
    }
  },
})


-- Auto update Lazy
vim.api.nvim_create_autocmd("VimEnter", { callback = function() require "lazy".update({ show = false }) end })
