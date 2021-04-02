command! SuperWrite :w ! sudo tee %
cnoreabbrev www SuperWrite
command! SuperQuit :q!
cnoreabbrev qq SuperQuit

cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev Q q

set tabstop=4
set shiftwidth=4
set expandtab
