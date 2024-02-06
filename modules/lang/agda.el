;;; lang/agda ---  -*- lexical-binding: t; -*-

;;; Commentary:
;; Agda is a bit of a tricky beast to handle with Emacs.
;; In general, `straight' doesn't manage it very well!
;; Therefore, we use some hacks to get the files using
;; the `agda-mode' binary.

;;; Code:
(require 'core/keys)
(require 'core/utils)

(require 'editor/snippets)

;; First, let's add some common locations to all the relevant PATH variables,
;; using our `add-to-path' helper from before.
(add-to-path "~/.local/bin/")
(add-to-path "~/.cabal/bin")

;; (create-file-template ".*.agda$" "agda-template" 'agda2-mode)

;; Now for the tricky part. `agda-mode' is a bit odd, as Agda ships with a bundle of elisp
;; files that need to match up with the version of Agda you've installed. This makes
;; `use-package' + `straight' not work very well, so we have to do this by hand.

(advice-add 'agda2-mode :before 'direnv-update-directory-environment)

(use-package agda-input
  :straight (agda-input :type git :host github :repo "agda/agda"
			:branch "release-2.6.3"
			:files ("src/data/emacs-mode/agda-input.el"))
  :config
  (agda-input-add-translations '(("hom" . "⇒")
				 ("lam" . "λ")
				 ("iso" . "≅")
				 ("mono" . "↣")
				 ("epi" . "↠")
				 ("nat" . "ℕ")
				 ("int" . "ℤ")
				 ("alpha" . "α")
				 ("beta" . "β")
				 ("gamma" . "γ")
				 ("monus" . "∸")
				 ("z;" . "⨟"))))

(use-package agda2-mode
  :straight (agda2-mode :type git :host github
			:repo "agda/agda"
			:branch "release-2.6.3"
			:files ("src/data/emacs-mode/*.el"
				(:exclude "agda-input.el")))
  :general
  (mode-leader-definer
    :keymaps 'agda2-mode-map
    "c" '(agda2-make-case :wk "case split")
    "l" '(agda2-load :wk "load")
    "n" '(agda2-compute-normalised-maybe-toplevel :wk "normalize")
    "i" '(agda2-search-about-toplevel :wk "info")
    "r" '(agda2-refine :wk "refine")
    "s" '(agda2-solve-maybe-all :wk "solve")
    "w" '(agda2-why-in-scope-maybe-toplevel :wk "describe scope")
    "o" '(agda2-module-contents-maybe-toplevel :wk "module contents")
    "," '(agda2-goal-and-context :wk "display goal")
    "." '(agda2-goal-and-context-and-inferred :wk "display type"))
  (global-motion-definer
    :keymaps 'agda2-mode-map
    "d" '(agda2-goto-definition-keyboard :wk "goto definition")))

(provide 'lang/agda)
;;; agda.el ends here
