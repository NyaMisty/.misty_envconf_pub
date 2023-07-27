command! SuperWrite :w ! sudo tee %
cnoreabbrev www SuperWrite
command! SuperQuit :q!
cnoreabbrev qq SuperQuit

cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev Q q

" https://vi.stackexchange.com/a/53/18902
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif

if !isdirectory($HOME."/.vim/backup-dir")
    call mkdir($HOME."/.vim/backup-dir", "", 0700)
endif
set backupdir=$HOME/.vim/backup-dir
set backup

if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=$HOME/.vim/undo-dir
set undofile

call plug#begin()

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-sleuth'

call plug#end()

set tabstop=4
"set shiftwidth=4
"set expandtab

set backspace=indent,eol,start
