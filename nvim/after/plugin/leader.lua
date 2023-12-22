-- Set up leader key
vim.g.mapleader = ' '

-- File explorer
vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- Telescope
local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function() ts.find_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fe', ts.oldfiles)
vim.keymap.set('n', '<leader>s', ts.live_grep)
vim.keymap.set('n', '<leader>b', ts.buffers)
vim.keymap.set('n', '<leader>tt', ':Telescope<CR>')

-- Easy picker
vim.keymap.set('n', '<leader>ge', ':Easypick unstaged_changes<CR>')

-- Lazygit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>')

-- Git signs
local gs = require('gitsigns')
vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk)
vim.keymap.set('n', '<leader>gS', gs.stage_buffer)
vim.keymap.set('n', '<leader>gR', gs.reset_buffer)
vim.keymap.set('n', '<leader>gp', gs.preview_hunk)
vim.keymap.set('n', '<leader>gb', function() gs.blame_line({ full = true, }) end)
vim.keymap.set('n', '<leader>gd', gs.diffthis)
vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end)

-- InspectTree
-- vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree)

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
