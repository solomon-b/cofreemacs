;;; lang/emacs-lisp ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(require 'core/keys)
(require 'editor/flycheck)
(require 'editor/snippets)

(create-file-template ".*.el$" "emacs-lisp-template" 'emacs-lisp-mode)

(when (featurep 'editor/flycheck)
  (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

  ;; Required to make flycheck able to recognize "require"
  ;; properly in the config.
  (setq-default flycheck-emacs-lisp-load-path 'inherit))

(when (featurep 'editor/company)
  (add-hook 'emacs-lisp-mode-hook #'company-mode))

(when (featurep 'editor/lispy)
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode))

(use-package ielm
  :init
  (add-hook 'ielm-mode-hook #'company-mode)
  (add-hook 'ielm-mode-hook #'lispy-mode)
  :commands
  emacs-lisp-switch-to-repl
  ielm-switch-to-working-buffer
  :config
  ;; Customize the IELM prompt
  (setq ielm-prompt "λ> ")

  (defun emacs-lisp-switch-to-repl ()
    "Open IELM, setting the working buffer to the current buffer."
    (interactive)
    (let ((src-buf (current-buffer))
          (repl-buf (get-buffer "*ielm*")))
      (if repl-buf
          (switch-to-buffer-other-window repl-buf)
        (progn
          (split-window-sensibly (selected-window))
          (other-window 1)
          (ielm)))
      (with-current-buffer "*ielm*"
        (ielm-change-working-buffer src-buf))))

  (defun ielm-switch-to-working-buffer ()
    "Switch to the current IELM working buffer."
    (interactive)
    (when ielm-working-buffer
      (switch-to-buffer-other-window ielm-working-buffer)))

  :general
  (open-menu-definer
    "i" '(ielm :wk "ielm"))
  (mode-leader-definer
    :keymaps 'ielm-map
    "b" '(ielm-change-working-buffer :wk "change working buffer")
    "s" '(ielm-switch-to-working-buffer :wk "switch to working buffer")))

(mode-leader-definer
  :keymaps 'emacs-lisp-mode-map
  "l" '(eval-buffer :wk "load buffer")
  "L" '(emacs-lisp-byte-compile-and-load :wk "load and compile buffer")
  "s" '(emacs-lisp-switch-to-repl :wk "switch to repl"))

(provide 'lang/emacs-lisp)
;;; emacs-lisp.el ends here
