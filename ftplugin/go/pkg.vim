if exists('b:did_ftplugin_go_pkg')
    finish
endif

function! GoRelPkg(file, relpkg)
    if isdirectory(a:file)
        return go#package#FromPath(a:file.'/'.a:relpkg)
    else
        return go#package#FromPath(fnamemodify(a:file, ':p:h').'/'.a:relpkg)
    end
endfunction

command! -buffer CurPkg call s:GoCurPkg()
function! s:GoCurPkg()
    let pkg=go#package#FromPath(@%)
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

" Set b:gopackage if any
if type(go#package#FromPath(@%)) == type('')
    let b:gopackage = go#package#FromPath(@%)
    compiler go " enable building the whole package
endif

let b:did_ft_plugin_go_pkg=1
