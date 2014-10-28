" Vim syntax file
" Language:     hl7
" Maintainer:   Random 
" Filenames:    *.hl7


syn match WildMenu  '|'
syn match vimTodo '\^'
syn match Special  '\r[A-Z0-9]*'
syn match Special  '\\r[A-Z0-9]*'
syn match Special  'MSH'
syn match Special  '^[0-9A-Z][0-9A-Z][0-9A-Z]|'
syn match Special  '|\\r[0-9A-Z][0-9A-Z][0-9A-Z]|'
syn region  Comment     start="^--" end="$"
syn match Pmenu '|ADT^A[0-1][0-9]|'
syn match Pmenu '|ORM^O01|'
syn match Pmenu '|ORU^R01|'
syn match Identifier   '|ORU^[^|]|'
syn match ModeMsg  '|200[0-9]\{11,13}'
