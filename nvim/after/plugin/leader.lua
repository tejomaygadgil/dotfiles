-- BM@leader

-- Leader
vim.g.mapleader = ' '

-- nvim
vim.keymap.set('n', '<leader>cd', ':cd %:h <CR>')
vim.keymap.set('n', '<leader>bd', ':b#|bd#<CR>')
vim.keymap.set('n', '<leader>nw', ':set wrap!<CR>')
vim.keymap.set('n', '<leader>nn', ':NoNeckPain<CR>')
vim.keymap.set('n', '<leader>mp', ':MarkdownPreviewToggle<CR>')
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Buffer
vim.keymap.set('n', '<leader>tn', ':term<CR>')
vim.keymap.set('n', '<leader>ts', ':sp +term<CR>')
vim.keymap.set('n', '<leader>tt', ':vs +term<CR>')
vim.keymap.set('n', '<leader>tT', ':tabe +term<CR>')
vim.keymap.set('n', '<leader>en', ':Oil<CR>')
vim.keymap.set('n', '<leader>es', ':sp +Oil<CR>')
vim.keymap.set('n', '<leader>ee', ':vs +Oil<CR>')
vim.keymap.set('n', '<leader>eE', ':tabe +Oil<CR>')

-- Run
vim.keymap.set('n', '<leader>rp', '<Esc>:w<CR>:!clear;ipython %<CR>')
vim.keymap.set('n', '<leader>rr', '<Esc>:w<CR>:!clear;Rscript %<CR>')
vim.keymap.set('n', '<leader>rs', '<Esc>:w<CR>:!scheme --quiet < %<CR>')

-- Slime
-- http://www.nicksun.fun/linux/2020/07/06/slime-time.html
vim.g.slime_cell_delimiter = "#```"
-- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/advanced.md#mappings
vim.keymap.set('n', '<c-c>c', '<Plug>SlimeSendCell')
vim.keymap.set('n', '<c-c>l', '<Plug>SlimeLineSend')
vim.keymap.set('n', '[`', function() vim.fn.search('```\\w', 'b') vim.cmd('norm zz') end, { noremap = true, silent = true })
vim.keymap.set('n', ']`', function() vim.fn.search('```\\w') vim.cmd('norm zz') end, { noremap = true, silent = true })

-- Git
vim.keymap.set('n', '<leader>gl', ':Git log<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gg', ':LazyGit<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gb', ':Git blame -C<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gu', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gR', ':Gitsigns reset_buffer<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gd', ':Gitsigns toggle_deleted<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gw', ':Gitsigns toggle_word_diff<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gl', ':Gitsigns toggle_linehl<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gn', ':Gitsigns toggle_numhl<CR>')

-- Telescope
local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>fb', ts.buffers)
vim.keymap.set('n', '<leader>fs', ts.live_grep)
vim.keymap.set('n', '<leader>ft', ':Telescope buffers<CR>iterm://<Esc>')
vim.keymap.set('n', '<leader>fm', function() ts.git_status({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fe', ts.oldfiles)
vim.keymap.set('n', '<leader>ff', function() ts.find_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fw', function() ts.live_grep({ cwd = os.getenv("WORKSPACE") }) end)
vim.keymap.set('n', '<leader>fb', function() ts.live_grep({ grep_open_files = true }) end)
-- vim.keymap.set('n', '<leader>tt', ':Telescope<CR>')
