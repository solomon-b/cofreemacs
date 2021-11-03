;;; ui/default-theme --- Default Themeing -*- lexical-binding: t; -*-

;;; Commentary:
;; This is the theme settings that I personally use.
;; If you don't want to use this, don't `require' it
;; in your `init.el'.

;;; Code:
(require 'use-package)
(require 'time)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Theming

;; I personally like the `modus-vivendi' theme, as
;; it provides a decent amount of contrast.
(use-package modus-themes
  :straight t
  :config
  (load-theme 'modus-vivendi t))

;; I also like to have a bit of a margin around the frame.
(set-frame-parameter (selected-frame) 'internal-border-width 48)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts

(set-face-attribute 'default nil :family "Iosevka Fixed"  :height 140)
;; Set up the fallback face for glyphs we don't know how to render.
;; Let's use "Apple Color Emoji" for now, as most problematic glyphs are indeed emoji
(set-fontset-font t nil (font-spec :size 14 :name "Apple Color Emoji"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode Line

;; I like a pretty minimal modeline so I can actually see stuff when I have
;; a bunch of window splits, so let's try and make that as small as possible.

;; First, let's activate some modes that add some info to the mode line.
(setq display-time-default-load-average nil)
(display-time-mode 1)
(display-battery-mode 1)

;; If we want some stuff right justified, we need to define a little helper function to compute the correct spacing.
(defun mode-line-render (left right)
  "Return a string of `window-width' length containing LEFT and RIGHT,
aligned respectively."
  (let* ((available-width (- (window-width) (length left) 2)))
    (format (format " %%s %%%ds " available-width) left right)))

(defconst mode-line-saved-status
  '(:eval (if (and buffer-file-name (buffer-modified-p))
              (propertize "×" 'face '(:inherit error))
            " "))
  "Displays a red × when the buffer is not saved.")

;; Mode Line Contents
(defconst mode-line-left
  '(" "
    mode-line-saved-status
    " %b "
    mode-name
    " "
    ;; TODO Propertize this nicely.
    (:eval (concat "[" (tab-bar-current-tab-name) "]"))

    ;; Mode Specific Stuff
    (:eval (format-mode-line mode-line-mode-info))

    ;; Org
    org-pomodoro-mode-line
    ;; TODO I don't love the look of this... Perhaps we could insert it somewhere else?
    " "
    display-time-string
    (:eval (s-replace "%" "%%%%" battery-mode-line-string)))
  "The left justified portion of the modeline.")

(defconst mode-line-evil
  '(:eval
    (pcase evil-state
      ('insert "I")
      ('normal "N")
      ('visual "Vl")
      ('emacs "E")
      ('operator "O")
      ('motion "M")
      ;; Make it very obvious when I have missed a state
      (s (propertize (symbol-name s) 'face '(:inherit error)))))
  "Custom evil indicator for the mode line.
We need this to avoid weird padding issues.")

(defconst mode-line-right
  '(
    " "
    mode-line-position
    "<" mode-line-evil ">")
  "The right justified portion of the modeline.")

;; Back up the default modeline for reference.
;; We use defvar here to prevent reevaluation of the buffer from cloberring.
(defvar mode-line-backup mode-line-format)

;; Now, let's put everything together.
(setq-default mode-line-format
              '((:eval
                 (mode-line-render (format-mode-line mode-line-left) (format-mode-line mode-line-right)))))

(provide 'ui/default-theme)
;;; default-theme.el ends here
