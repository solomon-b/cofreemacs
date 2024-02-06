;;; core/bootstrap --- Bootsraping code for our core systems -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; `straight.el' bootstrapping code. Used to initialize the package management system.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(require 'straight)
(straight-use-package 'org)

;; Load up `use-package', so we can declaratively manage packages.
(straight-use-package 'use-package)
(require 'use-package)

;; By default, the GC threshold for emacs is 800Kib, which is a bit low for initialization.
;; To avoid GC while we initialize, let's bump it up to 10Mib.
(setq gc-cons-threshold 10000000)

;; Restore the GC threshold after initialization is complete.
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 1000000)
            (message "gc-cons-threshold restored to %S"
                     gc-cons-threshold)))

;; We want to load this relatively early so that we can restart emacs nicely
;; even if we make a mistake in our config.
(use-package restart-emacs
  :straight t)

;; Consolidate backup files
(make-directory "~/.emacs_backups/" t)
(make-directory "~/.emacs_autosave/" t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs_autosave/" t)))
(setq backup-directory-alist '(("." . "~/.emacs_backups/")))
(setq backup-by-copying t)


(provide 'core/bootstrap)
;;; bootstrap.el ends here
