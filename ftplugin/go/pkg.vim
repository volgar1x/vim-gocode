if exists('b:did_ftplugin_go_pkg')
    finish
endif

if !exists('g:gocode_gopath')
    let g:gocode_gopath=system('go env GOPATH')[0:-2]
endif
let s:gopaths=map(split(g:gocode_gopath, ':'), 
                 \ 'fnamemodify(resolve(v:val), '':p'')')

function! GoPkg(arg)
    let path = fnamemodify(resolve(a:arg), ':p')

    for dir in s:gopaths
        if len(dir) && match(path, dir) == 0
            let gopath=dir
        endif
    endfor

    if !exists('gopath')
        return -1
    endif

    if isdirectory(path)
        return substitute(path, gopath . 'src/', '', '')
    else
        return substitute(substitute(path, gopath . 'src/', '', ''),
                    \ '/' . fnamemodify(path, ':t'), '', '')
    endif
endfunction

function! GoRelPkg(file, relpkg)
    if isdirectory(a:file)
        return GoPkg(a:file.'/'.a:relpkg)
    else
        return GoPkg(fnamemodify(a:file, ':p:h').'/'.a:relpkg)
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

" Set b:gopackage if any
if type(GoPkg(@%)) == type('')
    let b:gopackage = GoPkg(@%)
    compiler go " enable building the whole package
endif

let b:did_ft_plugin_go_pkg=1
