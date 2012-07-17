set nocompatible        " vim only options, not vi compatible
set smartindent					" add an indent if needed
set smarttab
set tabstop=2
set expandtab						" expand into spaces
set shiftwidth=2				" 
set showmatch 					"	show matching brackets
set ruler
set cursorline					" highlight current line
set number							" set line numbers
set incsearch
set hls
set history=700
set clipboard+=unnamed  " Yanks go on clipboard instead.
set mat=5 							" bracket blinking
set paste
set scrolloff=5					" keep 5 lines while scrolling
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

set nobackup
set noswapfile
set nowritebackup

set ttyfast 						" allow smoother changes

" enable wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.ds_store,*.db,.git,*.rbc,*.class,.svn
