(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval add-hook 'before-save-hook #'format-all-buffer nil t)
     (TeX-command-extra-options . "--shell-escape")
     (TeX-command-master . latexmk)
     (TeX-command-extra-options . "-xelatex --shell-escape")
     (TeX-command-master . "LatexMk")
     (eval org-shifttab 2))))
 ;;custom
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
