;;; init --- The main init file  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Make sure that everything inside of our modules folder can actually
;; be loaded by Emacs.
(add-to-list 'load-path "~/.emacs.d/modules")

;; Core:
(require 'core/bootstrap)
(require 'core/ui)
(require 'core/keys)
(require 'core/utils)

;; Default Configuration:
(require 'config/default-bindings)

;; Editor Settings:
(require 'editor/company)
(require 'editor/flycheck)
(require 'editor/imenu)
(require 'editor/lispy)
(require 'editor/lsp)
(require 'editor/projectile)
(require 'editor/snippets)
(require 'editor/selectrum)

;; Languages:
(require 'lang/agda)
(require 'lang/emacs-lisp)
(require 'lang/haskell)
(require 'lang/ocaml)

;; Tools
(require 'tools/eshell)
(require 'tools/magit)
(require 'tools/org)

;; UI:
(require 'ui/default-theme)

(provide 'init)
;;; init.el ends here
