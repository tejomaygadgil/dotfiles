local M = {}

function M.move_up()
  local current_file = vim.fn.bufname()
  if current_file:sub(-3) == ".md" then
    if not current_file:sub(1, -4):match("^%d+$") then
      if tonumber(current_file:sub(-4, -4)) then
        local new_file = current_file:sub(1, -4):gsub("(%d+)$","") .. ".md"
        vim.cmd('edit ' .. new_file)
      else
        local new_file = current_file:sub(1, -4):gsub("(%a+)$","") .. ".md"
        vim.cmd('edit ' .. new_file)
      end
    end
  end
end

function M.move_down()
  local current_file = vim.fn.bufname()
  if current_file:sub(-3) == ".md" then
    local last_char = current_file:sub(-4, -4)
    local new_char = tonumber(last_char) and 'b' or '1'
    local new_file = current_file:sub(1, -4) .. new_char .. '.md'
    vim.cmd('edit ' .. new_file)
  end
end

function M.move_left()
  local current_file = vim.fn.bufname()
  if current_file:sub(-3) == ".md" then
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
  if current_file:sub(-3) == ".md" then
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
