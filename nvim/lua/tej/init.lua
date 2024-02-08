require("tej.lazy")

-- Open telescope if no files are opened.
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argv(0) == "" then
--       require("telescope.builtin").oldfiles()
--     end
--   end,
-- })

local dntinet = require('tej.dntinet')

vim.keymap.set('n', 'zj', dntinet.move_down, { noremap = true, silent = true })
vim.keymap.set('n', 'zk', dntinet.move_up, { noremap = true, silent = true })
vim.keymap.set('n', 'zh', dntinet.move_left, { noremap = true, silent = true })
vim.keymap.set('n', 'zl', dntinet.move_right, { noremap = true, silent = true })
vim.keymap.set('n', 'zT', ':!ls | sort -V<CR>', { noremap = true, silent = true })
