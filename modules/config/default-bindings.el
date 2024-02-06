;;; config/default-bindings --- A set of default keybindings  -*- lexical-binding: t; -*-

;;; Commentary:
;; There are a lot of keybindings required for things like buffer management,
;; finding files, etc. This file collects them all into a single place.

;;; Code:
(require 'core/keys)

(require 'evil-collection)
(require 'general)
(require 'recentf)
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Buffers

(general-create-definer buffer-menu-definer
  :states '(normal motion)
  :wrapping global-definer
  :prefix "SPC b"
  "" '(:ignore t :wk "buffer"))

(defun kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))

(defun open-scratch-buffer ()
  "Open the scratch buffer."
  (interactive)
  (display-buffer (get-buffer-create "*scratch*")))

(buffer-menu-definer
  "b" '(switch-to-buffer :wk "switch buffer")
  "d" '(kill-current-buffer :wk "kill buffer")
  "D" '(kill-other-buffers :wk "kill other buffers")
  "r" '(revert-buffer :wk "reload buffer"))

(global-definer
  "," '(switch-to-buffer :wk "switch buffer")
  "x" '(open-scratch-buffer :wk "scratch buffer"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Files

(general-create-definer file-menu-definer
  :wrapping global-definer
  :prefix "SPC f"
  "" '(:ignore t :wk "file"))

(defun find-emacs-module ()
  "Open an Emacs configuration module."
  (interactive)
  (let ((default-directory "~/Public/emacs/cofreemacs/modules/"))
    (call-interactively 'find-file)))
 
(defun find-package-module ()
  "Open a third-party Emacs module."
  (interactive)
  (let ((default-directory "~/.emacs.d/straight/repos/"))
    (call-interactively 'find-file)))

(defun open-init-file ()
  "Open the initialization file."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; Enable `recentf-mode' so that our helper function works.
(recentf-mode 1)

(defun recentf-find-file ()
  "Open a recently opened file."
  (interactive)
  (find-file (completing-read "Find Recent File: " recentf-list)))

(file-menu-definer
  "f" '(find-file :wk "find file")
  "r" '(recentf-find-file :wk "recent file")
  "i" '(open-init-file :wk "configuration file")
  "m" '(find-emacs-module :wk "find module")
  "s" '(save-buffer :wk "save buffer")
  "p" '(find-package-module :wk "find package")
  "x" '(delete-file :wk "delete file"))

(defun open-xmonad-config ()
  (interactive)
  (find-file "~/Development/Nix/nixos-config/flakes/xmonad-solomon/xmonad.hs"))

(defun open-xmobar-config ()
  (interactive)
  (find-file "~/Development/Nix/nixos-config/flakes/xmobar-solomon/src/App.hs"))

(defun open-nixos-config ()
  (interactive)
  (find-file "~/Development/Nix/nixos-config/flake.nix"))

(general-create-definer config-file-definer
  :wrapping file-menu-definer
  :prefix "SPC f c"
  "" '(:ignore t :wk "config"))

(config-file-definer
  "c" '(open-nixos-config :wk "nixos config")
  "X" '(open-xmobar-config :wk "xmobar")
  "x" '(open-xmonad-config :wk "xmonad"))

(global-definer
  "." '(find-file :wk "find file"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Windows

(general-create-definer window-menu-definer
  :wrapping global-definer
  :prefix "SPC w"
  "" '(:ignore t :wk "window"))

(window-menu-definer
  "w" '(ace-window :wk "select window")
  "h" '(evil-window-left :wk "left")
  "j" '(evil-window-down :wk "down")
  "k" '(evil-window-up :wk "up")
  "l" '(evil-window-right :wk "right")
  "v" '(evil-window-vsplit :wk "vertical split")
  "s" '(evil-window-split :wk "horizontal split")
  "d" '(evil-window-delete :wk "close")
  "o" '(delete-other-windows :wk "close other")
  "f" '(toggle-frame-fullscreen :wk "toggle fullscreen")
  "=" '(balance-windows :wk "balance windows"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Help

(general-create-definer help-menu-definer
  :states '(normal motion)
  :wrapping global-definer
  :prefix "SPC h"
  "" '(:ignore t :wk "help"))

(use-package helpful
  :straight t
  :init
  ;; All of our elisp files are source controlled thanks to `straight',
  ;; so we need to set this to be able to easily navigate to them inside
  ;; of help buffers.

  :config
  (evil-collection-init 'helpful)
  :general
  (help-menu-definer
    "d" '(toggle-debug-on-error :wk "toggle debugger")
    "b" '(describe-bindings :wk "describe bindings")
    "f" '(helpful-callable :wk "describe function")
    "v" '(helpful-variable :wk "describe variable")
    "m" '(describe-mode :wk "describe mode")
    "p" '(describe-package :wk "describe package")
    "F" '(describe-face :wk "describe face")
    "k" '(helpful-key :wk "describe key")
    "i" '(info :wk "open manual")
    "'" '(describe-char :wk "describe char")
    "d" '(toggle-debug-on-error :wk "toggle debug on error")))

(use-package elisp-demos
  :straight t
  :defer t
  :init
  (advice-add 'helpful-update :after 'elisp-demos-advice-helpful-update))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open

(general-create-definer open-menu-definer
  :states '(normal motion)
  :wrapping global-definer
  :prefix "SPC o"
  "" '(:ignore t :wk "open"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Universal Argument

;; Because we will `universal-argument' behind a prefix,
;; we need to write a teeny wrapper function that
;; works when we have multiple `SPC u SPC u' in sequence.
(defun better-universal-argument ()
  "If `current-prefix-arg' is set, apply `universal-argument-more',
instead of `universal-argument'."
  (interactive)
  (if current-prefix-arg
      (universal-argument-more current-prefix-arg)
    (universal-argument)))

(global-definer
  "u" '(better-universal-argument :wk "universal"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil

(evil-collection-dired-setup)
(evil-collection-compile-setup)

(global-motion-definer
  "s" #'sort-lines
  "=" #'align-regexp
  "/" #'avy-goto-char-timer)

(provide 'config/default-bindings)
;;; default-bindings.el ends here
