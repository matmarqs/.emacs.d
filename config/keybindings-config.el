;;; keybindings-config.el --- Complete vim-style keybindings -*- lexical-binding: t; -*-

;;; Code:

;; ============================================
;; Global Keybindings
;; ============================================

;; Font scaling
;(global-set-key (kbd "C-=") 'text-scale-increase)
;(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Better scrolling
;(global-set-key (kbd "C-u") 'scroll-up-command)
;(global-set-key (kbd "C-d") 'scroll-down-command)

;; Window navigation
;(global-set-key (kbd "C-h") 'windmove-left)
;(global-set-key (kbd "C-j") 'windmove-down)
;(global-set-key (kbd "C-k") 'windmove-up)
;(global-set-key (kbd "C-l") 'windmove-right)

;; Buffer movement with shift
(require 'buffer-move)
;(global-set-key (kbd "C-S-h") 'buf-move-left)
;(global-set-key (kbd "C-S-j") 'buf-move-down)
;(global-set-key (kbd "C-S-k") 'buf-move-up)
;(global-set-key (kbd "C-S-l") 'buf-move-right)

;; Clear conflicting evil keys
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

;; ============================================
;; Leader Key Setup
;; ============================================

(use-package general
  :straight t
  :config
  (general-evil-setup)

  (general-create-definer matmarqs-leaderkeys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  ;; ============================================
  ;; File Operations (SPC f)
  ;; ============================================

  (matmarqs-leaderkeys
    "f" '(:ignore t :wk "File")
    "f f" '(counsel-find-file :wk "Find file")
    "f r" '(counsel-recentf :wk "Recent files")
    "f e" '((lambda () (interactive) (counsel-find-file user-emacs-directory)) :wk "Open emacs config dir"))

  ;; ============================================
  ;; Dired (SPC d)
  ;; ============================================
  (matmarqs-leaderkeys
    "d" '(dired-jump :wk "Dired current directory"))

  ;; ============================================
  ;; Buffer Operations (SPC b)
  ;; ============================================

  (matmarqs-leaderkeys
    "b" '(:ignore t :wk "Buffer")
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b i" '(ibuffer :wk "List all buffers")
    "b k" '(kill-current-buffer :wk "Kill buffer")
    "b K" '(kill-some-buffers :wk "Kill multiple buffers")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer"))

  ;; ============================================
  ;; Eval Operations (SPC e)
  ;; ============================================

  (matmarqs-leaderkeys
    "e" '(:ignore t :wk "Eval Elisp")
    "e e" '(elisp-eval-region-or-buffer :wk "Eval region or buffer")
    "e x" '(eval-expression :wk "Eval expression"))

  ;; ============================================
  ;; Window Operations (SPC w)
  ;; ============================================

  (matmarqs-leaderkeys
    "w" '(:ignore t :wk "Window")
    "w c" '(delete-window :wk "Close window")
    "w o" '(delete-other-windows :wk "Close other windows"))

  ;; ============================================
  ;; Project Operations (SPC p)
  ;; ============================================

  (with-eval-after-load 'projectile
    (matmarqs-leaderkeys
      "p" '(:ignore t :wk "Project")
      "p f" '(projectile-find-file :wk "Find file in project")
      "p g" '(projectile-ripgrep :wk "Grep in project")
      "p p" '(projectile-switch-project :wk "Switch project")
      "p d" '(projectile-dired :wk "Project dired")
      "p c" '(projectile-compile-project :wk "Compile project")
      "p r" '(projectile-recentf :wk "Recent project files")
      "p b" '(projectile-switch-to-buffer :wk "Switch to project buffer")
      "p t" '(projectile-test-project :wk "Test project")
      "p k" '(projectile-kill-buffers :wk "Kill project buffers")))

  ;; ============================================
  ;; Code/LSP Operations (SPC c)
  ;; ============================================

  (matmarqs-leaderkeys
    "g" '(:ignore t :wk "Code")
    "g d" '(lsp-find-definition :wk "Go to definition")
    "g r" '(lsp-find-references :wk "Find references")
    "g t" '(lsp-find-type-definition :wk "Go to type definition")
    "g n" '(lsp-rename :wk "Rename symbol")
    "g a" '(lsp-execute-code-action :wk "Code actions")
    "g e" '(lsp-ui-flycheck-list-errors :wk "List errors")
    "g f" '(clang-format-buffer :wk "Format buffer")
    "g h" '(lsp-ui-doc-glance :wk "Hover documentation")
    "g R" '(lsp-workspace-restart :wk "Restart LSP"))

  ;; ============================================
  ;; Search Operations (SPC s)
  ;; ============================================

  (matmarqs-leaderkeys
    "s" '(:ignore t :wk "Search")
    "s f" '(counsel-find-file :wk "Find file")
    "s g" '(counsel-grep-or-swiper :wk "Grep in project")
    "s m" '(counsel-imenu :wk "Imenu (functions)")
    "s r" '(counsel-recentf :wk "Recent files"))

  ;; ============================================
  ;; Toggle Operations (SPC t)
  ;; ============================================

  (matmarqs-leaderkeys
    "t" '(:ignore t :wk "Toggle")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t t" '(visual-line-mode :wk "Toggle visual line wrap")
    "t c" '(flycheck-mode :wk "Toggle flycheck"))

  ;; ============================================
  ;; Help Operations (SPC h)
  ;; ============================================

  (matmarqs-leaderkeys
    "h" '(:ignore t :wk "Help")
    "h a" '(counsel-apropos :wk "Apropos")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h k" '(describe-key :wk "Describe key")
    "h m" '(describe-mode :wk "Describe mode")
    "h b" '(describe-bindings :wk "Describe bindings")
    "h r" '(info-emacs-manual :wk "Emacs manual"))
)

;; ============================================
;; Ivy-rich Fix
;; ============================================

(with-eval-after-load 'ivy-rich
  (when (fboundp 'ivy-rich-switch-buffer-transformer)
    (ivy-set-display-transformer 'ivy-switch-buffer
                                 'ivy-rich-switch-buffer-transformer)))

(provide 'keybindings-config)

;;; keybindings-config.el ends here
