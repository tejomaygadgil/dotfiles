-- Set up leader key
vim.g.mapleader = ' '

-- SICP testing
vim.keymap.set('n', 'st', "'t<Plug>SlimeParagraphSend")
vim.keymap.set('n', 'sg', "'g<Plug>SlimeParagraphSend")
vim.keymap.set('n', 'ss', "'s<Plug>SlimeParagraphSend")

-- File explorer
vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- Telescope
local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function() ts.find_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fe', ts.oldfiles)
vim.keymap.set('n', '<leader>fs', ts.live_grep)
vim.keymap.set('n', '<leader>fb', ts.buffers)
vim.keymap.set('n', '<leader>h', ts.help_tags, { desc = "help" })
vim.keymap.set('n', '<leader>tt', ':Telescope<CR>')

-- GPT
vim.keymap.set("n", "<leader>cn", ":GpChatNew<cr>")
vim.keymap.set("n", "<leader>ce", ":GpChatToggle<cr>")
vim.keymap.set("n", "<leader>cc", ":GpChatFinder<cr>")
vim.keymap.set("n", "<leader>cp", "V:<C-u>'<,'>GpChatPaste<cr>")
vim.keymap.set("v", "<leader>cp", ":<C-u>'<,'>GpChatPaste<cr>")

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
