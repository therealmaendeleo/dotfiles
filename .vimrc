" ============================================================
" Настройки Vim
" ============================================================

" --- Менеджер плагинов ---
call plug#begin('~/.vim/plugged')
    " Тема (одна — и этого достаточно)
    Plug 'sainnhe/everforest'

    " Редактирование
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'

    " Навигация (бинарник fzf скачивается плагином при :PlugInstall)
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()

" --- Базовые настройки ---
syntax on
filetype plugin indent on

set number
set incsearch
set hlsearch
set ignorecase
set smartcase
set scrolloff=8
set undofile
set wildmenu
set splitbelow
set splitright

if has('clipboard') || has('clipboard_provider')
    set clipboard=unnamedplus
endif

" --- Отступы: мягкие табы (4 пробела) там, где это допустимо ---
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

augroup indent_four_spaces
    autocmd!
    " По умолчанию — 4 пробела, кроме файлов, где таб обязателен
    autocmd FileType * if index(['make', 'go'], &filetype) < 0 | setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 | endif
    " Makefile и Go: настоящие табы, чтобы не сломать сборку/форматирование
    autocmd FileType make,go setlocal noexpandtab tabstop=4 softtabstop=0 shiftwidth=4
augroup END

" Markdown: обёртывание в **жирный** клавишей *
augroup markdown_surround
    autocmd!
    autocmd FileType markdown let b:surround_42 = "**\r**"
augroup END

" --- Цвета ---
if has('termguicolors')
    set termguicolors
endif

" Параметры тем (должны быть заданы до colorscheme)
let g:everforest_background = 'soft'
let g:everforest_enable_italic = 1
let g:everforest_better_performance = 1

" Путь к файлу состояния темы (его обновляет bash-скрипт Hyprland)
let s:mode_file = expand('~/.config/hypr/current_theme_mode')
let s:last_mode = ''

function! s:ApplyTheme() abort
    let l:mode = filereadable(s:mode_file) ? trim(readfile(s:mode_file)[0]) : 'dark'
    if l:mode ==# s:last_mode
        return
    endif
    let s:last_mode = l:mode

    if l:mode ==# 'light'
        set background=light
    else
        set background=dark
    endif
    colorscheme everforest
endfunction

call s:ApplyTheme()

" Подхватываем смену темы без перезапуска Vim
augroup theme_mode_sync
    autocmd!
    autocmd FocusGained * call <SID>ApplyTheme()
augroup END

if has('timers')
    call timer_start(2000, {-> <SID>ApplyTheme()}, {'repeat': -1})
endif

" Памятка на русском: открывается командой :Guide
command! Guide edit ~/.vim/GUIDE.ru.md
