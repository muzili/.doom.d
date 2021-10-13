;;; .doom.d/config.el -*- lexical-binding: t; -*-
;;(toggle-debug-on-error)
(load! "encoding")
(load! "ui")

;; Place your private configuration here
;; General
(setq user-mail-address "muzili@gmail.com"
      user-full-name "Zhiguang Li")

(when (eq window-system 'w32)
  ;; Current value of server-auth-dir is "~\\.emacs.d\\server\\"
  (setq default-directory "D:")
  (setenv "HOME" "D:"))

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

;; Enable local variables
(setq-default enable-local-variables t)


;(setq doom-font (font-spec :family "Source Code Pro" :size 18))
(after! lsp
  (set-lsp-priority! 'clangd 1)  ; ccls has priority 0
  ;(setq lsp-auto-guess-root t)
  ;(setq lsp-eldoc-render-all nil)
  ;(setq lsp-inhibit-message t)
  ;(setq lsp-message-project-root-warning t)
  ;(setq lsp-prefer-flymake :none)
  ;(setq lsp-enable-snippet nil)
 ;; enable log only for debug
  (setq lsp-log-io nil)

  ;; use `evil-matchit' instead
  (setq lsp-enable-folding nil)

  ;; no real time syntax check
  (setq lsp-diagnostic-package :none)

  ;; handle yasnippet by myself
  (setq lsp-enable-snippet nil)

  ;; use `company-ctags' only.
  ;; Please note `company-lsp' is automatically enabled if installed
  (setq lsp-enable-completion-at-point nil)

  ;; turn off for better performance
  (setq lsp-enable-symbol-highlighting nil)

  ;; use ffip instead
  (setq lsp-enable-links nil)

  ;; auto restart lsp
  (setq lsp-restart 'auto-restart)

  ;; @see https://github.com/emacs-lsp/lsp-mode/pull/1498 and code related to auto configure.
  ;; Require clients could be slow.
  ;; I only load `lsp-clients' because it includes the js client which I'm interested
  (setq lsp-client-packages '(lsp-clients))

  ;; don't ping LSP lanaguage server too frequently
  (defvar lsp-on-touch-time 0)
  (defadvice lsp-on-change (around lsp-on-change-hack activate)
    ;; don't run `lsp-on-change' too frequently
    (when (> (- (float-time (current-time))
                lsp-on-touch-time) 30) ;; 30 seconds
      (setq lsp-on-touch-time (float-time (current-time)))
      ad-do-it))

  (setq lsp-file-watch-threshold 128000)
  )

;; Takes a major-mode, a quoted hook function or a list of either
(setq org-directory "~/Orgnote")
(after! org
  (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))
    ;; The following setting is different from the document so that you
    ;; can override the document org-agenda-files by setting your
    ;; org-agenda-files in the variable org-user-agenda-files
    ;;
  (if (boundp 'org-user-agenda-files)
      (setq org-agenda-files org-user-agenda-files)
    (setq org-agenda-files (quote ("~/Orgnote"))))

   (setq org-use-fast-todo-selection t)

   (setq org-treat-S-cursor-todo-selection-as-state-change nil)

    (setq org-todo-state-tags-triggers
          (quote (("CANCELLED" ("CANCELLED" . t))
                  ("WAITING" ("WAITING" . t))
                  ("HOLD" ("WAITING") ("HOLD" . t))
                  (done ("WAITING") ("HOLD"))
                  ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                  ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                  ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

    (setq org-default-notes-file (concat org-directory "/capture.org"))

                                        ; Targets include this file and any file contributing to the agenda - up to 9 levels deep
    (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                     (org-agenda-files :maxlevel . 9))))

                                        ; Use full outline paths for refile targets - we file directly with IDO
    (setq org-refile-use-outline-path t)

    ; Targets complete directly with IDO
    (setq org-outline-path-complete-in-steps nil)

    ; Allow refile to create parent tasks with confirmation
    (setq org-refile-allow-creating-parent-nodes (quote confirm))

  ;;   ;; Custom agenda command definitions
  ;;   (setq org-agenda-custom-commands
  ;;         (quote (("N" "Notes" tags "NOTE"
  ;;                  ((org-agenda-overriding-header "Notes")
  ;;                   (org-tags-match-list-sublevels t)))
  ;;                 ("h" "Habits" tags-todo "STYLE=\"habit\""
  ;;                  ((org-agenda-overriding-header "Habits")
  ;;                   (org-agenda-sorting-strategy
  ;;                    '(todo-state-down effort-up category-keep))))
  ;;                 (" " "Agenda"
  ;;                  ((agenda "" nil)
  ;;                   (tags "REFILE"
  ;;                         ((org-agenda-overriding-header "Tasks to Refile")
  ;;                          (org-tags-match-list-sublevels nil)))
  ;;                   (tags-todo "-CANCELLED/!"
  ;;                              ((org-agenda-overriding-header "Stuck Projects")
  ;;                               (org-agenda-skip-function 'bh/skip-non-stuck-projects)
  ;;                               (org-agenda-sorting-strategy
  ;;                                '(category-keep))))
  ;;                   (tags-todo "-HOLD-CANCELLED/!"
  ;;                              ((org-agenda-overriding-header "Projects")
  ;;                               (org-agenda-skip-function 'bh/skip-non-projects)
  ;;                               (org-tags-match-list-sublevels 'indented)
  ;;                               (org-agenda-sorting-strategy
  ;;                                '(category-keep))))
  ;;                   (tags-todo "-CANCELLED/!NEXT"
  ;;                              ((org-agenda-overriding-header (concat "Project Next Tasks"
  ;;                                                                     (if bh/hide-scheduled-and-waiting-next-tasks
  ;;                                                                         ""
  ;;                                                                       " (including WAITING and SCHEDULED tasks)")))
  ;;                               (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
  ;;                               (org-tags-match-list-sublevels t)
  ;;                               (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-sorting-strategy
  ;;                                '(todo-state-down effort-up category-keep))))
  ;;                   (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
  ;;                              ((org-agenda-overriding-header (concat "Project Subtasks"
  ;;                                                                     (if bh/hide-scheduled-and-waiting-next-tasks
  ;;                                                                         ""
  ;;                                                                       " (including WAITING and SCHEDULED tasks)")))
  ;;                               (org-agenda-skip-function 'bh/skip-non-project-tasks)
  ;;                               (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-sorting-strategy
  ;;                                '(category-keep))))
  ;;                   (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
  ;;                              ((org-agenda-overriding-header (concat "Standalone Tasks"
  ;;                                                                     (if bh/hide-scheduled-and-waiting-next-tasks
  ;;                                                                         ""
  ;;                                                                       " (including WAITING and SCHEDULED tasks)")))
  ;;                               (org-agenda-skip-function 'bh/skip-project-tasks)
  ;;                               (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-sorting-strategy
  ;;                                '(category-keep))))
  ;;                   (tags-todo "-CANCELLED+WAITING|HOLD/!"
  ;;                              ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
  ;;                                                                     (if bh/hide-scheduled-and-waiting-next-tasks
  ;;                                                                         ""
  ;;                                                                       " (including WAITING and SCHEDULED tasks)")))
  ;;                               (org-agenda-skip-function 'bh/skip-non-tasks)
  ;;                               (org-tags-match-list-sublevels nil)
  ;;                               (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
  ;;                               (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
  ;;                   (tags "-REFILE/"
  ;;                         ((org-agenda-overriding-header "Tasks to Archive")
  ;;                          (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
  ;;                          (org-tags-match-list-sublevels nil))))
  ;;                  nil))))

    ;;
    ;; Resume clocking task when emacs is restarted
    (org-clock-persistence-insinuate)
    ;;
    ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
    (setq org-clock-history-length 23)
    ;; Resume clocking task on clock-in if the clock is open
    (setq org-clock-in-resume t)
    ;; Change tasks to NEXT when clocking in
    (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
    ;; Separate drawers for clocking and logs
    (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
    ;; Save clock data and state changes and notes in the LOGBOOK drawer
    (setq org-clock-into-drawer t)
    ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
    (setq org-clock-out-remove-zero-time-clocks t)
    ;; Clock out when moving task to a done state
    (setq org-clock-out-when-done t)
    ;; Save the running clock and all clock history when exiting Emacs, load it on startup
    (setq org-clock-persist t)
    ;; Do not prompt to resume an active clock
    (setq org-clock-persist-query-resume nil)
    ;; Enable auto clock resolution for finding open clocks
    (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
    ;; Include current clocking task in clock reports
    (setq org-clock-report-include-clocking-task t)

    (setq org-time-stamp-rounding-minutes (quote (1 1)))

    (setq org-agenda-clock-consistency-checks
          (quote (:max-duration "4:00"
                                :min-duration 0
                                :max-gap 0
                                :gap-ok-around ("4:00"))))

    ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
    (setq org-clock-out-remove-zero-time-clocks t)

    ;; Agenda clock report parameters
    (setq org-agenda-clockreport-parameter-plist
          (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))

                                        ; Set default column view headings: Task Effort Clock_Summary
    (setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

                                        ; global Effort estimate values
                                        ; global STYLE property values for completion
    (setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                        ("STYLE_ALL" . "habit"))))

    ;; Agenda log mode items to display (closed and state changes by default)
    (setq org-agenda-log-mode-items (quote (closed state)))

                                        ; Tags with fast selection keys
    (setq org-tag-alist (quote ((:startgroup)
                                ("@errand" . ?e)
                                ("@office" . ?o)
                                ("@home" . ?H)
                                ("@farm" . ?f)
                                (:endgroup)
                                ("WAITING" . ?w)
                                ("HOLD" . ?h)
                                ("PERSONAL" . ?P)
                                ("WORK" . ?W)
                                ("FARM" . ?F)
                                ("ORG" . ?O)
                                ("NORANG" . ?N)
                                ("crypt" . ?E)
                                ("NOTE" . ?n)
                                ("CANCELLED" . ?c)
                                ("FLAGGED" . ??))))

                                        ; Allow setting single tags without the menu
    (setq org-fast-tag-selection-single-key (quote expert))

                                        ; For tag searches ignore tasks with scheduled and deadline dates
    (setq org-agenda-tags-todo-honor-ignore-options t)

    (setq org-agenda-span 'day)

    (setq org-stuck-projects (quote ("" nil nil "")))

    (setq org-archive-mark-done nil)
    (setq org-archive-location "%s_archive::* Archived Tasks")

    (setq org-babel-python-command "python3")
    ; Make babel results blocks lowercase
    (setq org-babel-results-keyword "results")
    ;; active Babel languages
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((R . t)
       (latex . t)
       (python . t)
       (dot . t)
       (ditaa . t)
       (plantuml . t)
       (shell . t)
       (emacs-lisp . nil)))

    (defun bh/display-inline-images ()
      (condition-case nil
          (org-display-inline-images)
        (error nil)))

                                        ; Do not prompt to confirm evaluation
                                        ; This may be dangerous - make sure you understand the consequences
                                        ; of setting this -- see the docstring for details
    (setq org-confirm-babel-evaluate nil)

    ;(setq org-plantuml-jar-path
;          (expand-file-name "~/.doom.d/etc/plantuml.jar"))
    (setq plantuml-default-exec-mode 'jar)
                                        ; Use fundamental mode when editing plantuml blocks with C-c '
    (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))

    ;; Don't enable this because it breaks access to emacs from my Android phone
    (setq org-startup-with-inline-images nil)

                                        ; Inline images in HTML instead of producting links to the image
    (setq org-html-inline-images t)
                                        ; Do not use sub or superscripts - I currently don't need this functionality in my documents
    (setq org-export-with-sub-superscripts nil)
                                        ; Use org.css from the norang website for export document stylesheets
    (setq org-html-head-extra "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />")
    (setq org-html-head-include-default-style nil)
                                        ; Do not generate internal css formatting for HTML exports
    (setq org-export-htmlize-output-type (quote css))
                                        ; Export with LaTeX fragments
    (setq org-export-with-LaTeX-fragments t)
                                        ; Increase default number of headings to export
    (setq org-export-headline-levels 6)

                                        ; List of projects
                                        ; norang       - http://www.norang.ca/
                                        ; doc          - http://doc.norang.ca/
                                        ; org-mode-doc - http://doc.norang.ca/org-mode.html and associated files
                                        ; org          - miscellaneous todo lists for publishing
    (setq org-publish-project-alist
                                        ;
                                        ; http://www.norang.ca/  (norang website)
                                        ; norang-org are the org-files that generate the content
                                        ; norang-extra are images and css files that need to be included
                                        ; norang is the top-level project that gets published
          (quote (("norang-org"
                   :base-directory "~/AeroFS/www.norang.ca"
                   :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
                   :recursive t
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function org-html-publish-to-html
                   :style-include-default nil
                   :section-numbers nil
                   :table-of-contents nil
                   :html-head "<link rel=\"stylesheet\" href=\"norang.css\" type=\"text/css\" />"
                   :author-info nil
                   :creator-info nil)
                  ("norang-extra"
                   :base-directory "~/AeroFS/www.norang.ca/"
                   :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs"
                   :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
                   :publishing-function org-publish-attachment
                   :recursive t
                   :author nil)
                  ("norang"
                   :components ("norang-org" "norang-extra"))
                                        ;
                                        ; http://doc.norang.ca/  (norang website)
                                        ; doc-org are the org-files that generate the content
                                        ; doc-extra are images and css files that need to be included
                                        ; doc is the top-level project that gets published
                  ("doc-org"
                   :base-directory "~/AeroFS/doc.norang.ca/"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
                   :recursive nil
                   :section-numbers nil
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function (org-html-publish-to-html org-org-publish-to-org)
                   :style-include-default nil
                   :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
                   :author-info nil
                   :creator-info nil)
                  ("doc-extra"
                   :base-directory "~/AeroFS/doc.norang.ca/"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
                   :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
                   :publishing-function org-publish-attachment
                   :recursive nil
                   :author nil)
                  ("doc"
                   :components ("doc-org" "doc-extra"))
                  ("doc-private-org"
                   :base-directory "~/AeroFS/doc.norang.ca/private"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
                   :recursive nil
                   :section-numbers nil
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function (org-html-publish-to-html org-org-publish-to-org)
                   :style-include-default nil
                   :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
                   :auto-sitemap t
                   :sitemap-filename "index.html"
                   :sitemap-title "Norang Private Documents"
                   :sitemap-style "tree"
                   :author-info nil
                   :creator-info nil)
                  ("doc-private-extra"
                   :base-directory "~/AeroFS/doc.norang.ca/private"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs/private"
                   :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
                   :publishing-function org-publish-attachment
                   :recursive nil
                   :author nil)
                  ("doc-private"
                   :components ("doc-private-org" "doc-private-extra"))
                                        ;
                                        ; Miscellaneous pages for other websites
                                        ; org are the org-files that generate the content
                  ("org-org"
                   :base-directory "~/AeroFS/org/"
                   :publishing-directory "/ssh:www-data@www:~/org"
                   :recursive t
                   :section-numbers nil
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function org-html-publish-to-html
                   :style-include-default nil
                   :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
                   :author-info nil
                   :creator-info nil)
                                        ;
                                        ; http://doc.norang.ca/  (norang website)
                                        ; org-mode-doc-org this document
                                        ; org-mode-doc-extra are images and css files that need to be included
                                        ; org-mode-doc is the top-level project that gets published
                                        ; This uses the same target directory as the 'doc' project
                  ("org-mode-doc-org"
                   :base-directory "~/AeroFS/org-mode-doc/"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
                   :recursive t
                   :section-numbers nil
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function (org-html-publish-to-html)
                   :plain-source t
                   :htmlized-source t
                   :style-include-default nil
                   :html-head "<link rel=\"stylesheet\" href=\"/org.css\" type=\"text/css\" />"
                   :author-info nil
                   :creator-info nil)
                  ("org-mode-doc-extra"
                   :base-directory "~/AeroFS/org-mode-doc/"
                   :publishing-directory "/ssh:www-data@www:~/doc.norang.ca/htdocs"
                   :base-extension "css\\|pdf\\|png\\|jpg\\|gif\\|org"
                   :publishing-function org-publish-attachment
                   :recursive t
                   :author nil)
                  ("org-mode-doc"
                   :components ("org-mode-doc-org" "org-mode-doc-extra"))
                                        ;
                                        ; http://doc.norang.ca/  (norang website)
                                        ; org-mode-doc-org this document
                                        ; org-mode-doc-extra are images and css files that need to be included
                                        ; org-mode-doc is the top-level project that gets published
                                        ; This uses the same target directory as the 'doc' project
                  ("tmp-org"
                   :base-directory "/tmp/publish/"
                   :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
                   :recursive t
                   :section-numbers nil
                   :table-of-contents nil
                   :base-extension "org"
                   :publishing-function (org-html-publish-to-html org-org-publish-to-org)
                   :html-head "<link rel=\"stylesheet\" href=\"http://doc.norang.ca/org.css\" type=\"text/css\" />"
                   :plain-source t
                   :htmlized-source t
                   :style-include-default nil
                   :auto-sitemap t
                   :sitemap-filename "index.html"
                   :sitemap-title "Test Publishing Area"
                   :sitemap-style "tree"
                   :author-info t
                   :creator-info t)
                  ("tmp-extra"
                   :base-directory "/tmp/publish/"
                   :publishing-directory "/ssh:www-data@www:~/www.norang.ca/htdocs/tmp"
                   :base-extension "css\\|pdf\\|png\\|jpg\\|gif"
                   :publishing-function org-publish-attachment
                   :recursive t
                   :author nil)
                  ("tmp"
                   :components ("tmp-org" "tmp-extra")))))

    ;; Enable abbrev-mode
    (add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))

    ;; Skeletons
    ;;
    ;; sblk - Generic block #+begin_FOO .. #+end_FOO
    (define-skeleton skel-org-block
      "Insert an org block, querying for type."
      "Type: "
      "#+begin_" str "\n"
      _ - \n
      "#+end_" str "\n")

    (define-abbrev org-mode-abbrev-table "sblk" "" 'skel-org-block)

    ;; splantuml - PlantUML Source block
    (define-skeleton skel-org-block-plantuml
      "Insert a org plantuml block, querying for filename."
      "File (no extension): "
      "#+begin_src plantuml :file " str ".png :cache yes\n"
      _ - \n
      "#+end_src\n")

    (define-abbrev org-mode-abbrev-table "splantuml" "" 'skel-org-block-plantuml)

    (define-skeleton skel-org-block-plantuml-activity
      "Insert a org plantuml block, querying for filename."
      "File (no extension): "
      "#+begin_src plantuml :file " str "-act.png :cache yes :tangle " str "-act.txt\n"
      (bh/plantuml-reset-counters)
      "@startuml\n"
      "skinparam activity {\n"
      "BackgroundColor<<New>> Cyan\n"
      "}\n\n"
      "title " str " - \n"
      "note left: " str "\n"
      "(*) --> \"" str "\"\n"
      "--> (*)\n"
      _ - \n
      "@enduml\n"
      "#+end_src\n")

    (defvar bh/plantuml-if-count 0)

    (defun bh/plantuml-if ()
      (incf bh/plantuml-if-count)
      (number-to-string bh/plantuml-if-count))

    (defvar bh/plantuml-loop-count 0)

    (defun bh/plantuml-loop ()
      (incf bh/plantuml-loop-count)
      (number-to-string bh/plantuml-loop-count))

    (defun bh/plantuml-reset-counters ()
      (setq bh/plantuml-if-count 0
            bh/plantuml-loop-count 0)
      "")

    (define-abbrev org-mode-abbrev-table "sact" "" 'skel-org-block-plantuml-activity)

    (define-skeleton skel-org-block-plantuml-activity-if
      "Insert a org plantuml block activity if statement"
      ""
      "if \"\" then\n"
      "  -> [condition] ==IF" (setq ifn (bh/plantuml-if)) "==\n"
      "  --> ==IF" ifn "M1==\n"
      "  -left-> ==IF" ifn "M2==\n"
      "else\n"
      "end if\n"
      "--> ==IF" ifn "M2==")

    (define-abbrev org-mode-abbrev-table "sif" "" 'skel-org-block-plantuml-activity-if)

    (define-skeleton skel-org-block-plantuml-activity-for
      "Insert a org plantuml block activity for statement"
      "Loop for each: "
      "--> ==LOOP" (setq loopn (bh/plantuml-loop)) "==\n"
      "note left: Loop" loopn ": For each " str "\n"
      "--> ==ENDLOOP" loopn "==\n"
      "note left: Loop" loopn ": End for each " str "\n" )

    (define-abbrev org-mode-abbrev-table "sfor" "" 'skel-org-block-plantuml-activity-for)

    (define-skeleton skel-org-block-plantuml-sequence
      "Insert a org plantuml activity diagram block, querying for filename."
      "File appends (no extension): "
      "#+begin_src plantuml :file " str "-seq.png :cache yes :tangle " str "-seq.txt\n"
      "@startuml\n"
      "title " str " - \n"
      "actor CSR as \"Customer Service Representative\"\n"
      "participant CSMO as \"CSM Online\"\n"
      "participant CSMU as \"CSM Unix\"\n"
      "participant NRIS\n"
      "actor Customer"
      _ - \n
      "@enduml\n"
      "#+end_src\n")

    (define-abbrev org-mode-abbrev-table "sseq" "" 'skel-org-block-plantuml-sequence)

    ;; sdot - Graphviz DOT block
    (define-skeleton skel-org-block-dot
      "Insert a org graphviz dot block, querying for filename."
      "File (no extension): "
      "#+begin_src dot :file " str ".png :cache yes :cmdline -Kdot -Tpng\n"
      "graph G {\n"
      _ - \n
      "}\n"
      "#+end_src\n")

    (define-abbrev org-mode-abbrev-table "sdot" "" 'skel-org-block-dot)

    ;; sditaa - Ditaa source block
    (define-skeleton skel-org-block-ditaa
      "Insert a org ditaa block, querying for filename."
      "File (no extension): "
      "#+begin_src ditaa :file " str ".png :cache yes\n"
      _ - \n
      "#+end_src\n")

    (define-abbrev org-mode-abbrev-table "sditaa" "" 'skel-org-block-ditaa)

    ;; selisp - Emacs Lisp source block
    (define-skeleton skel-org-block-elisp
      "Insert a org emacs-lisp block"
      ""
      "#+begin_src emacs-lisp\n"
      _ - \n
      "#+end_src\n")

    (define-abbrev org-mode-abbrev-table "selisp" "" 'skel-org-block-elisp)

    ;; Limit restriction lock highlighting to the headline only
    (setq org-agenda-restriction-lock-highlight-subtree nil)

    ;; Keep tasks with dates on the global todo lists
    (setq org-agenda-todo-ignore-with-date nil)

    ;; Keep tasks with deadlines on the global todo lists
    (setq org-agenda-todo-ignore-deadlines nil)

    ;; Keep tasks with scheduled dates on the global todo lists
    (setq org-agenda-todo-ignore-scheduled nil)

    ;; Keep tasks with timestamps on the global todo lists
    (setq org-agenda-todo-ignore-timestamp nil)

    ;; Remove completed deadline tasks from the agenda view
    (setq org-agenda-skip-deadline-if-done t)

    ;; Remove completed scheduled tasks from the agenda view
    (setq org-agenda-skip-scheduled-if-done t)

    ;; Remove completed items from search results
    (setq org-agenda-skip-timestamp-if-done t)

    (setq org-agenda-include-diary nil)
    (setq org-agenda-diary-file "~/Orgnote/diary.org")

    (setq org-agenda-insert-diary-extract-time t)

    ;; Include agenda archive files when searching for things
    (setq org-agenda-text-search-extra-files (quote (agenda-archives)))

    ;; Show all future entries for repeating tasks
    (setq org-agenda-repeating-timestamp-show-all t)

    ;; Show all agenda dates - even if they are empty
    (setq org-agenda-show-all-dates t)

    ;; Sorting order for tasks on the agenda
    (setq org-agenda-sorting-strategy
          (quote ((agenda habit-down time-up user-defined-up effort-up category-keep)
                  (todo category-up effort-up)
                  (tags category-up effort-up)
                  (search category-up))))

    ;; Start the weekly agenda on Monday
    (setq org-agenda-start-on-weekday 1)

    ;; Enable display of the time grid so we can see the marker for the current time
    (setq org-agenda-time-grid (quote ((daily today remove-match)
                                       #("----------------" 0 16 (org-heading t))
                                       (0900 1100 1300 1500 1700))))

    ;; Display tags farther right
    (setq org-agenda-tags-column -102)

    ;;
    ;; Agenda sorting functions
    ;;
    (setq org-enforce-todo-dependencies t)

    (setq org-hide-leading-stars nil)

    (setq org-startup-indented t)

    (setq org-cycle-separator-lines 0)

    (setq org-blank-before-new-entry (quote ((heading)
                                             (plain-list-item . auto))))

    (setq org-insert-heading-respect-content nil)

    (setq org-reverse-note-order nil)

    (setq org-show-following-heading t)
    (setq org-show-hierarchy-above t)
    (setq org-show-siblings (quote ((default))))

    (setq org-special-ctrl-a/e t)
    (setq org-special-ctrl-k t)
    (setq org-yank-adjusted-subtrees t)

    (setq org-id-method (quote uuidgen))

    (setq org-deadline-warning-days 30)

    (setq org-table-export-default-format "orgtbl-to-csv")

                                        ; Use the current window for C-c ' source editing
    (setq org-src-window-setup 'current-window)

    (setq org-log-done (quote time))
    (setq org-log-into-drawer t)
    (setq org-log-state-notes-insert-after-drawers nil)

                                        ; Enable habit tracking (and a bunch of other modules)
    (setq org-modules (quote (org-bibtex
                              org-crypt
                              org-id
                              org-info
                              org-jsinfo
                              org-habit
                              org-inlinetask
                              org-irc
                              org-mew
                              org-mhe
                              org-protocol
                              org-rmail
                              org-vm
                              org-wl
                              org-w3m)))

                                        ; position the habit graph on the agenda to the right of the default
    (setq org-habit-graph-column 50)

    (run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

    (global-auto-revert-mode t)

    (require 'org-crypt)
                                        ; Encrypt all entries before saving
    (org-crypt-use-before-save-magic)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))
                                        ; GPG key to use for encryption
    (setq org-crypt-key "F0B66B40")

    (setq org-crypt-disable-auto-save nil)

    (setq org-use-speed-commands t)
    (setq org-speed-commands-user (quote (("0" . ignore)
                                          ("1" . ignore)
                                          ("2" . ignore)
                                          ("3" . ignore)
                                          ("4" . ignore)
                                          ("5" . ignore)
                                          ("6" . ignore)
                                          ("7" . ignore)
                                          ("8" . ignore)
                                          ("9" . ignore)

                                          ("a" . ignore)
                                          ("d" . ignore)
                                          ("h" . bh/hide-other)
                                          ("i" progn
                                           (forward-char 1)
                                           (call-interactively 'org-insert-heading-respect-content))
                                          ("k" . org-kill-note-or-show-branches)
                                          ("l" . ignore)
                                          ("m" . ignore)
                                          ("q" . bh/show-org-agenda)
                                          ("r" . ignore)
                                          ("s" . org-save-all-org-buffers)
                                          ("w" . org-refile)
                                          ("x" . ignore)
                                          ("y" . ignore)
                                          ("z" . org-add-note)

                                          ("A" . ignore)
                                          ("B" . ignore)
                                          ("E" . ignore)
                                          ("F" . bh/restrict-to-file-or-follow)
                                          ("G" . ignore)
                                          ("H" . ignore)
                                          ("J" . org-clock-goto)
                                          ("K" . ignore)
                                          ("L" . ignore)
                                          ("M" . ignore)
                                          ("N" . bh/narrow-to-org-subtree)
                                          ("P" . bh/narrow-to-org-project)
                                          ("Q" . ignore)
                                          ("R" . ignore)
                                          ("S" . ignore)
                                          ("T" . bh/org-todo)
                                          ("U" . bh/narrow-up-one-org-level)
                                          ("V" . ignore)
                                          ("W" . bh/widen)
                                          ("X" . ignore)
                                          ("Y" . ignore)
                                          ("Z" . ignore))))

    (defun bh/show-org-agenda ()
      (interactive)
      (if org-agenda-sticky
          (switch-to-buffer "*Org Agenda( )*")
        (switch-to-buffer "*Org Agenda*"))
      (delete-other-windows))

    (require 'org-protocol)

    (setq require-final-newline t)

    (setq org-remove-highlights-with-change t)

    (setq org-read-date-prefer-future 'time)

    (setq org-list-demote-modify-bullet (quote (("+" . "-")
                                                ("*" . "-")
                                                ("1." . "-")
                                                ("1)" . "-")
                                                ("A)" . "-")
                                                ("B)" . "-")
                                                ("a)" . "-")
                                                ("b)" . "-")
                                                ("A." . "-")
                                                ("B." . "-")
                                                ("a." . "-")
                                                ("b." . "-"))))

    (setq org-tags-match-list-sublevels t)

    (setq org-agenda-persistent-filter t)

    (setq org-link-mailto-program (quote (compose-mail "%a" "%s")))

    ;; Bookmark handling
    ;;
    (global-set-key (kbd "<C-f6>") '(lambda () (interactive) (bookmark-set "SAVED")))
    (global-set-key (kbd "<f6>") '(lambda () (interactive) (bookmark-jump "SAVED")))

                                        ;(require 'org-mime)

    (setq org-agenda-skip-additional-timestamps-same-entry t)

    (setq org-table-use-standard-references (quote from))

    (setq org-file-apps (quote ((auto-mode . emacs)
                                ("\\.mm\\'" . system)
                                ("\\.x?html?\\'" . system)
                                ("\\.pdf\\'" . system))))

                                        ; Overwrite the current window with the agenda
    (setq org-agenda-window-setup 'current-window)

    (setq org-clone-delete-id t)

    (setq org-cycle-include-plain-lists t)

    (setq org-src-fontify-natively t)

    (setq org-structure-template-alist
          (quote (("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>")
                  ("e" "#+begin_example\n?\n#+end_example" "<example>\n?\n</example>")
                  ("q" "#+begin_quote\n?\n#+end_quote" "<quote>\n?\n</quote>")
                  ("v" "#+begin_verse\n?\n#+end_verse" "<verse>\n?\n</verse>")
                  ("c" "#+begin_center\n?\n#+end_center" "<center>\n?\n</center>")
                  ("l" "#+begin_latex\n?\n#+end_latex" "<literal style=\"latex\">\n?\n</literal>")
                  ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
                  ("h" "#+begin_html\n?\n#+end_html" "<literal style=\"html\">\n?\n</literal>")
                  ("H" "#+html: " "<literal style=\"html\">?</literal>")
                  ("a" "#+begin_ascii\n?\n#+end_ascii")
                  ("A" "#+ascii: ")
                  ("i" "#+index: ?" "#+index: ?")
                  ("I" "#+include %file ?" "<include file=%file markup=\"?\">"))))
    ;; add <el for emacs-lisp expansion
    (add-to-list 'org-structure-template-alist
	         '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"
	           "<src lang=\"emacs-lisp\">\n?\n</src>"))

    ;; add <sh for shell
    (add-to-list 'org-structure-template-alist
	         '("sh" "#+BEGIN_SRC sh\n?\n#+END_SRC"
	           "<src lang=\"shell\">\n?\n</src>"))

    (add-to-list 'org-structure-template-alist
	         '("lh" "#+latex_header: " ""))

    (add-to-list 'org-structure-template-alist
	         '("lc" "#+latex_class: " ""))

    (add-to-list 'org-structure-template-alist
	         '("lco" "#+latex_class_options: " ""))

    (add-to-list 'org-structure-template-alist
	         '("ao" "#+attr_org: " ""))

    (add-to-list 'org-structure-template-alist
	         '("al" "#+attr_latex: " ""))

    (add-to-list 'org-structure-template-alist
	         '("ca" "#+caption: " ""))

    (add-to-list 'org-structure-template-alist
	         '("tn" "#+tblname: " ""))

    (add-to-list 'org-structure-template-alist
	         '("n" "#+name: " ""))

    (add-to-list 'org-structure-template-alist
	         '("r" "#+BEGIN_SRC R :results output \n?\n#+END_SRC"))

    (add-to-list 'org-structure-template-alist
	         '("R" "#+BEGIN_SRC R :results output graphics :file ./test.png :exports results \n?\n#+END_SRC"))

    (setq org-startup-folded t)

    ;; flyspell mode for spell checking everywhere
    (add-hook 'org-mode-hook 'turn-on-flyspell 'append)

    ;; Disable keys in org-mode
    ;;    C-c [
    ;;    C-c ]
    ;;    C-c ;
    ;;    C-c C-x C-q  cancelling the clock (we never want this)
    (add-hook 'org-mode-hook
              '(lambda ()
                 ;; Undefine C-c [ and C-c ] since this breaks my
                 ;; org-agenda files when directories are include It
                 ;; expands the files in the directories individually
                 (org-defkey org-mode-map "\C-c[" 'undefined)
                 (org-defkey org-mode-map "\C-c]" 'undefined)
                 (org-defkey org-mode-map "\C-c;" 'undefined)
                 (org-defkey org-mode-map "\C-c\C-x\C-q" 'undefined))
              'append)

    (setq org-src-preserve-indentation nil)
    (setq org-edit-src-content-indentation 0)

    (setq org-catch-invisible-edits 'error)

    (setq org-export-coding-system 'utf-8)
    (prefer-coding-system 'utf-8)
    (set-charset-priority 'unicode)
    (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;https://www.cnblogs.com/apirobot/p/15366984.html
    (setq org-emphasis-regexp-components
          '("-[:multibyte:][:space:]('\"{"
            "-[:multibyte:][:space:].,:!?;'\")}\\["
            "[:space:]"
            "."
            1))
    (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
    (org-element-update-syntax)

    (setq org-time-clocksum-format
          '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

    (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

    (setq org-emphasis-alist (quote (("*" bold "<b>" "</b>")
                                     ("/" italic "<i>" "</i>")
                                     ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                                     ("=" org-code "<code>" "</code>" verbatim)
                                     ("~" org-verbatim "<code>" "</code>" verbatim))))

    (setq org-use-sub-superscripts nil)

    (setq org-odd-levels-only nil)

    (run-at-time "00:59" 3600 'org-save-all-org-buffers)

    ;; Org Mode LaTeX Export
  (require 'ox-latex)
  (require 'ox-beamer)

  (setq org-latex-compiler "xelatex") ; introduced in org 9.0
;    (setq org-latex-toc-command  "\\newpage\n\n\\tableofcontents\n\n\\newpage\n\n")
    ;; Previewing latex fragments in Org mode
    ;; https://orgmode.org/worg/org-tutorials/org-latex-preview.html
    (setq org-latex-create-formula-image-program 'imagemagick) ;Recommended

    ;; Controlling the order of loading certain packages w.r.t. `hyperref'
    ;; http://tex.stackexchange.com/a/1868/52678
    ;; ftp://ftp.ctan.org/tex-archive/macros/latex/contrib/hyperref/README.pdf
    ;; Remove the list element in `org-latex-default-packages-alist'.
    ;; that has '("hyperref" nil) as its cdr.
    ;; http://stackoverflow.com/a/9813211/1219634
    (setq org-latex-default-packages-alist
          (delq (rassoc '("hyperref" nil) org-latex-default-packages-alist)
                org-latex-default-packages-alist))
    ;; `hyperref' will be added again later in `org-latex-packages-alist'
    ;; in the correct order.

    ;; The `org-latex-packages-alist' will output tex files with
    ;;   \usepackage[FIRST STRING IF NON-EMPTY]{SECOND STRING}
    ;; It is a list of cells of the format:
    ;;   ("options" "package" SNIPPET-FLAG COMPILERS)
    ;; If SNIPPET-FLAG is non-nil, the package also needs to be included
    ;; when compiling LaTeX snippets into images for inclusion into
    ;; non-LaTeX output (like when previewing latex fragments using the
    ;; "C-c C-x C-l" binding.
    ;; COMPILERS is a list of compilers that should include the package,
    ;; see `org-latex-compiler'.  If the document compiler is not in the
    ;; list, and the list is non-nil, the package will not be inserted
    ;; in the final document.

    (defconst modi/org-latex-packages-alist-pre-hyperref
      '(;; Prevent an image from floating to a different location.
        ;; http://tex.stackexchange.com/a/8633/52678
        ("" "float")
        ;; % 0 paragraph indent, adds vertical space between paragraphs
        ;; http://en.wikibooks.org/wiki/LaTeX/Paragraph_Formatting
        ("" "parskip"))
      "Alist of packages that have to be loaded before `hyperref'
package is loaded.
ftp://ftp.ctan.org/tex-archive/macros/latex/contrib/hyperref/README.pdf ")

    (defconst modi/org-latex-packages-alist-post-hyperref
      '(;; Prevent tables/figures from one section to float into another section
        ;; http://tex.stackexchange.com/a/282/52678
        ("section" "placeins")
        ;; Graphics package for more complicated figures
        ("" "tikz")
        ("" "caption")
        ("" "tcolorbox")
        ;;
        ;; Packages suggested to be added for previewing latex fragments
        ;; https://orgmode.org/worg/org-tutorials/org-latex-preview.html
        ("mathscr" "eucal")
        ;;("" "titlesec")
        ("" "latexsym"))
      "Alist of packages that have to (or can be) loaded after `hyperref'
package is loaded.")

    (defconst modi/org-latex-packages-alist-zhfont
      '("
%%% 设置中文字体 %%%
% https://www.zhihu.com/question/20563044
% 衬线字体
\\setCJKmainfont[BoldFont = Source Han Sans CN,ItalicFont = FandolKai]{Source Han Serif CN}
% 无衬线字体同上
\\setCJKsansfont[BoldFont = Source Han Sans CN,ItalicFont = FandolKai]{Source Han Sans CN}
% 等宽字体/打印机字体
\\setCJKmonofont[BoldFont = Source Han Sans CN,ItalicFont = FandolKai]{Source Han Sans CN}

\\setCJKfamilyfont{zhsong}{Source Han Serif CN}
\\setCJKfamilyfont{zhhei}{Source Han Sans CN}
\\setCJKfamilyfont{zhkai}{FandolKai}

%%% Prefer the free fonts %%%
\\setmainfont{Roboto Slab Light}
\\setsansfont{Roboto Light}
\\setmonofont{Roboto Mono Light}

"))


   ;; The "H" option (`float' package) prevents images from floating around.
    (setq org-latex-default-figure-position "H") ;figures are NOT floating
    ;; (setq org-latex-default-figure-position "htb") ;default - figures are floating

    ;; `hyperref' package setup
    (setq org-latex-hyperref-template
          (concat "\\hypersetup{\n"
                  "pdfauthor={%a},\n"
                  "pdftitle={%t},\n"
                  "pdfkeywords={%k},\n"
                  "pdfsubject={%d},\n"
                  "pdfcreator={%c},\n"
                  "pdflang={%L},\n"
                  ;; Get rid of the red boxes drawn around the links
                  "colorlinks,\n"
                  "citecolor=black,\n"
                  "filecolor=black,\n"
                  "linkcolor=blue,\n"
                  "urlcolor=blue\n"
                  "}\n"))

    (defvar modi/temporary-file-directory (let ((dir (file-name-as-directory (expand-file-name user-login-name temporary-file-directory))))))
    (defvar modi/ox-latex-use-minted nil 
      "Use `minted' package for listings.")

    (if modi/ox-latex-use-minted
        ;; using minted
        ;; https://github.com/gpoore/minted
        (progn
          (setq org-latex-listings 'minted) ;default nil
          ;; The default value of the `minted' package option `cachedir'
          ;; is "_minted-\jobname". That clutters the working dirs with
          ;; _minted* dirs. So instead create them in temp folders.
          (defvar latex-minted-cachedir
            (file-name-as-directory
             (expand-file-name ".minted/\\jobname" modi/temporary-file-directory)))
          ;; `minted' package needed to be loaded AFTER `hyperref'.
          ;; http://tex.stackexchange.com/a/19586/52678
          (add-to-list 'modi/org-latex-packages-alist-post-hyperref
                       `(,(concat "cachedir=" ;options
                                  latex-minted-cachedir)
                         "minted" ;package
                         ;; If `org-latex-create-formula-image-program'
                         ;; is set to `dvipng', minted package cannot be
                         ;; used to show latex previews.
                         ,(not (eq org-latex-create-formula-image-program 'dvipng)))) ;snippet-flag

          ;; minted package options (applied to embedded source codes)
          (setq org-latex-minted-options
                '(("linenos")
                  ("numbersep" "5pt")
                  ("frame"     "none") ;box frame is created by `mdframed' package
                  ("framesep"  "2mm")
                  ;; minted 2.0+ required for `breaklines'
                  ("breaklines"))) ;line wrapping within code blocks
          (when (equal org-latex-compiler "pdflatex")
            (add-to-list 'org-latex-minted-options '(("fontfamily"  "zi4")))))
      ;; not using minted
      (progn
        ;; Commented out below because it clashes with `placeins' package
        ;; (add-to-list 'modi/org-latex-packages-alist-post-hyperref '("" "color"))
        (add-to-list 'modi/org-latex-packages-alist-post-hyperref '("" "listings"))))

    (setq org-latex-packages-alist
          (append modi/org-latex-packages-alist-pre-hyperref
                  '(("" "hyperref" nil))
                  modi/org-latex-packages-alist-post-hyperref
                  modi/org-latex-packages-alist-zhfont))

    ;; `-shell-escape' is required when using the `minted' package
                                        ;http://emacs-china.org/blog/2015/04/20/%E4%BD%BF%E7%94%A8-ctex-%E5%B0%86-org-%E6%96%87%E4%BB%B6%E8%BD%AC%E5%8C%96%E4%B8%BA-pdf/
    (setq org-latex-default-class "ctexart")
    (add-to-list 'org-latex-classes
                 '("ctexart"
                   "\\documentclass[UTF8,a4paper]{ctexart}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{titlesec}
[EXTRA]
\\titleformat{\\section}{\\normalfont\\Large\\bfseries}{\\makebox[30pt][l]{\\thesection}}{0pt}{}
\\titleformat{\\subsection}{\\normalfont\\large\\bfseries}{\\makebox[30pt][l]{\\thesubsection}}{0pt}{}
"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    (add-to-list 'org-latex-classes
                 '("ctexrep"
                   "\\documentclass[fancyhdr,fntef,nofonts,UTF8,a4paper,cs4size]{ctexrep}"
                   ("\\part{%s}" . "\\part*{%s}")
                   ("\\chapter{%s}" . "\\chapter*{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

    (add-to-list 'org-latex-classes
                 '("ctexbook"
                   "\\documentclass[fancyhdr,fntef,nofonts,UTF8,a4paper,cs4size]{ctexbook}"
                   ("\\part{%s}" . "\\part*{%s}")
                   ("\\chapter{%s}" . "\\chapter*{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

    (add-to-list 'org-latex-classes
                 '("beamer"
                   "\\documentclass\[presentation\]\{ctexbeamer\}"
                   ("\\section\{%s\}" . "\\section*\{%s\}")
                   ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                   ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

    ;; latex公式预览, 调整latex预览时使用的header,默认使用ctexart类
    (setq org-format-latex-header
          (replace-regexp-in-string
           "\\\\documentclass{.*}"
           "\\\\documentclass[nofonts,UTF8]{ctexart}"
           org-format-latex-header))

    (setq org-beamer-theme nil)
    (setq org-latex-commands
          '(("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
             "bibtex %b"
             "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
             "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")
            ("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

    (defun my-org-latex-compile (orig-fun texfile &optional snippet)
      (let ((org-latex-pdf-process
             (if snippet (car (cdr org-latex-commands))
               (car org-latex-commands))))
        (funcall orig-fun texfile snippet)))

    (advice-add 'org-latex-compile :around #'my-org-latex-compile)

    ;; 指定你要用什麼外部 app 來開 pdf 之類的檔案。我是偷懶所以直接用 evince，你也可以指定其他的。
    (setq org-file-apps '((auto-mode . emacs)
                          ("\\.mm\\'" . default)
                          ("\\.x?html?\\'" . "xdg-open %s")
                          ("\\.pdf\\'" . "evince %s")
                          ("\\.jpg\\'" . "geeqie %s")))

    )


;; ccls
(after! ccls
(setq ccls-initialization-options
      (if (boundp 'ccls-initialization-options)
          (append ccls-initialization-options `(:cache (:directory ,(expand-file-name "~/.ccls-cache"))))
        `(:cache (:directory ,(expand-file-name "~/.ccls-cache"))))))

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--enable-config"
                                "--header-insertion=iwyu"))
(after! cc-mode
  (c-add-style
   "my-cc" '("user"
             (c-basic-offset . 4)
             (c-offsets-alist
              . ((innamespace . 0)
                 (access-label . -)
                 (case-label . 0)
                 (member-init-intro . +)
                 (topmost-intro . 0)
                 (arglist-cont-nonempty . +)))))
  (setq c-default-style "my-cc"))

;; show trailing whitespace if possible
(setq-default show-trailing-whitespace t)

;; rust
(after! rustic
  (setq lsp-rust-server 'rust-analyzer
        rustic-lsp-server 'rust-analyzer
        lsp-rust-analyzer-server-command '("~/.cargo/bin/ra_lsp_server")))

(load! "+tex")
(global-set-key (kbd "C-.") 'isearch-forward-symbol-at-point)

;; Will only work on macos/linux
(after! counsel
  (setq counsel-rg-base-command "rg -M 240 --with-filename --no-heading --line-number --color never %s || true"))

(add-load-path! "$HOME/.emacs.d/.local/straight/repos/gendoxy")
(load "gendoxy.el")

(put 'projectile-project-compilation-cmd 'safe-local-variable #'stringp)

(use-package! protobuf-mode
  :mode
  (("\\.proto\\'" . protobuf-mode)))

;https://github.com.cnpmjs.org/andrewpeck/doom.d
;;; Line wrapping
;;------------------------------------------------------------------------------

(defun ap/no-wrap ()
  (interactive)
  (visual-line-mode 0)
  (toggle-truncate-lines 1)
  (visual-fill-column-mode 0))

(after! text-mode
  (setq fill-column 120)
  ;; Disable auto fill mode in text modes
  (remove-hook 'text-mode-hook #'auto-fill-mode)

  ;; Don't wrap text modes unless we really want it
  (remove-hook 'text-mode-hook #'+word-wrap-mode)

  (defun fix-visual-fill-column-mode (&optional ARG)
    (setq visual-fill-column-mode visual-line-mode))

  ;; toggle visual-fill column mode when chaing word wrap settings
  (advice-add '+word-wrap-mode
              :after 'fix-visual-fill-column-mode)
  ;;
  ;(add-hook 'text-mode #'visual-line-mode)
  (add-hook 'visual-line-mode-hook #'visual-fill-column-mode)

)
