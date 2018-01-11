"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" #depends vim
set encoding=utf-8
scriptencoding utf-8
" set nocompatible
set background=dark
let g:rehash256 = 1
if !has('gui_running')
  if $TERM ==# 'xterm-256color' || $TERM ==# 'screen-256color' || $COLORTERM ==# 'gnome-terminal'
    set t_Co=256
  elseif has('terminfo')
    colorscheme default
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
  else
    colorscheme default
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
  " Disable Background
  " Color Erase when
  " within tmux -
  " https://stackoverflow.com/q/6427650/102704
  if $TMUX !=? ''
    set t_ut=
  endif
endif
set backspace=2        " backspace can delete lines
set nobackup           " no tilde files
set noswapfile         " no swap file
set nowritebackup
set hidden             " keep buffer alive in background
set showmatch          " Show matching parenthesis
set title              " Set term title
set visualbell         " no beep
set noerrorbells       " no beep on errors
set virtualedit+=block " allow editing dead chars in blocks
highlight clear SignColum " no highlight in gitgutter
try
    set showtabline=0 " no tabline
catch
endtry

" Lines of memory to remember
set history=1000

let g:mapleader=','
let g:localleader=',,'

" date insertion
nnoremap <C-D> a<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><ESC>
inoremap <C-D> <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>

" Always save when leaving a buffer
autocmd BufLeave,FocusLost * silent! wall
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugins')
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/local/opt/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" #depends ctags
Plug 'ludovicchabant/vim-gutentags'
" #depends silver-searcher
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-sleuth'
" #depends g++
" #depends cmake
" #depends python
Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer' }
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-utils/vim-man'
" #depends npm 
" #depends python
Plug 'w0rp/ale'
Plug 'xuyuanp/nerdtree-git-plugin'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wrap " Wrap lines
" Treat long lines as break lines
noremap j gj
noremap k gk
inoremap jj <esc>
 

" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Use the space or return keys to toggle folds
nnoremap <space> za
vnoremap <space> zf

" having Ex mode start or showing me the command history
" is a complete pain in the ass if i mistype
map Q  <silent>
map q: <silent>
map K  <silent>

" #depends ag
let g:ackprg = 'ag --vimgrep'
nnoremap <C-*> :Ack! "\b<cword>\b" <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wildmenu And CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu " Show completion option in mini buffer
set wildmode=list:longest,full
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.a,*.so,*.dylib,*.d
set mouse=a
set history=5000
set selectmode=mouse

nnoremap <C-P> :Files<CR>
nnoremap <C-T> :Tags<CR>
nnoremap <C-H> :Commands<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax and spelling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

highlight clear SignColum " no hightlight on syntastic symbols
" ALE
set signcolumn=yes
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

set nospell
let g:ale_enabled=0

function! ToggleCheck()
    setlocal spell!
    ALEToggle
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', l:all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', l:all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

augroup Mine
autocmd User ALELint call s:MaybeUpdateLightline()
augroup END

" Update and show lightline but only if it's visible
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 " always display statusline ...
" ...Unless I don't want to
function! ToggleSl ()
    if !&laststatus
        setlocal laststatus=2
    else
        setlocal laststatus=0
    endif
endfunction

" lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['filename', 'modified']],
      \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error'
      \ },
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Whitespaces and indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set listchars=tab:▶\ ,trail:×,eol:¬
set nolist
set colorcolumn=0
function! ToggleWs ()
    if !&colorcolumn
        setlocal colorcolumn=120
        setlocal list
    else
        setlocal colorcolumn=0
        setlocal nolist
    endif
endfunction
set autoindent  " Auto indent
set smartindent " Tabs only at the begining
" do not indent case labels
set cinoptions=:0l1g0N-s " do not indent case labels nor namespaces in c++


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
  set antialias
  set guioptions-=m
  set guioptions-=T
  set guioptions-=t
  set guioptions-=r
  set guioptions-=l
  set guifont =Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono:h11
  " increase decrease font size
  nnoremap <S-Up> :silent! let &guifont = substitute(&guifont, '\d\+', '\=eval(submatch(0)+1)', '')<CR>
  nnoremap <S-Down> :silent! let &guifont = substitute( &guifont, '\d\+', '\=eval(submatch(0)-1)', '')<CR>
else
  if $TMUX !=# ''
    set t_ut=
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase " case insensitive search
set smartcase  " case sensitive only with caps
set incsearch  " search while typing
set hlsearch   " highlight matches

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<cr>
vnoremap <silent> # :call VisualSelection('b')<cr>
" Search man page of current word
nnoremap <silent> K :<C-U>exe "Man " . v:count1 . " <C-R><C-W>"<cr>

let g:ag_prg='ag --vimgrep --smart-case --ignore tags'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Function keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent><F2> :call ToggleSl()<CR>
nnoremap <silent><S-F2> :GitGutterToggle<CR>
nnoremap <silent><F3> :call ToggleWs()<CR>
nnoremap <silent><S-F3> :setlocal paste!<CR>
nnoremap <silent><F4> :cn<CR>
nnoremap <silent><S-F4> :cp<CR>
nnoremap <silent><F6> :call ToggleCheck()<CR>
nnoremap <silent><F7> :make<CR>
nnoremap <silent><F8> :NERDTreeToggle<CR>
nnoremap <silent><F9> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_width = 30


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theming
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans = 1
colorscheme solarized

" nice-looking highlight if I remember to set my terminal colors
highlight clear Search
highlight Search term=NONE cterm=NONE ctermfg=black ctermbg=yellow

" make highlighted matching parents less offensive
highlight clear MatchParen
highlight link MatchParen Search

" colors for NERD_tree
highlight def link NERDTreeRO NERDTreeFile

" make trailing spaces visible
highlight SpecialKey ctermbg=Yellow guibg=Yellow

" make menu selections visible
highlight PmenuSel ctermfg=black ctermbg=magenta

" Git Gutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menu,menuone,longest

let g:ycm_auto_trigger=0
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_echo_current_diagnostic = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdTree git plugin 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Unknown'   : '?'
    \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go-Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup Go
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage)
autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
autocmd FileType go nmap <Leader>gb <Plug>(go-doc-browser)o
autocmd FileType go nmap <Leader>i <Plug>(go-info)
augroup END
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled = 1
set conceallevel=2
let g:vim_markdown_fenced_languages = ['c=c', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_autowrite = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If exists, load some local config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(glob('$HOME/.vimrc.local'))
    source $HOME/.vimrc.local
endif
