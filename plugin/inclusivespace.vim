" This map makes it easier to search across linebreaks. If you want to
" search for "hello there" but there might be a linebreak in between
" the "hello" and the "there", you will have to do something like
" "hello[ \n]there". But what about other whitespace? Okay, you say, I'll
" search for "hello\_s\+there" to catch one or more whitespace characters,
" including newlines. But what if the phrase occurs in a comment? In that case
" there might be a comment character in front of the "there". And what if this
" is a Markdown document and the phrase occurs inside a blockquote? You don't
" *really* want to search for
" "hello\(\_s\+\|\V<!--\m\|\V-->\m\|\V>\m\)\+there" each time, do you?
" Instead, with this map, just type "hello" then <C-X><Space> then "there".

cnoremap <expr> <C-X><Space> "<C-R>=<SID>InclusiveSpace('" . getcmdtype() . "')<CR>"

function! s:InclusiveSpace(cmdtype)
  " TODO also get 'm' (and others?) from &comments.
  let l:result = '\(\_s\+'
  if &commentstring !=# ""
    " Try to get the parts of the commentstring, e.g. "<!--" and "-->" for
    " HTML, "/*" and "*/" for C.
    for l:cmt in split(&commentstring, '%s')
      if l:cmt !=# ""
        " Strip whitespace
        let l:cmt = substitute(l:cmt, '^\s*\(.\{-}\)\s*$', '\1', '')
        let l:result .= '\|\V' . escape(l:cmt, a:cmdtype.'\') . '\m'
      endif
    endfor
  endif
  if &comments !=# ""
    for l:cmt in split(&comments, ',')
      if l:cmt =~# "n:"
        " Strip the "n:"
        let l:cmt = strpart(l:cmt, 2)
        " Strip whitespace
        let l:cmt = substitute(l:cmt, '^\s*\(.\{-}\)\s*$', '\1', '')
        let l:result .= '\|\V' . escape(l:cmt, a:cmdtype.'\') . '\m'
      endif
    endfor
  endif
  let l:result .= '\)\+'
  return l:result
endfunction
