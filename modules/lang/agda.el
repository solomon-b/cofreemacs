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

(create-file-template ".*.agda$" "agda-template" 'agda2-mode)

;; Now for the tricky part. `agda-mode' is a bit odd, as Agda ships with a bundle of elisp
;; files that need to match up with the version of Agda you've installed. This makes
;; `use-package' + `straight' not work very well, so we have to do this by hand.

;; First, let's define a little helper function that will use the `agda-mode' binary to
;; find the location of the elisp files.
(defun agda-mode-locate ()
  "Determine the location of the `agda2-mode' elisp files on your system."
  (condition-case _ (with-temp-buffer (call-process "agda-mode" nil t nil "locate")
                                    (buffer-string))
      (error (error "Could not find the `agda-mode' binary in your path. Do you have agda installed?"))))

;; Now, let's load up `agda-mode'
(load (agda-mode-locate))

;; Once that file is loaded, we apply our configuration, which mostly consists of keybindings.
(with-eval-after-load 'agda2-mode
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

(with-eval-after-load 'agda-input
  ;; Needed to silence the byte compiler.
  (declare-function agda-input-add-translations "agda-input")
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
				 ("monus" . "∸"))))

(provide 'lang/agda)
;;; agda.el ends here
