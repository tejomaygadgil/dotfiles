lua require("tej")

" SICP testing
" Abbrevations
func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
iab sd (define () )<esc>T(i<C-R>=Eatchar('\s')<CR>
iab sv (define )<esc>ha<C-R>=Eatchar('\s')<CR>
iab sb ```{{scheme}}<CR><CR><CR><CR>```<Esc>kki<C-R>=Eatchar('\s')<CR>
iab sc ; #################### ####################<Esc>bhi
" Slime
nnoremap st 't<Plug>SlimeParagraphSend
nnoremap sg 'g<Plug>SlimeParagraphSend

" vim-slime
xmap ss <Plug>SlimeRegionSend
nmap ss <Plug>SlimeParagraphSend

" Multiple vim sessions on the same file
let g:instant_username ="tej"
function! StartInstant()
    execute 'InstantStartServer 127.0.0.1 8080'
    execute 'InstantStartSession 127.0.0.1 8080'
endfunction
function! JoinInstant()
    execute 'InstantJoinSession 127.0.0.1 8080'
    execute 'InstantFollow tej'
endfunction

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
nnoremap <F2> :call ToggleTwoColumns()<CR>

" Toggle search highlighting
noremap <F5> :set hlsearch! hlsearch?<CR>

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

" Disable arrow keys
" for key in ['<Up>', '<Down>', '<Left>', '<Right>']
"   exec 'noremap' key '<Nop>'
"   exec 'inoremap' key '<Nop>'
"   exec 'cnoremap' key '<Nop>'
" endfor

