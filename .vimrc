set nocompatible        " Vim only options, not vi compatible
" set smarttab          " Use tabs for indentation and spaces otherwise
set tabstop=2
set expandtab						" Expand into spaces
set shiftwidth=2				" Changes number of spaces inserted for indents
set showmatch 					"	Show matching brackets
set ruler               " Info displayed at bottom
set cursorline					" Highlight current line
set number							" Set line numbers
set incsearch           " Search while typing instead of after
set hls                 " Hilight search hits
set history=700         " Command history
set clipboard+=unnamed  " Yanks go on clipboard instead.
set mat=5 							" Bracket blinking
set paste
set scrolloff=5					" Keep 5 lines while scrolling
colorscheme inspiration
set wildmenu						" Show files in dir for tab complete
set laststatus=2				" Show last status
set cmdheight=2 				" The commandbar height
set ignorecase 					" Ignore case when searching
set smartcase           " No case set then search up + low, else lock case
syntax enable 					" Enable syntax hl
:command W w
:command Bc Bclose

" Nerd Tree
" ctrl+ww flips back and forth between nerdtree and editor
" ctrl+e toggles nerdtree
nmap <silent> <C-E> :NERDTreeToggle<CR>

"nmap <silent> <C-tab> :NERDTreeToggle<CR>
set backspace=indent,eol,start "mac backspace fix

"Show hidden files by default
let g:NERDTreeShowHidden=1

set nobackup
set noswapfile
set nowritebackup

set ttyfast 						" Allow smoother changes

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
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Strip trailing whitespace on save
  autocmd FileType python,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e
endif
