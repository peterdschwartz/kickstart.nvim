local M = {}

M.journal_path = vim.fn.expand '~/Documents/.journal.md'
M.interval = 60 * 60 -- seconds

function M.get_last_edit_time()
  local file = io.open(M.journal_path, 'r')
  if not file then
    return nil
  end

  for line in file:lines() do
    local date_str = line:match 'Last Check:%s*(.+)'
    if date_str then
      file:close()
      -- convert to timestamp
      local pattern = '(%d+)%-(%d+)%-(%d+)%s+(%d+):(%d+):(%d+)'
      local y, m, d, H, M_, S = date_str:match(pattern)
      if y then
        return os.time { year = y, month = m, day = d, hour = H, min = M_, sec = S }
      end
    end
  end
  file:close()
  return nil
end

function M.check_journal()
  local last_edit = M.get_last_edit_time()
  local now = os.time()

  if not last_edit or (now - last_edit) > M.interval then
    M.notify_journal()
  end
end

function M.notify_journal()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = { '📝 Time to journal!' }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 30
  local height = #lines
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = 2,
    col = vim.o.columns - width - 2,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, false, opts)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })
end

function M.update_journal_timestamp()
  local path = M.journal_path
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 then
    vim.notify('Journal Buffer not loaded', vim.logl.levels.WARN, {})
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local updated = false

  for i, line in ipairs(lines) do
    if line:match 'Last Check:' then
      local now = os.date '%Y-%m-%d %H:%M:%S'
      lines[i] = '- Last Check: ' .. now
      updated = true
      break
    end
  end

  if updated then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.notify 'Journal timestamp updated! 🌠'
  else
    vim.notify('No "Last Check:" line found in journal.', vim.log.levels.INFO)
  end
end

function M.open_journal()
  local path = M.journal_path

  -- Check if it's already open in a buffer
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bufnr) == path then
      vim.api.nvim_set_current_buf(bufnr)
      vim.notify 'Switched to open journal buffer ✏️'
      return
    end
  end

  -- Open it in a new buffer if not already open
  vim.cmd('edit ' .. vim.fn.fnameescape(path))
  vim.notify 'Opened journal 📓'
end

return M
