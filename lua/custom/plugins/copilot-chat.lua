return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'gpt-5.1', -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float'
        width = 0.5, -- 50% of screen width
      },
      auto_insert_mode = true, -- Enter insert mode when opening
      init = function()
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'copilot-chat',
          callback = function()
            vim.keymap.set('n', '<C-h>', '<C-w>h', { buffer = true, silent = true })
            vim.keymap.set('n', '<C-l>', '<C-w>l', { buffer = true, silent = true })
          end,
        })
      end,
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'copilot-chat',
        callback = function(ev)
          local map = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, noremap = true })
          end

          -- Prefer calling the tmux-navigator commands directly
          map('n', '<C-h>', '<cmd><C-U>TmuxNavigateLeft<cr>')
          map('n', '<C-j>', '<cmd><C-U>TmuxNavigateDown<cr>')
          map('n', '<C-k>', '<cmd><C-U>TmuxNavigateUp<cr>')
          map('n', '<C-l>', '<cmd><C-U>TmuxNavigateRight<cr>')
          map('n', '<C-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>')

          -- If CopilotChat leaves you in insert mode and you want the same behavior there:
          map('i', '<C-h>', '<Esc><cmd><C-U>TmuxNavigateLeft<cr>')
          map('i', '<C-j>', '<Esc><cmd><C-U>TmuxNavigateDown<cr>')
          map('i', '<C-k>', '<Esc><cmd><C-U>TmuxNavigateUp<cr>')
          map('i', '<C-l>', '<Esc><cmd><C-U>TmuxNavigateRight<cr>')
          map('i', '<C-\\>', '<Esc><cmd><C-U>TmuxNavigatePrevious<cr>')
        end,
      })
    end,
  },
}
