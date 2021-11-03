;;; core/utils --- Commonly used utilities  -*- lexical-binding: t; -*-

;;; Commentary:
;; There are a bunch of packages I use inside of the configuration
;; itself, so let's make sure to load those up ASAP.

;;; Code:
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General

;; `dash' provides a bunch of useful utility functions,
;; mostly centered around providing a more FP style.
(use-package dash
  :straight t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paths

(use-package f
  :straight t)

(defun add-to-path (path)
  "Add PATH to the variable `exec-path' and update $PATH.
This is used in place of `exec-path-from-shell' to avoid having
to start up a shell process, and is also more consistent."
  (let ((expanded-path (expand-file-name path)))
    (add-to-list 'exec-path expanded-path)
    ;;(setq eshell-path-env (concat expanded-path ":" eshell-path-env))
    (setenv "PATH" (concat expanded-path ":" (getenv "PATH")))))

;; Add some common locations to the path.
(add-to-path "/usr/local/bin")
(add-to-path "~/.local/bin/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Strings

(use-package s
  :straight t)

(provide 'core/utils)
;;; utils.el ends here
