require('lspconfig').mlir_lsp_server.setup {
  -- Path to the mlir-lsp-server binary
  cmd = { vim.fn.expand '~/.local/bin/mlir-lsp-server' },

  -- File types this LSP should handle
  filetypes = { 'mlir' },

  -- Root directory of your project (typically where `.git` is)
  root_dir = require('lspconfig.util').root_pattern('.git', '.'),

  -- Optional: Enable on-demand code formatting if needed
  settings = {
    mlir = {
      diagnostics = {
        enable = true, -- enable diagnostics
      },
    },
  },
}
