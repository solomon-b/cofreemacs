;;; lang/latex ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)
(require 'core/utils)


(use-package auctex
  :straight t
  :init
  ;; Make sure to add the TeX binaries to the path.
  (when (eq system-type 'darwin)
    (add-to-path "/Library/TeX/texbin/"))
  
  :config
  ;; This is a buffer-local variable, so we have to set it via hook...
  (add-hook 'LaTeX-mode-hook
	    (lambda ()
	      (setq TeX-command-extra-options "-shell-escape")
	      (setq TeX-engine 'luatex)))

  :general
  (mode-leader-definer
    :keymaps 'TeX-mode-map
    "c" '(TeX-command-master :wk "compile")
    "e" '(LaTeX-environment :wk "environment")
    "i" '(LaTeX-insert-item :wk "item")))

(use-package evil-tex
  :straight t
  :after auctex)

(provide 'lang/latex)
;;; latex.el ends here
