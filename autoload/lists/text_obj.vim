" A Vim plugin to handle lists
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! lists#text_obj#list_element(is_inner, vmode) abort " {{{1
  let [l:root, l:current] = lists#parser#get_current()
  if empty(l:current)
    if a:vmode
      normal! gv
    endif
    return
  endif

  while v:true
    let l:start = [l:current.lnum_start, 1]
    let l:end = [l:current.lnum_end_children(), 1]
    let l:end[1] = strlen(getline(l:end[0]))
    let l:linewise = 1

    if a:is_inner
      let l:start[1] = 3 + indent(l:start[0])
      let l:linewise = 0
    endif

    if !a:vmode
          \ || l:current.type ==# 'root'
          \ || l:start != getpos('''<')[1:2]
          \ || l:end[0] != getpos('''>')[1]
          \ | break | endif

    let l:current = l:current.parent
  endwhile

  call cursor(l:start)
  execute 'normal!' (l:linewise ? 'V' : 'v')
  call cursor(l:end)
endfunction

" }}}1
