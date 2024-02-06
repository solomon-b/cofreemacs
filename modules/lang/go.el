;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(require 'core/keys)
(require 'core/utils)

(use-package go-mode
  :straight t
  :init
  (add-hook 'go-mode-hook 'direnv-mode)
  (add-hook 'go-mode-hook 'lsp-deferred))

  :general
  (mode-leader-definer
    :keymaps 'go-mode-map
    "d" '(godef-describe :wk "Describe at point"))

  (global-motion-definer
    :keymaps 'go-mode-map
    "k" '(beginning-of-defun :wk "top of definition")
    "j" '(end-of-defun :wk "bottom of definition")
    "d" '(lsp-find-definition :wk "goto definition")
    "r" '(xref-find-references :wk "find references"))


(provide 'lang/go)
;;; go.el ends here
