" Инициализация менеджера плагинов
call plug#begin('~/.vim/plugged')
    " Пакеты с темами
    Plug 'wuelnerdotexe/vim-enfocado'
    Plug 'chriskempson/base16-vim'
call plug#end()

" Включаем поддержку истинных цветов (True Color)
if (has('termguicolors'))
    set termguicolors
endif

" Путь к файлу состояния темы (его будет обновлять ваш bash-скрипт)
let s:mode_file = expand('~/.config/hypr/current_theme_mode')

" Читаем текущий режим (по умолчанию dark, если файла нет)
let s:mode = filereadable(s:mode_file) ? trim(readfile(s:mode_file)[0]) : 'dark'

if s:mode ==# 'light'
    " --- СВЕТЛАЯ ТЕМА ---
    set background=light
    let g:everforest_background = 'nature'
    colorscheme enfocado
else
    " --- ТЕМНАЯ ТЕМА ---
    set background=dark
    colorscheme base16-ashes
endif
