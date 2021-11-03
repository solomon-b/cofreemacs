;;; editor/company ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'core/ui)

(require 'use-package)

(use-package company
  :straight t
  :diminish company-mode
  :commands company-mode)

(provide 'editor/company)
;;; company.el ends here
