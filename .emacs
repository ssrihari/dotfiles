(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
    (url-retrieve-synchronously
      "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "/Users/sriharisriraman/dev/scripts/dotemacs/recipes")

(setq nel:my-packages '())
(defvar nel-initialized-hook nil)

(defun nel:require-packages (&rest packages)
  (setq nel:my-packages 
    (append nel:my-packages packages)))

(defun nel:customize-package (name &rest details)
  (setq el-get-sources
        (cons (append (list :name name) details) el-get-sources)))

(defmacro nel:run-after-initializing (&rest body) 
  `(add-hook 'nel-initialized-hook
     (lambda ()
       ,@body)))

(add-to-list 'exec-path "~/bin")

;; end of preface
;; base.el
(nel:require-packages 'anzu 'browse-kill-ring 'company-mode 'projectile 'undo-tree 'smex 'multiple-cursors 'yasnippets 'rainbow-delimiters 'expand-region 'neotree)

(defun back-to-indentation-or-beginning () (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
      (beginning-of-line)))

(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn (indent-region (region-beginning) (region-end)))
      (progn (indent-buffer)))))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(nel:run-after-initializing
 (projectile-global-mode t)
 (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
 (global-linum-mode t)
 (global-company-mode t)
 (global-undo-tree-mode t)
 (tool-bar-mode -1)
 (ido-mode 1)
 (delete-selection-mode t)
 (fset 'yes-or-no-p 'y-or-n-p)
 (scroll-bar-mode -1)
 (yas-global-mode t)
 (add-hook 'before-save-hook 'delete-trailing-whitespace))

(nel:run-after-initializing
 (windmove-default-keybindings)
 (global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)
 (global-set-key (kbd "C-=") 'er/expand-region)
 (global-set-key (kbd "s-t") 'projectile-find-file)
 (global-set-key (kbd "s-g") 'projectile-grep)
 (global-set-key (kbd "M-x") 'smex)
 (global-set-key (kbd "RET") 'newline-and-indent)
 (global-set-key (kbd "s-p") 'projectile-switch-project)
 (global-set-key (kbd "M-S-<up>") 'move-line-up)
 (global-set-key (kbd "M-S-<down>") 'move-line-down)
 (global-set-key (kbd "C-c n") 'indent-region-or-buffer))

;; Show full file path in the title bar
(setq
 frame-title-format
 '((:eval (if (buffer-file-name)
	      (abbreviate-file-name (buffer-file-name))
	    "%b"))))

;; Scroll one line at a time
(setq scroll-conservatively 10)

(global-hl-line-mode)

;; Disables audio bell
(setq ring-bell-function
      (lambda () (message "*beep*")))
;; clojure.el
(nel:require-packages 'cider-x 'clj-refactor 'align-cljlet 'smartparens 'fill-column-indicator)

(setq cider-repl-history-file "~/.emacs.d/nrepl-history")
(setq cider-auto-select-error-buffer t)
(setq cider-repl-popup-stacktraces t)

(defcustom clojure-column-line nil
  "When non nil, puts a line at some character on clojure mode"
  :type 'integer
  :group 'clojure)

(defun custom-cider-shortcuts ()
  (local-set-key (kbd "C-c ,") 'cider-test-run-tests)
  (local-set-key (kbd "C-c ,") 'cider-test-run-tests))

(defun custom-turn-on-fci-mode ()
  (when clojure-column-line
    (setq fci-rule-column clojure-column-line)
    (turn-on-fci-mode)))

(defmacro clojure:save-before-running (function)
  `(defadvice ,function (before save-first activate)
     (save-buffer)))

(defmacro clojure:load-before-running (function)
  `(defadvice ,function (before save-first activate)
     (cider-load-buffer)))

(nel:run-after-initializing
  (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
  (add-hook 'clojure-mode-hook 'clj-refactor-mode)
  (add-hook 'clojure-mode-hook 'show-paren-mode)
  (add-hook 'clojure-mode-hook 'sp-use-paredit-bindings)
  (add-hook 'clojure-mode-hook (lambda () (cljr-add-keybindings-with-prefix "C-c C-m")))
  (add-hook 'clojure-mode-hook 'custom-cider-shortcuts)
  (add-hook 'clojure-mode-hook 'custom-turn-on-fci-mode)

  (add-hook 'cider-repl-mode-hook 'smartparens-strict-mode)
  (add-hook 'cider-repl-mode-hook 'show-paren-mode)
  (add-hook 'cider-repl-mode-hook 'sp-use-paredit-bindings)

  (clojure:save-before-running cider-load-current-buffer)
  (clojure:load-before-running cider-test-run-tests)
  (clojure:load-before-running cider-test-rerun-tests)
  (clojure:load-before-running cider-test-run-test))
;; git.el
(nel:require-packages 'magit)

(nel:run-after-initializing
 (global-set-key (kbd "C-c g") 'magit-status))
;; grizzl.el
(nel:require-packages 'grizzl)

(setq projectile-completion-system 'grizzl)
;; markdown.el
(nel:require-packages 'markdown-mode)
;; sanityinc-solarized-dark.el
(nel:require-packages 'sanityinc-solarized)

(nel:run-after-initializing
  (add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/sanityinc-solarized")
  (load-theme 'sanityinc-solarized-dark t))
;; save-autosave-in-temp-folder.el
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))
;; sublime.el
(nel:require-packages 'expand-region)

(defmacro move-back-horizontal-after (&rest code)
  `(let ((horizontal-position (current-column)))
     (progn
       ,@code
       (move-to-column horizontal-position))))

(defun comment-or-uncomment-line-or-region ()
  (interactive)
  (if (region-active-p)
    (comment-or-uncomment-region (region-beginning) (region-end))
    (move-back-horizontal-after
     (comment-or-uncomment-region (line-beginning-position) (line-end-position))
     (forward-line 1))))

(defun duplicate-line ()
  (interactive)
  (move-back-horizontal-after
   (move-beginning-of-line 1)
   (kill-line)
   (yank)
   (open-line 1)
   (forward-line 1)
   (yank)))

(defun expand-to-word-and-multiple-cursors (args)
  (interactive "p")
  (if (region-active-p) (mc/mark-next-like-this args) (er/mark-word)))

(nel:run-after-initializing
  (require 'expand-region)
  (global-set-key (kbd "M-s-<right>") 'switch-to-next-buffer)
  (global-set-key (kbd "M-s-<left>") 'switch-to-prev-buffer)
  (global-set-key (kbd "s-D") 'duplicate-line)
  (global-set-key (kbd "s-Z") 'undo-tree-redo)
  (global-set-key (kbd "M-;") 'comment-or-uncomment-line-or-region)
  (global-set-key (kbd "s-d") 'expand-to-word-and-multiple-cursors))
;; web.el
(nel:require-packages 'web-mode 'scss-mode 'coffee-mode 'jsx-mode 'jshint-mode)

(setq coffee-tab-width 2)
(setq scss-compile-at-save nil)
(setq js-indent-level 2)

(add-hook 'js-mode-hook 'smartparens-strict-mode)
(add-hook 'js-mode-hook 'show-paren-mode)
(add-hook 'js-mode-hook 'sp-use-paredit-bindings)
;; source-code-pro.el
(set-default-font "Source Code Pro 12")
;; auto-revert.el
(global-auto-revert-mode t)
;; modules/personal/empty.el.el
;; start of epilogue

(el-get 'sync nel:my-packages)
(run-hooks 'nel-initialized-hook)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
