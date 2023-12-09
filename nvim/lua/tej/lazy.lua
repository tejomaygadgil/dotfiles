local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
 
require("lazy").setup({
    {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme tokyonight-night]])
    end,
    opts = {},
    },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts={
        defaults = {
            initial_mode = "normal",
            }
        },
    }, 
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { 
                    "c", 
                    "lua", 
                    "vim",
                    "vimdoc",
                    "html",
                    "python",
                    "csv",
                    "css",
                    "json",
                    "latex",
                    "markdown",
                    "markdown_inline",
                    "php",
                    "r",
                    "sql",
                    "tsv",
                    "yaml",
                },

          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
    }, 
    {
        "mbbill/undotree",
    }
})
