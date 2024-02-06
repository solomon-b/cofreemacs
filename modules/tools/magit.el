;;; tools/magit ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/keys)

(require 'use-package)

(use-package magit
  :straight t
  :commands magit-status magit-blame
  :config
  (evil-collection-magit-setup))

;; Show TODO, FIXME, etc in the `magit' buffer.
(use-package magit-todos
  :straight t
  :after magit
  :config
  (magit-todos-mode t))

(straight-use-package
 '(git-timemachine
   :type git
   :host nil
   :repo "https://codeberg.org/pidu/git-timemachine"))

;; (use-package git-timemachine
;;   :straight t
;;   :commands git-timemachine)

(general-create-definer magit-menu-definer
  :wrapping global-definer
  :prefix "SPC g"
  "" '(:ignore t :wk "git"))

(magit-menu-definer
  "g" '(magit-status :wk "status")
  "s" '(magit-status :wk "status")
  "b" '(magit-blame :wk "blame")
  "t" '(git-timemachine :wk "timemachine"))

(general-define-key
 :keymaps 'git-timemachine-mode-map
 :states 'normal
 "C-j" '(git-timemachine-show-previous-revision :wk "previous revision")
 "C-k" '(git-timemachine-show-next-revision :wk "next revision")
 "q"   '(git-timemachine-quit :wk "quit timemachine"))


(use-package git-link
  :straight t
  :general
  (global-motion-definer
    "l" 'git-link))

(provide 'tools/magit)
;;; magit.el ends here
