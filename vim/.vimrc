if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/bundle')
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }

call plug#end()

set nocompatible
set backspace=indent,eol,start

" show line numbers
set number
" show invisible characters
set list
" ignore case for search
set ignorecase
" but if there is an uppercase then search is case sensitive
set smartcase
" incremental search
set incsearch
" enable syntax highligting
syntax enable
" length of tab
set tabstop=2
" show commands which i'm typing
set showcmd

set cursorline

" file type detection on (allows syntax highlighting etc)
filetype plugin indent on

" kind of autocompletion
set wildmenu

" buffer screen updates
set lazyredraw

set showmatch
set hlsearch
set foldenable
set foldlevelstart=5
set foldmethod=indent

