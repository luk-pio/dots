(defconst org-roam-packages
  '((org-roam :location
        (recipe :fetcher github :repo "jethrokuan/org-roam" :branch "master"))))

(defun org-roam/init-org-roam ()
    (use-package org-roam
        :hook
        (after-init . org-roam-mode)
        :custom
        (org-roam-directory "~/Workspace/org/laptop/roam/")
        :init
        (progn
          (spacemacs/declare-prefix "aR" "org-roam")
          (spacemacs/set-leader-keys
            "aRl" 'org-roam
            "aRt" 'org-roam-today
            "aRf" 'org-roam-find-file
            "aRg" 'org-roam-show-graph)

          (spacemacs/declare-prefix-for-mode 'org-mode "mR" "org-roam")
          (spacemacs/set-leader-keys-for-major-mode 'org-mode
            "Rl" 'org-roam
            "Rt" 'org-roam-today
            "Rb" 'org-roam-switch-to-buffer
            "Rf" 'org-roam-find-file
            "Ri" 'org-roam-insert
            "Rg" 'org-roam-show-graph))
        :config
        (defun my-org-roam-no-timestamp-in-title (title)
          (let ((slug (org-roam--title-to-slug title)))
            (format "%s" slug)))

        (setq org-roam-templates
              (list (list "default" (list :file #'my-org-roam-no-timestamp-in-title
                                          :content "#+TITLE: ${title}"))))
))
