call plug#begin()

Plug 'tpope/vim-sensible'

" Git
Plug 'tpope/vim-fugitive'

" Theme
Plug 'junegunn/seoul256.vim'

call plug#end()

set shell=/bin/bash
set ts=8
set sw=8
set softtabstop=8

set autoindent
set cindent
set smartindent

set cursorline
set hlsearch
set t_Co=256
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

let g:seoul256_background = 233
:silent! colorscheme seoul256

set cc=80
highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$\| \+ze\t/

