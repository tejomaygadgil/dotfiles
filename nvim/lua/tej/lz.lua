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

function M.make()
  local current_file = vim.fn.bufname()
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

function M.todo()
  local ts = require('telescope.builtin')
  ts.live_grep({ default_text = "\\[0b\\]" })
end

return M
