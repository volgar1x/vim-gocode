if exists("b:did_ftplugin_go_install")
	finish
endif

function! GocodeCompletePkg(arg, cmd, index)
	let s:base=getcwd()
	let s:dirs=filter(split(globpath(s:base, a:arg.'*'), '\n'), 'isdirectory(v:val)')
	return map(s:dirs, 'substitute(v:val, s:base."/", "", "")')
endfunction

command! -buffer -nargs=1 -complete=customlist,GocodeCompletePkg GoInstall call s:GoInstall(getcwd(), <f-args>)
command! -buffer GoCurInstall call s:GoInstall(@%, '.')
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

command! -buffer -nargs=1 -complete=customlist,GocodeCompletePkg GoTest call s:GoTest(getcwd(), <f-args>)
command! -buffer GoCurTest call s:GoTest(@%, '.')
function! s:GoTest(file, relpkg)
	let pkg=GoRelPkg(a:file, a:relpkg)
	if pkg != -1
		echo system('go test '.pkg)
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	endif
endfunction

command! -buffer -nargs=1 -complete=customlist,GocodeCompletePkg GoTestVerbose call s:GoTestVerbose(getcwd(), <f-args>)
function! s:GoTestVerbose(file, relpkg)
	let pkg=GoRelPkg(a:file, a:relpkg)
	if pkg != -1
		echo system('go test -v '.pkg)
	else
		echohl Error | echo 'You are not in a go package' | echohl None
	endif
endfunction

let b:did_ftplugin_go_install=1
