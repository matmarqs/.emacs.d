;;; init.el --- Minimal Emacs config for C, GNU AS, and OS development -*- lexical-binding: t; -*-
;; Native Emacs bindings only.  No evil, no org, no magit.
;; Package.el + use-package.  Eglot + mason for LSP.
;; Ivy/counsel for completion (fd-powered file search).
;; Ghostel for terminal (libghostty-vt).

;;; Code:

(require 'use-package-ensure)
(setq use-package-always-ensure t
      package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
      package-quickstart t)
(unless (bound-and-true-p package--initialized) (package-initialize))

;; ============================================================
;; Base behavior
;; ============================================================

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)
(when (display-graphic-p) (set-frame-parameter (selected-frame) 'alpha '(93 93)))
(add-to-list 'default-frame-alist '(alpha . (93 . 93)))
(tool-bar-mode -1) (menu-bar-mode -1) (scroll-bar-mode -1)
(global-hl-line-mode t) (show-paren-mode t) (global-display-line-numbers-mode t)
(recentf-mode 1) (delete-selection-mode t) (electric-pair-mode t) (global-auto-revert-mode t)
(setq scroll-margin 5 scroll-conservatively 101 scroll-preserve-screen-position t)
(setq-default indent-tabs-mode nil tab-width 4)
(setq make-backup-files nil auto-save-default nil
      native-comp-async-report-warnings-errors 'silent warning-minimum-level :error)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; ============================================================
;; LSP: eglot (built-in) + mason.el
;; ============================================================

(use-package mason :hook (after-init . mason-ensure))
(use-package eglot
  :ensure nil
  :hook ((c-mode c++-mode python-mode asm-mode) . eglot-ensure)
  :custom (eglot-autoshutdown t) (eglot-report-progress nil)
          (flymake-show-diagnostics-at-end-of-line 'short)
  :bind (("C-c g d" . xref-find-definitions) ("C-c g D" . xref-find-references)
         ("C-c g r" . eglot-rename) ("C-c g a" . eglot-code-actions)
         ("C-c g l" . flymake-show-buffer-diagnostics)))

;; ============================================================
;; Completion: ivy + counsel (fd-powered file search)
;; ============================================================

(defun my/counsel-fd-file-jump (&optional initial-input)
  "Find file recursively using fd.  Falls back to `find-file' for new files."
  (interactive)
  (counsel-require-program "fd")
  (let* ((default-directory (projectile-project-root))
         (cands (process-lines "fd" "--type" "f" "--hidden" "--exclude" ".git")))
    (ivy-read "fd: " cands :initial-input initial-input
              :action (lambda (f) (find-file f)) :require-match nil
              :history 'file-name-history :caller 'my/counsel-fd-file-jump)))
(use-package counsel
  :bind (([remap find-file] . counsel-find-file) ("M-x" . counsel-M-x))
  :custom (counsel-grep-base-command "rg --no-heading -n %s"))
(use-package ivy
  :defer 0.5
  :custom (ivy-use-virtual-buffers t) (ivy-height 20)
          (ivy-sort-matches-functions-alist '((t . ivy--sort-files-by-date))) (ivy-wrap t)
  :config (ivy-mode 1))

(use-package ghostel :defer t :custom (ghostel-shell "bash"))
(use-package which-key
  :ensure nil :hook (after-init . which-key-mode)
  :custom (which-key-idle-delay 0.3) (which-key-side-window-location 'bottom)
          (which-key-sort-order #'which-key-key-order-alpha)
          (which-key-add-column-padding 1) (which-key-min-display-lines 6)
          (which-key-allow-imprecise-window-fit nil))
(use-package diff-hl :hook (after-init . global-diff-hl-mode))
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces '(("TODO" warning bold) ("FIXME" error bold)
    ("REVIEW" font-lock-keyword-face bold) ("HACK" font-lock-constant-face bold)
    ("DEPRECATED" font-lock-doc-face bold) ("NOTE" success bold)
    ("BUG" error bold) ("XXX" font-lock-constant-face bold))))
(use-package ws-butler :hook (after-init . ws-butler-global-mode))

;; ============================================================
;; GNU AS (AT&T syntax): asm-mode, fixed for GAS
;; ============================================================

(defun my/asm-gas-setup ()
  (setq-local comment-start "# " comment-end ""
              comment-start-skip "\\(#+\\|\\s<+\\)\\s-*"
              comment-column 40 indent-line-function 'indent-relative))
(use-package asm-mode
  :ensure nil :mode (("\\.S\\'" . asm-mode) ("\\.asm\\'" . asm-mode))
  :hook (asm-mode . my/asm-gas-setup))

(setq compilation-scroll-output 'first-error)
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(require 'buffer-move)

;; ============================================================
;; Keybindings
;; ============================================================

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-\\") 'ignore) ; Reserved for tmux
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-_") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
(global-set-key (kbd "C-x 4 s")
                (lambda () (interactive) (select-window (split-window-right))
                  (call-interactively 'ghostel)))

;; buffer navigation
(global-set-key (kbd "C-c n") 'next-buffer)
(global-set-key (kbd "C-c p") 'previous-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

;; toggle keybindings
(global-set-key (kbd "C-c t l") 'display-line-numbers-mode)
(global-set-key (kbd "C-c t w") 'visual-line-mode)
(global-set-key (kbd "C-c t t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c t f") 'flymake-mode)
(global-set-key (kbd "C-c t h") 'global-hl-line-mode)

(global-set-key (kbd "C-S-h") 'buf-move-left)
(global-set-key (kbd "C-S-j") 'buf-move-down)
(global-set-key (kbd "C-S-k") 'buf-move-up)
(global-set-key (kbd "C-S-l") 'buf-move-right)
(when (executable-find "rg")
  (setq grep-program "rg" grep-use-null-device nil xref-search-program 'ripgrep))

(provide 'init)
;;; init.el ends here
