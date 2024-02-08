local M = {}

function M.move_up()
  local current_file = vim.fn.bufname()
  if current_file:sub(-3) == ".md" then
    local new_file = current_file:sub(1, -5) .. '.md'
    vim.cmd('edit ' .. new_file)
  end
end

-- Function to move the cursor down
function M.move_down()
  local current_file = vim.fn.bufname()
  if current_file:sub(-3) == ".md" then
    local last_char = current_file:sub(-4, -4)
    local new_char = tonumber(last_char) and 'b' or '1'
    local new_file = current_file:sub(1, -4) .. new_char .. '.md'
    vim.cmd('edit ' .. new_file)
  end
end

-- Function to move the cursor left
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

-- Function to move the cursor right
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

return M
