syntax on

set tabstop=2
set expandtab
set shiftwidth=2
set autoindent

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

set splitright
set splitbelow

set wildmode=longest,list,full
set wildmenu

set diffopt=vertical

au BufWinLeave * mkview
au BufWinEnter * silent loadview
au BufRead,BufNewFile *.twig set filetype=htmljinja

highlight Folded ctermbg=black ctermfg=brown

