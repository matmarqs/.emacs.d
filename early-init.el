;;; early-init.el --- Startup optimizations before init.el -*- lexical-binding: t; -*-

;; Doom-style GC: disable during init, restore after.
(setq gc-cons-threshold (* 1024 1024 128)
      gc-cons-percentage 1.0)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 2)
                  gc-cons-percentage 0.2)))

;; Read more data from process output (LSP, compilation, etc.)
(setq read-process-output-max (* 1024 1024))

;; Freeze file-name-handler-alist during init.
(defvar last-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist last-file-name-handler-alist)))

;; Disable UI elements before frame creation.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil)

;; Font.
(set-face-attribute 'default nil :height 120 :weight 'medium)
(setq-default line-spacing 0.12)

;; Encoding.
(prefer-coding-system 'utf-8)

;;; early-init.el ends here
