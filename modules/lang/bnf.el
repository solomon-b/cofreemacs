;;;  lang/bnf ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(use-package bnf-mode
  :straight t
  :init (add-hook 'nix-mode 'direnv-mode))

(provide 'lang/bnf)
;;; bnf.el ends here
