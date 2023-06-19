set background=dark
set nocompatible                                  " disable vi compatibility, idk what this does
set noswapfile                                    " no temp file
set backspace=indent,eol,start                    " allow backspace over everything
set number                                        " show line numbers
set showmatch                                     " show matching parenthesis
set showcmd                                       " show commands which i'm typing
set cursorline                                    " highlight cursor
set title                                         " set terminal title
set history=1000
set undolevels=1000
set lazyredraw                                    " buffer screen updates
set clipboard=unnamedplus                         " copy to system clipboard
set updatetime=250

filetype plugin indent on                         " file type detection on (allows syntax highlighting etc)
syntax enable                                     " enable syntax highligting

" show all invisible characters {{
set listchars=tab:‣\ ,trail:␣,extends:#,nbsp:·
set list                                          "}}

" search settings {{
set ignorecase                                    " ignore case for search
set smartcase                                     " but if there is an uppercase then search is case sensitive
set incsearch                                     " incremental search
set hlsearch                                      " highlight search as I type }}

" tabs {{
set tabstop=2                                     " tab is 2 spaces by default
set autoindent                                    " new lines indented automatically
set copyindent                                    " indents are copied
set smarttab                                      " }}

" fold syntax by default {{
set foldenable
set foldmethod=syntax
set foldlevel=5
set fillchars=fold:\ 
" }}

" autocompletion for vim commands {{
set wildmenu
set wildoptions=pum
set wildignorecase                                "}}

" enable mouse {{
if !has('nvim')
  set ttymouse=xterm2
endif
set mouse=a                                       "}}

" tmux integration {{
augroup tmux
  autocmd!
  if exists('$TMUX')
    autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
    autocmd VimLeave * call system("tmux set-window-option automatic-rename")
  endif
augroup END "}}

" no beeps {{
set visualbell
set noerrorbells "}}

" line wrapping {{
set wrap                                          " wrap long lines
set breakindent                                   " indent at same level as rapped line }}

" enable modeline and settings, to let vim be controlled by last line comment {{
set modeline
set modelineexpr " }}

" vim plugin management {{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'morhetz/gruvbox'
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc'}
Plug 'tpope/vim-sleuth'                           " run `verbose Sleuth` to force vim to detect indent manually
Plug 'airblade/vim-gitgutter'
call plug#end()                                   "}}

" netrw {{
let g:netrw_banner = 0                           " no header
let g:netrw_liststyle = 3                        " tree view
let g:netrw_browse_split = 4                     " open file in new tab
let g:netrw_altv = 1                             " vertical split
let g:netrw_winsize = 25                         " 25% of window length
"}}

autocmd vimenter * colorscheme gruvbox            " color theme can be set only after plugin is loaded

" vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\"\\\ \\\|{{','','g')
