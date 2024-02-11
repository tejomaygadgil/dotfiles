local M = {}

local function get_last_char(file_name)
  return file_name:sub(-4, -4)
end

local function get_luh_name(file_name)
  return file_name:sub(1, -4)
end

local function get_parent(file_name)
  local regex = tonumber(get_last_char(file_name)) and "(%d+)$" or "(%a+)$"
  return get_luh_name(file_name):gsub(regex, "")
end

local function is_md(file_name)
  return file_name:sub(-3) == ".md"
end

local function is_root(file_name)
  return get_luh_name(file_name):match("^%d+$")
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
    vim.cmd('edit ' .. get_luh_name(current_file) .. new_char .. '.md')
  end
end

function M.move_left()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local last_char = get_last_char(current_file)
    if tonumber(last_char) then
      if last_char ~= '0' then
        local new_char = tostring(tonumber(last_char) - 1)
        local new_file = current_file:sub(1, -5) .. new_char .. '.md'
        vim.cmd('edit ' .. new_file)
      end
    else
      if last_char ~= 'a' then
        local new_char = string.char(last_char:byte() - 1)
        local new_file = current_file:sub(1, -5) .. new_char .. '.md'
        vim.cmd('edit ' .. new_file)
      end
    end
  end
end

function M.move_right()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local last_char = get_last_char(current_file)
    if tonumber(last_char) then
      local new_char = tostring(tonumber(last_char) + 1)
      local new_file = current_file:sub(1, -5) .. new_char .. '.md'
      vim.cmd('edit ' .. new_file)
    else
      if last_char ~= 'z' then
        local new_char = string.char(last_char:byte() + 1)
        local new_file = current_file:sub(1, -5) .. new_char .. '.md'
        vim.cmd('edit ' .. new_file)
      end
    end
  end
end

function M.make()
  local current_file = vim.fn.bufname()
  local current_index = get_luh_name(current_file)
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
