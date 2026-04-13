;;; keybindings-config.el --- Emacs-style keybindings -*- lexical-binding: t; -*-

;;; Code:
(global-unset-key (kbd "C-q"))

;; ============================================
;; Global Keybindings (Standard Emacs)
;; ============================================

;; Font scaling
;;(global-set-key (kbd "C-=") 'text-scale-increase)
;;(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Window navigation with C-q prefix
(global-set-key (kbd "C-q w b") 'windmove-left)
(global-set-key (kbd "C-q w n") 'windmove-down)
(global-set-key (kbd "C-q w p") 'windmove-up)
(global-set-key (kbd "C-q w f") 'windmove-right)

;; Buffer movement with shift (C-q + Shift)
(require 'buffer-move)
(global-set-key (kbd "C-q w B") 'buf-move-left)
(global-set-key (kbd "C-q w N") 'buf-move-down)
(global-set-key (kbd "C-q w P") 'buf-move-up)
(global-set-key (kbd "C-q w F") 'buf-move-right)

;; ============================================
;; File Operations (C-q f)
;; ============================================

(global-set-key (kbd "C-q f f") 'counsel-find-file)
(global-set-key (kbd "C-q f r") 'counsel-recentf)
(global-set-key (kbd "C-q f e") (lambda () (interactive) (counsel-find-file user-emacs-directory)))
(global-set-key (kbd "C-q f s") 'save-buffer)
(global-set-key (kbd "C-q f S") 'save-some-buffers)

;; ============================================
;; Dired (C-q d)
;; ============================================

(global-set-key (kbd "C-q d d") 'dired-jump)
(global-set-key (kbd "C-q d j") 'dired-jump)

;; ============================================
;; Buffer Operations (C-q b)
;; ============================================

(global-set-key (kbd "C-q b b") 'switch-to-buffer)
(global-set-key (kbd "C-q b i") 'ibuffer)
(global-set-key (kbd "C-q b k") 'kill-current-buffer)
(global-set-key (kbd "C-q b K") 'kill-some-buffers)
(global-set-key (kbd "C-q b n") 'next-buffer)
(global-set-key (kbd "C-q b p") 'previous-buffer)
(global-set-key (kbd "C-q b r") 'revert-buffer)
(global-set-key (kbd "C-q b R") 'rename-buffer)

;; ============================================
;; Eval Operations (C-q e)
;; ============================================

(global-set-key (kbd "C-q e b") 'eval-buffer)
(global-set-key (kbd "C-q e e") 'eval-last-sexp)
(global-set-key (kbd "C-q e r") 'eval-region)
(global-set-key (kbd "C-q e x") 'eval-expression)

;; ============================================
;; Project Operations (C-q p)
;; ============================================

(with-eval-after-load 'projectile
  (global-set-key (kbd "C-q p f") 'projectile-find-file)
  (global-set-key (kbd "C-q p g") 'projectile-ripgrep)
  (global-set-key (kbd "C-q p p") 'projectile-switch-project)
  (global-set-key (kbd "C-q p d") 'projectile-dired)
  (global-set-key (kbd "C-q p c") 'projectile-compile-project)
  (global-set-key (kbd "C-q p r") 'projectile-recentf)
  (global-set-key (kbd "C-q p b") 'projectile-switch-to-buffer)
  (global-set-key (kbd "C-q p t") 'projectile-test-project)
  (global-set-key (kbd "C-q p k") 'projectile-kill-buffers))

;; ============================================
;; Code/LSP Operations (C-q g)
;; ============================================

(global-set-key (kbd "C-q g d") 'lsp-find-definition)
(global-set-key (kbd "C-q g r") 'lsp-find-references)
(global-set-key (kbd "C-q g i") 'lsp-find-implementation)
(global-set-key (kbd "C-q g t") 'lsp-find-type-definition)
(global-set-key (kbd "C-q g n") 'lsp-rename)
(global-set-key (kbd "C-q g a") 'lsp-execute-code-action)
(global-set-key (kbd "C-q g e") 'lsp-ui-flycheck-list-errors)
(global-set-key (kbd "C-q g f") 'clang-format-buffer)
(global-set-key (kbd "C-q g h") 'lsp-ui-doc-glance)
(global-set-key (kbd "C-q g R") 'lsp-workspace-restart)

;; ============================================
;; Search Operations (C-q s)
;; ============================================

(global-set-key (kbd "C-q s f") 'counsel-find-file)
(global-set-key (kbd "C-q s g") 'counsel-grep-or-swiper)
(global-set-key (kbd "C-q s m") 'counsel-imenu)
(global-set-key (kbd "C-q s r") 'counsel-recentf)

;; ============================================
;; Toggle Operations (C-q t)
;; ============================================

(global-set-key (kbd "C-q t l") 'display-line-numbers-mode)
(global-set-key (kbd "C-q t w") 'visual-line-mode)
(global-set-key (kbd "C-q t c") 'flycheck-mode)
(global-set-key (kbd "C-q t t") 'toggle-truncate-lines)

;; ============================================
;; Which-key (show available keybindings)
;; ============================================

(use-package which-key
  :straight t
  :config
  (which-key-mode t)
  (setq which-key-idle-delay 0.3))

;; ============================================
;; Ivy-rich Fix
;; ============================================

(with-eval-after-load 'ivy-rich
  (when (fboundp 'ivy-rich-switch-buffer-transformer)
    (ivy-set-display-transformer 'ivy-switch-buffer
                                 'ivy-rich-switch-buffer-transformer)))

(provide 'keybindings-config)

;;; keybindings-config.el ends here
