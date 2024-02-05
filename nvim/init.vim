lua require("tej")

" Abbrevations
iab sc ; #################### ####################<Esc>bhi

" Set shell to bash to prevent vim-slime slowdown
" https://github.com/jpalardy/vim-slime/issues/204
set shell=/bin/sh " set default shell

" Autoset working directory to current file
" https://vimways.org/2019/vim-and-the-working-directory/
set autochdir

" Jump to the last position when reopening a file
" https://stackoverflow.com/a/774599
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

" Map ctrl-s to copy to the system clipboard
vnoremap <C-s> "+y

" Two column scrolling
" https://vi.stackexchange.com/a/26876
let g:TwoColumnsActive = 0
function! ToggleTwoColumns()
  if g:TwoColumnsActive == 0
    execute "normal zR"
    set noscrollbind
    vsplit
    execute "normal \<c-f>"
    execute "normal jjj"
    set scrollbind
    wincmd h
    set scrollbind
    let g:TwoColumnsActive = 1
  else
    wincmd l
    q
    set noscrollbind
    let g:TwoColumnsActive = 0
  endif
endfunction
nnoremap <F7> :call ToggleTwoColumns()<CR>

" Highlight cursorline for better readability
" https://stackoverflow.com/a/58372745
set cursorline
set cursorcolumn
highlight LineNr guifg=LightGrey
highlight CursorLineNR gui=bold guifg=white
" Change sign for Gitsigns
highlight GitSignsChange guifg=gold

" Toggle search highlighting
set nohlsearch
noremap <F5> :set hlsearch! hlsearch?<CR>

" Strip trailing white space
" https://vi.stackexchange.com/a/2285
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Conceal formatting characters for Markdown text
set conceallevel=2

" Add new line above and below without entering insert mode
" https://stackoverflow.com/a/16136133
nmap o o<Esc>
nmap O O<Esc>

" Fix line wrapping
noremap j gj
noremap k gk

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

" Ignore case
set ignorecase
set smartcase

" Improve scroll
set scrolloff=8

" Set relative and absolute lines numbers
set nu rnu
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set nu rnu

