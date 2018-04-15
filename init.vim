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
endif
" }}} Bootstrap vim plug' "

call plug#begin('~/.config/nvim/plugged')

"Completion
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator'
"Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Easier text editing
Plug 'simnalamburt/vim-mundo'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-multiple-cursors' "Experimental
Plug 'matze/vim-move'
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 200
"Mappings
Plug 'tpope/vim-repeat'
"Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
Plug 'sbdchd/neoformat'
"File Navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
"Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"Languages -----------------------
"Latex
Plug 'lervag/vimtex'
"Ocaml
Plug 'the-lambda-church/merlin'
"Haskell
Plug 'eagletmt/ghcmod-vim'
" required for ghcmod
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'eagletmt/neco-ghc'
"General linter
Plug 'w0rp/ale'
"Documentation
if has('mac') == 1
    Plug 'rizzatti/dash.vim'
endif

call plug#end()
" End Plugin Settings ----}}}

" Config filetypes ---------------------- {{{
" no code folding on open
set foldlevel=99

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap , :wall<CR>:source $MYVIMRC<CR>:nohlsearch<CR>
    autocmd FileType vim nnoremap <silent> <buffer> <Leader>vs :source %<CR>
    autocmd FileType vim nnoremap <silent> <buffer> <Leader>vi :PlugInstall<CR>
    autocmd FileType vim nnoremap <silent> <buffer> <Leader>vu :PlugUpdate<CR>
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
let maplocalleader = "\<Space>"

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

" In case we actually need to type fd, this makes it bearable
set timeoutlen=350

" Fix behavior of Y so it matches C and D
nnoremap Y y$

" Capital H and L are stronger h and l
nnoremap H ^
nnoremap L $

" Formatting
nmap = <Plug>(EasyAlign)
vmap = <Plug>(EasyAlign)
nnoremap <silent> <Leader>= :Neoformat<CR>
let g:move_map_keys = 0
vmap <DOWN> <Plug>MoveBlockDown
vmap <UP> <Plug>MoveBlockUp

