"{{{ The Basics
set nocompatible
set t_Co=256
set noanti
set background=dark
set noswapfile
set encoding=utf-8
set showcmd
set showmode
set number
set history=1000
colorscheme darkdevel 
if has ('gui_running')
    " Different cursors for different modes.
    colorscheme jellybeans 
    set guicursor=a:block-Cursor
    set guicursor+=i:ver100-iCursor
    set guicursor+=a:blinkon0
    set guicursor+=i:blinkwait10
    set go-=T
    set guifont=gohufont-14:h12
    "set guifont=Consolas:h11
    set lines=40 columns=120
    syntax enable
    syntax on
endif
    hi Cursor guifg=white guibg=DarkGreen
    hi iCursor guifg=white guibg=DarkGreen
    hi vCursor guifg=white guibg=DarkGreen
execute pathogen#infect()
set clipboard=unnamed
set laststatus=2
set backspace=indent,eol,start
"{{{"Status line modification
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor
hi User1 guifg=#eea040 guibg=#222222
hi User2 guifg=#dd3333 guibg=#222222
hi User3 guifg=#ff66ff guibg=#222222
hi User4 guifg=#a0ee40 guibg=#222222
hi User5 guifg=#eeee40 guibg=#222222
"}}}
"}}}
"{{{Convenience Mappings----------------------------------------------------------------
" Fuck you, help key.
noremap  <F1> :edit!<cr>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}
"}}}"
"{{{Inaction in Insert-------------------------------- 
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=10000
au InsertLeave * let &updatetime=updaterestore
"}}}
" Filetype-specific ------------------------------------------------------- {{{

" Assembly {{{

augroup ft_asm
    au!
    au FileType asm setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8
augroup END

" }}}
" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=marker foldmarker={,}
augroup END
"{{{ C File Specific Options
au FileType c,cpp set cindent
au FileType c,cpp set formatoptions+=ro
let g:C_UseTool_cmake = 'yes'
let g:C_UseTool_doxygen = 'yes'
"}}}

" }}}
" Clojure {{{

let g:clojure_fold_extra = [
            \ 'defgauge',
            \ 'defmeter',
            \ 'defhistogram',
            \ 'defcounter',
            \ 'deftimer',
            \
            \ 'defdb',
            \ 'defentity',
            \ 'defaspect',
            \ 'add-aspect',
            \ 'defmigration',
            \
            \ 'defsynth',
            \ 'definst',
            \ 'defproject',
            \
            \ 'defroutes',
            \
            \ 'defrec',
            \
            \ 'defparser',
            \
            \ 'defform',
            \ 'defform-',
            \
            \ 'defpage',
            \ 'defsketch'
            \
            \ ]

let g:clojure_highlight_extra_defs = [
            \ 'defparser',
            \ 'deftest',
            \ 'match',
            \
            \ 'defproject',
            \
            \ 'defquery',
            \ 'defqueries',
            \
            \ 'defform',
            \
            \ 'deferror',
            \ 'when-found',
            \ 'when-valid',
            \
            \ 'defroutes'
            \ ]

let g:clojure_highlight_extra_exceptions = [
            \ 'try+',
            \ 'throw+',
            \ ]

