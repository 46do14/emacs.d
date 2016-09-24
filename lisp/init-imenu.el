(require-package 'imenu)
(require-package 'imenu-list)

(global-set-key (kbd "C-'") #'imenu-list-minor-mode)
(setq imenu-list-focus-after-activation t)


(provide 'init-imenu)
