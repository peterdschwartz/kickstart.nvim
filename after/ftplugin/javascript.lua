local lspconfig = require 'lspconfig'

-- lspconfig.tsserver.setup {
--   filetypes = { 'javascript', 'typescript' },
--   root_dir = require('lspconfig.util').find_git_ancestor or function(fname)
--     return vim.fn.getcwd() -- Fall back to the current working directory
--   end,
-- }
