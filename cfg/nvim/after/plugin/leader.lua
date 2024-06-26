-- BM@leader
-- Set up leader key
vim.g.mapleader = ' '

-- Dictionary
vim.keymap.set('n', '<leader>d', 'yiW:new | r !~/dict.sh <C-r>"<CR>gg')

-- Buffer commands
vim.keymap.set('n', '<leader>br', ':e!<CR>')
vim.keymap.set('n', '<leader>ba', ':arga<CR>')
vim.keymap.set('n', '<leader>bd', ':argd<CR>')
vim.keymap.set('n', '<leader>bD', ':b#|bd#<CR>')

-- File explorer
vim.keymap.set('n', '<leader>en', ':Oil<CR>')
vim.keymap.set('n', '<leader>eS', ':sp +Oil<CR>')
vim.keymap.set('n', '<leader>eV', ':vs +Oil<CR>')
-- Shortcuts
local NOTES = os.getenv('NOTES')
vim.keymap.set('n', '<leader>eM', ':e Makefile<CR>')
vim.keymap.set('n', '<leader>es', ':Oil ' .. NOTES .. '/swe/sicp/<CR>')
vim.keymap.set('n', '<leader>ez', ':Oil ' .. NOTES .. '/zet/<CR>')

-- Eval
vim.keymap.set('n', '<leader>em', ":make!<CR>")
vim.keymap.set('v', '<leader>ep', ":'<,'>!python -c 'import sys; exec(sys.stdin.read())'<CR>")
vim.keymap.set('v', '<leader>es', ":'<,'>!scheme --quiet < /dev/stdin<CR>")

-- Open terminal
vim.keymap.set('n', '<leader>tn', ':term<CR>')
vim.keymap.set('n', '<leader>tm', ':term make<CR>')
vim.keymap.set('n', '<leader>tS', ':sp +term<CR>')
vim.keymap.set('n', '<leader>tV', ':vs +term<CR>')

-- No-neck-pain
vim.keymap.set('n', '<leader>nn', ':NoNeckPain<CR>')

-- Inline Latex rendering
-- Set wrap, cf.
-- https://github.com/jbyuki/nabla.nvim/issues/35#issuecomment-1719055459
local function nabla()
  vim.cmd('lua require"nabla".toggle_virt({autogen = true})')
end
vim.keymap.set('n', '<leader>fn', nabla)

-- Markdown preview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreviewToggle<CR>')

-- Toggle line wrap
vim.keymap.set('n', '<leader>fw', ':set wrap!<CR>')

-- Telescope
local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function() ts.find_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fg', function() ts.git_files({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fm', function() ts.git_status({ hidden = true, }) end)
vim.keymap.set('n', '<leader>fe', ts.oldfiles)
vim.keymap.set('n', '<leader>fs', ts.live_grep)
vim.keymap.set('n', '<leader>bs', function() ts.live_grep({ grep_open_files = true }) end)
vim.keymap.set('n', '<leader>bt', ':Telescope buffers<CR>iterm://<Esc>')
vim.keymap.set('n', '<leader>fb', ts.buffers)
vim.keymap.set('n', '<leader>th', ts.help_tags, { desc = "help" })
vim.keymap.set('n', '<leader>tt', ':Telescope<CR>')
vim.keymap.set('n', '<leader>ts', ts.symbols)

-- GPT
vim.keymap.set("n", "<leader>cn", ":GpChatNew<cr>")
vim.keymap.set("n", "<leader>cg", ":GpChatRespond<cr>")
vim.keymap.set("n", "<leader>cd", ":GpChatDelete<cr>")
vim.keymap.set("n", "<leader>ce", ":GpChatToggle<cr>")
vim.keymap.set("n", "<leader>cc", ":GpChatFinder<cr>")
vim.keymap.set("n", "<leader>cp", "V:<C-u>'<,'>GpChatPaste<cr>")
vim.keymap.set("v", "<leader>cp", ":<C-u>'<,'>GpChatPaste<cr>")

-- Easy picker
-- vim.keymap.set('n', '<leader>fg', ':Easypick unstaged_changes<CR>')

-- Lazygit / Gitsigns / Fugitive
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>')
vim.keymap.set('n', '<leader>gf', ':Git<CR>')
vim.keymap.set('n', '<leader>gd', ':Git diff<CR>')
vim.keymap.set('n', '<leader>gl', ':Git log<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gC', ':Git commit --amend<CR>')
vim.keymap.set('n', '<leader>gr', ':Git reset<CR>')
vim.keymap.set('n', '<leader>ga', ':Git add %<CR>')
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
-- http://www.nicksun.fun/linux/2020/07/06/slime-time.html
vim.g.slime_cell_delimiter = "```"
vim.keymap.set('n', 'sc', '<Plug>SlimeConfig')
vim.keymap.set('n', 'ss', '<Plug>SlimeSendCell')
vim.keymap.set('x', 'ss', '<Plug>SlimeRegionSend')
vim.keymap.set('n', 'sl', '<Plug>SlimeLineSend')
vim.keymap.set('n', 'sp', '<Plug>SlimeParagraphSend')
vim.keymap.set('n', 's`', '<Plug>SlimeParagraphSend')
vim.keymap.set('n', '[`', function() vim.fn.search('```\\w', 'b') vim.cmd('norm zz') end, { noremap = true, silent = true })
vim.keymap.set('n', ']`', function() vim.fn.search('```\\w') vim.cmd('norm zz') end, { noremap = true, silent = true })

-- InspectTree
-- vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree)

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
