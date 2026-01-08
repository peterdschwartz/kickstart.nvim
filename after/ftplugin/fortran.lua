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

-- after/ftplugin/fortran.lua

local function close_fortran_block()
  local line = vim.api.nvim_get_current_line()

  -- match leading spaces, then keyword, then name
  -- e.g. "  subroutine foo(bar)" -> kw="subroutine", name="foo"
  local indent, kw, name = line:match '^(%s*)(%a+)%s+([%w_]+)'

  if not kw or not name then
    vim.notify('Not on a type/module/subroutine/function line', vim.log.levels.WARN)
    return
  end

  kw = kw:lower()
  local end_kw
  if kw == 'type' or kw == 'class' then
    end_kw = 'type'
  elseif kw == 'subroutine' then
    end_kw = 'subroutine'
  elseif kw == 'function' then
    end_kw = 'function'
  elseif kw == 'module' then
    end_kw = 'module'
  else
    vim.notify("Keyword '" .. kw .. "' not handled", vim.log.levels.WARN)
    return
  end

  local end_line = string.format('%send %s %s', indent, end_kw, name)

  -- insert the "end ..." on the line *below* the current one
  vim.api.nvim_put({ end_line }, 'l', true, true)
end

-- Map it: <leader>fe in normal mode to close the current block
vim.keymap.set('n', '<leader>fe', close_fortran_block, { buffer = true, desc = 'Insert matching end ... name' })

-- require('lspconfig').fortls.setup {
--   settings = {
--     fortls = {
--       include_dirs = { '/usr/include', '~/.local/include', '~/.local/hdf5/include' },
--     },
--   },
-- }
