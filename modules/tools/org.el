;;; tools/org ---  -*- lexical-binding: t; -*-

;;; Commentary:
;; This module is a bit of a beast, as I use `org'
;; pretty heavily.

;;; Code:
(require 'core/keys)

;; We set up a definer for all things that are
;; related to `org', so we can easily extend
;; the global bindings when we add other packages.
(general-create-definer notes-menu-definer
  :states '(normal motion)
  :wrapping global-definer
  :prefix "SPC n"
  "" '(:ignore t :wk "notes"))

(use-package org
  :straight t
  :mode ("\\.org\\'" . org-mode)
  :init
  (add-hook 'org-mode-hook 'auto-fill-mode)

  (setq org-todo-keywords '((sequence
     		             "TODO(t)"
     		             "PROJ(p)"
     		             "STRT(s)"
     		             "WAIT(w)"
     		             "REVW(r)"
     		             "QUAL(q)"
     		             "BLCK(b)"
     		             "|"
     		             "DONE(d)"
     		             "KILL(k)")))

  ;; Use custom faces for our org keywords.
  ;;(custom-declare-face 'org-todo-active '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
  ;;(custom-declare-face 'org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
  ;;(custom-declare-face 'org-todo-onhold '((t (:inherit (bold warning org-todo)))) "")
  ;;(custom-declare-face 'org-todo-blocked '((t (:inherit (bold error org-todo)))) "")
  :config
  (defun find-task-file ()
    "Open an org task file."
    (interactive)
    (let ((default-directory "~/Org/"))
      (call-interactively 'find-file)))

  (evil-collection-define-key 'normal 'org-mode-map
    [tab] 'org-cycle
    [S-tab] 'org-shifttab)

  :general
  (mode-leader-definer
    :keymaps 'org-mode-map
    "l" '(org-insert-link :wk "insert link")
    "o" '(org-open-at-point :wk "open at point")
    "t" '(org-todo :wk "change todo state")
    "w" '(org-refile :wk "refile")
    "'" '(org-edit-special :wk "edit block"))

  (general-create-definer org-set-definer
    :wrapping mode-leader-definer
    :keymaps 'org-mode-map
    :prefix "SPC m x"
    "" '(:ignore t :which-key "set")
    "p" '(org-set-property :wk "set property"))

  (notes-menu-definer
    "t" '(find-task-file :wk "open org file")
    "l" '(org-store-link :wk "store link")
    "c" '(org-capture :wk "capture")
    "o" '(org-clock-goto :wk "open current task")))

(use-package org-pomodoro
  :straight t
  :after org
  :general
  (notes-menu-definer
    "s" '(org-pomodoro :wk "start pomodoro")))


(load "~/.emacs.d/straight/repos/org/lisp/org-compat")

(require 'org-element)
(require 'org-persist)
(require 'org-tempo)

(setq org-startup-folded t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Roam

(use-package emacsql
  :straight t)

(use-package emacsql-sqlite3
  :straight t)

(use-package org-roam
  :straight t
  :commands org-roam-node-find
  :after org
  :init
  (setq org-roam-directory "~/Org/org-roam")
  :config
  (org-roam-db-autosync-mode)
  :general
  (mode-leader-definer
    :keymaps 'org-mode-map
    "i" '(org-roam-node-insert :wk "roam insert"))
  (notes-menu-definer
    "d" '(org-roam-dailies-goto-today :wk "today's daily note")
    "n" '(org-roam-node-find :wk "open note")))

(setq org-roam-database-connector 'sqlite3)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((restclient . t)))

(setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:10}" 'face 'org-tag)))

(provide 'tools/org)
;;; org.el ends here
