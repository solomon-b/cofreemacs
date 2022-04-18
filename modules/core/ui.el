;;; core/ui --- User Interface Tweaks required for bootstrapping -*- lexical-binding: t; -*-

;;; Commentary:
;; This may seem a bit out of place, but we want to get some important
;; UI tweaking code loaded early in the init process so that we can
;; use it inside of things like `core/keys'.  Also included in this
;; file are UI tweaks that we want to apply ASAP, in case some other
;; part of the loading process fails.

;;; Code:
(require 'use-package)

;; Disable the window decorations
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(setq enable-recursive-minibuffers t)

;; Let's keep our auto-save data in a different folder, as opposed to directly
;; alongside the files.
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      backup-by-copying t
      backup-directory-alist '((".*" . "~/.emacs-tmp"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Disable the bell ring
(setq ring-bell-function 'ignore)

;; Make "yes or no" prompts use "y" and "n" instead
(defalias 'yes-or-no-p 'y-or-n-p)

;; "diminish" lets us easily hide active modes from the modeline.
(use-package diminish
  :straight t
  :functions diminish
  :config
  (diminish 'global-whitespace-mode)
  (diminish 'auto-revert-mode)
  (diminish 'eldoc-mode)
  (diminish 'abbrev-mode))

(setq scroll-conservatively 101)
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)
;; Avoid calling line-move-partial, increasing scroll speed.
;; https://emacs.stackexchange.com/questions/28736/emacs-pointcursor-movement-lag/28746
(setq auto-window-vscroll nil)

(show-paren-mode 1)
(global-display-line-numbers-mode 1)

(provide 'core/ui)
;;; ui.el ends here
