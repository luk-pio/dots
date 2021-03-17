(add-hook 'LaTeX-mode-hook (lambda ()
                             (TeX-fold-mode 1)))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; DO NOT EDIT THIS FILE DIRECTLY
;; This is a file generated from a literate programing source file located at
;; https://gitlab.com/zzamboni/dot-doom/-/blob/master/doom.org
;; You should make any changes there and regenerate it from Emacs org-mode
;; using org-babel-tangle (C-c C-v t)

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)

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


(add-hook 'org-mode-hook
          (lambda () (add-hook 'after-save-hook #'org-babel-tangle
                               :append :local)))
(pdf-tools-install)
(setq auto-save-visited-mode t)
(setq display-line-numbers-type nil)
(setq avy-all-windows t)
(setq bookmark-save-flag 1)
(define-globalized-minor-mode ace-window-display-mode-global ace-window-display-mode
  (lambda () (ace-window-display-mode 1)))
(ace-window-display-mode-global 1)
(after! centaur-tabs
  (centaur-tabs-mode 1)
  (setq centaur-tabs-height 36
        centaur-tabs-set-icons t
        centaur-tabs-modified-marker "o"
        centaur-tabs-close-button "×"
        centaur-tabs-set-bar 'above
        centaur-tabs-gray-out-icons 'buffer)
  )
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
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
;; Also in visual mode
(define-key evil-visual-state-map "j" 'evil-next-visual-line)
(define-key evil-visual-state-map "k" 'evil-previous-visual-line)
(require 'evil-replace-with-register)
(setq evil-replace-with-register-key (kbd "gr"))
(evil-replace-with-register-install)
(winner-mode +1)
(map! :map winner-mode-map
      "<C-M-right>" #'winner-redo
      "<C-M-left>" #'winner-undo)
(map! :leader
      "<M-left>" #'avy-pop-mark)
(setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 15 :height 1.0)
      doom-variable-pitch-font (font-spec :family "Newsreader" :height 1.0 :size 17)
      )
(setq doom-theme 'spacemacs-light)
  (setq solaire-global-mode -1)
  (setq global-hl-line-mode -1)

(require 'find-lisp)
(setq org-directory "~/Dropbox/org/"
      jethro/org-agenda-directory (concat org-directory "gtd/")
      org-agenda-files (find-lisp-find-files jethro/org-agenda-directory "\.org$")
      org-startup-folded 'overview)
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")
        ))
  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
(use-package! mixed-pitch
  :hook (org-mode . mixed-pitch-mode)
  :config
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 1.3))

(add-hook 'org-mode-hook :append :local
          (lambda ()
            (mixed-pitch-mode 1)
            (hl-line-mode -1)
            (set-left-margin 4)
            (set-right-margin 4)
            (set-window-buffer nil (current-buffer))))

(setq line-spacing 0.1
      header-line-format " "
      )

(setq org-startup-indented t
      org-superstar-headline-bullets-list '(" ") ;; no bullets, needs org-bullets package
      org-ellipsis "  " ;; folding symbol
      org-pretty-entities t
      org-hide-emphasis-markers t
      ;; show actually italicized text instead of /italicized text/
      org-agenda-block-separator ""
      org-fontify-whole-heading-line t
      org-fontify-done-headline t
      org-fontify-quote-and-verse-blocks t)
(setq-local
 bg-white           "#fbf8ef"
 bg-light           "#222425"
 bg-dark            "#1c1e1f"
 bg-darker          "#1c1c1c"
 fg-white           "#ffffff"
 shade-white        "#efeae9"
 fg-light           "#655370"
 dark-cyan          "#008b8b"
 region-dark        "#2d2e2e"
 region             "#39393d"
 slate              "#8FA1B3"
 keyword            "#f92672"
 comment            "#525254"
 builtin            "#fd971f"
 purple             "#9c91e4"
 doc                "#727280"
 type               "#66d9ef"
 string             "#b6e63e"
 gray-dark          "#999"
 gray               "#bbb"
 sans-font          "Hack Nerd Font Mono"
 serif-font         "Newsreader"
 et-font            "Newsreader"
 sans-mono-font     "Hack Nerd Font Mono"
 serif-mono-font    "Verily Serif Mono")

(custom-theme-set-faces
 'user
 `(variable-pitch

   ( (t (:family ,et-font
         :foreground ,bg-dark
         :background ,bg-white
         :height 1.7) ) ))
 `(org-document-title

   ( (t (:inherit nil
         :family ,et-font
         :height 1.8
         :foreground ,bg-dark
         :underline nil) ) ))
 `(org-document-info

   ( (t (:height 1.2
         :slant italic) ) ))
 `(org-level-1

   ( (t (:inherit nil
         :family ,et-font
         :height 1.6
         :weight normal
         :slant normal
         :foreground ,bg-dark) ) ))
 `(org-level-2

   ( (t (:inherit nil
         :family ,et-font
         :weight normal
         :height 1.3
         :slant italic
         :foreground ,bg-dark) ) ))
 `(org-level-3

   ( (t (:inherit nil
         :family ,et-font
         :weight normal
         :slant italic
         :height 1.2
         :foreground ,bg-dark) ) ))
 `(org-level-4

   ( (t (:inherit nil
         :family ,et-font
         :weight normal
         :slant italic
         :height 1.1
         :foreground ,bg-dark) ) ))
 `(org-level-5
   ( (t (:inherit variable-pitch
         :weight bold
         :height 1.1
         :foreground ,slate) ) )
   )
 `(org-level-6
   ( (t (:inherit variable-pitch
         :weight bold
         :height 1.1
         :foreground ,slate) ) )
   )
 `(org-level-7
   ( (t (:inherit variable-pitch
         :weight bold
         :height 1.1
         :foreground ,slate) ) )
   )
 `(org-level-8
   ( (t (:inherit variable-pitch
         :weight bold
         :height 1.1
         :foreground ,slate) ) )
   )
 `(org-headline-done

   ( (t (:family ,et-font
         :strike-through t) ) ))
 `(org-quote
   ( (t (:background ,bg-light) ) )
   )
 `(org-block

   ( (t (:background nil
         :foreground ,bg-dark) ) ))
 `(org-block-begin-line

   ( (t (:background nil
         :height 0.8
         :family ,sans-mono-font
         :foreground ,bg-dark) ) ))
 `(org-block-end-line

   ( (t (:background nil
         :height 0.8
         :family ,sans-mono-font
         :foreground ,bg-dark) ) ))
 `(org-document-info-keyword

   ( (t (:height 0.8
         :foreground ,gray) ) ))
 `(org-link

   ( (t (:foreground ,bg-dark) ) ))
 `(org-special-keyword

   ( (t (:family ,sans-mono-font
         :height 0.8) ) ))
 `(org-todo
   ( (t (:inherit variable-pitch :height 0.8) ) )
   )
 `(org-done
   ( (t (:inherit variable-pitch
         :height 0.8
         :strike-through t
         ) ) )
   )
 `(org-agenda-current-time
   ( (t (:foreground ,slate) ) )
   )
 `(org-hide
   ( (t (:foreground ,bg-white) ) ))
 `(org-indent
   ( (t (:inherit org-hide) ) )
   )
 `(org-time-grid
   ( (t (:foreground ,comment) ) )
   )
 `(org-warning
   ( (t (:foreground ,builtin) ) )
   )
 `(org-date
   ( (t (:family ,sans-mono-font
         :height 0.8) ) ))
 `(org-agenda-structure
   ( (t (:height 1.3
         :foreground ,doc
         :weight normal
         :inherit variable-pitch) ) )
   )
 `(org-agenda-date

   ( (t (:inherit variable-pitch
         :height 1.1) ) ))
 `(org-agenda-date-today
   ( (t (:height 1.5
         :foreground ,dark-cyan
         :inherit variable-pitch) ) )
   )
 `(org-agenda-date-weekend
   ( (t (:inherit org-agenda-date) ) )
   )
 `(org-scheduled
   ( (t (:foreground ,gray) ) )
   )
 `(org-upcoming-deadline
   ( (t (:foreground ,keyword) ) )
   )
 `(org-scheduled-today
   ( (t (:foreground ,fg-white) ) )
   )
 `(org-scheduled-previously
   ( (t (:foreground ,slate) ) )
   )
 `(org-agenda-done
   ( (t (:strike-through t) ) ))
 `(org-ellipsis

   ( (t (:underline nil
         :foreground ,comment) ) ))
 `(org-tag

   ( (t (:foreground ,doc) ) ))
 `(org-table

   ( (t (:family ,serif-mono-font
         :height 0.9
         :background ,bg-white) ) ))
 `(org-code

   ( (t (:inherit
         :family ,serif-mono-font
         :foreground ,comment
         :height 0.7) ) ))
 `(mode-line
   ( (t (:background ,bg-white) ) ))
 )
(map! :leader
      "C" #'org-capture)

(setq org-capture-templates
      `(("i" "Inbox" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
         ,(concat "* TODO %?\n"
                  "/Entered on/ %u \n"
                  "What is the first step for this task?"))
        ("c" "org-protocol-capture" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
         "* TODO [[%:link][%:description]]\n\n %i"
         :immediate-finish t)))

(defun jethro/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-complete-tags-always-offer-all-agenda-tags t)
(setq org-tag-alist '(("@social" . ?s)
                      ("@work" . ?w)
                      ("@music" . ?m)
                      ("@fitness&health" . ?f)
                      ("@learning" . ?l)
                      ))
(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "r" #'jethro/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'jethro/org-inbox-capture)
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm
      org-refile-targets '((org-agenda-files . (:level . 1))))
(defvar jethro/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")
(setq org-agenda-bulk-custom-functions `((,jethro/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))
(defun jethro/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (setq case-fold-search nil)
  (custom/org-agenda-bulk-mark-regexp-category "inbox")
  (setq case-fold-search t)
  (jethro/bulk-process-entries))

(defun custom/org-agenda-bulk-mark-regexp-category (regexp)
  "Mark entries whose category matches REGEXP for future agenda bulk action."
  (interactive "sMark entries with category matching regexp: ")
  (let ((entries-marked 0) txt-at-point)
    (save-excursion
      (goto-char (point-min))
      (goto-char (next-single-property-change (point) 'org-hd-marker))
      (while (and (re-search-forward regexp nil t)
                  (setq category-at-point
                        (get-text-property (match-beginning 0) 'org-category)))
        (if (get-char-property (point) 'invisible)
            (beginning-of-line 2)
          (when (string-match-p regexp category-at-point)
            (setq entries-marked (1+ entries-marked))
            (call-interactively 'org-agenda-bulk-mark)))))
    (unless entries-marked
      (message "No entry matching this regexp."))))

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
(defun jethro/set-todo-state-next ()
  "Visit each parent task and change NEXT states to TODO"
  (org-todo "NEXT"))

(add-hook 'org-clock-in-hook 'jethro/set-todo-state-next 'append)
(use-package! org-agenda
  :init
  (map! :leader
        :prefix "n"
        :desc "org-agenda" "a" #'jethro/switch-to-agenda)
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
         ((jethro/is-project-p)
          next-headline)
         (t
          nil)))))
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
(setq org-roam-directory (concat org-directory "roam/") )
(require 'org-roam-protocol)
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
(use-package! org-roam-server
  :after ( org-roam server )
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        )
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (org-roam-server-mode 1)
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))

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
;; TODO add hook to send notification to mobile when break ends

(setq org-pomodoro-length 50)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-long-break-length 10)
(require 'org-ref)
(setq reftex-default-bibliography '("~/Workspace/Engineering-Thesis/paper/Bibliography.bib"))
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
