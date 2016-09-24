(require-package 'hydra)

(set-register ?i `(file . ,(concat "c:/users/" (getenv"USERNAME") "/Polybox/notes/index.org")))

(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")

(setq inhibit-start-message t)
(setq initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode 0)
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

;; Always end searches at the beginning of the matching expression.
(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
(defun my-goto-match-beginning ()
  (when (and isearch-forward isearch-other-end)
    (goto-char isearch-other-end)))

(defadvice isearch-exit (after my-goto-match-beginning activate)
  "Go to beginning of match."
  (when (and isearch-forward isearch-other-end)
    (goto-char isearch-other-end)))

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

;;>>--- narrow-or-widen-dwim
;; http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html
;;
(defun narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or
defun, whichever applies first. Narrowing to
org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer
is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))
;;<<--- narrow-or-widen-dwim


;;>> swap 2 buffers
(defun gla/swap-buffers ()
  (interactive)
  (let ((curr-buffer (current-buffer)))
    (other-window 1)
    (let ((other-buffer (current-buffer)))
      (switch-to-buffer curr-buffer)
      (other-window -1)
      (switch-to-buffer other-buffer))))

;;>>---bind keys to Ctrl-$
(define-prefix-command 'gla-bindings-keymap)
(define-key gla-bindings-keymap (vector ?b) 'helm-browse-project)
(define-key gla-bindings-keymap (vector ?c) 'balance-windows)
(define-key gla-bindings-keymap (vector ?d) 'toggle-debug-on-error)
(define-key gla-bindings-keymap (vector ?r) 'gla/ido-recentf-open)
(define-key gla-bindings-keymap (vector ?l) 'helm-locate)
(define-key gla-bindings-keymap (vector ?n) 'narrow-or-widen-dwim)
(define-key gla-bindings-keymap (vector ?s) 'gla/swap-buffers)
(define-key gla-bindings-keymap (vector ?.) 'repeat-complex-command)
(define-key gla-bindings-keymap (vector ?ä) 'query-replace-regexp)


; >> glange
(global-set-key (kbd "C-$") 'gla-bindings-keymap)
;;>>---bind keys to Ctrl-$

(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; --------------
;; swap 2 buffers
;; --------------
(defun swap-buffers ()
  (interactive)
  (let ((curr-buffer (current-buffer)))
    (other-window 1)
    (let ((other-buffer (current-buffer)))
      (switch-to-buffer curr-buffer)
      (other-window -1)
      (switch-to-buffer other-buffer))))


;; -----------------
;; dedicatetd window
;; -----------------
(defun toggle-current-window-dedication ()
  (interactive)
  (let* ((window    (selected-window))
         (dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window (not dedicated))
    (message "Window %sdedicated to %s"
             (if dedicated "no longer " "")
             (buffer-name))))

(global-set-key [pause] 'toggle-current-window-dedication)

(provide 'init-local)
