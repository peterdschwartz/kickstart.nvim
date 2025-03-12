## VIM MOTION TIPS

'I' : Go to first non-whitespace character of the line and enter Insert Mode
'A' : Go to last character of line and enter Insert Mode
'_' : Goes to 1st non-whitespace char of line (not insert mode).  Handy for macros that work on the beginning of line
'=<motion>' : do correct indentation

# Visually select 
```vim
:s/(\w.*)/arr[0] = '\1';
:g/regex/y/A
:let @a='' | %s/regex/\=setreg('A', submatch(0) . "\n")/n
```
The '\1' represents the text captured by the regex.
use 'o' in visual mode to go to next {} thing.


# Telescope:
<leader>/ : fuzzy search in current buffer only
<leader><leader> : fuzzy search in all open buffers


# NeoVIM and LazyVim install steps
dependencies:
*'apt-get install ninja-build gettext cmake unzip curl build-essential
