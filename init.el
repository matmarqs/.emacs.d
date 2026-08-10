;;; init.el --- Minimal Emacs config for C, GNU AS, and OS development -*- lexical-binding: t; -*-
;;
;; Native Emacs bindings only.  No evil, no org, no magit.
;; Built-ins do the heavy lifting: project.el, eglot+clangd, flymake,
;; xref, c-ts-mode, asm-mode (fixed for GAS), compile/gud, vterm.
;;
;; Package count (everything else is Emacs built-in):
;;   vertico, consult, which-key, diminish, move-text,
;;   vterm, multi-vterm, clang-format, diff-hl, buffer-move (local)

;;; Code:

;; ============================================================
;; Package manager: straight.el + use-package
;; ============================================================

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

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; ============================================================
;; Base behavior
;; ============================================================

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load-file custom-file)

(when (display-graphic-p)
  (set-frame-parameter (selected-frame) 'alpha '(93 93)))
(add-to-list 'default-frame-alist '(alpha . (93 . 93)))
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (display-graphic-p)
              (set-frame-parameter frame 'alpha '(93 93)))))

(set-face-attribute 'default nil :height 120)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-hl-line-mode t)
(show-paren-mode t)
(global-display-line-numbers-mode t)
(menu-bar--display-line-numbers-mode-relative)
(recentf-mode 1)
(setq select-enable-clipboard t)

(setq scroll-margin 5
      scroll-conservatively 101
      scroll-preserve-screen-position t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-default-style "bsd" c-basic-offset 4)

;; Treesit grammars for c-ts-mode / c++-ts-mode (install once, first run)
(when (fboundp 'treesit-install-language-grammar)
  (dolist (lang '(c cpp))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

;; ============================================================
;; Completion (find-file / switch-buffer / M-x / grep)
;; ============================================================

(use-package diminish)

(use-package vertico
  :diminish
  :custom
  (vertico-count 14)
  (vertico-cycle t)
  :config
  (vertico-mode 1)
  (setq enable-recursive-minibuffers t))

(use-package consult
  :custom
  ;; fd is used automatically when find-program is "fd"
  (consult-find-args '("--hidden" "--no-ignore-vcs"))
  :bind (("C-c s f" . consult-find)
         ("C-c s g" . consult-grep)
         ("C-c s i" . consult-imenu)
         ("C-c s r" . consult-recent-file)))

(setq find-program "fd")

;; ============================================================
;; Discoverability: which-key
;; ============================================================

(use-package which-key
  :diminish
  :custom
  (which-key-idle-delay 0.3)
  :config
  (which-key-mode 1))

;; ============================================================
;; Small editing helpers
;; ============================================================

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(require 'buffer-move)
(global-set-key (kbd "C-S-h") 'buf-move-left)
(global-set-key (kbd "C-S-j") 'buf-move-down)
(global-set-key (kbd "C-S-k") 'buf-move-up)
(global-set-key (kbd "C-S-l") 'buf-move-right)

;; ============================================================
;; C / C++: c-ts-mode + eglot (clangd) + flymake + clang-format
;; ============================================================

(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook (lambda () (setq c-ts-mode-indent-offset 4))))

;; Remove trailing whitespace on save (C-family only)
(dolist (hook '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook))
  (add-hook hook
            (lambda () (add-hook 'before-save-hook 'delete-trailing-whitespace nil t))))

(use-package eglot
  :straight nil
  :commands (eglot-rename eglot-code-actions eglot-hover)
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.3)
  :config
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c-mode c++-ts-mode c++-mode)
                 . ("clangd"
                    "--background-index"
                    "--clang-tidy"
                    "--completion-style=detailed"
                    "--fallback-style=BSD")))
  :bind (("C-c g d" . xref-find-definitions)
         ("C-c g D" . xref-find-references)
         ("C-c g r" . eglot-rename)
         ("C-c g a" . eglot-code-actions)
         ("C-c g h" . eglot-hover)
         ("C-c g l" . flymake-show-buffer-diagnostics)))

;; clangd tip for OS projects without compile_commands.json:
;; add a .clangd file at the project root with e.g.
;;   CompileFlags:
;;     Add: [-ffreestanding, -m64, -nostdinc, -Itools/include]
;; or run `bear -- make` once to generate compile_commands.json.
(use-package clang-format
  :custom
  (clang-format-style "bsd")
  (clang-format-fallback-style "bsd")
  :bind (("C-c g f" . clang-format-buffer)))

;; Build: C-c c = M-x compile, C-x p c = project-compile (built-in)
(setq compilation-scroll-output 'first-error)
(global-set-key (kbd "C-c c") 'compile)
;; Kernel debugging later: M-x gdb (built-in gud) works with QEMU's
;; -s -S remote gdbserver out of the box.  No packages needed.

;; ============================================================
;; GNU AS (AT&T syntax): built-in asm-mode, fixed for GAS
;; ============================================================

(defun my/asm-gas-setup ()
  "Set up asm-mode for GNU AS (GAS, AT&T syntax, x86-64).
GAS uses `#' as the comment char on x86 (not `;'), and asm-mode's
column-based auto-indent fights GAS layout, so use plain relative
indent instead."
  (setq-local comment-start "/* ")
  (setq-local comment-end " */")
  (setq-local comment-start-skip "\\(#+\\|\\s<+\\)\\s-*")
  (setq-local comment-column 40)
  (setq-local indent-line-function 'indent-relative))

(use-package asm-mode
  :straight nil
  :mode (("\\.S\\'" . asm-mode)      ; GAS with C preprocessor
         ("\\.asm\\'" . asm-mode))
  :hook (asm-mode . my/asm-gas-setup))

;; ============================================================
;; Terminals: vterm + multi-vterm (no tmux inside Emacs!)
;; ============================================================
;;
;; The slowness you felt was tmux running inside vterm, not vterm
;; itself.  Use many vterm buffers instead: split windows = panes,
;; multi-vterm next/previous = tabs.
;;
;; Built-in alternatives: C-x p e = project-eshell, C-x p s = project-shell

(use-package vterm)

(use-package multi-vterm)

(defun other-window-eshell ()
  "Open a new eshell in a split window at current buffer's directory."
  (interactive)
  (let ((dir default-directory))
    (select-window (split-window-below))
    (let ((default-directory dir))
      (eshell))))

(defun my/vterm-split ()
  "Open a vterm in a split window below, cd'ing to current directory."
  (interactive)
  (let ((dir default-directory))
    (select-window (split-window-below))
    (multi-vterm)
    (vterm-send-string (concat "cd " (shell-quote-argument dir) "\n"))))

(global-set-key (kbd "C-x 4 s") 'other-window-eshell)
(global-set-key (kbd "C-c v v") 'multi-vterm)
(global-set-key (kbd "C-c v s") 'my/vterm-split)
(global-set-key (kbd "C-c v p") 'multi-vterm-previous)
(global-set-key (kbd "C-c v n") 'multi-vterm-next)
(global-set-key (kbd "C-c v e") 'other-window-eshell)

;; ============================================================
;; Version control: diff markers in the fringe only
;; ============================================================

(use-package diff-hl
  :hook (after-init . global-diff-hl-mode))

;; ============================================================
;; Keybindings (native Emacs + consistent C-c leader)
;;
;;   C-x p   projects (built-in: p f find-file, p g grep, p c compile,
;;                     p p switch-project, p b buffers, p C-h all)
;;   C-c f   find-file      C-c g   code (eglot/xref)
;;   C-c c   compile        C-c s   search
;;   C-c v   terminals      C-c t   toggles
;;
;; Everything is discoverable: press C-c then wait for which-key,
;; or C-h k <keys> to describe any binding.
;;
;; Stock bindings are untouched: C-x C-f find-file, C-q quoted-insert,
;; M-. xref-find-definitions, C-x C-e eval-last-sexp, M-x ... etc.
;; ============================================================

;; Font scaling
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-_") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; Files
(global-set-key (kbd "C-c f") 'find-file)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c k") 'kill-whole-line)

;; Buffers
(global-set-key (kbd "C-c n") 'next-buffer)
(global-set-key (kbd "C-c p") 'previous-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)

;; Toggles
(global-set-key (kbd "C-c t l") 'display-line-numbers-mode)
(global-set-key (kbd "C-c t w") 'visual-line-mode)
(global-set-key (kbd "C-c t t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c t f") 'flymake-mode)
(global-set-key (kbd "C-c t h") 'global-hl-line-mode)

(provide 'init)
;;; init.el ends here
