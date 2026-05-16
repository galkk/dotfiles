set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

set termguicolors
set foldcolumn=auto
set fillchars+=foldopen:▾,foldsep:│,foldclose:▸
set diffopt=internal,filler,closeoff,algorithm:histogram,indent-heuristic,linematch:60,context:3

" vim:foldmethod=marker:foldmarker={{,}}:foldlevel=0:foldtext=substitute(getline(v\:foldstart),'\\"\\\ \\\|{{','','g')
