vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 3
vim.opt_local.tabstop = 3
vim.opt_local.softtabstop = 3

-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'fortran' },
  callback = function()
    vim.b.autoformat = false
  end,
})
vim.api.nvim_set_keymap('n', '<leader>f', ':%!fprettify<CR>', { noremap = true, silent = true })
