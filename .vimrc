" general {{
let s:is_vim = !has('nvim')
set background=dark
set noswapfile                                    " no temp file
set undofile                                      " persistent undo across sessions
set number                                        " show line numbers
set showmatch                                     " show matching parenthesis
set cursorline                                    " highlight cursor
set title                                         " set terminal title
set history=1000
set clipboard+=unnamedplus                         " copy to system clipboard
set updatetime=250
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
set foldmethod=syntax
set foldlevel=5
set fillchars=fold:\ 
" }}

" autocompletion for vim commands {{
set wildoptions=pum
set wildignorecase                                "}}

" enable mouse {{
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
"}}

" line wrapping {{
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
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc'}
Plug 'tpope/vim-sleuth'                           " run `verbose Sleuth` to force vim to detect indent manually
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
if s:is_vim || !has('nvim-0.10')
  Plug 'tpope/vim-commentary'
endif
if s:is_vim
  Plug 'joshdick/onedark.vim'
  Plug 'airblade/vim-gitgutter'
endif

call plug#end()                                   "}}

function! s:PlugMissing()
  return !empty(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
endfunction

if s:PlugMissing()
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | runtime! after/plugin/**/*.lua
endif

if s:is_vim
  if !isdirectory($HOME . '/.vim/undodir')
    call mkdir($HOME . '/.vim/undodir', 'p')
  endif
  set undodir=~/.vim/undodir
  set lazyredraw                                  " buffer screen updates (causes issues in nvim 0.10+)
  set ttymouse=xterm2
  if has('termguicolors')
    set termguicolors
  endif

  " onedark color theme settings {{
  let g:onedark_terminal_italics=1
  if !s:PlugMissing()
    colorscheme onedark                          "}}
  endif

endif

" netrw {{
let g:netrw_banner = 0                           " no header
let g:netrw_liststyle = 3                        " tree view
let g:netrw_browse_split = 4                     " open file in new tab
let g:netrw_altv = 1                             " vertical split
let g:netrw_winsize = 25                         " 25% of window length
"}}

" vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\"\\\ \\\|{{','','g')
