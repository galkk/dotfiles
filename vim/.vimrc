if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/bundle')
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'morhetz/gruvbox'
call plug#end()

autocmd vimenter * colorscheme gruvbox
set background=dark

set nocompatible

set backspace=indent,eol,start " allow backspace over everything

set number  " show line numbers

" show invisible characters
set listchars=eol:$,tab:>-,trail:~,extends:#,nbsp:. 
set list

set ignorecase  " ignore case for search
set smartcase " but if there is an uppercase then search is case sensitive
set incsearch " incremental search

syntax enable " enable syntax highligting

set tabstop=4 " length of tab

set showcmd " show commands which i'm typing

set cursorline

set title " set terminal title

set visualbell " no beeps
set noerrorbells 

set autoindent
set copyindent
set smarttab

set history=1000
set undolevels=1000

filetype plugin indent on " file type detection on (allows syntax highlighting etc)

" autocompletion for vim commands
set wildmenu
set wildmode=list:full,full

" buffer screen updates
set lazyredraw

set showmatch
set hlsearch
set foldenable
set foldlevelstart=5
set foldmethod=indent

augroup tmux
  autocmd!
  if exists('$TMUX')
    autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
    autocmd VimLeave * call system("tmux set-window-option automatic-rename")
  endif
augroup END
