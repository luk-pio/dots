" Custom keymaps
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k
nnoremap <C-J> a<CR><Esc>k$

inoremap fd <ESC> l

map <C-n> :NERDTreeToggle<CR>

syntax enable " enable syntax processing
set background=dark
colorscheme peachpuff
set encoding=utf-8

" TABS
set tabstop=2 " number of visual spaces per tab
set softtabstop=2 " number of spaces to insert per tab when editing
set expandtab " all tabs are converted into spaces
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab

" VISUAL INFO
set number " show line nums
set rnu " show relative line numbers
set showcmd " show last command
set cursorline " highlight selected line
set wildmenu " visual cmd autocomplete
set lazyredraw 
set showmatch " highlight matching parens
set hlsearch " highlight search matches
set incsearch " highlight matches as you type
set autoread " automatically reload changes on disk

highlight Pmenu ctermbg=gray 
highlight PmenuSel ctermbg=green ctermfg=white

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview


if &term =~ '^xterm\\|rxvt'
  " solid underscore
  let &t_SI .= "\<Esc>[4 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

packadd! matchit

" Automatically install plug.vim
if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

source $HOME/.vim/plugins.vim
