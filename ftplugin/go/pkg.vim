if exists('b:did_ftplugin_go_pkg')
    finish
endif

if !exists('g:go_package_commands')
    let g:go_package_commands = 1
endif

if g:go_package_commands
    command! -buffer CurPkg call s:GoCurPkg()
    command! -buffer -nargs=1 RelPkg call s:GoRelPkg(<f-args>)
endif

function! GoRelPkg(file, relpkg)
    if isdirectory(a:file)
        return go#package#FromPath(a:file.'/'.a:relpkg)
    else
        return go#package#FromPath(fnamemodify(a:file, ':p:h').'/'.a:relpkg)
    end
endfunction

function! s:GoCurPkg()
    let pkg=go#package#FromPath(@%)
    if pkg != -1
        echo pkg
    else
        echohl Error | echo 'You are not in a go package' | echohl None
    endif
endfunction

function! s:GoRelPkg(rel)
    let pkg=GoRelPkg(@%, a:rel)
    if pkg != -1
        echo pkg
    else
        echohl Error | echo 'You are not in a go package' | echohl None
    end
endfunction

let b:did_ft_plugin_go_pkg=1

" vim:sw=4:et
