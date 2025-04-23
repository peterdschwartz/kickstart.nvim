local M = {}

-- interval to notify in seconds
local interval = 60 * 60

function M.notify_journal()
  -- Create Floating Window
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = { '📝 Time to journal!', 'Use :e ~/Documents/.journal.md' }
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

  -- Map 'q' to close the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })

  -- Close the window after 10 seconds
  -- vim.defer_fn(function()
  --   vim.api.nvim_win_close(win, true)
  -- end, 10000)
end

-- Start the repeating timer
local timer = vim.loop.new_timer
timer:start(0, interval * 1000, vim.schedule_wrap(M.notify_journal))

return M
