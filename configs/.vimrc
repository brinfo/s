set number
set expandtab
set shiftwidth=4
set tabstop=4
set autoindent
set cindent
"set smartindent
set showmatch
set matchtime=5
set hlsearch
set incsearch
set autowrite
set tags+=../tags

syntax on
colorscheme default
"Cyan Magenta green
hi LineNr cterm=none ctermfg=grey ctermbg=black guifg=#888888 guibg=#000000

set fileencoding=utf-8
set fileencodings=utf-8,gbk

nmap    <silent>    ==     <Esc>:make<CR>
nmap    <silent>    --     <Esc>:make clean; make<CR>

