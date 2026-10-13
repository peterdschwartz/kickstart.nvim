return {
  cmd = {
    'fortls',
    '--notify_init',
    '--hover_signature',
    '--hover_language=fortran',
    '--use_signature_help',
    '--lowercase_intrinsics',
  },

  filetypes = { 'fortran' },

  root_markers = {
    '.fortls',
    '.fortlsrc',
    '.fortls.json',
    'CMakeLists.txt',
    'Makefile',
    '.git',
  },

  settings = {
    fortls = {
      include_dirs = {
        '/usr/include/',
        vim.fn.expand '~/.local/include',
        vim.fn.expand '~/.local/hdf5/include',
        vim.fn.expand '~/.local/netcdf-fortran/include',
        vim.fn.expand '~/.local/netcdf-c/include',
        vim.fn.expand '~/.local/ftorch/include',
      },
      variable_hover = true,
      use_signature_help = true,
      hover_signature = true,
      hover_language = 'fortran',
      enable_code_actions = true,
      symbol_include = { 'all' },
      lowercase_intrinsics = true,
    },
  },
}
