local M = {}

-- 1. Helper functions
-- Primitives
local function get_last_char(file_name)
  return file_name:sub(-4, -4)
end

local function get_file_name(file_name)
  return file_name:sub(1, -4)
end

local function is_last_char_num(file_name)
  return tonumber(get_last_char(file_name))
end

-- Selectors
local function get_current_file()
  return vim.fn.bufname()
end

local function get_zet_index()
  return get_file_name(get_current_file())
end

local function get_parent()
  local file_name = get_current_file()
  local regex = is_last_char_num(file_name) and "(%d+)$" or "(%a+)$"
  return get_file_name(file_name):gsub(regex, "")
end

local function get_next_char()
  return is_last_char_num(get_current_file()) and 'b' or '1'
end

local function get_leaf()
  local file_name = get_current_file()
  local regex = is_last_char_num(file_name) and "(.*)%a(%d+)$" or "(.*)%d(%a+)$"
  return get_file_name(file_name):gsub(regex, "%2")
end

-- Predicates
local function is_md()
  return get_current_file():sub(-3) == ".md"
end

local function is_root()
  return get_file_name(get_current_file()):match("^%d+$")
end

-- 2. Movement functions
-- Helper
local function add_to_index(index, amount)
  if tonumber(index) then
    return tostring(math.max(tonumber(index) + amount, 0))
  else
    return string.char(math.min(math.max(index:byte() + amount, 97), 122))
  end
end

-- Core movement functions
function M.move_up()
  if is_md() then
    if not is_root() then
      vim.cmd('edit ' .. get_parent() .. '.md')
    end
  end
end

function M.move_down()
  if is_md() then
    vim.cmd('edit ' .. get_zet_index() .. get_next_char() .. '.md')
  end
end

function M.move_left()
  if is_md() then
    local parent = is_root() and '' or get_parent()
    vim.cmd('edit ' .. parent .. add_to_index(get_leaf(), -1) .. '.md')
  end
end

function M.move_right()
  if is_md() then
    local parent = is_root() and '' or get_parent()
    vim.cmd('edit ' .. parent .. add_to_index(get_leaf(), 1) .. '.md')
  end
end

-- 3. Editing functions
function M.new()
  if is_md() then
    vim.cmd('norm i# ' .. get_zet_index() .. '\r\r## ')
    if is_root() then
      vim.cmd('norm GA')
    else
      vim.cmd('norm i\r\r[[' .. get_parent() .. ']]')
      vim.cmd('norm kkA')
    end
  end
end

function M.copy_index()
  if is_md() then
    -- TODO: Use get_zet_index()
    vim.cmd('norm gg0wyiw' .. vim.api.nvim_replace_termcodes('<C-o>', true, true, true))
  end
end

function M.copy_zet()
  if is_md() then
    vim.cmd('norm gg0VGy')
  end
end

function M.cut_zet()
  if is_md() then
    M.copy_zet()
    vim.cmd("call delete(expand('%')) | bdelete!")
  end
end

function M.paste_zet()
  if is_md() then
    M.new()
    vim.cmd('norm Gp2jdd5kVp6jVd4kpdf]xk$JjV2jdgg0') -- xD
  end
end

-- 4. Navigation functions
function M.bookmark(mark, dir)
  local ts = require('telescope.builtin')
  ts.live_grep({
    default_text = mark,
    cwd = os.getenv(dir)
  })
end

function M.bm_notes() M.bookmark('BM' .. '@', 'NOTES') end

function M.bm_cfg() M.bookmark('BM' .. '@', 'DOTFILES') end

function M.todo() M.bookmark('@' .. 'TODO', 'ZET') end

function M.fav() M.bookmark('FAV'..'@', 'NOTES') end

function M.search_zet() M.bookmark('', 'ZET') end

function M.children() M.bookmark('\\['..get_zet_index()..'\\]', 'ZET') end

function M.search_tag(tag, forward)
  if is_md() then
    if forward then
      vim.fn.search(tag)
    else
      vim.fn.search(tag, 'b')
    end
  vim.cmd('norm zz')
  end
end

function M.next_zet() M.search_tag('[[', true) end

function M.prev_zet() M.search_tag('[[', false) end

function M.next_link() M.search_tag('](', true) end

function M.prev_link() M.search_tag('](', true) end

-- BM@lz
-- 5. Keymaps
-- Leader
vim.keymap.set('n', '<leader>fz', M.search_zet, { noremap = true, silent = true })
-- Movement
vim.keymap.set('n', '<A-j>', M.move_down, { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', M.move_up, { noremap = true, silent = true })
vim.keymap.set('n', '<A-h>', M.move_left, { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', M.move_right, { noremap = true, silent = true })
-- Editing
vim.keymap.set('n', '<A-n>', M.new, { noremap = true, silent = true })
vim.keymap.set('n', '<A-y>', M.copy_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-x>', M.cut_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-p>', M.paste_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-i>', M.copy_index, { noremap = true, silent = true })
-- Navigation
vim.keymap.set('n', '<A-c>', M.children, { noremap = true, silent = true })
vim.keymap.set('n', '<A-f>', M.next_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-S-f>', M.prev_zet, { noremap = true, silent = true })
vim.keymap.set('n', '<A-g>', function() vim.cmd('norm gd') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-CR>', function() vim.cmd('norm gd') end, { noremap = true, silent = true })
vim.keymap.set('n', '[z', M.prev_zet, { noremap = true, silent = true })
vim.keymap.set('n', ']z', M.next_zet, { noremap = true, silent = true })
vim.keymap.set('n', '[l', M.prev_link, { noremap = true, silent = true })
vim.keymap.set('n', ']l', M.next_link, { noremap = true, silent = true })
-- Bookmarks
vim.keymap.set('n', '<A-0>', function() vim.cmd('edit $ZET/0.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', M.todo, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() vim.cmd('edit $ZET/0b.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() vim.cmd('edit $ZET/0c.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-4>', function() vim.cmd('edit $ZET/0d.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-5>', function() vim.cmd('edit $ZET/r.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-6>', function() vim.cmd('edit $ZET/w.md') end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-7>', M.bm_cfg, { noremap = true, silent = true })
vim.keymap.set('n', '<A-8>', M.fav, { noremap = true, silent = true })
vim.keymap.set('n', '<A-m>', M.bm_notes, { noremap = true, silent = true })
vim.keymap.set('n', '<A-u>', function() vim.cmd('edit $ZET/m.md') end, { noremap = true, silent = true })

return M
