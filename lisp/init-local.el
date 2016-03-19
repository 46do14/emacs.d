(require-package 'hydra)

(set-register ?i `(file . ,(concat "c:/users/" (getenv"USERNAME") "/Polybox/.notes/index.org")))

(setq inhibit-start-message t)
(setq initial-scratch-message nil)
;(tool-bar-mode 0)
(menu-bar-mode 0)
(setq tab-width 4)

(setq default-directory "~/")

;; disable automatic file search in ido mode
;;(setq ido-auto-merge-work-directories-length -1)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; select word by double-clicking
(global-set-key (kbd "<mouse-3>") 'copy-region-as-kill)

;; mark ring
;; allows to press just C-SPC after pressing C-u C-SPC
(setq set-mark-command-repeat-pop t)

(autoload 'zap-up-to-char "misc"
  "Kill u to, but not including ARGth occurrence of CHAR")

(global-set-key (kbd "\M-z") 'zap-up-to-char)

;; ido
;;(setq ido-create-new-buffer 'always)

;; dsvn
(eval-after-load "vc-hooks"
  '(define-key vc-prefix-map "=" 'ediff-revision))

;; dired+ (Reusing Dired buffers)
(toggle-diredp-find-file-reuse-dir t)

;; magit
(defun magit-expand-git-file-name--msys (args)
  "Handle Msys directory names such as /c/* by changing them to C:/*"
  (let ((filename (car args)))
        (when (string-match "^/\\([a-z]\\)/\\(.*\\)" filename)
          (setq filename (concat (match-string 1 filename) ":/"
                                 (match-string 2 filename))))
        (list filename)))
(advice-add 'magit-expand-git-file-name :filter-args #'magit-expand-git-file-name--msys)



;; hydra
;; (global-set-key
;;  (kbd "<f2>")
;;  (defhydra hydra-window (:color amaranth)
;;    "window"
;;    ("h" windmove-left)
;;    ("j" windmove-down)
;;    ("k" windmove-up)
;;    ("l" windmove-right)
;;    ("v" (lambda ()
;;           (interactive)
;;           (split-window-right)
;;           (windmove-right))
;;         "vert")
;;    ("x" (lambda ()
;;           (interactive)
;;           (split-window-below)
;;           (windmove-down))
;;         "horz")
;;    ("t" transpose-frame "'")
;;    ("o" delete-other-windows "one" :color blue)
;;    ("a" ace-window "ace")
;;    ("s" ace-swap-window "swap")
;;    ("d" ace-delete-window "del")
;;    ("i" ace-maximize-window "ace-one" :color blue)
;;    ("b" ido-switch-buffer "buf")
;;    ("m" headlong-bookmark-jump "bmk")
;;    ("q" nil "cancel")))

(load-theme 'zenburn)

(global-set-key (kbd "\C-z") 'undo)

;;>>---isearch
(local-set-key [(control s)] 'isearch-forward-regexp)
(local-set-key [(control r)] 'isearch-backward-regexp)

;;>>---query-replace-regexp
(defalias 'qrr 'query-replace-regexp)


;; Always end searches at the beginning of the matching expression.
(add-hook 'isearch-mode-end-hook 'custom-goto-match-beginning)

(defun custom-goto-match-beginning ()
  "Use with isearch hook to end search at first char of match."
  (when isearch-forward (goto-char isearch-other-end)))

(defun isearch-occur ()
  "*Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
(define-key isearch-mode-map (kbd "C-c") 'isearch-yank-symbol)
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)
(define-key isearch-mode-map (kbd "C-t") 'isearch-toggle-case-fold)
;;<<---isearch

;;>>---recentf dialog
(defun gla/ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
;;<<---recentf dialog

;;>>---bind keys to Ctrl-$
(define-prefix-command 'gla-bindings-keymap)
(define-key gla-bindings-keymap (vector ?l) 'helm-locate)
(define-key gla-bindings-keymap (vector ?b) 'helm-browse-project)
(define-key gla-bindings-keymap (vector ?c) 'balance-windows)
(define-key gla-bindings-keymap (vector ?r) 'gla/ido-recentf-open)
;; >> glange
(global-set-key (kbd "C-$") 'gla-bindings-keymap)
;;>>---bind keys to Ctrl-$

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'init-local)
