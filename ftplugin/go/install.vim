if exists("b:did_ftplugin_go_install")
	finish
endif

function! GocodeCompletePkg(arg, cmd, index)
	let s:base=DirName(@%)
	let s:dirs=filter(split(globpath(s:base, a:arg.'*'), '\n'), 'isdirectory(v:val)')
	let s:ndirs=len(s:dirs)

	if s:ndirs <= 0
		return ''
	elseif s:ndirs == 1
		let s:matched=s:dirs[0]
	else
		let s:matched=s:dirs[0] " TODO select the next match
	endif

	return substitute(s:matched, s:base.'/', '', '').'/' " add a trailing / to quickly match a child
endfunction

command! -buffer -nargs=1 -complete=custom,GocodeCompletePkg GoInstall call s:GoInstall(@%, <f-args>)
function! s:GoInstall(file, relpkg)
	let pkg=GoRelPkg(a:file, a:relpkg)
	if pkg != -1
		let output=system('go install '.pkg)
		if !v:shell_error
			echo 'Package '.pkg.' installed'
		else
			echo output
		endif
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	endif
endfunction

command! -buffer -nargs=1 -complete=custom,GocodeCompletePkg GoTest call s:GoTest(@%, <f-args>)
function! s:GoTest(file, relpkg)
	let pkg=GoRelPkg(a:file, a:relpkg)
	if pkg != -1
		echo system('go test '.pkg)
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	endif
endfunction

let b:did_ftplugin_go_install=1

