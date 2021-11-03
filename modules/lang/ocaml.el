;;; lang/ocaml ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)
(require 'core/utils)

(use-package tuareg
  :straight t
  :init
  (add-hook 'tuareg-mode #'lsp)
  (setq lsp-ocaml-lsp-server-command (expand-file-name "~/.opam/4.12.0/bin/ocamllsp"))
  :config

  (defun ocaml-switch-interface ()
    "Switch between an interface file, and it's implementation."
    (interactive)
    (let* ((fname (buffer-file-name))
	   (ext (pcase (file-name-extension fname)
		  ("ml" "mli")
		  ("mli" "ml")
		  (_ (error "Cannot find interface file for %s" fname)))))
      (find-file (concat (file-name-sans-extension fname) "." ext))))

  (defun ocaml-menhir-grammar-conflicts ()
    "Open up a the .conflicts file for the current .mly file."
    (interactive)
    (let* ((project-root (projectile-project-root))
	   (conflicts-path (f-swap-ext (f-join project-root "_build/default" (f-relative (buffer-file-name) project-root)) "conflicts")))
      (find-file conflicts-path)))
  :general
  (mode-leader-definer
    :keymaps 'tuareg-mode-map
    "s" '(ocaml-switch-interface :wk "switch interface")

    (mode-leader-definer
      :keymaps 'tuareg-menhir-mode-map
      "s" '(ocaml-menhir-grammar-conflicts :wk "conflicts"))

    (global-motion-definer
      :keymaps 'utop-mode-map
      "k" '(utop-history-goto-prev :wk "previous")
      "j" '(utop-history-goto-next :wk "next"))))

(use-package ocp-indent
  :straight t
  :after tuareg
  :config
  ;; ocp-indent-buffer is broken...
  (advice-add 'ocp-indent-buffer
              :override (lambda (&rest r)
                          (ocp-indent-region (point-min) (point-max))))

  (add-hook 'tuareg-mode-hook
            (lambda () (add-hook 'before-save-hook 'ocp-indent-buffer nil 'local))))

(use-package utop
  :straight t
  :config
  (setq utop-command "opam config exec -- dune utop . -- -emacs")

  :general
  (mode-leader-definer
    :keymaps 'tuareg-mode-map
    "l" '(utop-eval-buffer :wk "load"))
  (global-motion-definer
    :keymaps 'utop-mode-map
    "k" '(utop-history-goto-prev :wk "previous")
    "j" '(utop-history-goto-next :wk "next")))

(provide 'lang/ocaml)
;;; ocaml.el ends here
