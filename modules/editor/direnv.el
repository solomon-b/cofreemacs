;;; editor/direnv ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(use-package direnv
  :straight t
  :config (direnv-mode))

(use-package nix-sandbox
  :straight t
  :config
  (setq default-nix-wrapper
	(lambda (args)
	  (append (list "nix-shell" "--command")
		  (list (mapconcat 'identity args " ")))
	  (list (nix-current-sandbox)))))


(provide 'editor/direnv)
;;; direnv.el ends here
