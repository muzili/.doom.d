;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

;packages for golang
;go get -u github.com/motemen/gore/cmd/gore
;go get -u github.com/mdempsky/gocode
;go get -u golang.org/x/tools/cmd/godoc
;go get -u golang.org/x/tools/cmd/goimports
;go get -u golang.org/x/tools/cmd/gorename
;go get -u golang.org/x/tools/cmd/guru

; packages for rustlang
;rustup component add rustfmt
;rustup component add cargo-check
;rustup component add cargo-edit

(package! ripgrep)
(package! undo-tree :disable t)
