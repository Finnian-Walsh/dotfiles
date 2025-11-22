set relativenumber
set number
set cursorline

let mapleader = "\<Space>"

nnoremap <silent> <leader>t :Ex<CR>
nnoremap <silent> <leader>c :bd<CR>
nnoremap <silent> <leader>j :bn<CR>
nnoremap <silent> <leader>k :bp<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

if has('termguicolors')
    set termguicolors
endif

" plug auto install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'catppuccin/vim', {'as': 'catppuccin'}
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'bling/vim-bufferline'

call plug#end()

syntax enable
set background=dark
colorscheme catppuccin_mocha

