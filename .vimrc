" general {{
set background=dark
set nocompatible                                  " disable vi compatibility, idk what this does
set noswapfile                                    " no temp file
set undofile                                      " persistent undo across sessions
if !has('nvim')
  if !isdirectory($HOME . '/.vim/undodir')
    call mkdir($HOME . '/.vim/undodir', 'p')
  endif
  set undodir=~/.vim/undodir
endif
set backspace=indent,eol,start                    " allow backspace over everything
set number                                        " show line numbers
set showmatch                                     " show matching parenthesis
set showcmd                                       " show commands which i'm typing
set cursorline                                    " highlight cursor
set title                                         " set terminal title
set history=1000
set undolevels=1000
if !has('nvim')
  set lazyredraw                                  " buffer screen updates (causes issues in nvim 0.10+)
endif
set clipboard+=unnamedplus                         " copy to system clipboard
set updatetime=250
set signcolumn=auto                               " show sign column only when there are signs
set scrolloff=8                                   " keep context around cursor
set splitbelow                                    " sane split defaults
set splitright
set confirm                                       " ask to save instead of failing on :q
set autoread                                      " reload files changed externally
set laststatus=2                                  " always show statusline
set formatoptions+=j                              " remove comment leader when joining lines
set ttimeout
set ttimeoutlen=50                                " faster escape sequences
set nrformats-=octal                              " ctrl-a/x won't treat 007 as octal
set modeline
set modelineexpr
"}}

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

" use ripgrep for :grep {{
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif "}}

" no beeps {{
set visualbell
set noerrorbells "}}

" line wrapping {{
set wrap                                          " wrap long lines
set breakindent                                   " indent at same level as rapped line }}

" smooth scrolling (vim 9.1+) {{
if has('patch-9.0.0640')
  set smoothscroll
endif " }}

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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
if has('nvim')
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'sindrets/diffview.nvim'
  Plug 'navarasu/onedark.nvim'
else
  Plug 'airblade/vim-gitgutter'
endif

call plug#end()                                   "}}

" netrw {{
let g:netrw_banner = 0                           " no header
let g:netrw_liststyle = 3                        " tree view
let g:netrw_browse_split = 4                     " open file in new tab
let g:netrw_altv = 1                             " vertical split
let g:netrw_winsize = 25                         " 25% of window length
"}}

if !has('nvim')
  " gruvbox color theme settings {{
  let g:gruvbox_italic=1
  let g:gruvbox_transparent_bg=1
  let g:gruvbox_improved_strings=1
  let g:gruvbox_improved_warnings=1
  let g:gruvbox_contrast_dark='hard'
  let g:gruvbox_invert_indent_guides=1
  let g:gruvbox_italicize_strings=1
  autocmd VimEnter * hi Normal ctermbg=none
  colorscheme gruvbox                            "}}
endif

" vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\"\\\ \\\|{{','','g')
