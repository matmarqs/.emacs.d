;; straight.el: package manager bootstrap

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Initialize straight.el and use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(use-package diminish)
(add-to-list 'load-path "~/.emacs.d/modules/")
(add-to-list 'load-path "~/.emacs.d/config/")

;;(load-file "~/.emacs.d/config/evil-config.el")
(load-file "~/.emacs.d/config/lsp-config.el")
;;(load-file "~/.emacs.d/config/keybindings-config.el")
(load-file "~/.emacs.d/config/keybindings-emacs.el")
(load-file "~/.emacs.d/config/rg-config.el")
(load-file "~/.emacs.d/config/git-config.el")
;;(load-file "~/.emacs.d/config/markdown-config.el")

;; -- CUSTOM CONFIG BELOW --

;; my custom theme
(set-frame-parameter (selected-frame) 'alpha '(93 93))
(add-to-list 'default-frame-alist '(alpha-background . 93))

(setq custom-file "~/.emacs.d/custom.el") ;; custom-file is where Emacs writes the automatic config
(load-file custom-file)

;; Disable GUI elements for a cleaner, vim-like experience
(tool-bar-mode -1)     ; disable toolbar
(menu-bar-mode -1)     ; disable menubar
(scroll-bar-mode -1)   ; disable scrollbars

(global-hl-line-mode t) ;; Current point line highlighting

;; Better scrolling
(setq scroll-margin 5
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-default-style "bsd" c-basic-offset 4)

;; Remove trailing whitespace on save only for C/C++
(add-hook 'c-mode-hook
          (lambda () (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))
(add-hook 'c++-mode-hook
          (lambda () (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))

;; Enable better clipboard integration
(setq select-enable-clipboard t)

;; Show matching parentheses
(show-paren-mode t)

;; Save place in files between sessions
;;(save-place-mode t)

;; Enable line numbers
(global-display-line-numbers-mode t)
(menu-bar--display-line-numbers-mode-relative)

(provide 'init)
