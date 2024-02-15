require("tej.lazy")

-- Open telescope if no files are opened.
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argv(0) == "" then
--       require("telescope.builtin").oldfiles()
--     end
--   end,
-- })

local lz = require('tej.lz')

vim.keymap.set('n', '<A-j>', lz.move_down, { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', lz.move_up, { noremap = true, silent = true })
vim.keymap.set('n', '<A-h>', lz.move_left, { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', lz.move_right, { noremap = true, silent = true })
vim.keymap.set('n', '<A-n>', lz.new, { noremap = true, silent = true })
vim.keymap.set('n', '<A-c>', lz.children, { noremap = true, silent = true })
vim.keymap.set('n', '<A-y>y', lz.copy_index, { noremap = true, silent = true })
vim.keymap.set('n', '<A-x>', lz.cut, { noremap = true, silent = true })
vim.keymap.set('n', '<A-y>', lz.copy, { noremap = true, silent = true })
vim.keymap.set('n', '<A-p>', lz.paste, { noremap = true, silent = true })
vim.keymap.set('n', '<A-f>', lz.next_zet, { noremap = true, silent = true })
vim.keymap.set('n', '[z', lz.prev_zet, { noremap = true, silent = true })
vim.keymap.set('n', ']z', lz.next_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() vim.cmd('edit $ZET/0.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() vim.cmd('edit $ZET/0b.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() vim.cmd('edit $ZET/0c.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-4>', function() vim.cmd('edit $ZET/0d.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-5>', function() vim.cmd('edit $ZET/r.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-6>', function() vim.cmd('edit $ZET/w.md') end, { noremap = true, silent = true })
