# AGENTS.md

Personal Emacs 30 config (dotfiles) for C / GNU AS / OS development.
Plain Emacs bindings only — no evil, org, magit, by design.
No build/test/lint tooling; verify by reloading the config (below).

## Layout

- `init.el` — entire config, one file with `;; ===` section banners. Add settings there.
- `early-init.el` — disables package.el; straight.el manages all packages.
- `custom.el` — machine-written Customize state (the theme lives here), loaded by
  `init.el`. Do not hand-edit; set values in `init.el` instead.
- `modules/` — self-written packages, on `load-path`; wire up via `add-to-list` +
  `require` (see buffer-move).

## Packages

- straight.el + use-package; `straight-use-package-by-default t`.
  Built-ins need explicit `:straight nil` (eglot, asm-mode do this).
- Fresh clone: first startup bootstraps straight.el over the network,
  installs treesit c/cpp/lua grammars, builds vterm (needs cmake + libvterm).
- `straight/build/` contains leftovers from older configs (ivy, counsel, ...);
  harmless and gitignored.
- Keep the package inventory in the `init.el` header comment accurate.

## Language servers

- All servers are wired through `my/lsp-servers` in `init.el`
  (major modes -> binary -> install command). To add a language:
  add an entry there and hook its mode in the dolist below it.
- Opening a file prompts once to install a missing server;
  `M-x my/lsp-install-server` does it manually.
- The explicit `add-to-list 'eglot-server-programs'` entries exist to
  beat eglot's built-in defaults (e.g. pyright instead of pylsp) —
  do not remove them.
- Elisp intentionally has no LSP; built-in elisp-mode help is better.

## Verify changes

    emacs --batch -l init.el                          # must load error-free
    emacs --batch -f batch-byte-compile <file>.el     # syntax check edited files

Never commit generated paths: `straight/`, `eln-cache/`, `auto-save-list/`,
`eshell/`, `recentf`, `projects`.

## Conventions

- `lexical-binding: t` everywhere; spaces not tabs, tab-width 4.
- C/C++ indentation is BSD/4, set in two places: `c-default-style` and the
  `c-ts-mode-indent-offset` hook — change both.
- Bindings use the C-c leader prefixes documented in the `init.el` header
  (C-c f/g/c/s/v/t); stock bindings stay untouched. File new keys under an
  existing prefix.
- External tools assumed on PATH: rg, fd (fdfind fallback), clangd,
  clang-format. LSP install recipes additionally use npm/pip3/cargo/curl
  and xbps (Void Linux).
- Deliberate quirks — do not "fix":
  - asm-mode gets GAS patches via hook: `#` comment char, `indent-relative`.
  - `clang-format-style` is "file" with GNU fallback ("bsd" is not a valid
    clang-format style name).
  - Never run tmux inside vterm (that caused the earlier slowness);
    use multi-vterm buffers/window splits instead.
