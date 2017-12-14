"overwrite with yanked text in visual mode
xnoremap p "_dP
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
noremap gp heli x<Esc>b"bPldwxbyw
noremap Q @q "use Q for playing q macro
nnoremap <BS> :Switch<CR>
nnoremap <F8> :TagbarToggle<CR>

let mapleader=","
" open a file using fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>v :tabedit $MYVIMRC<CR>
nnoremap <leader>l :set wrap!<CR> "toggle line wrapping
nnoremap <leader>` :<CR>!<CR>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
xmap ga <Plug>(EasyAlign) " Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign) " Start interactive EasyAlign for a motion/text object (e.g. gaip)
