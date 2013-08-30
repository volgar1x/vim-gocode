vim-gocode
==========

All credit goes to [nsf/code](http://github.com/nsf/gocode)

## Commands

* **:CurPkg** takes no argument and print the current file's package

*Example* `:CurPkg` in the `$GOPATH/src/github.com/Blackrush/gofus/main.go` file will print `github.com/Blackrush/gofus`

* **:RelPkg** takes one argument, a relative package path, and print it as a full package path

*Example* `:RelPkg ../pkg/child` in the `$GOPATH/src/github.com/Blackrush/gofus/main.go` file will print `github.com/Blackrush/pkg/child`

* **:Install** takes one argument, a relative package path, install it or print compilation errors otherwise

*Example* `:Install ../pkg/child` in the `$GOPATH/src/github.com/Blackrush/gofus/main.go` file will try to install the `github.com/Blackrush/pkg/child` package

See #1 to see future commands implementation.

## Installation

### Vundle

Add this line to your ~/.vimrc configuration file :

> Bundle 'Blackrush/vim-gocode'

And then run vim :

> vim +BundleInstall

### Pathogen

*todo*
