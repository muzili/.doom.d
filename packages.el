;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)

(when (package! lsp-mode)
  (package! lsp-ui)
  (package! company-lsp)

  (when (featurep! +python)
    (package! anaconda-mode :disable t))

  (when (featurep! +cpp)
    (package! ccls)
    (package! rtags :disable t))

  (when (featurep! +sh)
    (package! company-shell :disable t)))
