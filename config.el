;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; General
(setq user-mail-address "muzili@gmail.com"
      user-full-name "Zhiguang Li")

;; Remove the request from killing emacs
(setq confirm-kill-emacs nil)

;; Start maximized
(setq frame-resize-pixelwise t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; wrap lines
(global-visual-line-mode t)

;;Show all the icons in the modeline
(setq doom-modeline-icon t)
;; Don’t compact font caches during GC - for performance
(setq inhibit-compacting-font-caches t)

;; CSS
(setq web-mode-css-indent-offset 2)
(setq css-indent-offset 2)

(setq doom-font (font-spec :family "Source Code Pro" :size 18))
