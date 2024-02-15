local M = {}

local function get_last_char(file_name)
  return file_name:sub(-4, -4)
end

local function get_index(file_name)
  return file_name:sub(1, -4)
end

local function get_parent(file_name)
  local regex = tonumber(get_last_char(file_name)) and "(%d+)$" or "(%a+)$"
  return get_index(file_name):gsub(regex, "")
end

local function get_leaf(file_name)
  local regex = tonumber(get_last_char(file_name)) and "(.*)%a(%d+)$" or "(.*)%d(%a+)$"
  return get_index(file_name):gsub(regex, "%2")
end

local function add_to_index(index, amount)
  if tonumber(index) then
    return tostring(math.max(tonumber(index) + amount, 0))
  else
    return string.char(math.min(math.max(index:byte() + amount, 97), 122))
  end
end

local function is_md(file_name)
  return file_name:sub(-3) == ".md"
end

local function is_root(file_name)
  return get_index(file_name):match("^%d+$")
end

function M.move_up()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    if not is_root(current_file) then
      vim.cmd('edit ' .. get_parent(current_file) .. '.md')
    end
  end
end

function M.move_down()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local new_char = tonumber(get_last_char(current_file)) and 'b' or '1'
    vim.cmd('edit ' .. get_index(current_file) .. new_char .. '.md')
  end
end

function M.move_left()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local parent = is_root(current_file) and '' or get_parent(current_file)
    vim.cmd('edit ' .. parent .. add_to_index(get_leaf(current_file), -1) .. '.md')
  end
end

function M.move_right()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local parent = is_root(current_file) and '' or get_parent(current_file)
    vim.cmd('edit ' .. parent .. add_to_index(get_leaf(current_file), 1) .. '.md')
  end
end

function M.new()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local current_index = get_index(current_file)
    vim.cmd('norm i# ' .. current_index .. '\r\r## ')
    if is_root(current_file) then
      vim.cmd('norm GA')
    else
      local parent_index = get_parent(current_file)
      vim.cmd('norm i\r\r[[' .. parent_index .. ']]')
      vim.cmd('norm kkA')
    end
  end
end

function M.children()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local ts = require('telescope.builtin')
    ts.live_grep({ default_text = '\\[' .. get_index(current_file) .. '\\]' })
  end
end

function M.copy_index()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    vim.cmd('norm gg0wyiw' .. vim.api.nvim_replace_termcodes('<C-o>', true, true, true))
  end
end

function M.copy()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    vim.cmd('norm gg0VGy')
  end
end

function M.cut()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    M.copy()
    vim.cmd("call delete(expand('%')) | bdelete!")
  end
end

function M.paste()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    M.new()
    vim.cmd('norm Gp2jdd5kVp6jVd4kpdf]xk$JjV2jdgg0')
  end
end

function M.next_zet()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    vim.fn.search('[[')
  end
end

function M.prev_zet()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    vim.fn.search('[[', 'b')
  end
end

return M
