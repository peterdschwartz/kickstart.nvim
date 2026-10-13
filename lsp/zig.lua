-- ~/.config/nvim/lua/lsp/zig.lua
local lspconfig = require 'lspconfig'

-- Load nvim-cmp LSP capabilities if available
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  pcall(require, 'cmp_nvim_lsp') and require('cmp_nvim_lsp').default_capabilities() or {}
)

lspconfig.zls.setup {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern('build.zig', '.git'),
  settings = {
    zls = {
      enable_snippets = true,
      warn_style = true,
    },
  },
}
