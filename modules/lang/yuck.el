;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(add-to-list 'load-path "~/Development/ELisp/yuck-mode")
(autoload 'yuck-mode "yuck-mode" nil t)

(add-to-list 'auto-mode-alist '("\\.yuck\\'" . yuck-mode))


;; (use-package yuck-mode
;; ;;   :ensure t
;; ;;   :straight t
;; ;;   :config)

(provide 'lang/yuck)
;;; yuck.el ends here
