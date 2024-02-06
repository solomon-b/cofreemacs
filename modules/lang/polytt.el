;;;  ---  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'straight)

(straight-use-package '(polytt-mode :type git
                                    :repo "https://github.com/ToposInstitute/polytt.git"
                                    :branch "main"
				    :files ("emacs/polytt-mode.el")))
(require 'polytt-mode)

(provide 'lang/polytt)
;;; polytt.el ends here
