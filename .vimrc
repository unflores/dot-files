set nocompatible
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set showmatch 					"show matching brackets
set ruler
set incsearch
set hls
set history=700
set clipboard+=unnamed  " Yanks go on clipboard instead.
set number
set mat=5 							" bracket blinking
colorscheme inspiration
set wildmenu						" show files in dir for tab complete
set laststatus=2				" show last status
set cmdheight=2 				" The commandbar height
set ignorecase 					" Ignore case when searching
set smartcase
syntax enable 					" Enable syntax hl
:command W w
:command Bc Bclose
nmap <silent> <S-tab> :NERDTreeToggle<CR>
set backspace=indent,eol,start "mac backspace fix