augroup ft_clojure
    au!

    au BufNewFile,BufRead *.edn set filetype=clojure

    au BufNewFile,BufRead riemann.config set filetype=clojure
    au FileType clojure silent! call TurnOnClojureFolding()
    au FileType clojure compiler clojure
    au FileType clojure setlocal report=100000

    " Things that should be indented 2-spaced
    au FileType clojure setlocal lispwords+=when-found,defform,when-valid

    au FileType clojure RainbowParenthesesActivate
    au syntax clojure RainbowParenthesesLoadRound
    au syntax clojure RainbowParenthesesLoadSquare
    au syntax clojure RainbowParenthesesLoadBraces

    " Since YCM is hosefucked for Clojure, we'll use omnicompletion on <c-n>
    au FileType clojure inoremap <c-n> <c-x><c-o>

    " And close the omnicomplete preview window after we're done with it.
    au InsertLeave *.clj if pumvisible() == 0|pclose|endif

    " Friendlier Paredit mappings.
    au FileType clojure noremap <buffer> () :<c-u>call PareditWrap("(", ")")<cr>
    au FileType clojure noremap <buffer> )( :<c-u>call PareditSplice()<cr>
    au FileType clojure noremap <buffer> (( :<c-u>call PareditMoveLeft()<cr>
    au FileType clojure noremap <buffer> )) :<c-u>call PareditMoveRight()<cr>
    au FileType clojure noremap <buffer> (j :<c-u>call PareditJoin()<cr>
    au FileType clojure noremap <buffer> (s :<c-u>call PareditSplit()<cr>
    au FileType clojure noremap <buffer> [ :<c-u>call PareditSmartJumpOpening(0)<cr>
    au FileType clojure noremap <buffer> ] :<c-u>call PareditSmartJumpClosing(0)<cr>
    " )))

    " Indent top-level form.
    au FileType clojure nmap <buffer> <localleader>= mz99[(v%='z
    " ])
augroup END

" }}}
" Clojurescript {{{

augroup ft_clojurescript
    au!

    au BufNewFile,BufRead *.cljs set filetype=clojurescript
    au FileType clojurescript call TurnOnClojureFolding()

    " Indent top-level form.
    au FileType clojurescript nmap <buffer> <localleader>= v((((((((((((=%
augroup END

" }}}
" Common Lisp {{{

function! SendToTmuxStripped(text)
    call SendToTmux(substitute(a:text, '\v\n*$', '', ''))
endfunction
function! SetLispWords()
    if exists("g:did_set_lisp_words")
        return
    endif

    let g:did_set_lisp_words = 1

    set lispwords+=switch
    set lispwords+=cswitch
    set lispwords+=eswitch
endfunction

augroup ft_commonlisp
    au!

    au BufNewFile,BufRead *.asd setfiletype lisp

    au FileType lisp call SetLispWords()

    " Set up some basic tslime mappings until I shave the fuckin
    " Fireplace/Common Lisp yak.
    "
    " key  desc                   mnemonic
    " \t - connect tslime         [t]slime
    " \f - send current form      [f]orm
    " \e - send top-level form    [e]val
    " \r - send entire file       [r]eload file
    " \c - send ctrl-l            [c]lear

    " Send the current form to the REPL
    au FileType lisp nnoremap <buffer> <silent> <localleader>f :let lisp_tslime_view = winsaveview()<cr>vab"ry:call SendToTmuxStripped(@r)<cr>:call winrestview(lisp_tslime_view)<cr>

    " Send the current top-level form to the REPL
    au FileType lisp nnoremap <buffer> <silent> <localleader>e :let lisp_tslime_view = winsaveview()<cr>:silent! normal! l<cr>:call PareditFindDefunBck()<cr>vab"ry:call SendToTmuxStripped(@r)<cr>:call winrestview(lisp_tslime_view)<cr>

    " Send the entire buffer to the REPL
    au FileType lisp nnoremap <buffer> <silent> <localleader>r :let lisp_tslime_view = winsaveview()<cr>ggVG"ry:call SendToTmuxStripped(@r)<cr>:call winrestview(lisp_tslime_view)<cr>

    " Clear the REPL
    au FileType lisp nnoremap <buffer> <silent> <localleader>c :call SendToTmuxRaw("")<cr>

    au FileType lisp RainbowParenthesesActivate
    au syntax lisp RainbowParenthesesLoadRound
    au syntax lisp RainbowParenthesesLoadSquare
    au syntax lisp RainbowParenthesesLoadBraces

    au FileType lisp silent! call TurnOnLispFolding()

    au FileType lisp noremap <buffer> () :<c-u>call PareditWrap("(", ")")<cr>
    au FileType lisp noremap <buffer> )( :<c-u>call PareditSplice()<cr>
    au FileType lisp noremap <buffer> (( :<c-u>call PareditMoveLeft()<cr>
    au FileType lisp noremap <buffer> )) :<c-u>call PareditMoveRight()<cr>
    au FileType lisp noremap <buffer> (j :<c-u>call PareditJoin()<cr>
    au FileType lisp noremap <buffer> (s :<c-u>call PareditSplit()<cr>
    au FileType lisp noremap <buffer> )j :<c-u>call PareditJoin()<cr>
    au FileType lisp noremap <buffer> )s :<c-u>call PareditSplit()<cr>
    au FileType lisp noremap <buffer> [[ :<c-u>call PareditSmartJumpOpening(0)<cr>
    au FileType lisp noremap <buffer> ]] :<c-u>call PareditSmartJumpClosing(0)<cr>
    " ))

    " Indent top-level form.
    au FileType lisp nmap <buffer> <localleader>= mz99[(v%='z
    " ])
augroup END

" }}}
" Confluence {{{

augroup ft_c
    au!

    au BufRead,BufNewFile *.confluencewiki setlocal filetype=confluencewiki

    " Wiki pages should be soft-wrapped.
    au FileType confluencewiki setlocal wrap linebreak nolist
augroup END

" }}}
" Cram {{{

let cram_fold=1

augroup ft_cram
    au!

    au BufNewFile,BufRead *.t set filetype=cram
    au Syntax cram setlocal foldlevel=1
    au FileType cram nnoremap <buffer> <localleader>ee :e<cr>
augroup END

" }}}
" CSS and LessCSS {{{

augroup ft_css
    au!

    au BufNewFile,BufRead *.less setlocal filetype=less

    au Filetype less,css setlocal foldmethod=marker
    au Filetype less,css setlocal foldmarker={,}
    au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
    au Filetype less,css setlocal iskeyword+=-

    " Use <leader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    au BufNewFile,BufRead *.less,*.css inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}
" Django {{{

augroup ft_django
    au!

    au BufNewFile,BufRead urls.py           setlocal nowrap
    au BufNewFile,BufRead urls.py           normal! zR
    au BufNewFile,BufRead dashboard.py      normal! zR
    au BufNewFile,BufRead local_settings.py normal! zR

    au BufNewFile,BufRead admin.py     setlocal filetype=python.django
    au BufNewFile,BufRead urls.py      setlocal filetype=python.django
    au BufNewFile,BufRead models.py    setlocal filetype=python.django
    au BufNewFile,BufRead views.py     setlocal filetype=python.django
    au BufNewFile,BufRead settings.py  setlocal filetype=python.django
    au BufNewFile,BufRead settings.py  setlocal foldmethod=marker
    au BufNewFile,BufRead forms.py     setlocal filetype=python.django
    au BufNewFile,BufRead common_settings.py  setlocal filetype=python.django
    au BufNewFile,BufRead common_settings.py  setlocal foldmethod=marker
augroup END

" }}}
" DTrace {{{

augroup ft_dtrace
    au!

    autocmd BufNewFile,BufRead *.d set filetype=dtrace
augroup END

" }}}
" Firefox {{{

augroup ft_firefox
    au!
    au BufRead,BufNewFile ~/Library/Caches/*.html setlocal buftype=nofile
augroup END

" }}}
" Fish {{{

augroup ft_fish
    au!

    au BufNewFile,BufRead *.fish setlocal filetype=fish

    au FileType fish setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

" }}}
" Haskell {{{

augroup ft_haskell
    au!
    au BufEnter *.hs compiler ghc
augroup END

" }}}
" HTML, Django, Jinja, Dram {{{

let g:html_indent_tags = ['p', 'li']

augroup ft_html
    au!

    au BufNewFile,BufRead *.html setlocal filetype=htmldjango
    au BufNewFile,BufRead *.dram setlocal filetype=htmldjango

    au FileType html,jinja,htmldjango setlocal foldmethod=manual

    " Use <localleader>f to fold the current tag.
    au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>f Vatzf

    " Use <localleader>t to fold the current templatetag.
    au FileType html,jinja,htmldjango nmap <buffer> <localleader>t viikojozf

    " Indent tag
    au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>= Vat=

    " Django tags
    au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

    " Django variables
    au FileType jinja,htmldjango inoremap <buffer> <c-b> {{<space><space>}}<left><left><left>
augroup END

" }}}
" Java {{{

augroup ft_java
    au!

    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}
augroup END

" }}}
" Javascript {{{

augroup ft_javascript
    au!

    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}
        " Make {<cr> insert a pair of brackets in such a way that the cursor is correctly
    " positioned inside of them AND the following code doesn't get unfolded.
    au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><space><space><space><space>.<cr><esc>kA<bs>
augroup END

" }}}
" Markdown {{{

augroup ft_markdown
    au!

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown foldlevel=1

    " Use <localleader>1/2/3 to add headings.
    au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>3 mzI###<space><esc>`zllll
    au Filetype markdown nnoremap <buffer> <localleader>4 mzI####<space><esc>`zlllll

    au Filetype markdown nnoremap <buffer> <localleader>p VV:'<,'>!python -m json.tool<cr>
    au Filetype markdown vnoremap <buffer> <localleader>p :!python -m json.tool<cr>
augroup END

" }}}
" Mercurial {{{

augroup ft_mercurial
    au!

    au BufNewFile,BufRead *hg-editor-*.txt setlocal filetype=hgcommit
augroup END

" }}}
" Mutt {{{

augroup ft_muttrc
    au!

    au BufRead,BufNewFile *.muttrc set ft=muttrc

    au FileType muttrc setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

" }}}
" Nand2Tetris HDL {{{

augroup ft_n2thdl
    au!

    au BufNewFile,BufRead *.hdl set filetype=n2thdl
augroup END

" }}}
" Nginx {{{

augroup ft_nginx
    au!

    au BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
    au BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
    au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
    au BufRead,BufNewFile vhost.nginx                            set ft=nginx

    au FileType nginx setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
" OrgMode {{{

augroup ft_org
    au!

    au Filetype org nmap <buffer> Q vahjgq
    au Filetype org setlocal nolist
augroup END

" }}}
" Postgresql {{{

augroup ft_postgres
    au!

    au BufNewFile,BufRead *.sql set filetype=pgsql
    au BufNewFile,BufRead *.pgsql set filetype=pgsql

    au FileType pgsql set foldmethod=indent
    au FileType pgsql set softtabstop=2 shiftwidth=2
    au FileType pgsql setlocal commentstring=--\ %s comments=:--

    " Send to tmux with localleader e
    au FileType pgsql nnoremap <buffer> <silent> <localleader>e :let psql_tslime_view = winsaveview()<cr>vip"ry:call SendToTmux(@r)<cr>:call winrestview(psql_tslime_view)<cr>

augroup END

    " kill pager with q
    au FileType pgsql nnoremap <buffer> <silent> <localleader>q :call SendToTmuxRaw("q")<cr>

" }}}
" Puppet {{{

augroup ft_puppet
    au!

    au Filetype puppet setlocal foldmethod=marker
    au Filetype puppet setlocal foldmarker={,}
augroup END

" }}}
" Python {{{

augroup ft_python
    au!

    au FileType python setlocal define=^\s*\\(def\\\\|class\\)
    au FileType man nnoremap <buffer> <cr> :q<cr>

    " Jesus tapdancing Christ, built-in Python syntax, you couldn't let me
    " override this in a normal way, could you?
    au FileType python if exists("python_space_error_highlight") | unlet python_space_error_highlight | endif

    au FileType python iabbrev <buffer> afo assert False, "Okay"
augroup END

" }}}
" QuickFix {{{

augroup ft_quickfix
    au!
    au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap tw=0
augroup END

" }}}
" ReStructuredText {{{

augroup ft_rest
    au!

    au Filetype rst nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
    au Filetype rst nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
    au Filetype rst nnoremap <buffer> <localleader>3 yypVr~:redraw<cr>
    au Filetype rst nnoremap <buffer> <localleader>4 yypVr`:redraw<cr>
augroup END

" }}}
" Riemann Config Files {{{

augroup ft_riemann
    au!

    au BufNewFile,BufRead riemann.config set filetype=clojure
    au BufNewFile,BufRead riemann.config nnoremap <buffer> <localleader>= mzgg=G`z
augroup END

" }}}
" Rubby {{{

augroup ft_ruby
    au!
    au Filetype ruby setlocal foldmethod=syntax
    au BufRead,BufNewFile Capfile setlocal filetype=ruby
augroup END

" }}}
" Scala {{{

augroup ft_scala
    au!
    au Filetype scala setlocal foldmethod=marker foldmarker={,}
    au Filetype scala setlocal textwidth=100
    au Filetype scala compiler maven
    au Filetype scala let b:dispatch = 'mvn -B package install'
    au Filetype scala nnoremap <buffer> <localleader>s mz:%!sort-scala-imports<cr>`z
    au Filetype scala nnoremap <buffer> M :call scaladoc#Search(expand("<cword>"))<cr>
    au Filetype scala vnoremap <buffer> M "ry:call scaladoc#Search(@r)<cr>
    au Filetype scala nmap <buffer> <localleader>( ysiwbi
    au Filetype scala nmap <buffer> <localleader>[ ysiwri
    ")]
augroup END

" }}}
" Standard In {{{

augroup ft_stdin
    au!

    " Treat buffers from stdin (e.g.: echo foo | vim -) as scratch.
    au StdinReadPost * :set buftype=nofile
augroup END

" }}}
" Vagrant {{{

augroup ft_vagrant
    au!
    au BufRead,BufNewFile Vagrantfile set ft=ruby
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
" YAML {{{

augroup ft_yaml
    au!

    au FileType yaml set shiftwidth=2
augroup END

" }}}
" XML {{{

augroup ft_xml
    au!

    au FileType xml setlocal foldmethod=manual

    " Use <localleader>f to fold the current tag.
    au FileType xml nnoremap <buffer> <localleader>f Vatzf

    " Indent tag
    au FileType xml nnoremap <buffer> <localleader>= Vat=
augroup END

" }}}

" }}}
" Plugin settings --------------------------------------------------------- {{{

" NERD Tree {{{

noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

augroup ps_nerdtree
    au!

    au Filetype nerdtree setlocal nolist
    au Filetype nerdtree nnoremap <buffer> H :vertical resize -10<cr>
    au Filetype nerdtree nnoremap <buffer> L :vertical resize +10<cr>
    " au Filetype nerdtree nnoremap <buffer> K :q<cr>
augroup END

let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = ['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index',
                    \ 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json',
                    \ '.*\.o$', 'db.db', 'tags.bak', '.*\.pdf$', '.*\.mid$',
                    \ '.*\.midi$']

let NERDTreeMinimalUI = 1 "Hide the Bookmarks label 
let NERDTreeDirArrows = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let NERDTreeMapJumpFirstChild = 'gK'

" }}}
" Python-Mode {{{

let g:pymode_doc = 1
let g:pymode_doc_key = 'M'
let g:pydoc = 'pydoc'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 0
let g:pymode_syntax_builtin_objs = 1
let g:pymode_syntax_print_as_function = 0
let g:pymode_syntax_space_errors = 0
let g:pymode_run = 0
let g:pymode_lint = 0
let g:pymode_breakpoint = 0
let g:pymode_utils_whitespaces = 0
let g:pymode_virtualenv = 0
let g:pymode_folding = 0

let g:pymode_options_indent = 0
let g:pymode_options_fold = 0
let g:pymode_options_other = 0
let g:pymode_options = 0

let g:pymode_rope = 1
let g:pymode_rope_global_prefix = "<localleader>R"
let g:pymode_rope_local_prefix = "<localleader>r"
let g:pymode_rope_auto_project = 1
let g:pymode_rope_enable_autoimport = 0
let g:pymode_rope_autoimport_generate = 1
let g:pymode_rope_autoimport_underlineds = 0
let g:pymode_rope_codeassist_maxfixes = 10
let g:pymode_rope_sorted_completions = 1
let g:pymode_rope_extended_complete = 1
let g:pymode_rope_autoimport_modules = ["os", "shutil", "datetime"]
let g:pymode_rope_confirm_saving = 1
let g:pymode_rope_vim_completion = 1
let g:pymode_rope_guess_project = 1
let g:pymode_rope_goto_def_newwin = 0
let g:pymode_rope_always_show_complete_menu = 0

" }}}
" Supertab {{{

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabLongestHighlight = 1
let g:SuperTabCrMapping = 1

"}}}
" Syntastic {{{

let g:syntastic_enable_signs = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 0
let g:syntastic_java_checker = 'javac'
let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "active_filetypes": [],
            \ "passive_filetypes": ['java', 'html', 'rst']
            \ }
let g:syntastic_stl_format = '[%E{%e Errors}%B{, }%W{%w Warnings}]'
let g:syntastic_jsl_conf = '$HOME/.vim/jsl.conf'
let g:syntastic_scala_checkers = ['fsc']

nnoremap <leader>C :SyntasticCheck<cr>

" }}}
" Splice {{{

let g:splice_prefix = "-"

let g:splice_initial_mode = "grid"

let g:splice_initial_layout_grid = 0
let g:splice_initial_layout_loupe = 0
let g:splice_initial_layout_compare = 0
let g:splice_initial_layout_path = 0

let g:splice_initial_diff_grid = 1
let g:splice_initial_diff_loupe = 0
let g:splice_initial_diff_compare = 1
let g:splice_initial_diff_path = 0

let g:splice_initial_scrollbind_grid = 0
let g:splice_initial_scrollbind_loupe = 0
let g:splice_initial_scrollbind_compare = 0
let g:splice_initial_scrollbind_path = 0

let g:splice_wrap = "nowrap"

" }}}

" }}}
"{{{ Indenting, Folding
set tabstop=4 "numbers of spaces of tab character
set shiftwidth=4	"numbers of spaces to (auto)indent
set softtabstop=4	"counts n spaces when DELTE or BCKSPCE is used
set expandtab		"insert spaces instead of tab chars
set autoindent		"always set autoindenting on
set nosmartindent	"intelligent indenting - DEPRECIATED by cindent
set foldenable
set foldmethod=marker
set foldlevelstart=0
nnoremap <left>  :5wincmd <<cr>
nnoremap <right> :5wincmd ><cr>
nnoremap <up>    :5wincmd +<cr>
nnoremap <down>  :5wincmd -<cr>
nnoremap <Space> za
vnoremap <Space> za
"}}}
