lua require("tej")

" PERSONAL COMMANDS
" Natural split openings
" https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
set splitbelow
set splitright

" Easier split navigation
" https://stackoverflow.com/questions/6053301/easier-way-to-navigate-between-vim-split-panes
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


" Don't jump back when exiting search
set cpoptions+=x

" Set tabs 
set tabstop=4
set shiftwidth=4
set expandtab

" Improve search
set nohlsearch
set incsearch

" Improve scroll
set scrolloff=8

" Set relative and absolute lines numbers
set nu rnu

" Disable arrow keys
for key in ['<Up>', '<Down>', '<Left>', '<Right>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
  exec 'cnoremap' key '<Nop>'
endfor

