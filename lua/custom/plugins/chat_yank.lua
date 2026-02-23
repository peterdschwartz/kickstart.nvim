local M = {}

-- Simple heuristic to detect code fences like ```lua or ```
local function is_fence(line)
  return line:match '^```'
end

-- Find the fenced block around the current line in the current buffer
local function find_block(bufnr, cursor_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local n = #lines
  if n == 0 then
    return nil
  end

  -- Neovim API is 1-based for cursor line; convert to 1-based
  local cur = cursor_line

  -- Move up to find opening fence
  local start_fence = nil
  for l = cur, 1, -1 do
    if is_fence(lines[l]) then
      start_fence = l
      break
    end
  end
  if not start_fence then
    return nil
  end

  -- Move down to find closing fence
  local end_fence = nil
  for l = start_fence + 1, n do
    if is_fence(lines[l]) then
      end_fence = l
      break
    end
  end
  if not end_fence then
    return nil
  end

  -- Content is between the fences (exclusive)
  local content_start = start_fence + 1
  local content_end = end_fence - 1
  if content_start > content_end then
    return nil
  end

  return {
    start_line = content_start,
    end_line = content_end,
  }
end

-- Yank the fenced block under cursor into a register (default "+")
function M.yank_block(register)
  register = register or '+'
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1]

  local block = find_block(bufnr, cursor_line)
  if not block then
    vim.notify('No fenced code block found', vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(
    bufnr,
    block.start_line - 1, -- 0-based
    block.end_line, -- end is exclusive
    false
  )

  -- Set register
  local text = table.concat(lines, '\n')

  -- Set register
  vim.fn.setreg(register, text)

  -- Trigger highlight-on-yank manually
  vim.highlight.on_yank({
    higroup = 'IncSearch',
    timeout = 200,
    on_visual = false,
    -- Required fields
    regname = register,
    regtype = 'v',
    bufnr = bufnr,
    -- Use the actual range we yanked
    lnum = block.start_line,
    col = 1,
    end_lnum = block.end_line,
    end_col = 1,
  })


  vim.notify('Yanked code block to register "' .. register .. '"', vim.log.levels.INFO)
end

-- Yank all fenced blocks in the current buffer (concatenated)
function M.yank_all_blocks(register)
  register = register or '+'
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local n = #lines

  local chunks = {}
  local inside = false
  local start_line = nil

  for i = 1, n do
    if is_fence(lines[i]) then
      if not inside then
        inside = true
        start_line = i + 1
      else
        -- closing fence
        local end_line = i - 1
        if start_line and start_line <= end_line then
          local block_lines = vim.list_slice(lines, start_line, end_line)
          table.insert(chunks, table.concat(block_lines, '\n'))
        end
        inside = false
        start_line = nil
      end
    end
  end

  if #chunks == 0 then
    vim.notify('No fenced code blocks in buffer', vim.log.levels.WARN)
    return
  end

  local text = table.concat(chunks, '\n\n')
  vim.fn.setreg(register, text)
  vim.notify('Yanked ' .. #chunks .. ' code block(s) to register "' .. register .. '"', vim.log.levels.INFO)
end

-- Setup keymaps
function M.setup(opts)
  opts = opts or {}
  local map = opts.map or {}

  -- Yank block under cursor
  local yank_block_key = map.yank_block or '<leader>yc'
  vim.keymap.set('n', yank_block_key, function()
    M.yank_block(opts.register or '+')
  end, { desc = 'Yank fenced code block under cursor' })

  -- Yank all blocks in buffer
  local yank_all_key = map.yank_all or '<leader>yC'
  vim.keymap.set('n', yank_all_key, function()
    M.yank_all_blocks(opts.register or '+')
  end, { desc = 'Yank all fenced code blocks in buffer' })
end

return M
