local util = require 'lspconfig.util'

return {
  cmd = {
    vim.fn.expand '~/.local/bin/fortls',
    '--notify_init',
    '--hover_signature',
    '--hover_language=fortran',
    '--use_signature_help',
    '--lowercase_intrinsics',
  },
  root_dir = function(fname)
    return util.root_pattern('.fortls', 'CMakeLists.txt', 'Makefile', '.git')(fname) or vim.fn.getcwd()
  end,
  filetypes = { 'fortran', 'f90', 'F90', 'f95', 'for', 'f03', 'f08' },
  settings = {
    fortls = {
      include_dirs = {
        '/usr/include/',
        vim.fn.expand '~/.local/include',
        vim.fn.expand '~/.local/hdf5/include',
        vim.fn.expand '~/.local/netcdf-fortran/include',
        vim.fn.expand '~/.local/netcdf-c/include',
      },
      variable_hover = true,
      use_signature_help = true,
      hover_signature = true,
      hover_language = 'fortran',
      enable_code_actions = true,
      symbol_include = { 'all' }, -- might help with symbol resolution
      lowercase_intrinsics = true,
    },
  },
}
