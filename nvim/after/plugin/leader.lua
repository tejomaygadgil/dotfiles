-- Set up leader key
vim.g.mapleader = ' '

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

-- Gitsigns / Fugitive
vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gd', ':Gitsigns reset_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gb', ':Git blame<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gr', ':Git reset<CR>')
vim.keymap.set('n', '<leader>gR', ':Git reset --hard<CR>')
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>')
vim.keymap.set('n', '<leader>gP', ':Git push<CR>')
vim.keymap.set('n', '<leader>gPf', ':Git push --force-with-lease<CR>')

-- InspectTree
-- vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree)

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
