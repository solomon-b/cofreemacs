;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; (use-package x86-lookup
;;   :ensure t
;;   :straight t
;;   :config
;;   (setq  x86-lookup-pdf "~/Dropbox/Books/Hacking/64-iA32-Instruction-set-reference-vol2.pdf")
;;   )

(use-package nasm-mode
   :ensure t
   :straight t
   :config
   (add-hook 'asm-mode-hook 'nasm-mode)
   )

(provide 'lang/asm)
;;; asm.el ends here
