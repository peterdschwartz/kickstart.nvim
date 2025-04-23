local M = {}

function M.get_indent()
  local lnum = vim.v.lnum
  if lnum == 1 then
    return 0
  end

  local prev_line = vim.fn.getline(lnum - 1):gsub('^%s*', ''):lower()
  local curr_line = vim.fn.getline(lnum):gsub('^%s*', ''):lower()
  local sw = vim.bo.shiftwidth
  local indent = vim.fn.indent(lnum - 1)
  -- Basic indent rules
  -- local increase_keywords = { 'do', 'if', 'select', 'where', 'associate', 'forall' }
  -- local decrease_keywords = { 'end', 'else', 'elseif', 'case' }
  -- Decrease indent for ending lines
  if
    curr_line:match '^(end%s*do)'
    or curr_line:match '^(end%s*if)'
    or curr_line:match '^(end%s*subroutine)'
    or curr_line:match '^(end%s*function)'
    or curr_line:match '^(end%s*select)'
    or curr_line:match '^(case)'
  then
    return math.max(0, vim.fn.indent(lnum - 1) - sw)
  end

  -- Increase indent after control statements
  if
    prev_line:match '^(do)'
    or prev_line:match '^(if.*then)'
    or prev_line:match '^(select%s+case)'
    or prev_line:match '^(subroutine)'
    or prev_line:match '^(function)'
    or prev_line:match '^(module)'
  then
    return vim.fn.indent(lnum - 1) + sw
  end

  -- Keep same indent
  return vim.fn.indent(lnum - 1)
end

return M
