(use-package markdown-mode
  :straight t
  :mode (("\\.md\\'" . markdown-mode))
  :config
  (defun my/markdown-preview-eww ()
    "Preview markdown in eww."
    (interactive)
    (let ((file (buffer-file-name)))
      (when file
        (eww (concat "file://" file)))))
  
  (define-key markdown-mode-map (kbd "C-c C-p") 'my/markdown-preview-eww))
