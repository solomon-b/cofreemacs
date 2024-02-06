;;; tools/org ---  -*- lexical-binding: t; -*-

;;; Commentary:
;; This module is a bit of a beast, as I use `org'
;; pretty heavily.

;;; Code:
(require 'core/keys)

;; We set up a definer for all things that are
;; related to `org', so we can easily extend
;; the global bindings when we add other packages.
(general-create-definer notes-menu-definer
   :states '(normal motion)
   :wrapping global-definer
   :prefix "SPC n"
   "" '(:ignore t :wk "notes"))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :straight t
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :init
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'visual-line-mode)

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)

  (setq org-habit-graph-column 60)

  (setq org-agenda-files
	'("~/Org/org-roam/20220627133506-personal_organization.org"
	  "~/Org/org-roam/20220627125115-friends.org"))

  (setq org-todo-keywords '((sequence
     		             "TODO(t)"
     		             "STRT(s)"
     		             "WAIT(w)"
     		             "REVW(r)"
     		             "BLCK(b)"
     		             "|"
     		             "DONE(d)"
     		             "KILL(k)")))
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-prefix-format '(
    ;; (agenda  . " %i %-12:c%?-12t% s") ;; file name + org-agenda-entry-type
    (agenda  . "  • ")
    (timeline  . "  % s")
    (todo  . " %i %-12:c")
    (tags  . " %i %-12:c")
    (search . " %i %-12:c")))

  ;; Use custom faces for our org keywords.
  ;;(custom-declare-face 'org-todo-active '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
  ;;(custom-declare-face 'org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
  ;;(custom-declare-face 'org-todo-onhold '((t (:inherit (bold warning org-todo)))) "")
  ;;(custom-declare-face 'org-todo-blocked '((t (:inherit (bold error org-todo)))) "")
  :config
  (defun find-task-file ()
    "Open an org task file."
    (interactive)
    (let ((default-directory "~/Org/"))
      (call-interactively 'find-file)))

  (evil-collection-define-key 'normal 'org-mode-map
    [tab] 'org-cycle
    [S-tab] 'org-shifttab)

  ;; :general
  (mode-leader-definer
    :keymaps 'org-mode-map
    "l" '(org-insert-link :wk "insert link")
    "o" '(org-open-at-point :wk "open at point")
    "t" '(org-todo :wk "change todo state")
    "w" '(org-refile :wk "refile")
    "'" '(org-edit-special :wk "edit block"))

  (general-create-definer org-set-definer
    :wrapping mode-leader-definer
    :keymaps 'org-mode-map
    :prefix "SPC m x"
    "" '(:ignore t :which-key "set")
    "p" '(org-set-property :wk "set property"))

  (notes-menu-definer
    "t" '(find-task-file :wk "open org file")
    "l" '(org-store-link :wk "store link")
    "c" '(org-capture :wk "capture")
    "o" '(org-clock-goto :wk "open current task"))
  )

(use-package org-super-agenda
     :straight t
     :ensure t
     :config
     (org-super-agenda-mode)
     (setq org-super-agenda-groups
           '((:name "Daily Tasks" :tag ("DAILY"))
	     (:take (5 (:name "Friends To Call" :tag ("CALL")))))
      ))

(cl-defun org-super-agenda--group-dispatch-take (items (n group))
  "Take N ITEMS that match selectors in GROUP.
If N is positive, take the first N items, otherwise take the last N items.
Note: the ordering of entries is not guaranteed to be preserved, so this may
not always show the expected results."
  (-let* (((name non-matching matching) (org-super-agenda--group-dispatch items group))
          (take-fn (if (cl-minusp n) #'-take-last #'-take))
          (placement (if (cl-minusp n) "Last" "First"))
          (name (format "%s %d %s" placement (abs n) name)))
    (list name non-matching (funcall take-fn (abs n) matching))))

(use-package org-bullets
  :straight t
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-pomodoro
   :straight t
   :after org
   :general
   (notes-menu-definer
     "s" '(org-pomodoro :wk "start pomodoro")))

(use-package org-element
  :after org)

;; (use-package org-persist
;; ;;   :after org)

(use-package org-tempo
  :after org)

;; (setq org-modules (quote
;; 		   (ol-doi
;; 		    ol-w3m
;; 		    ol-bbdb
;; 		    ol-bibtex
;; 		    ol-docview
;; 		    ol-gnus
;; 		    ol-info
;; 		    ol-irc
;; 		    ol-mhe
;; 		    ol-rmail
;; 		    ol-eww
;; 		    org-habit)))

(setq org-startup-folded t)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t)
   (sql . t)
   (haskell . t)
   (emacs-lisp . nil)))

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
(setq org-format-latex-options (plist-put org-format-latex-options :foreground "#FFCC66"))

(defvar my/org-habit-show-graphs-everywhere nil
  "If non-nil, show habit graphs in all types of agenda buffers.

Normally, habits display consistency graphs only in
\"agenda\"-type agenda buffers, not in other types of agenda
buffers.  Set this variable to any non-nil variable to show
consistency graphs in all Org mode agendas.")

(defun my/org-agenda-mark-habits ()
  "Mark all habits in current agenda for graph display.

This function enforces `my/org-habit-show-graphs-everywhere' by
marking all habits in the current agenda as such.  When run just
before `org-agenda-finalize' (such as by advice; unfortunately,
`org-agenda-finalize-hook' is run too late), this has the effect
of displaying consistency graphs for these habits.

When `my/org-habit-show-graphs-everywhere' is nil, this function
has no effect."
  (when (and my/org-habit-show-graphs-everywhere
         (not (get-text-property (point) 'org-series)))
    (let ((cursor (point))
          item data) 
      (while (setq cursor (next-single-property-change cursor 'org-marker))
        (setq item (get-text-property cursor 'org-marker))
        (when (and item (org-is-habit-p item)) 
          (with-current-buffer (marker-buffer item)
            (setq data (org-habit-parse-todo item))) 
          (put-text-property cursor
                             (next-single-property-change cursor 'org-marker)
                             'org-habit-p data))))))

(advice-add #'org-agenda-finalize :before #'my/org-agenda-mark-habits)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Roam

(use-package emacsql-sqlite3
  :straight t
  :ensure t)

(use-package org-roam
  :straight t
  :ensure t
  :commands org-roam-node-find
  :after org
  :init
  (setq org-roam-directory "~/Org/org-roam")
  (setq org-roam-database-connector 'sqlite3)
  :config
  (org-roam-db-autosync-mode)
  :general
  (mode-leader-definer
    :keymaps 'org-mode-map
    "i" '(org-roam-node-insert :wk "roam insert"))
  (notes-menu-definer
    "d" '(org-roam-dailies-goto-today :wk "today's daily note")
    "n" '(org-roam-node-find :wk "open note")))

;(use-package 'org-roam-db
;  :straight t
;  :after org)

;; (use-package 'ob-restclient
;; ;;   :after org
;; ;;   :config
;; ;;   (org-babel-do-load-languages
;; ;;    'org-babel-load-languages
;; ;;    '((restclient . t))))


;(setq org-roam-node-display-template
;      (concat "${title:*} "
;              (propertize "${tags:10}" 'face 'org-tag)))
;
;;; (setq org-roam-v2-ack t)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Org Agenda
;
;;; The following code loads TODOs from org-roam into our org-agenda.
;;; See: https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html
;
;(use-package vulpea
;  :straight (vulpea
;             :type git
;             :host github
;             :repo "d12frosted/vulpea")
;  :after org
;  ;; hook into org-roam-db-autosync-mode you wish to enable
;  ;; persistence of meta values (see respective section in README to
;  ;; find out what meta means)
;  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable)))
;
;(require 'vulpea-buffer)
;
;(defun vulpea-project-p ()
;  "Return non-nil if current buffer has any todo entry.
;
;TODO entries marked as done are ignored, meaning the this
;function returns nil if current buffer contains only completed
;tasks."
;  (org-element-map
;      (org-element-parse-buffer 'headline)
;      'headline
;    (lambda (h)
;      (eq (org-element-property :todo-type h)
;          'todo))
;    nil 'first-match))
;
;(add-hook 'find-file-hook #'vulpea-project-update-tag)
;(add-hook 'before-save-hook #'vulpea-project-update-tag)
;
;(defun vulpea-project-update-tag ()
;      "Update PROJECT tag in the current buffer."
;      (when (and (not (active-minibuffer-window))
;                 (vulpea-buffer-p))
;        (save-excursion
;          (goto-char (point-min))
;          (let* ((tags (vulpea-buffer-tags-get))
;                 (original-tags tags))
;            (if (vulpea-project-p)
;                (setq tags (cons "project" tags))
;              (setq tags (remove "project" tags)))
;
;            ;; cleanup duplicates
;            (setq tags (seq-uniq tags))
;
;            ;; update tags if changed
;            (when (or (seq-difference tags original-tags)
;                      (seq-difference original-tags tags))
;              (apply #'vulpea-buffer-tags-set tags))))))
;
;(defun vulpea-buffer-p ()
;  "Return non-nil if the currently visited buffer is a note."
;  (and buffer-file-name
;       (string-prefix-p
;        (expand-file-name (file-name-as-directory org-roam-directory))
;        (file-name-directory buffer-file-name))))
;
;(defun vulpea-project-files ()
;  "Return a list of note files containing 'project' tag." ;
;  (seq-uniq
;   (seq-map
;    #'car
;    (org-roam-db-query
;     [:select [nodes:file]
;      :from tags
;      :left-join nodes
;      :on (= tags:node-id nodes:id)
;      :where (like tag (quote "%\"project\"%"))]))))
;
;(defun vulpea-agenda-files-update (&rest _)
;  "Update the value of `org-agenda-files'."
;  (setq org-agenda-files (vulpea-project-files)))
;
;(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
;(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

(provide 'tools/org)
;;; org.el ends here
