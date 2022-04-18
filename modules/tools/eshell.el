;;; tools/eshell ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)
(require 'config/default-bindings)

(require 'esh-mode)
(require 'em-hist)

;; `esh-help' gives us eldocs for eshell commands.
(use-package esh-help
  :straight t
  :config
  (setup-esh-help-eldoc))

(defun eshell-search-history ()
  "Search through the `eshell-history-ring' using `completing-read'."
  (interactive)
  (let ((cmd (completing-read "History: " (ring-elements eshell-history-ring))))
    ;; Move the point outside of the prompt area
    (forward-char 1)
    (insert cmd)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings

(open-menu-definer
  "e" '(eshell :wk "eshell"))

;(mode-leader-definer
;  :keymaps 'eshell-mode-map
;  "h" '(eshell-search-history :wk "search history"))

;; NOTE: https://github.com/noctuid/general.el/issues/80
(add-hook 'eshell-mode-hook
	  (lambda ()
	    (global-motion-definer
	      :keymaps 'eshell-mode-map
	      "j" 'eshell-next-input
	      "k" 'eshell-previous-input)))


(provide 'tools/eshell)
;;; eshell.el ends here
