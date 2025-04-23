vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'fortran' },
  callback = function()
    -- vim.b.did_indent = 1 -- disable sleuth
    vim.b.autoformat = false
    vim.bo.autoindent = true
    vim.bo.smartindent = true
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 3
    vim.opt_local.tabstop = 3
    vim.opt_local.softtabstop = 3
    vim.bo.indentexpr = "v:lua.require'indent.fortran'.get_indent()"
  end,
})
vim.keymap.set('n', '<leader>f', function()
  vim.cmd 'silent %!fprettify'
  vim.cmd 'set filetype=fortran'
end, { buffer = true, desc = 'Format with fprettify' })

-- require('lspconfig').fortls.setup {
--   settings = {
--     fortls = {
--       include_dirs = { '/usr/include', '~/.local/include', '~/.local/hdf5/include' },
--     },
--   },
-- }
