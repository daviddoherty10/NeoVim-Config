# Validation

Verified in a fresh, isolated installation on Linux with Neovim **0.12.6** and the
plugin revisions in `lazy-lock.json`. No existing Neovim configuration or plugin data
was used. The macOS installation commands are documented in `README.md`; the config
has not been run on David's Mac.

| Check | Result |
| --- | --- |
| Clean startup and loading every configured plugin | Passed |
| Core/custom mappings after all plugins load | 51 checked |
| Completion controls and Tab/Shift-Tab exclusion | Passed |
| Harpoon add/jump and quickfix next/previous | Passed |
| One Conform save hook | Passed |
| Real LSP attachment and request response | All 17 configured servers passed |
| Deliberate-error diagnostics | Lua, TSX, Go, Java, C, Python, JSON, YAML, ESLint passed |
| Formatting on save | Lua, TSX, Go, Python passed |
| FormatToggle | Passed |
| Treesitter parser loading and highlight query compilation | All 23 configured languages passed |
| External prerequisites and Java runtime health | Passed with Java 21 |
| StyLua formatting and git whitespace check | Passed |

ESLint, Tailwind, and Svelte fixtures used disposable project dependencies. Java was
tested with a standalone class. These checks establish configuration and protocol
functionality; real projects still need their own dependencies, build metadata,
ESLint/Prettier rules, and C/C++ compilation database.

The keybinding audit used `daviddoherty10/NeoVim-Config` at
`9026675e1f03d5603b4a095118e956df4a258775` and the `nvim/` directory in
`daviddoherty10/dotfiles` at `3d081b60ccb16b0a270eba1e0f00c8b3d47959dc`.
Local changes not pushed to either repository are outside that audit. Conflicting
bindings and the corrected behaviour are listed explicitly in the README.
