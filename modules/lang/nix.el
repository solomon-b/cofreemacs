;;; lang/nix ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(use-package nix-mode
  :straight t
  :init (add-hook 'nix-mode 'direnv-mode))

(provide 'lang/nix)
;;; nix.el ends here
