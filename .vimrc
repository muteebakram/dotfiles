"Vim Settings"

"Turn on language color highlighting."
syntax on

"Show line numbers"
set number

"Draw line for cursor position."
set cursorline
let &t_SI = "\<esc>[5 q"  "Blinking I-beam in insert mode.
let &t_SR = "\<esc>[3 q"  "Blinking underline in replace mode.
let &t_EI = "\<esc>[ q"  "Default cursor (usually blinking block) otherwise.

