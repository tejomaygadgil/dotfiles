local M = {}

local function get_parent(file_name)
  local regex = tonumber(file_name:sub(-4, -4)) and "(%d+)$" or "(%a+)$"
  return file_name:sub(1, -4):gsub(regex, "")
end

local function is_md(file_name)
  return file_name:sub(-3) == ".md"
end

local function is_root(file_name)
  return file_name:sub(1, -4):match("^%d+$")
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
    local last_char = current_file:sub(-4, -4)
    local new_char = tonumber(last_char) and 'b' or '1'
    local new_file = current_file:sub(1, -4) .. new_char .. '.md'
    vim.cmd('edit ' .. new_file)
  end
end

function M.move_left()
  local current_file = vim.fn.bufname()
  if is_md(current_file) then
    local last_char = current_file:sub(-4, -4)
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
    local last_char = current_file:sub(-4, -4)
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
  local current_index = vim.fn.bufname():sub(1, -4)
  local parent_index = vim.fn.bufname():sub(1, -5)
  vim.cmd('norm i# ' .. current_index .. '\r\r## ')
  if #parent_index > 0 then
    vim.cmd('norm i\r\r[[' .. parent_index .. ']]')
    vim.cmd('norm kkA')
  else
    vim.cmd('norm GA')
  end
end

function M.todo()
  local ts = require('telescope.builtin')
  ts.live_grep({ default_text = "\\[0b\\]" })
end

return M
