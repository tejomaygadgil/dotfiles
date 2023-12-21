-- Set up leader key
vim.g.mapleader = ' '

-- File explorer
vim.keymap.set('n', '<leader>e', vim.cmd.Ex)

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    hidden = true,
  })
end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- Open file explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- InspectTree
vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree, {})

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {})
