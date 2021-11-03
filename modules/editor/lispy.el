;;; editor/lispy ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package lispy
  :straight t
  :commands lispy-mode
  :config
  (setq lispy-colon-p nil))

(provide 'editor/lispy)
;;; lispy.el ends here
