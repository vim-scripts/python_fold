" Vim folding file
" Language:	Python
" Author:	Jorrit Wiersma
" Last Change:	2003 May 08


setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold(v:lnum)

" Only define function once
if exists("*GetPythonFold")
  finish
endif

function GetPythonFold(lnum)
    " Determine folding level in Python source
    "
    let line = getline(a:lnum)
    let ind  = indent(a:lnum)

    " Ignore blank lines
    if line =~ '^\s*$'
	return "="
    endif

    " Ignore triple quoted strings
    if line =~ '"""'
	return "="
    endif

    " Ignore continuation lines (this should be done better)
    if line =~ '\\$'
	return '='
    endif

    " Support markers
    if line =~ '{{{'
	return "a1"
    elseif line =~ '}}}'
	return "s1"
    endif

    " Classes and functions get their own folds
    if line =~ '^\s*\(class\|def\)\s'
	return ">" . (ind / &sw + 1)
    endif

    let pnum = prevnonblank(a:lnum - 1)

    if pnum == 0
	" Hit start of file
	return 0
    endif

    " The end of a fold is determined through a difference in indentation
    " between this line and the next.
    " So first look for next line
    let nnum = nextnonblank(a:lnum + 1)
    if nnum == 0
	return "="
    endif

    " First I check for some common cases where this algorithm would
    " otherwise fail. (This is all a hack)
    let nline = getline(nnum)
    if nline =~ '^\s*\(except\|else\|elif\)'
        return "="
    endif

    " If next line has less indentation we end a fold.
    " This ends folds that aren't there a lot of the time, and this sometimes
    " confuses vim.  Luckily only rarely.
    let nind = indent(nnum)
    if nind < ind
	return "<" . (nind / &sw + 1)
    endif

    " If none of the above apply, keep the indentation
    return "="


endfunction