" Git
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gp :execute ":Git push origin " . fugitive#head(0)<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gca :Gcommit --amend<CR>:q<CR>
nnoremap <silent> <Leader>gl :silent! Glog<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
let g:gitgutter_map_keys = 0
nmap <Leader>ga <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
nmap <Leader>gv <Plug>GitGutterPreviewHunk
nnoremap <silent> <Leader>gg :GitGutter<CR>
nnoremap <silent> ]g :GitGutterNextHunk<CR>
nnoremap <silent> [g :GitGutterPrevHunk<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>

" Tabs
nnoremap <silent> <Leader>t :tabnew<CR>

" Buffers
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprev<CR>

" Linter errors
nnoremap <silent> ]e :ALENextWrap<CR>
nnoremap <silent> [e :ALEPreviousWrap<CR>
nnoremap <silent> <Leader>at :ALEToggleBuffer<CR>
nnoremap <silent> <Leader>ad :ALEDetail<CR><C-w><C-j>

" Vimrc mappings under leader v
nnoremap <silent> <Leader>ve :tabedit ~/.config/nvim/init.vim<CR>

" Undo tree visualization 
nnoremap <silent> <Leader>u :MundoToggle<CR>

" Weird python thing I don't understand
nnoremap <buffer> <C-B> :exec ':w !python' shellescape(@%, 1)<cr>

" }}} Key mappings "

" Navigation {{{

" Easymotion config
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1 " 1 matches !, etc.
" Imporve vim's normal f motion
nmap f <Plug>(easymotion-sl)
omap f <Plug>(easymotion-sl)

" Incsearch 
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Inccommand
set inccommand=nosplit

" Create GotoCharTimer
nmap F <Plug>(easymotion-sn)
function! PressEnter(timer)
    :call feedkeys("\<CR>")
endfunction
function! GoToCharTimer()
    :call feedkeys("F")
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

" Find tabs easily
nnoremap <silent> <leader>1 1gt
nnoremap <silent> <leader>2 2gt
nnoremap <silent> <leader>3 3gt
nnoremap <silent> <leader>4 4gt
nnoremap <silent> <leader>5 5gt
nnoremap <silent> <leader>6 6gt
nnoremap <silent> <leader>7 7gt
nnoremap <silent> <leader>8 8gt
nnoremap <silent> <leader>9 9gt

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
nnoremap <leader><space> :Files<CR>
set grepprg=rg\ --vimgrep

" Fuzzy term finding in project with fzf 
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column 
 \ --line-number --no-heading 
 \ --fixed-strings --ignore-case 
 \ --follow --glob "!.git/*" 
 \ --color "always" '.shellescape(<q-args>), 1, <bang>0)
nnoremap <leader>/ :Find<CR>

" Fzf list buffers
nnoremap : :Buffers<CR>

" Search documentation
nmap <silent> <leader>d <Plug>DashSearch

" }}}

" Completion and snippets {{{ "

" List all snippets active
nnoremap <silent> <leader>sl :Snippets<CR>
" Edit snippets
nnoremap <silent> <leader>se :UltiSnipsEdit<CR>
nnoremap <silent> <leader>sE :vs ~/.config/nvim/plugged/vim-snippets/snippets<CR>


" Python autocompletion
let s:python_version = 3
let g:ycm_python_binary_path = '/usr/local/bin/python3'

" Stop asking about .ycm_extra_conf.py file
let g:ycm_extra_conf_globlist = ['~/*']

" Use bare bones global ycm conf as default
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/ycm_extra_conf.py'

" I never use this
let g:ycm_key_detailed_diagnostics = ''


let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:ycm_key_list_select_completion=['<C-j>']
let g:ycm_key_list_previous_completion=['<C-k>']

" Let Ultisnips split window
let g:UltiSnipsEditSplit="horizontal"

" Just continue editing built in snippets
let g:UltiSnipsSnippetsDir="~/.config/nvim/plugged/vim-snippets/UltiSnips"

" DelimitMate Config
let delimitMate_expand_cr=2

" Tab autocomplete (bashlike)
set wildmode=longest,list

" }}} Completion and snippets "

" Miscellaneous {{{ "

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
set gdefault

" Color scheme (terminal)
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
set noshowmode
" Allow background color toggle
if exists("*ToggleBackground") == 0
	function ToggleBackground()
		if &background == "dark"
			set background=light
		else
			set background=dark
		endif
	endfunction
	command BG call ToggleBackground()
endif

" For easier copying into vim
set pastetoggle=<F2>
set clipboard=unnamed

" Swap files are annoying
set noswapfile

" }}} Miscellaneous "

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

" This adds a callback hook that updates Skim after compilation {{{
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
" }}}

" Prevent .tex files from being treated as plain text
let g:tex_flavor = 'latex'

" Enable folding
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1
let g:vimtex_imaps_leader = ';'

augroup latex
    autocmd!
    autocmd Filetype tex inoremap <silent> <buffer> fd <ESC>:wall<CR>
    autocmd Filetype tex setlocal spell
    autocmd Filetype tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
    autocmd Filetype tex let b:delimitMate_quotes = "$"
    autocmd Filetype tex inoremap <buffer> \[ \[\]<LEFT><LEFT>
    autocmd Filetype tex inoremap <buffer> _ _{}<LEFT>
    autocmd Filetype tex inoremap <buffer> ^ ^{}<LEFT>
    autocmd Filetype tex let b:ale_enabled = 0
augroup END
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
    autocmd Filetype haskell let b:ale_linters = {
                                   \   'haskell': ['stack-ghc-mod', 'stack-ghc'],
                                   \}
augroup END

let g:ycm_semantic_triggers = {'haskell' : ['.']}
" }}} Haskell config "

" " {{{ Ocaml config
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line

" Disable ocaml's default mappings
let g:no_ocaml_maps=1
let g:merlin_disable_default_keybindings = 1
augroup ocaml
    autocmd!
    autocmd BufEnter,BufWinEnter *.ml      setlocal commentstring=(*\ %s\ *)
    autocmd BufEnter,BufWinEnter *.mll     setlocal commentstring=(*\ %s\ *)
    autocmd BufEnter,BufWinEnter *.mly     setlocal commentstring=/*\ %s\ */
    autocmd Filetype ocaml nnoremap <silent> <buffer> tq :MerlinTypeOf<CR>
    autocmd Filetype ocaml vnoremap <silent> <buffer> tq :MerlinTypeOf<CR>
augroup END
" " }}}
