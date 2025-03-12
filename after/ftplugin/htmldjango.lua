local lspconfig = require 'lspconfig'

lspconfig.html.setup {
  filetypes = { 'html', 'htmldjango' },
}

lspconfig.htmx.setup {
  filetypes = { 'html', 'htmldjango' },
}
