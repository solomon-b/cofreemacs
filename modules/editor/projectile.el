;;; editor/projectile ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)

(require 'use-package)

(use-package projectile
  :straight t
  :custom (projectile-completion-system 'default)
  :functions projectile-add-known-project
  :config
  (projectile-mode 1)
  :general
  (global-definer
    "p" '(:keymap projectile-command-map :package projectile :wk "project"))
  )

;; Instead of `projectile-ripgrep', I like to use `rg' as it lets
;; us narrow down our searches a lot better, and perform bulk edits.
(use-package rg
  :straight t
  :config
  (rg-menu-transient-insert "Manage" "e" "Edit" 'wgrep-change-to-wgrep-mode)
  :general
  (global-definer
    "r" '(rg-menu :wk "rg")))

(setq ripgrep-arguments '("-."))

(provide 'editor/projectile)
;;; projectile.el ends here
