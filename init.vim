"---------------------------------
" Moving to NeoVim
"---------------------------------

" Plugin settings ----{{{

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Bootstrap vim plug' {{{ "
if empty(glob("~/.config/nvim/autoload/plug.vim"))
    " Ensure all needed directories exist
    execute '!mkdir -p ~/.config/nvim/plugged'
    execute '!mkdir -p ~/.config/nvim/autoload'
    " Download the actual plugin manager
    execute '!curl -fLo ~/.config/nvim/autoload/plug.vim 
        \ --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    normal! :PlugInstall<CR>
endif
" }}} Bootstrap vim plug' "

call plug#begin('~/.config/nvim/plugged')

"Completion
Plug 'Valloric/YouCompleteMe', {'do': './install.py -all'}
Plug 'rdnetto/YCM-Generator'
"Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Easier text editing
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
"Mappings
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
"Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
let g:lightline = { 'colorscheme': 'solarized', }
"File Navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
"Git
Plug 'tpope/vim-fugitive'
"Languages -----------------------
"Latex
Plug 'lervag/vimtex'
Plug 'matze/vim-tex-fold'
"Ocaml
Plug 'the-lambda-church/merlin'
"Haskell
Plug 'eagletmt/ghcmod-vim'
" required for ghcmod
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'eagletmt/neco-ghc'
Plug 'parsonsmatt/intero-neovim'
"General linter
Plug 'w0rp/ale'

call plug#end()
" End Plugin Settings ----}}}

" Config filetypes ---------------------- {{{
" no code folding on open
set foldlevel=99
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap , :wall<CR>:source ~/.config/nvim/init.vim<CR>:nohlsearch<CR>
augroup END

augroup filetype_config
    autocmd!
    autocmd FileType conf setlocal foldmethod=marker
augroup END

augroup filetype_help
    autocmd!
    autocmd FileType help wincmd L
augroup END

augroup filetype_all
    autocmd!
    autocmd InsertLeave * set cursorline
    autocmd InsertEnter * set nocursorline
augroup END
" }}}

" Misc Key mappings {{{ " 

let mapleader = "\<Space>"

"Life is better this way
nnoremap ; :
vnoremap ; :

"Since comma isn't the leader, use it to save
nnoremap , :wall<CR>

" Toggle comment with single key
nmap ' <Plug>CommentaryLine
nmap " gcap
vmap ' <Plug>Commentary

" Ycmd Fixit
nnoremap <Leader>h :YcmCompleter FixIt<CR>

" Remap escape key.
inoremap fd <Esc>
tnoremap fd <C-\><C-n>

" Fix behavior of Y so it matches C and D
nnoremap Y y$

" Formatting
nmap = <Plug>(EasyAlign)
vmap = <Plug>(EasyAlign)

" Access git
nnoremap <Leader>g :Gstatus<CR>

" Edit vimrc easily
nnoremap <silent> <Leader>ev :vs ~/.config/nvim/init.vim<CR>

" Weird python thing I don't understand
nnoremap <buffer> <C-B> :exec ':w !python' shellescape(@%, 1)<cr>

" }}} Key mappings "

" Navigation {{{

" Easymotion config
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1 " 1 matches !, etc.
" Imporve vim's normal f motion
nmap f <Plug>(easymotion-sl)

" Incsearch 
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Create GotoCharTimer
nmap <c--> <Plug>(easymotion-sn)
function! PressEnter(timer)
    :call feedkeys("\<CR>")
endfunction
function! GoToCharTimer()
    :call feedkeys("\<c-->")
    let timer=timer_start(1500, 'PressEnter')
    :set nohlsearch
endfunction    

" Now <c-f> behaves like avy-go-to-char-timer
nnoremap <c-f> :call GoToCharTimer()<CR>
omap <c-f> <Plug>(easymotion-tn)

" Move up/down visual lines
nnoremap j gj
nnoremap k gk

" Move across windows normally
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Scroll nicely in terminal mode
tnoremap <c-j> <c-n>
tnoremap <c-k> <c-p>

" Open NerdTree
nnoremap - :NERDTreeToggle<CR>

" Close vim if all that's left open in NERDTree
augroup nerd_tree
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Fuzzy file finding
nnoremap <c-p> :Files<CR>
set grepprg=rg\ --vimgrep

" Fuzzy term finding in project with fzf 
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column 
 \ --line-number --no-heading 
 \ --fixed-strings --ignore-case 
 \ --follow --glob "!.git/*" 
 \ --color "always" '.shellescape(<q-args>), 1, <bang>0)
nnoremap s :Find<CR>

" Fzf list buffers
nnoremap : :Buffers<CR>

" }}}

" Completion and snippets {{{ "

" List all snippets active
nnoremap <silent> <leader>sl :Snippets<CR>
" Edit snippets
nnoremap <silent> <leader>se :UltiSnipsEdit<CR>

" Python autocompletion
let g:ycm_python_binary_path = '/usr/bin/python3'

" Stop asking about .ycm_extra_conf.py file
let g:ycm_extra_conf_globlist = ['~/*']

" Use bare bones global ycm conf as default
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:ycm_key_list_select_completion=['<C-j>']
" previous completion select buggy
let g:ycm_key_list_select_previous_completion=['<C-k>']

" Let Ultisnips split window
let g:UltiSnipsEditSplit="vertical"

" Just continue editing built in snippets
let g:UltiSnipsSnippetsDir="~/.config/nvim/plugged/vim-snippets/snippets"

" DelimitMate Config
let delimitMate_expand_cr=2

" Tab autocomplete (bashlike)
set wildmode=longest,list

" }}} Completion and snippets "

" Miscellaneous {{{ "

" Airline Fonts
let g:airline_powerline_fonts = 0

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Use mouse to resize buffers
set mouse=a

" Turn on syntax highlighting
syntax on

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Allow hidden buffers
set hidden

" Rendering
set ttyfast
set autoread

" Status bar
set laststatus=2

" Last line
set showcmd

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Color scheme (terminal)
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
set noshowmode

" For easier copying into vim
set pastetoggle=<F2>
set clipboard=unnamed

" Swap files are annoying
set noswapfile

" }}} Miscellaneous "

" {{{ Ocaml config
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## f9f88af42dffebb4b3f6fb7a3b95952c ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/Users/josephmorag/.opam/system/share/vim/syntax/ocp-indent.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line

" }}}

" Latex Config {{{
" Latex autocompletion and viewing
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
    \ 're!\\hyperref\[[^]]*',
    \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\(include(only)?|input){[^}]*',
    \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
    \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
    \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
    \ ]

let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
    call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
    call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
    call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
    call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction

" Prevent .tex files from being treated as plain text
let g:tex_flavor = 'latex'
" }}}

" Haskell config {{{ "
augroup filetype_haskell
    autocmd!
    autocmd Filetype haskell nnoremap <silent> <buffer> tw :GhcModTypeInsert<CR>
    autocmd Filetype haskell nnoremap <silent> <buffer> ts :GhcModSplitFunCase<CR>
    autocmd Filetype haskell nnoremap <silent> <buffer> tq :GhcModType<CR>
    autocmd Filetype haskell nnoremap <silent> <buffer> te :GhcModTypeClear<CR>
    " Remove <> from haskell matchpairs
    autocmd Filetype haskell let b:delimitMate_matchpairs = "(:),[:],{:}"
augroup END

let g:ycm_semantic_triggers = {'haskell' : ['.']}
" }}} Haskell config "
