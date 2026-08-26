# AGENTS.md

Personal Emacs 30 config (dotfiles) for C / GNU AS / OS development.
Plain Emacs bindings only — no evil, org, magit, by design.
No build/test/lint tooling; verify by reloading the config (below).

## Layout

- `init.el` — entire config, one file with `;; ===` section banners. Add settings there.
- `early-init.el` — Doom-style startup optimizations (GC, file-name-handler-alist, UI disable).
- `custom.el` — machine-written Customize state (the theme lives here), loaded by
  `init.el`. Do not hand-edit; set values in `init.el` instead.
- `modules/` — self-written packages, on `load-path`; wire up via `add-to-list` +
  `require` (see buffer-move).

## Packages

- package.el + use-package; `use-package-always-ensure t`.
  Built-ins need explicit `:ensure nil` (eglot, asm-mode, which-key do this).
- Fresh clone: first startup installs all packages from MELPA/ELPA automatically.
- mason.el manages LSP server installation (like mason.nvim).
- Keep the package inventory in the `init.el` header comment accurate.

## Language servers

- LSP servers are managed by mason.el. Use `M-x mason-install` to add servers.
- Eglot is configured minimally: it starts servers for c-mode, c++-mode,
  python-mode, and asm-mode. Mason ensures binaries exist.
- Elisp intentionally has no LSP; built-in elisp-mode help is better.

## Verify changes

    emacs --batch -l init.el                          # must load error-free
    emacs --batch -f batch-byte-compile <file>.el     # syntax check edited files

Never commit generated paths: `eln-cache/`, `auto-save-list/`,
`eshell/`, `recentf`, `projects`, `elpa/`.

## Conventions

- `lexical-binding: t` everywhere; spaces not tabs, tab-width 4.
- C/C++ indentation is BSD/4, set in `c-default-style`.
- Bindings use the C-c leader prefixes documented in the `init.el` header
  (C-c f/g/c/s/v/t); stock bindings stay untouched. File new keys under an
  existing prefix.
- External tools assumed on PATH: rg, fd (fdfind fallback), clangd.
- Deliberate quirks — do not "fix":
  - asm-mode gets GAS patches via hook: `#` comment char, `indent-relative`.
  - consult-fd replaces default find-file (C-c f).
