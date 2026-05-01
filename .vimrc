" Set colorscheme
colorscheme wildcharm

" Set true color
set termguicolors

" Show line numbers
set number

" Relative line numbers
set relativenumber

" Remove trailing white space on save
autocmd BufWritePre * :%s/\s\+$//e

" Align similar lines in diff view
set diffopt+=linematch:100

" Compatibility mode
set nocompatible

" Smart indentation
set autoindent smartindent

" Enable wildmenu for command-line completion
set wildmenu

" Use popup menu instead of inline wildmenu
set wildoptions=pum

" noselect: no pre-select; lastused: recent buffers; full: cycle matches
set wildmode=noselect:lastused,full

" Syntax highlighting
syntax on

" Allow switching buffers without saving
set hidden

" Show statusline
set laststatus=2

" Scroll window
set mouse=a

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Use system clipboard
set clipboard=unnamedplus

" Enable full backspacing
set backspace=indent,eol,start

" Enable file type detection and indentation
filetype plugin indent on

" Provides the completion candidates
set omnifunc=syntaxcomplete#Complete

" Controls how the menu behaves
set completeopt=menuone,noselect

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

set undofile
set undodir=$HOME/.vim/vim-undo

" Create undo directory if it doesn't exist
let undodir = "/.vim/vim-undo"
if undodir == 0
    call mkdir($HOME . undodir, "p")
endif

" Delete without copying Shift+D
nnoremap D "_D

" Map jj to <Esc> in insert mode
inoremap jj <Esc>

" Map Ctrl+S to save in normal, insert, and visual modes
noremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>
vnoremap <C-s> <Esc>:update<CR>

" Clear search highlighting with <Space>
nnoremap <silent> <Space> :nohlsearch<CR>

" Copy visual selection to system clipboard
vnoremap <C-c> y:call system('wl-copy', getreg('"'))<CR>

" Paste in normal mode
nnoremap <C-v> :r !wl-paste<CR>

" Paste in insert mode
inoremap <C-v> <C-r>=system('wl-paste')<CR>
