require("tej.lazy")
require("tej.lz")

-- New tab
vim.api.nvim_set_keymap('n', '<A-t>', ':tabe<CR><C-o>', { noremap = true, silent = true })
