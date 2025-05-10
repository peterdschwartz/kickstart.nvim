local M = {}

-- Namespace for extmarks so we can clear highlights easily
local ns_id = vim.api.nvim_create_namespace 'regex_preview_ns'

-- Create floating window config helper
local function create_float(opts)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  return buf, win
end

-- Live preview function
function M.regex_live_preview()
  -- Get visual selection lines
  local start_pos = vim.fn.getpos("'<")[2]
  local end_pos = vim.fn.getpos("'>")[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_pos - 1, end_pos, false)

  -- Create view window
  local view_opts = {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.6),
    height = #lines + 2,
    row = 3,
    col = math.floor(vim.o.columns * 0.2),
    style = 'minimal',
    border = 'rounded',
  }
  local view_buf, view_win = create_float(view_opts)
  vim.api.nvim_buf_set_lines(view_buf, 0, -1, false, lines)

  -- Create prompt window
  local prompt_opts = {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.6),
    height = 1,
    row = 1,
    col = math.floor(vim.o.columns * 0.2),
    style = 'minimal',
    border = 'single',
  }
  local prompt_buf, prompt_win = create_float(prompt_opts)
  vim.bo[prompt_buf].buftype = 'prompt'
  vim.bo[prompt_buf].bufhidden = 'wipe'
  vim.fn.prompt_setprompt(prompt_buf, 'Regex: ')

  local label_len = 8
  -- Highlight matches based on regex
  local function highlight_matches()
    -- Clear existing highlights
    vim.api.nvim_buf_clear_namespace(view_buf, ns_id, 0, -1)

    local input = vim.fn.getline '.'
    if #input < label_len then
      print 'nothing'
      return
    end
    input = input:sub(label_len)
    input = vim.trim(input)

    local ok, regex = pcall(vim.regex, input)
    if not ok then
      print('Invalid regex: ' .. input)
      return
    end

    -- Highlight matches in view buffer
    for lnum, line in ipairs(lines) do
      local s, e = regex:match_str(line)
      if s and e then
        vim.api.nvim_buf_add_highlight(view_buf, ns_id, 'Search', lnum - 1, s, e)
      end
    end
  end

  local function yank_matches()
    -- Clear register a
    -- Get text from the prompt buffer explicitly
    local text = table.concat(vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false), '')

    vim.fn.setreg('a', '')
    if #text < label_len then
      print 'nothing'
      return
    end
    text = text:sub(label_len)
    text = vim.trim(text)

    local ok, regex = pcall(vim.regex, text)
    if not ok then
      print('Invalid regex: ' .. text)
      return
    end

    -- Highlight matches in view buffer
    for lnum, line in ipairs(lines) do
      local s, e = regex:match_str(line)
      if s and e then
        local current = vim.fn.getreg 'a'
        local newreg = current .. line:sub(s + 1, e) .. '\n'
        print('Yanked: ', newreg)
        vim.fn.setreg('a', newreg)
      end
    end
    vim.api.nvim_win_close(view_win, true)
    vim.api.nvim_win_close(prompt_win, true)
  end

  vim.fn.prompt_setcallback(prompt_buf, function()
    yank_matches()
  end)

  -- Setup autocmd to update on every keystroke in prompt
  vim.api.nvim_create_autocmd('TextChangedI', {
    buffer = prompt_buf,
    callback = highlight_matches,
  })

  vim.api.nvim_buf_set_keymap(prompt_buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(view_win, true)
      vim.api.nvim_win_close(prompt_win, true)
    end,
  })

  -- Start insert mode in prompt
  vim.api.nvim_set_current_win(prompt_win)
  vim.cmd 'startinsert'
end

return M
