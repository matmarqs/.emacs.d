;;; init.el -*- lexical-binding: t; -*-
;;; Hybrid Emacs/Vim configuration.
;;;   normal state: Vim, but Emacs movement keybindings available
;;;   insert state: Vanilla Emacs (C-a, C-e, C-k, M-f, ...)

(require 'use-package-ensure)
(setq use-package-always-ensure t package-quickstart t
      package-archives '(("melpa"  . "https://melpa.org/packages/")
                         ("elpa"   . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;;; Evil for normal-mode, Emacs for insert-mode
(defun my/insert-newline-indent ()
  (interactive) (evil-insert 1) (newline-and-indent))

(use-package evil
  :init (setq evil-want-integration t evil-want-keybinding nil
              evil-want-C-u-scroll t evil-want-C-i-jump nil
              evil-disable-insert-state-bindings t  ; insert = pure Emacs
              evil-undo-system 'undo-redo
              evil-move-beyond-eol t                ; M-e reaches sentence ends
              evil-insert-state-cursor nil evil-normal-state-cursor nil)
  :config
  (dolist (m (list evil-normal-state-map evil-motion-state-map))
    (dolist (k '(("C-y" . yank)
                 ("C-b" . evil-backward-char)
                 ("C-f" . evil-forward-char)
                 ("C-n" . evil-next-line)
                 ("C-p" . evil-previous-line)
                 ("C-a" . move-beginning-of-line)
                 ("C-e" . move-end-of-line)))
      (define-key m (kbd (car k)) (cdr k))))
  (define-key evil-normal-state-map (kbd "RET") #'my/insert-newline-indent)
  (evil-mode 1))

(use-package evil-collection
  :after evil :demand t
  :init (setq evil-collection-mode-list
              '(dired help info ibuffer calendar xref flymake)
              evil-collection-key-blacklist '("g"))
  :config (evil-collection-init))

;;; General settings
(setq-default indent-tabs-mode nil tab-width 4)
(setq scroll-margin 5 scroll-conservatively 101
      scroll-preserve-screen-position t
      make-backup-files nil auto-save-default nil
      native-comp-async-report-warnings-errors 'silent
      warning-minimum-level :error
      compilation-scroll-output 'first-error)
(recentf-mode 1) (delete-selection-mode 1) (electric-pair-mode 1)
(global-auto-revert-mode 1) (blink-cursor-mode -1)
(tool-bar-mode -1) (menu-bar-mode -1) (scroll-bar-mode -1)
(global-hl-line-mode 1) (show-paren-mode 1)
(global-display-line-numbers-mode 1) (save-place-mode 1)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Alpha transparency
(when (display-graphic-p) (set-frame-parameter nil 'alpha '(93 93)))
(add-to-list 'default-frame-alist '(alpha . (93 . 93)))

;;; Completion: ivy + counsel, company, yasnippet
(setq find-program "fd" counsel-file-jump-args '("--ignore-case" "--hidden"))
(use-package counsel
  :bind (([remap find-file] . counsel-file-jump) ("M-x" . counsel-M-x))
  :custom (counsel-grep-base-command "rg --no-heading -n %s"))
(use-package ivy
  :defer 0.5
  :custom (ivy-use-virtual-buffers t) (ivy-height 20) (ivy-wrap t)
  (ivy-sort-matches-functions-alist '((t . ivy--sort-files-by-date)))
  :config (ivy-mode 1))
(use-package company
  :hook (after-init . global-company-mode)
  :custom (company-idle-delay 0.2) (company-minimum-prefix-length 1)
  (company-selection-wrap-around t) (company-show-numbers t)
  :config (define-key company-mode-map (kbd "TAB") nil))
(use-package yasnippet
  :hook (after-init . yas-global-mode))

;;; LSP: enabling only for specific languages I actually use.
;;; Other LSP implementations are not that great (e.g. Python, NASM)
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l"
              lsp-warn-no-matched-clients nil
              lsp-auto-install-server t
              lsp-enable-on-type-formatting nil   ; stop reindenting on Enter
              lsp-enable-indentation nil)         ; let cc-mode handle indent
  :hook ((c-mode c++-mode lua-mode markdown-mode latex-mode) . lsp-deferred)
  :bind (("C-c g d" . lsp-find-definition)
         ("C-c g D" . lsp-find-references)
         ("C-c g r" . lsp-rename)
         ("C-c g a" . lsp-execute-code-action)
         ("C-c g l" . flymake-show-buffer-diagnostics)))
(setq flymake-show-diagnostics-at-end-of-line 'short)

;;; C and NASM specific configs I like
(setq c-default-style "k&r")
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-basic-offset 4)))
(defun my/nasm-setup ()
  (setq-local comment-start "; ")
  (setq-local comment-column 24)
  (setq-local comment-add 0))
(use-package nasm-mode
  :hook ((asm-mode . nasm-mode) (nasm-mode . my/nasm-setup))
  :custom (nasm-basic-offset 4))

;;; Terminal. Ghostel is great, emacs-only keybindings
(use-package ghostel
  :defer t :custom (ghostel-shell "bash")
  :config (evil-set-initial-state 'ghostel-mode 'emacs)
  (add-hook 'ghostel-mode-hook #'evil-emacs-state))

;;; Misc
(use-package which-key
  :ensure nil :hook (after-init . which-key-mode)
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
  (hl-todo-keyword-faces '(("TODO" warning bold) ("FIXME" error bold)
                           ("HACK" font-lock-constant-face bold)
                           ("NOTE" success bold))))

;;; Ripgrep is the default for grepping
(when (executable-find "rg")
  (setq grep-program "rg" grep-use-null-device nil xref-search-program 'ripgrep))

;;; PDFs open in zathura
(defun my/find-file (orig &rest args)
  (if (and (stringp (car args)) (string-match-p "\\.pdf\\'" (car args)))
      (start-process "zathura" nil "zathura" (expand-file-name (car args)))
    (apply orig args)))
(advice-add 'find-file :around #'my/find-file)

;;; Global keybindings
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-+") #'text-scale-increase)
(global-set-key (kbd "C-_") #'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>")   #'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") #'text-scale-decrease)
(global-set-key (kbd "C-x 4 s")
                (lambda () (interactive) (split-window-below)
                  (other-window 1) (call-interactively #'ghostel)))
(global-set-key (kbd "C-c r") #'revert-buffer)
(windmove-swap-states-default-keybindings 'meta)

(provide 'init)
;;; init.el ends here
