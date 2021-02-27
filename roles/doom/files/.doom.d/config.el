
;;
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; --------------------- CUSTOM VARIABLES ---------------------------

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name ""
      user-mail-address "")

;; --------------------- Appearance ---------------------

(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "Libre Baskerville")
      doom-serif-font (font-spec :family "Libre Baskerville")
      )

(setq doom-theme 'doom-tomorrow-night)

;; --------------------- Vterm keybindings ------------
(evil-define-key 'normal vterm-mode-map "h" 'vterm-send-left)
(evil-define-key 'normal vterm-mode-map "l" 'vterm-send-right)
(evil-define-key 'normal vterm-mode-map "b" 'vterm-send-M-b)
(evil-define-key 'normal vterm-mode-map "e" 'vterm-send-M-f)
(evil-define-key 'normal vterm-mode-map "db" 'vterm-send-C-w)
(evil-define-key 'normal vterm-mode-map "de" 'vterm-send-M-d)
(evil-define-key 'normal vterm-mode-map "p" 'vterm-yank)
(evil-define-key 'normal vterm-mode-map "P" '(lambda ()
                                               (interactive)
                                               (vterm-send-C-b)
                                               (vterm-yank)))
(evil-define-key 'visual vterm-mode-map "d" 'vterm-send-M-w)
;; --------------------- Org Mode ---------------------

;; (add-to-list 'load-path "~/.emacs.d/habitrpg/habitrpg")
;; (require 'habitrpg)
;; (setq habitrpg-api-user "ac7bc572-4a83-4e3f-ba89-42cb95edb474")
;; (setq habitrpg-api-token "5aed1d8a-84ce-4eb9-8edd-09ceab0ae91e")
;; (global-set-key (kbd "C-c C-x h") 'habitrpg-add)
;; (global-set-key (kbd "<f9> a") 'habitrpg-status)
;; (add-hook 'org-after-todo-state-change-hook 'habitrpg-add 'append)

(require 'org-habit)
(map! :leader
      "C" #'org-capture)
(map! :map org-mode-map
      "M-n" #'outline-next-visible-heading
      "M-p" #'outline-previous-visible-heading)
(require 'find-lisp)

(setq org-directory "~/Dropbox/org/"
      jethro/org-agenda-directory (concat org-directory "gtd/")
      org-agenda-files (find-lisp-find-files jethro/org-agenda-directory "\.org$")
      org-startup-folded 'overview)

(setq org-capture-templates
      `(("i" "Inbox" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
         ,(concat "* TODO %?\n"
                  "/Entered on/ %u \n"
                  "What is the first step for this task?"))
        ("e" "Inbox [mail]" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
         ,(concat "* TODO Process: \"%a\" %?\n"
                  "/Entered on/ %u"))
        ("c" "org-protocol-capture" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
         "* TODO [[%:link][%:description]]\n\n %i"
         :immediate-finish t)))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w!)" "HOLD(h!)" "|" "CANCELLED(c!)")))

;; Tags represent represent Areas (prefixed with @) or interests (prefixed with &) according to the PARA system
(setq org-tag-alist '(("@social" . ?s)
                      ("@work" . ?w)
                      ("@music" . ?m)
                      ("@fitness&health" . ?f)
                      ("@learning" . ?l)
                      ("@hrpghabit" . ?a)
                      ("@hrpgdaily" . ?d)
                      ("@hrpgreward" . ?g)
                      ))

(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm
      org-refile-targets '((org-agenda-files . (:level . 1))))

;; --------------------- GTD inbox processing ---------------------

(defvar jethro/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

(defun jethro/org-archive-done-tasks ()
  "Archive all done tasks.de, processes all inbox items."
  (interactive)
  (custom/org-agenda-bulk-mark-regexp-category "inbox")
  (jethro/bulk-process-entries))

(defvar jethro/org-current-effort "1:00"
  "Current effort for agenda items.")

(defun jethro/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " jethro/org-current-effort) nil nil jethro/org-current-effort)))
  (setq jethro/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil jethro/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun jethro/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'jethro/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun jethro/bulk-process-entries ()
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'jethro/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(defun jethro/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions `((,jethro/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))

(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "r" #'jethro/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'jethro/org-inbox-capture)

(defun jethro/set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "NEXT"))

(add-hook 'org-clock-in-hook 'jethro/set-todo-state-next 'append)

(use-package! org-agenda
  :init
  (map! "<f1>" #'jethro/switch-to-agenda)
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t)
  (defun jethro/switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (defun jethro/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task has-subtask))))

  (defun jethro/skip-projects ()
    "Skip trees that are projects"
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((org-is-habit-p)
          next-headline)
         ((jethro/is-project-p)
          next-headline)
         (t
          nil)))))

  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")

;; Show effort estimate in the agenda view

(setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t%-6e% s")
                                (todo . " %i %-12:c %-6e")
                                (tags . " %i %-12:c")
                                (search . " %i %-12:c")))

  (setq org-agenda-custom-commands `((" " "Agenda"
                                      ((agenda ""
                                               ((org-agenda-span 'week)
                                                (org-deadline-warning-days 14)))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Inbox")
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "inbox.org")))))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Emails")
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "emails.org")))))
                                       (todo "NEXT"
                                             ((org-agenda-overriding-header "In Progress")
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "projects.org") ,(concat jethro/org-agenda-directory "next.org")))))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Active Projects")
                                              (org-agenda-skip-function #'jethro/skip-projects)
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "projects.org")))))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "One-off Tasks")
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "next.org")))
                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Habits")
                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "habits.org")))
                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))

                                      )))))

;; Org Roam

( setq org-roam-directory (concat org-directory "roam/") )
(require 'org-roam-protocol)
(winner-mode +1)
  (map! :map winner-mode-map
        "<M-right>" #'winner-redo
        "<M-left>" #'winner-undo)
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-capture" "c" #'org-roam-capture
        :desc "org-roam-deactivate-buffer" "d" #'org-roam-buffer-toggle-display)

(setq org-roam-tag-sources '(prop last-directory))

;; TODO template the main string
(setq org-roam-capture-templates
        '(("r" "read" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "src/read/${slug}"
           :head "#+title: ${title}\n
#+roam_alias: \n
#+roam_tags: \n
* ${title}\n
- source :: ${ref}\n
- links :: "
           :unnarrowed t)
          ("w" "web" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "src/web/${slug}"
           :head "#+title: ${title}\n
#+roam_alias: \n
#+roam_tags: \n
* ${title}\n
- source :: ${ref}\n
- links :: "
           :unnarrowed t)
          ("m" "media" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "src/media/${slug}"
           :head "#+title: ${title}\n
#+roam_alias: \n
#+roam_tags: \n
* ${title}\n
- source :: ${ref}\n
- links :: "
           :unnarrowed t)
          ("c" "concept" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+title: ${title}\n
#+roam_alias: \n
#+roam_tags: \n
* ${title}
- links :: "
           :unnarrowed t)))
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "src/web/${slug}"
           :head "#+title: ${title}
#+roam_key: ${ref}
#+roam_tags: website
* ${title}
- source :: ${ref}
- links :: "
           :unnarrowed t)))

;; Org server

;; (use-package org-roam-server
;;   :ensure t
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8080
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20))

;; Org Flashcards org-fc

;; (setq org-fc-directories org-roam-directory)

;; Org Pomodoro
;; TODO add hook to send notification to mobile when break ends

(setq org-pomodoro-length 50)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-long-break-length 10)

;; Org-ref
(require 'org-ref)
(setq reftex-default-bibliography '("~/Workspace/Engineering-Thesis/paper/Bibliography.bib"))
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;; --------------------- Misc ---------------------

(setq display-line-numbers-type 'relative)

;; Make avy lambda searches span all windows

(setq avy-all-windows t)

;; Bookmarks get saved to with every modification

(setq bookmark-save-flag 1)

;; Always show hints for ace-window

(define-globalized-minor-mode ace-window-display-mode-global ace-window-display-mode
  (lambda () (ace-window-display-mode 1)))

(ace-window-display-mode-global 1)

;; delete current file and buffer

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

(map! :leader
        :prefix "b"
        :desc "delete-file-and-buffer" "D" #'delete-file-and-buffer)

(setq auto-save-visited-mode t)

;; --------------------- CUSTOM KEYMAP ---------------------------

;; Make evil-mode up/down operate in screen lines instead of logical lines

(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)

;; Also in visual mode

(define-key evil-visual-state-map "j" 'evil-next-visual-line)
