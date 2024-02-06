;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'use-package)

(require 'core/keys)
(require 'core/utils)

(advice-add 'rust-mode :before 'direnv-update-directory-environment)

(use-package rustic
  :straight t
  :config
  (setq rustic-format-on-save nil)
  :ensure t)

(use-package flycheck-rust
  :straight t
  :ensure t
  :after (rust-mode flycheck)
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (add-hook 'rust-mode-hook #'flycheck-mode))

(use-package cargo
  :straight t
  :ensure t
  :after (rust-mode))

(setq lsp-rust-analyzer-server-display-inlay-hints t)
(setq lsp-rust-analyzer-server-display-chaining-hints t)
(setq lsp-rust-analyzer-server-display-closure-return-type-hints t)


(provide 'lang/rust)
;;; rust.el ends here
