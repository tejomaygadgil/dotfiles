-- Set up leader key
vim.g.mapleader = ' '

-- No-neck-pain
vim.keymap.set('n', '<leader>nn', ':NoNeckPain<CR>')

-- File explorer
vim.keymap.set('n', '<leader>e', ':Neotree toggle source=last<CR>')

-- Telescope
local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function() ts.find_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fe', ts.oldfiles)
vim.keymap.set('n', '<leader>fs', ts.live_grep)
vim.keymap.set('n', '<leader>fb', ts.buffers)
vim.keymap.set('n', '<leader>th', ts.help_tags, { desc = "help" })
vim.keymap.set('n', '<leader>tt', ':Telescope<CR>')

-- GPT
vim.keymap.set("n", "<leader>cn", ":GpChatNew<cr>")
vim.keymap.set("n", "<leader>cg", ":GpChatRespond<cr>")
vim.keymap.set("n", "<leader>cd", ":GpChatDelete<cr>")
vim.keymap.set("n", "<leader>ce", ":GpChatToggle<cr>")
vim.keymap.set("n", "<leader>cc", ":GpChatFinder<cr>")
vim.keymap.set("n", "<leader>cp", "V:<C-u>'<,'>GpChatPaste<cr>")
vim.keymap.set("v", "<leader>cp", ":<C-u>'<,'>GpChatPaste<cr>")

-- Easy picker
vim.keymap.set('n', '<leader>fg', ':Easypick unstaged_changes<CR>')

-- Lazygit / Gitsigns / Fugitive 
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>')
vim.keymap.set('n', '<leader>gf', ':Git<CR>')
vim.keymap.set('n', '<leader>gd', ':Git diff<CR>')
vim.keymap.set('n', '<leader>gl', ':Git log<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gC', ':Git commit --amend<CR>')
vim.keymap.set('n', '<leader>gr', ':Git reset<CR>')
vim.keymap.set('n', '<leader>gR', ':Git reset --hard<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gb', ':Git blame -C<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gS', ':Gitsigns stage_buffer<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hR', ':Gitsigns reset_buffer<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hu', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hd', ':Gitsigns toggle_deleted<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hw', ':Gitsigns toggle_word_diff<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hl', ':Gitsigns toggle_linehl<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hn', ':Gitsigns toggle_numhl<CR>')

-- Slime
vim.keymap.set('x', 'ss', '<Plug>SlimeRegionSend')
vim.keymap.set('n', 'ss', '<Plug>SlimeParagraphSend')

-- InspectTree
-- vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree)

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
