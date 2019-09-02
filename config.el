;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; General
(setq user-mail-address "wdiazux@gmail.com"
      user-full-name "William Diaz")

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

;; Prettier
(def-package! prettier-js
  :commands (prettier-js-mode)
  :init
  (defun setup-prettier-js ()
    "Sets up arguments and the mode."
    (interactive)
    (setq prettier-js-args '("--single-quote"))

    (prettier-js-mode))
  (add-hook! (typescript-mode
              js2-mode)
    #'setup-prettier-js)
(add-hook! web-mode (enable-minor-mode '("\\.tsx\\'" . setup-prettier-js))))

;; Typescript
(after! typescript-mode
  (add-hook 'typescript-mode-hook #'flycheck-mode))

;; Javascript
(after! js2-mode
  ;; use eslintd-fix so when i save it fixes dumb stuff
  (add-hook 'js2-mode-hook #'eslintd-fix-mode))

;; Web-mode
(after! web-mode
(add-hook 'web-mode-hook #'flycheck-mode))

(def-package! lsp-mode
  :commands (lsp-mode lsp-define-stdio-client))

(def-package! lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (set-lookup-handlers! 'lsp-ui-mode
                        :definition #'lsp-ui-peek-find-definitions
                        :references #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-max-height 8
        lsp-ui-doc-max-width 35
        lsp-ui-sideline-ignore-duplicate t))

(def-package! company-lsp
  :after lsp-mode
  :config
  (set-company-backend! 'lsp-mode 'company-lsp)
  (setq company-lsp-enable-recompletion t))

;(def-package! ccls
;  :when (featurep! +cpp)
;  :hook ((c-mode c++-mode objc-mode) . +setup-ccls)
;  :init
;  (setq ccls-extra-init-params '(:index (:comments 2)
;                                          :cacheFormat "msgpack"
;                                          :completion (:detailedLabel t))
;        ccls-sem-highlight-method 'overlay) ;; set to 'font-lock if highlighting slowly
;  (defun +setup-ccls ()
;    (setq-local company-transformers nil)
;    (setq-local company-lsp-cache-candidates nil)
;    (condition-case nil
;        (lsp-ccls-enable)
;      (user-error nil))))
;
(when (featurep! +rust)
  (after! rust
    (add-hook 'rust-mode-hook 'lsp)))


(when (featurep! +python)
  (after! python
    (lsp-define-stdio-client lsp-python "python"
                             #'projectile-project-root
                             '("pyls"))
    (add-hook! python-mode #'lsp-python-enable)))

(when (featurep! +sh)
  (after! sh-script
    (lsp-define-stdio-client lsp-sh
                            "sh"
                            #'projectile-project-root
                            '("bash-language-server" "start"))
    (add-hook 'sh-mode-hook #'lsp-sh-enable)))
