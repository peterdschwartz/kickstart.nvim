local M = {}

function is_renderable(char)
  local width = vim.fn.strdisplaywidth(char)
  -- Filter out unprintable or fallback characters (width 0 or 1)
  return width > 0
end
-- Function to generate lines of characters from codepoint range
function M.generate_glyph_lines(start_codepoint, end_codepoint, header)
  header = header or ''
  local lines = {}
  if header ~= '' then
    table.insert(lines, header)
  end
  local num_per_line = 5
  local line = ''
  for codepoint = start_codepoint, end_codepoint do
    local ok, char = pcall(vim.fn.nr2char, codepoint)
    if ok and is_renderable(char) then
      local display_width = vim.fn.strdisplaywidth(char)
      line = line .. char .. ' '
      if vim.fn.strchars(line) >= num_per_line * 2 then
        table.insert(lines, line)
        line = ''
      end
    end
  end
  if line ~= '' then
    table.insert(lines, line)
  end

  return lines
end

function M.range_emoji_picker()
  -- List of emojis (add your faves here)
  -- local emojis = {
  --   '📝',
  --   '📖',
  --   '💡',
  --   '✅',
  --   '🔥',
  --   '✨',
  --   '🔍',
  --   '📅',
  --   '🕑',
  --   '📦',
  --   '📌',
  --   '🔒',
  --   '🔓',
  --   '📂',
  --   '📎',
  --   '📊',
  --   '📈',
  --   '📉',
  -- }
  -- Pick a UTF-8 range (example: Misc Symbols and Pictographs)

  local start_devicons = 0xE700
  local end_devicons = 0xE7AA
  local emoji_table = {}

  local lines = M.generate_glyph_lines(start_devicons, end_devicons, '~~Devicons !!!')
  vim.list_extend(emoji_table, lines)

  local start_pt = 0x1F300
  local end_pt = 0x1F4FF
  lines = M.generate_glyph_lines(start_pt, end_pt, '~~Glyphs')
  vim.list_extend(emoji_table, lines)

  start_pt = 0xEA60
  end_pt = 0xEEFF
  lines = M.generate_glyph_lines(start_pt, end_pt, '~~Codicons')
  vim.list_extend(emoji_table, lines)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, emoji_table)

  local height = math.min(#lines, vim.o.lines - 4)
  local width = 20
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = 2,
    col = vim.o.columns - width - 3,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.bo[buf].buftype = 'nofile'

  -- Key mappings
  -- q to quit
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })

  -- <CR> to insert selected emoji
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
    noremap = true,
    silent = true,
    callback = function()
      local linenr = vim.api.nvim_win_get_cursor(win)[1]
      local line = vim.api.nvim_buf_get_lines(buf, linenr - 1, linenr, false)[1]
      local parts = vim.split(line, ' ')
      local char = parts[2]
      print(vim.inspect(line))
      vim.api.nvim_put({ char }, 'c', true, true)
    end,
  })

  -- Clean options
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
end

return M
