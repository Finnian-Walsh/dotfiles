set relativenumber
set number
set cursorline

let mapleader = "\<Space>"
nnoremap <Leader>t :Ex<CR>

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

call plug#end()

syntax enable
set background=dark
colorscheme catppuccin_mocha

