;;; editor/flycheck --- Flycheck setup  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)

(require 'use-package)

(use-package flycheck
  :straight t
  :commands flycheck-mode)

(general-define-key
 :states '(normal motion)
 :keymaps 'flycheck-error-list-mode-map
 "q" 'quit-window)

(general-create-definer error-menu-definer
  :states '(normal motion)
  :wrapping global-definer
  :prefix "SPC e"
  "" '(:ignore t :wk "error"))

(error-menu-definer
  "e" '(flycheck-list-errors :wk "list errors")
  "j" '(flycheck-next-error :wk "next error")
  "k" '(flycheck-previous-error :wk "prev error"))

(provide 'editor/flycheck)
;;; flycheck.el ends here
