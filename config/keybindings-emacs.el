;;; keybindings-config.el --- Emacs-style keybindings -*- lexical-binding: t; -*-

;;; Code:
(global-unset-key (kbd "C-z"))

;; ============================================
;; Global Keybindings (Standard Emacs)
;; ============================================

;; Font scaling
;;(global-set-key (kbd "C-=") 'text-scale-increase)
;;(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Window navigation with C-z prefix
(global-set-key (kbd "C-z w b") 'windmove-left)
(global-set-key (kbd "C-z w n") 'windmove-down)
(global-set-key (kbd "C-z w p") 'windmove-up)
(global-set-key (kbd "C-z w f") 'windmove-right)

;; Buffer movement with shift (C-z + Shift)
(require 'buffer-move)
(global-set-key (kbd "C-z w B") 'buf-move-left)
(global-set-key (kbd "C-z w N") 'buf-move-down)
(global-set-key (kbd "C-z w P") 'buf-move-up)
(global-set-key (kbd "C-z w F") 'buf-move-right)

;; ============================================
;; File Operations (C-z f)
;; ============================================

(global-set-key (kbd "C-z f f") 'counsel-find-file)
(global-set-key (kbd "C-z f r") 'counsel-recentf)
(global-set-key (kbd "C-z f e") (lambda () (interactive) (counsel-find-file user-emacs-directory)))
(global-set-key (kbd "C-z f s") 'save-buffer)
(global-set-key (kbd "C-z f S") 'save-some-buffers)

;; ============================================
;; Dired (C-z d)
;; ============================================

(global-set-key (kbd "C-z d d") 'dired-jump)
(global-set-key (kbd "C-z d j") 'dired-jump)

;; ============================================
;; Buffer Operations (C-z b)
;; ============================================

(global-set-key (kbd "C-z b b") 'switch-to-buffer)
(global-set-key (kbd "C-z b i") 'ibuffer)
(global-set-key (kbd "C-z b k") 'kill-current-buffer)
(global-set-key (kbd "C-z b K") 'kill-some-buffers)
(global-set-key (kbd "C-z b n") 'next-buffer)
(global-set-key (kbd "C-z b p") 'previous-buffer)
(global-set-key (kbd "C-z b r") 'revert-buffer)
(global-set-key (kbd "C-z b R") 'rename-buffer)

;; ============================================
;; Eval Operations (C-z e)
;; ============================================

(global-set-key (kbd "C-z e b") 'eval-buffer)
(global-set-key (kbd "C-z e e") 'eval-last-sexp)
(global-set-key (kbd "C-z e r") 'eval-region)
(global-set-key (kbd "C-z e x") 'eval-expression)

;; ============================================
;; Project Operations (C-z p)
;; ============================================

(with-eval-after-load 'projectile
  (global-set-key (kbd "C-z p f") 'projectile-find-file)
  (global-set-key (kbd "C-z p g") 'projectile-ripgrep)
  (global-set-key (kbd "C-z p p") 'projectile-switch-project)
  (global-set-key (kbd "C-z p d") 'projectile-dired)
  (global-set-key (kbd "C-z p c") 'projectile-compile-project)
  (global-set-key (kbd "C-z p r") 'projectile-recentf)
  (global-set-key (kbd "C-z p b") 'projectile-switch-to-buffer)
  (global-set-key (kbd "C-z p t") 'projectile-test-project)
  (global-set-key (kbd "C-z p k") 'projectile-kill-buffers))

;; ============================================
;; Code/LSP Operations (C-z g)
;; ============================================

(global-set-key (kbd "C-z g d") 'lsp-find-definition)
(global-set-key (kbd "C-z g r") 'lsp-find-references)
(global-set-key (kbd "C-z g i") 'lsp-find-implementation)
(global-set-key (kbd "C-z g t") 'lsp-find-type-definition)
(global-set-key (kbd "C-z g n") 'lsp-rename)
(global-set-key (kbd "C-z g a") 'lsp-execute-code-action)
(global-set-key (kbd "C-z g e") 'lsp-ui-flycheck-list-errors)
(global-set-key (kbd "C-z g f") 'clang-format-buffer)
(global-set-key (kbd "C-z g h") 'lsp-ui-doc-glance)
(global-set-key (kbd "C-z g R") 'lsp-workspace-restart)

;; ============================================
;; Search Operations (C-z s)
;; ============================================

(global-set-key (kbd "C-z s f") 'counsel-find-file)
(global-set-key (kbd "C-z s g") 'counsel-grep-or-swiper)
(global-set-key (kbd "C-z s m") 'counsel-imenu)
(global-set-key (kbd "C-z s r") 'counsel-recentf)

;; ============================================
;; Toggle Operations (C-z t)
;; ============================================

(global-set-key (kbd "C-z t l") 'display-line-numbers-mode)
(global-set-key (kbd "C-z t w") 'visual-line-mode)
(global-set-key (kbd "C-z t c") 'flycheck-mode)
(global-set-key (kbd "C-z t t") 'toggle-truncate-lines)

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
