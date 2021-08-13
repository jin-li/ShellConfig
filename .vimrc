" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 Jul 18
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

""" Following is for vundle, added on 2018.3.8 by lijin

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" YouCompleteMe, installed on 2018.3.8 by lijin
" Plugin 'Valloric/YouCompleteMe' " Can be used with vim 7.4.1578
" airline, a copy of powerline, installed on 2018.3.8 by lijin
Plugin 'vim-airline/vim-airline'
" vimtex, for LaTeX, installed on 2018.5.13 by lijin
Plugin 'lervag/vimtex'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
""Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
""Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
""Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""" End of vundle plugin

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
"set backspace=indent,eol

set autoindent		" always set autoindenting on
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nospell

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Make cursor keys ignore wrapping
map <Down> gj
map <Up> gk
 

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

endif " has("autocmd")

set tabstop=6
set shiftwidth=4

"------------------->
"Paste Mode On/Off 
"USE this when you use vim over putty
map <F12> :call Paste_on_off()<CR>
set pastetoggle=<F12>

let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
        if g:paste_mode == 0
                set paste
                let g:paste_mode = 1
        else
                set nopaste
                let g:paste_mode = 0
        endif
        return
endfunc 
"<--------------------

"------------------->
"by yangzw, to cancel the automatic comment label when adding a new line.
"<------------------
au FileType * setl fo-=cro

"set mouse=a
syntax enable
set number
set relativenumber

"------------------------>
" set by lijin, 2018.3.9
"<-----------------------
set ts=4
"set list  " display special chars
"set listchars=space:·

set background=dark
"set background=light
"colorscheme monokai
"colorscheme solarized
"colorscheme murphy
"colorscheme delek
"colorscheme desert
"colorscheme blue
"colorscheme darkblue
"colorscheme elflord
"colorscheme evening
"colorscheme koehler
"colorscheme morning
"colorscheme pablo
"colorscheme peachpuff
"colorscheme ron
"colorscheme shine
"colorscheme torte
"colorscheme zellner

"YouCompleteMe
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:airline_powerline_fonts=1

"vimtex
let g:vimtex_compiler_latexmk={'callback':0}

if !exists('g:airline_symbols')
	let g:airline_symbols={}
endif
let g:airline_symbols.linenr='≡'
let g:tex_flavor = 'plain'
