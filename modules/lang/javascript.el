;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

;; (add-hook 'js-mode-hook (lambda ()
;; ;; 			  (setq tab-width 2)
;; ;; 			  (setq-default indent-tabs-mode nil)
;; ;; 			  ))
;; (setq js-indent-level 2)

(use-package js2-mode
  :ensure t
  :defer t
  :commands js2-mode
  :config
  (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode))
  (setq-default js2-basic-offset 2)
  (setq-default js-indent-level 2)
  (add-hook 'js2-mode-hook 'flycheck-mode)
  (customize-set-variable 'js2-mode-show-parse-errors nil)
  (customize-set-variable 'js2-strict-missing-semi-warning nil)
  (customize-set-variable 'js2-strict-trailing-comma-warning nil)
  (customize-set-variable 'js2-strict-inconsistent-return-warning nil))

(use-package js
  :ensure t)

(defun fwoar/typescript-mode-hook ()
  (tree-sitter-require 'typescript)
  (when (s-suffix-p ".tsx" buffer-file-name)
    (setq-local tree-sitter-language (tree-sitter-require 'tsx)))
  (flycheck-mode 1)
  (lsp)
  (prettier-js-mode 1)
  (tree-sitter-mode 1)
  (tree-sitter-hl-mode 1)
  (set-syntax-table rjsx-mode-syntax-table)
  (setq-default typescript-indent-level 2)
  )

(use-package typescript-mode
  :ensure t
  :config
  (add-hook 'typescript-mode-hook 'fwoar/typescript-mode-hook)
  (add-to-list 'auto-mode-alist
               '("\\.tsx$" . typescript-mode)))

(use-package f
  :ensure t)

(use-package tree-sitter
  :ensure t)

(use-package tree-sitter-langs
  :init
  (message "setting up tree-sitter-langs")
  (require 'tree-sitter-langs)
  :after tree-sitter f
  :no-require t
  :ensure nil)

(use-package rjsx-mode
  :ensure t
  :config
  (add-hook 'js2-mode-hook 'lsp)
  (add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode)))

(use-package prettier-js
  :ensure t
  :delight " p"
  :init
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'css-mode 'prettier-js-mode))


(provide 'lang/javascript)
;;; javascript.el ends here
