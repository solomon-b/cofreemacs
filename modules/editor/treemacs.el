;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(use-package treemacs
  :straight t
  :ensure t
  :defer t
  :general
  (global-definer
    "<tab>" '(treemacs :wk "treemacs")))

(use-package treemacs-evil
  :straight t
  :after (treemacs evil)
  :ensure t)


(use-package treemacs-projectile
  :straight t
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :straight t
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :straight t
  :after (treemacs magit)
  :ensure t)


(provide 'editor/treemacs)
;;; treemacs.el ends here
