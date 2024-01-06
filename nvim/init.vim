lua require("tej")

" Set shell to bash to prevent vim-slime slowdown
" https://github.com/jpalardy/vim-slime/issues/204
set shell=/bin/sh " set default shell

"
" Jump to the last position when reopening a file
" https://stackoverflow.com/a/774599
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" Add new line above and below without entering insert mode
" https://stackoverflow.com/a/16136133
nmap oo o<Esc>
nmap OO O<Esc>
set timeoutlen=300

" Ctrl-s to save, and saving exits insert mode
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>

" Spelling
setlocal spell spelllang=en_us

" Vim slime
let g:slime_target = "tmux"
" Fix for ipython %cpaste
let g:slime_bracketed_paste = 1

" Undotree
let g:undotree_SetFocusWhenToggle = 1

" Complete menu options
set completeopt=menu,preview,noinsert

" Natural split openings
" https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
set splitbelow
set splitright

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

