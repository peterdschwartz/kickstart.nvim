vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

require('lspconfig').clangd.setup {
  cmd = { 'clangd', '--background-index' },
  root_dir = require('lspconfig').util.root_pattern('compile_commands.json', '.git'),
}
