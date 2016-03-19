(recentf-mode 1)
(setq recentf-max-saved-items 1000
      recentf-exclude '("/tmp/" "/ssh:"))

;; << glange
(defun gla/ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(global-set-key (kbd "C-x C-r") 'gla/ido-recentf-open)
;; >> glange

(provide 'init-recentf)
