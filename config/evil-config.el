;;; evil-config.el --- Evil mode configuration -*- lexical-binding: t; -*-

(use-package evil
  :straight t
  :init
  ;; Set evil as the default editing mode
  (setq evil-want-keybinding nil)  ; let evil-collection handle bindings
  (setq evil-want-C-u-scroll t)    ; make C-u scroll up like in vim
  (setq evil-want-C-i-jump nil)    ; don't let C-i interfere with TAB
  (setq evil-want-integration t)   ; integrate with other packages
  (setq evil-want-minibuffer nil)  ; DON'T enable evil in minibuffer - this fixes your issues!
  :config
  (evil-mode 1)
  
  ;; Visual hints for different modes
  (setq evil-normal-state-cursor '("green" box)
        evil-insert-state-cursor '("orange" bar)
        evil-visual-state-cursor '("cyan" box)
        evil-replace-state-cursor '("red" bar)
        evil-operator-state-cursor '("red" hollow)))

;; Only initialize evil-collection for packages that are actually installed
(use-package evil-collection
  :straight t
  :after evil
  :demand t
  :config
  (setq evil-collection-setup-minibuffer nil)  ; Don't touch minibuffer
  (evil-collection-init))

;; Which-key shows available keybindings (essential for vim users)
(use-package which-key
  :straight t
  :config
  (which-key-mode t))

(provide 'evil-config)
;;; evil-config.el ends here
