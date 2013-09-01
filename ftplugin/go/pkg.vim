if exists('b:did_ftplugin_go_pkg')
	finish
endif

function! TrimSystemOutput(output)
	return strpart(a:output, 0, strlen(a:output)-1)
endfunction

function! ReadLink(file)
	return TrimSystemOutput(system('readlink -f '.a:file))
endfunction

function! BaseName(file)
	return TrimSystemOutput(system('basename '.a:file))
endfunction

function! DirName(file)
	return TrimSystemOutput(system('dirname '.a:file))
endfunction

if !exists('g:gocode_gopath')
	let g:gocode_gopath=TrimSystemOutput(system('go env GOPATH'))
endif
let s:gopath=ReadLink(g:gocode_gopath)

function! GoPkg(arg)
	let s:path=ReadLink(a:arg)

	if match(s:path, s:gopath) < 0
		echohl Error | echomsg "You are not in a go package" | echohl None
		return -1
	endif

	if isdirectory(s:path)
		return substitute(s:path, s:gopath.'/src/', '', '')
	else
		return substitute(substitute(s:path, s:gopath.'/src/', '', ''), '/'.BaseName(s:path), '', '')
	endif
endfunction

function! GoRelPkg(file, relpkg)
	if isdirectory(a:file)
		return GoPkg(a:file.'/'.a:relpkg)
	else
		return GoPkg(DirName(a:file).'/'.a:relpkg)
	end
endfunction

command! -buffer CurPkg call s:GoCurPkg()
function! s:GoCurPkg()
	let pkg=GoPkg(@%)
	if pkg != -1
		echo pkg
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	endif
endfunction

command! -buffer -nargs=1 RelPkg call s:GoRelPkg(<f-args>)
function! s:GoRelPkg(rel)
	let pkg=GoRelPkg(@%, a:rel)
	if pkg != -1
		echo pkg
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	end
endfunction

let b:did_ft_plugin_go_pkg=1
