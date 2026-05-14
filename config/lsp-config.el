;;; lsp-config.el --- Minimal but complete LSP configuration -*- lexical-binding: t; -*-

;;; Code:

;; ============================================
;; Core LSP
;; ============================================

(use-package lsp-mode
  :straight t
  :commands lsp
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :config
  (setq lsp-completion-provider :capf
        lsp-idle-delay 0.3
        lsp-enable-symbol-highlighting t
        lsp-headerline-breadcrumb-enable t
        lsp-enable-on-type-formatting nil
        lsp-enable-indentation nil
        lsp-enable-text-document-sync nil)
  
  ;; clangd settings
  (setq lsp-clients-clangd-args
        '("--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--fallback-style=bsd")))

;; LSP UI (minimal but useful)
(use-package lsp-ui
  :straight t
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-flycheck-enable t))

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (add-to-list 'company-backends 'company-files)
  (company-idle-delay .1)
  (company-minimum-prefix-length 4)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

;; Syntax checking
(use-package flycheck
  :straight t
  :hook (after-init . global-flycheck-mode))


;; Code formatting - configure to use BSD style with 4 spaces
(use-package clang-format
  :straight t
  :config
  ;; Set clang-format to use BSD style with 4 spaces
  (setq clang-format-style "bsd")
  (setq clang-format-fallback-style "bsd")

  ;; Manual formatting only (no auto-format on save)
  ;; Remove or comment out the hook if you want manual control
  ;; :hook ((c-mode . clang-format-on-save-mode)
  ;;        (c++-mode . clang-format-on-save-mode))
)

;; Ivy and Counsel for completion (replace the ivy-rich section)
(use-package ivy
  :straight t
  :bind
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (enable-recursive-minibuffers t)
  :config
  (ivy-mode 1))

(use-package counsel
  :straight t
  :after ivy
  :diminish
  :config
  (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :straight t
  :after ivy
  :init
  (ivy-rich-mode 1)
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev))

;; Remove the all-the-icons-ivy-rich line if it's causing issues
;; (use-package all-the-icons-ivy-rich
;;   :straight t
;;   :init (all-the-icons-ivy-rich-mode 1))

(use-package projectile
  :config
  (projectile-mode 1))

(provide 'lsp-config)

;;; lsp-config.el ends here
