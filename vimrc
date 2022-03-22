set history=500

filetype plugin on
filetype indent on

" Set to auto read when file changed from outside
set autoread
au FocusGained,BufEnter * checktime

set wildignore=*.o,*.ko,*.mod.c,*.order,modules.builtin,*.pyc

" Always show current position
set ruler

" Height of command bar
set cmdheight=1

" Enable syntax highlighting
syntax enable

set encoding=utf8
set ffs=unix

" Turn backup and swap off
set nobackup
set nowb
set noswapfile

" Use tabs only with tabwidth of 8
setlocal tabstop=8
setlocal shiftwidth=8
setlocal softtabstop=8
setlocal textwidth=80
setlocal noexpandtab

set colorcolumn=+1

setlocal cindent
setlocal cinoptions=:0,l1,t0,g0,(0

" highlight ExtraWhitespace ctermbg=red
" match ExtraWhitespace /\s\+$/
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

syn keyword cOperator likely unlikely
syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64

highlight default link LinuxError ErrorMsg

syn match LinuxError / \+\ze\t/		            " spaces before tab
syn match LinuxError /\%>80v[^()\{\}\[\]<>]\+/  " virtual column 81 or more

" Highlight trailing whitespace, unless we're in insert mode and the
" cursor's placed right after the whitespace. This prevents us from having
" to put up with whitespace being highlighted in the middle of typing
" something
autocmd InsertEnter * match LinuxError /\s\+\%#\@<!$/
autocmd InsertLeave * match LinuxError /\s\+$/

" Highlight whitespace problems.
" flags is '' to clear highlighting, or is a string to
" specify what to highlight (one or more characters):
"   e  whitespace at end of line
"   i  spaces used for indenting
"   s  spaces before a tab
"   t  tabs not at start of line
function! ShowWhitespace(flags)
  let bad = ''
  let pat = []
  for c in split(a:flags, '\zs')
    if c == 'e'
      call add(pat, '\s\+$')
    elseif c == 'i'
      call add(pat, '^\t*\zs \+')
    elseif c == 's'
      call add(pat, ' \+\ze\t')
    elseif c == 't'
      call add(pat, '[^\t]\zs\t\+')
    else
      let bad .= c
    endif
  endfor
  if len(pat) > 0
    let s = join(pat, '\|')
    exec 'syntax match ExtraWhitespace "'.s.'" containedin=ALL'
  else
    syntax clear ExtraWhitespace
  endif
  if len(bad) > 0
    echo 'ShowWhitespace ignored: '.bad
  endif
endfunction

function! ToggleShowWhitespace()
  if !exists('b:ws_show')
    let b:ws_show = 0
  endif
  if !exists('b:ws_flags')
    let b:ws_flags = 'iest'  " default (which whitespace to show)
  endif
  let b:ws_show = !b:ws_show
  if b:ws_show
    call ShowWhitespace(b:ws_flags)
  else
    call ShowWhitespace('')
  endif
endfunction

nnoremap <Leader>ws :call ToggleShowWhitespace()
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

"set list
"set listchars=tab:>-,trail:$
" vim: ts=4 et sw=4
