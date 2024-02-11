require("tej.lazy")

-- Open telescope if no files are opened.
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argv(0) == "" then
--       require("telescope.builtin").oldfiles()
--     end
--   end,
-- })

local lzet = require('tej.lzet')

vim.keymap.set('n', 'zj', lzet.move_down, { noremap = true, silent = true })
vim.keymap.set('n', 'zk', lzet.move_up, { noremap = true, silent = true })
vim.keymap.set('n', 'zh', lzet.move_left, { noremap = true, silent = true })
vim.keymap.set('n', 'zl', lzet.move_right, { noremap = true, silent = true })
vim.keymap.set('n', 'zm', lzet.make, { noremap = true, silent = true })
vim.keymap.set('n', 'zt', lzet.todo, { noremap = true, silent = true })
