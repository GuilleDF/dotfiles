set rtp+=~/.vim/Vundle.vim

call vundle#begin()

Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-surround'
Plugin 'pangloss/vim-javascript'
Plugin 'MaxMEllon/vim-jsx-pretty'

Bundle 'sonph/onehalf', {'rtp': 'vim/'}

call vundle#end()

filetype plugin indent on
