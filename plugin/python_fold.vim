" Vim folding file
" Language:	Python
" Author:	Jorrit Wiersma
" Last Change:	2002 Dec 19


setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold()

" Only define function once
if exists("*GetPythonFold")
  finish
endif

function GetPythonFold()
    " Determine folding level in Python source
    "
    let pnum = prevnonblank(v:lnum - 1)

    if pnum == 0
	" Hit start of file
	return 0
    endif

    let line = getline(v:lnum)
    let ind  = indent(v:lnum)

    " Ignore blank lines
    if line =~ '^\s*$'
	return "="
    endif

    " Ignore triple quoted strings
    if line =~ '"""'
	return "="
    endif

    " Support markers
    if line =~ '{{{'
	return "a1"
    elseif line =~ '}}}'
	return "s1"
    endif

    " Classes and functions get their own folds
    if line =~ '^\s*\(class\|def\)'
	return ">" . (ind / &sw + 1)
    endif

    " The end of a fold is determined through a difference in indentation
    " between this line and the next.
    " So first look for next line
    let nnum = nextnonblank(v:lnum + 1)
    if nnum == 0
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

