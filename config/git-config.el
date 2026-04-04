(use-package diff-hl
  :straight t
  :hook (after-init . global-diff-hl-mode)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh))
