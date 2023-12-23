lua require("tej")

" Swap mappings of f and F with / and ?
nnoremap F ?
nnoremap ? F
vnoremap F ?
vnoremap ? F
nnoremap f /
nnoremap / f
vnoremap f /
vnoremap / f

" Spelling
setlocal spell spelllang=en_us

" Vim slime
let g:slime_target = "tmux"

" Undotree
let g:undotree_SetFocusWhenToggle = 1

" Complete menu options
set completeopt=menu,preview,noinsert

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
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" Remove search highlighting
set nohlsearch

" Ignore case
set ignorecase
set smartcase 

" Improve scroll
set scrolloff=8

" Set relative and absolute lines numbers
set nu rnu
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set nu rnu

" Disable arrow keys
for key in ['<Up>', '<Down>', '<Left>', '<Right>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
  exec 'cnoremap' key '<Nop>'
endfor

