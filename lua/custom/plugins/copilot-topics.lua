local M = {}

-- Directory where chat transcripts will live
local base_dir = vim.fn.stdpath("data") .. "/copilot-chats"

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Prompt for a topic and save current CopilotChat buffer to a file
function M.save_current_chat_as_topic()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype

  if ft ~= "copilot-chat" then
    vim.notify("Not in a CopilotChat buffer\nName = "..name .."\nFiletype = "..vim.bo[bufnr].filetype, vim.log.levels.WARN)
    return
  end

  ensure_dir(base_dir)

  vim.ui.input({ prompt = "Topic name: " }, function(input)
    if not input or input == "" then
      return
    end

    -- create a simple slug
    local slug = input:gsub("%s+", "-"):gsub("[^%w%-_]", ""):lower()
    if slug == "" then
      vim.notify("Invalid topic name", vim.log.levels.ERROR)
      return
    end

    local filename = string.format("%s/%s-%s.md", base_dir, os.date("%Y%m%d-%H%M%S"), slug)

    -- name buffer & write
    vim.api.nvim_buf_set_name(bufnr, filename)
    vim.bo[bufnr].buftype = ""          -- normal file
    vim.bo[bufnr].swapfile = true
    vim.bo[bufnr].bufhidden = "hide"
    vim.bo[bufnr].modifiable = true

    vim.cmd("write")
    vim.notify("Saved chat as " .. filename, vim.log.levels.INFO)
  end)
end

function M.pick_chat_topic()
  local dir = vim.fn.stdpath("data") .. "/copilot-chats"
  require("telescope.builtin").find_files({
    prompt_title = "Copilot Chat Topics",
    cwd = dir,
  })
end

-- Setup keymaps
function M.setup(opts)
  opts = opts or {}
  local map = opts.map or {}

  -- Yank block under cursor
  local save_chat = map.save_chat or '<leader>cs'
  vim.keymap.set('n', save_chat, function()
    M.save_current_chat_as_topic()
  end, { desc = 'Save copilot chat to stdpath("data")/copilot-chats/' })

  -- Yank all blocks in buffer
  local pick = map.pick_chat_topic or '<leader>ct'
  vim.keymap.set('n', pick, function()
    M.pick_chat_topic()
  end, { desc = 'select from saved chat topics in stdpath("data")/copilot-chats/' })
end
return M
