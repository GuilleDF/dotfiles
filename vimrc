runtime! archlinux.vim

syntax on
set t_Co=256
set cursorline
set wildmode=longest,list,full
set wildmenu

"set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
set indentkeys=!<Tab>,o,O
map <Tab> i<Tab><Esc>^

set expandtab 
set autoindent 
set shiftwidth=2 
set softtabstop=2 
set tabstop=2

set mouse=a

so ~/.vim/plugins.vim

colorscheme onehalfdark
let g:airline_theme='onehalfdark'
