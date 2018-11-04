execute pathogen#infect()
" vim-plug
" :PlugInstall from vim console
" fzf needs `apt-get install silversearcher-ag` to be worth a damn
call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'othree/yajs.vim'
  Plug 'leafgarland/typescript-vim' " Vim typescript syntax highlighting
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'Quramy/tsuquyomi'
"  Plug 'pangloss/vim-javascript'
"  Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

set t_Co=256
set hidden              " keep undo for hidden buffers
set nocompatible        " Vim only options, not vi compatible
set smarttab            " Use tabs for indentation and spaces otherwise
set tabstop=2
set expandtab           " Expand into spaces
set shiftwidth=2        " Changes number of spaces inserted for indents
set showmatch           " Show matching brackets
set autoindent          " Vim handles indentation for you
set smartindent         " I have had mixed results.  It should intelligently indent for you
set ruler               " Info displayed at bottom
set cursorline          " Highlight current line
set number              " Set line numbers
set incsearch           " Search while typing instead of after
set hls                 " Hilight search hits
set history=700         " Command history
set clipboard+=unnamed  " Yanks go on clipboard instead.
set mat=5               " Bracket blinking
set scrolloff=5         " Keep 5 lines while scrolling
"colorscheme desert
colorscheme tokyo-metro
set wildmenu            " Show files in dir for tab complete
set nobackup            " Get rid of backup files, we'll do it live!
set noswapfile
set nowritebackup
set nowrap              " This should help me to make a newline when I should :)
set ttyfast             " Allow smoother changes
set list
set listchars=tab:>-

set re=1                " An older regex engine for vim which is faster for ruby syntax highlighting
set laststatus=2        " Show last status
set cmdheight=2         " The commandbar height
set ignorecase          " Ignore case when searching
set smartcase           " No case set then search up + low, else lock case

set exrc                " Have vim rc files outside of home
set secure              " Protect against using certain rc file commands in project directories
set foldmethod=indent   " Have vim fold based on its indentation
set foldlevel=20        " Don't let the code be folded by default unless it's more than 20 levels deep. B/c I always want code unfolded at start

"begin Auto set and unset paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" end Auto set and unset paste

" ctrl-p -> open fzf search in vim
nmap <silent> <C-P> :FZF<CR>
let g:fzf_layout = { 'left': '~20%' }

" use fzf to build list of open buffers
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

filetype plugin on      " Enable plugins based on the filetype
filetype indent on      " Enable filetype indenting
syntax on               " Enable syntax highlighting
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%101v.\+/

:command W w
:command Bc Bclose

" Nerd Tree
" ctrl+ww flips back and forth between nerdtree and editor
" ctrl+n toggles nerdtree
nmap <silent> <C-n> :NERDTreeToggle<CR>

set statusline=%f        "path leading to filename
"set statusline+=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%#todo# "Flip the color
set statusline+=%m      "modified flag
set statusline+=%*      "flip the color back
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

"nmap <silent> <C-tab> :NERDTreeToggle<CR>

"Map f2 and f3 for quick cycle through buffers
map <F2> :bprevious<CR>
map <F3> :bnext<CR>

" Map \d to next buffer then delete previous buffer
nmap <leader>d :bprevious<CR>:bdelete #<CR>

" Map \f to open nerd tree to open file in current pane
nmap <leader>f :NERDTreeFind<CR>

" Constrain fzf by gitignored files, needs the_silver_surfer, heh, ag
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

"Show hidden files by default
let g:NERDTreeShowHidden=1

" Enable wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ds_store,*.db,.git,*.rbc,*.class,.svn

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

"----------------------------------------------------------------------------
" Set Custom Filetypes
"----------------------------------------------------------------------------

au BufNewFile,BufRead {Vagrantfile,Gemfile,Rakefile,config.ru} set filetype=ruby

" Close ruby method defs
au BufRead,BufNewFile *.rb :iab def 
\def
\<CR>end<Up>

" Retain selection after increasing/decreasing indent
vmap > >gv
vmap < <gv

" Restore cursor position
if has("autocmd")
  augroup vimrc_autocmd
    " Clear out autocmd
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    " Strip trailing whitespace on save
    autocmd FileType python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e
    autocmd BufWritePre *.slim,*.yml,*.erb,*.md,*.haml,*.scss,*.js,*.ts,*.tsx,*.jsx,*.ts,*.tsx,*.coffee :%s/\s\+$//e
  augroup END
endif
