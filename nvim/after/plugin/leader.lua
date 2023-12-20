-- Set up leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- InspectTree
vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree, {})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', function()
   builtin.find_files({
        hidden = true,
    })
end, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>t', vim.cmd.InspectTree, {})
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {})

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {})