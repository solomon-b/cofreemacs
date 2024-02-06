;;; init --- The main init file  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Make sure that everything inside of our modules folder can actually
;; be loaded by Emacs.
(add-to-list 'load-path "~/.emacs.d/cofreemacs/modules")

;; Core:
(require 'core/bootstrap)
(require 'core/ui)
(require 'core/keys)
(require 'core/utils)

;; Default Configuration:
(require 'config/default-bindings)
;; 
;; ;; Tools
(require 'tools/curl)
(require 'tools/eshell)
(require 'tools/magit)
(require 'tools/org)

;; Editor Settings:
(require 'editor/company)
(require 'editor/direnv)
(require 'editor/flycheck)
(require 'editor/imenu)
(require 'editor/lispy)
(require 'editor/lsp)
(require 'editor/projectile)
(require 'editor/snippets)
(require 'editor/selectrum)
(require 'editor/treemacs)

;; Languages:
(require 'lang/agda)
(require 'lang/asm)
(require 'lang/bnf)
(require 'lang/emacs-lisp)
(require 'lang/go)
(require 'lang/gemini)
(require 'lang/haskell)
(require 'lang/nix)
(require 'lang/ocaml)
(require 'lang/polytt)
(require 'lang/rust)
(require 'lang/terraform)
(require 'lang/yaml)
(require 'lang/yuck)

;; UI:
(require 'ui/default-theme)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" default))
 '(merlin-command "ocamlmerlin")
 '(safe-local-variable-values '((lsp-haskell-formatting-provider . "fourmolu")))
 '(warning-suppress-log-types '((comp) (direnv)))
 '(warning-suppress-types '((direnv))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
