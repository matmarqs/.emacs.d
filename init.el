;;; init.el -*- lexical-binding: t; -*-
;; Native Emacs bindings only. No evil, no org, no magit.
;; package.el + use-package.
;; eglot + mason for LSP.
;; ivy/counsel for completion (counsel-file-jump + fd).
;; ghostel for terminal (libghostty-vt).
;; zathura opens .pdf files

(require 'use-package-ensure)
(setq use-package-always-ensure t
      package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
      package-quickstart t)

;; custom.el is where customize features go
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;; Base behavior
(setq-default indent-tabs-mode nil tab-width 4)
(setq scroll-margin 5
      scroll-conservatively 101
      scroll-preserve-screen-position t
      make-backup-files nil
      auto-save-default nil
      native-comp-async-report-warnings-errors 'silent
      warning-minimum-level :error
      compilation-scroll-output 'first-error)
(recentf-mode 1) (delete-selection-mode t) (electric-pair-mode t) (global-auto-revert-mode t)

;; UI elements
(tool-bar-mode -1) (menu-bar-mode -1) (scroll-bar-mode -1)
(global-hl-line-mode t) (show-paren-mode t) (global-display-line-numbers-mode t)
(save-place-mode 1)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Alpha transparency
(when (display-graphic-p) (set-frame-parameter (selected-frame) 'alpha '(93 93)))
(add-to-list 'default-frame-alist '(alpha . (93 . 93)))

;; Toggleable trailing whitespace removal on save.
(define-minor-mode my/delete-trailing-whitespace-mode
  "Delete trailing whitespace on save when enabled."
  :lighter " DWS"
  (if my/delete-trailing-whitespace-mode
      (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
    (remove-hook 'before-save-hook #'delete-trailing-whitespace t)))
(my/delete-trailing-whitespace-mode 1)

;; Completion: ivy + counsel (counsel-file-jump + fd)
(setq find-program "fd"
      counsel-file-jump-args '("--no-ignore-vcs"))

(use-package counsel
  :bind (([remap find-file] . counsel-file-jump) ("M-x" . counsel-M-x))
  :custom (counsel-grep-base-command "rg --no-heading -n %s"))

(use-package ivy
  :defer 0.5
  :custom (ivy-use-virtual-buffers t)
          (ivy-height 20)
          (ivy-sort-matches-functions-alist '((t . ivy--sort-files-by-date)))
          (ivy-wrap t)
  :config (ivy-mode 1))

;; LSP: eglot (built-in) + mason.el
(use-package mason :hook (after-init . mason-ensure))
(use-package eglot
  :ensure nil
  :hook ((c-mode c++-mode python-mode asm-mode) . eglot-ensure)
  :custom (eglot-autoshutdown t)
          (eglot-report-progress nil)
          (flymake-show-diagnostics-at-end-of-line 'short)
  :bind (("C-c g d" . xref-find-definitions)
         ("C-c g D" . xref-find-references)
         ("C-c g r" . eglot-rename)
         ("C-c g a" . eglot-code-actions)
         ("C-c g l" . flymake-show-buffer-diagnostics)))

;; Terminal + utilities
(use-package ghostel :defer t :custom (ghostel-shell "bash"))

(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :custom (which-key-idle-delay 0.3)
          (which-key-side-window-location 'bottom)
          (which-key-sort-order #'which-key-key-order-alpha)
          (which-key-add-column-padding 1)
          (which-key-min-display-lines 6)
          (which-key-allow-imprecise-window-fit nil))

(use-package diff-hl
  :hook (find-file . turn-on-diff-hl-mode)
  :config (global-diff-hl-mode))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces '(("TODO" warning bold)
                           ("FIXME" error bold)
                           ("HACK" font-lock-constant-face bold)
                           ("NOTE" success bold))))

(when (executable-find "rg")
  (setq grep-program "rg" grep-use-null-device nil xref-search-program 'ripgrep))

;; Let zathura open all .pdf files
(defun my-open-pdf-in-zathura (filename)
  "Open FILENAME in Zathura if it's a PDF."
  (when (string-match-p "\\.pdf\\'" filename)
    (let ((process-connection-type nil))
      (start-process "zathura" nil "zathura" (expand-file-name filename)))
    t))
(defun my-find-file-advice (orig-fun &rest args)
  "Open PDFs externally instead of in Emacs."
  (if (my-open-pdf-in-zathura (car args))
      nil  ; suppress original call, no buffer created
    (apply orig-fun args)))
(advice-add 'find-file :around #'my-find-file-advice) ;; intercept find-file

;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-_") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(global-set-key (kbd "C-x 4 s")
                (lambda () (interactive)
                  (split-window-below)
                  (other-window 1)
                  (call-interactively 'ghostel)))

(global-set-key (kbd "C-c n") 'next-buffer)
(global-set-key (kbd "C-c p") 'previous-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

(global-set-key (kbd "C-c t l") 'display-line-numbers-mode)
(global-set-key (kbd "C-c t w") 'visual-line-mode)
(global-set-key (kbd "C-c t t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c t f") 'flymake-mode)
(global-set-key (kbd "C-c t h") 'global-hl-line-mode)
(global-set-key (kbd "C-c t d") 'my/delete-trailing-whitespace-mode)

(global-set-key (kbd "C-S-h") 'windmove-swap-states-left)
(global-set-key (kbd "C-S-j") 'windmove-swap-states-down)
(global-set-key (kbd "C-S-k") 'windmove-swap-states-up)
(global-set-key (kbd "C-S-l") 'windmove-swap-states-right)

(provide 'init)
;;; init.el ends here
