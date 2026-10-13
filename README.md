# David's Neovim config

A fresh, modular configuration built around **lazy.nvim** and Neovim's native LSP API.
Your Space leader, editing habits, Telescope, Harpoon, netrw, undo history, completion,
and window/tab shortcuts are retained. TokyoNight Night supplies a transparent theme,
with a compact statusline, Git gutter signs, and a keybinding popup.

## Requirements

- **Neovim 0.12+**. This uses the current `nvim-treesitter` main-branch API.
- Git, ripgrep, curl, tar, unzip, a C compiler, and **tree-sitter CLI 0.26.1+**.
- Node.js LTS and npm for web language servers and Prettier.
- Current Go for gopls/goimports, and Python 3 with venv support for Python tools.
- **Java 21+** to run JDT LS. Your Java projects can still target an older JDK.
- A Nerd Font is optional; diagnostic gutter signs also work with a standard font.

On macOS with Homebrew:

```sh
xcode-select --install # only if Command Line Tools are not already installed
brew install neovim ripgrep node go python tree-sitter openjdk@21
```

If Neovim is already installed, run `brew upgrade neovim`. Install the tree-sitter CLI
through Homebrew rather than npm. Set this in your shell config to use Homebrew Java
only for the language server (including on Apple Silicon):

```sh
export JDTLS_JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
```

## Try the rewrite without replacing your config

The downloadable `neovim-config.zip` contains an `nvim-rewrite/` directory. Extract
it into `~/.config` and launch it as a separate Neovim app:

```sh
mkdir -p ~/.config
unzip ~/Downloads/neovim-config.zip -d ~/.config
NVIM_APPNAME=nvim-rewrite nvim
```

Alternatively, clone the rewrite branch into the same separate app directory:

```sh
git clone --branch rebuild/lazy-modern-lsp \
  https://github.com/daviddoherty10/NeoVim-Config.git \
  ~/.config/nvim-rewrite
NVIM_APPNAME=nvim-rewrite nvim
```

This uses separate config, data, cache, and state directories. It also avoids loading
plugins left over from Packer. On the first launch, lazy.nvim installs plugins. Open
a code file to start automatic Mason installation of the configured language servers
and formatters. Keep Neovim open until `:Mason` shows the installations have finished.
Treesitter installs the configured parsers asynchronously. Reopen the buffer after
initial parser installation to activate highlighting.

The repository contains `lazy-lock.json` with the tested plugin commits. Use
`:Lazy restore` to return to those versions and `:Lazy update` when you want to upgrade.
Plugin update notifications are disabled.

To make this your regular config, first close Neovim and back up your current
directory (moving a symlink backs up the symlink without changing its target):

```sh
mv ~/.config/nvim "${HOME}/.config/nvim-backup-$(date +%Y%m%d-%H%M%S)"
mv ~/.config/nvim-rewrite ~/.config/nvim
nvim
```

If you manage Neovim through your `dotfiles/nvim` directory, copy this config there
instead of maintaining two competing configurations. Remove its old `after/`,
`plugin/packer_compiled.lua`, and `lua/theprimeagen/` files as part of the replacement;
overlaying the new files over the old ones will run both configurations.

## Language support

| Language | Servers | Formatting |
| --- | --- | --- |
| Go | gopls | goimports, gofmt |
| JavaScript / TypeScript / React | ts_ls, ESLint | Project-local Prettier preferred |
| Svelte | svelte, ESLint | Prettier with project-installed prettier-plugin-svelte |
| HTML / CSS | html, cssls, Emmet | Prettier |
| Tailwind | tailwindcss | Prettier |
| Java | jdtls | JDT LS |
| C / C++ | clangd | clangd |
| Python | jedi_language_server | isort, Black |
| Lua | lua_ls | StyLua |
| JSON / YAML | jsonls, yamlls | Prettier |
| Shell | bashls | shfmt |
| Docker / Compose | dockerls, docker_compose_language_service | Prettier for YAML |

`tsserver` is now `ts_ls`. The abandoned Rome server is removed: TypeScript language
features come from ts_ls and formatting comes from Prettier. ESLint and Tailwind attach
in projects containing their configuration/dependencies; they do not need to run in
every web buffer. Install ESLint and Prettier in the project to use its own versions
and rules. For Svelte projects:

```sh
npm install --save-dev prettier prettier-plugin-svelte
```

Add `"plugins": ["prettier-plugin-svelte"]` to the project's Prettier configuration.
For C/C++ projects, generate `compile_commands.json` (for CMake, set
`CMAKE_EXPORT_COMPILE_COMMANDS=ON`) so clangd can resolve project include paths.

Java detects Maven, Gradle, Ant (`build.xml`), Git roots, and standalone-file directories.
Each root receives its own workspace, identified by a hash of the full root path.
Ant root detection does not import an arbitrary Ant build's classpath: for complex
NetBeans/Ant projects supply Eclipse `.project`/`.classpath` metadata or migrate to
Maven/Gradle so JDT LS can resolve dependencies. No Java debugging plugin is required
for diagnostics, completion, navigation, and formatting.

## Preserved keys

`<leader>` means **Space**. Modes: n = normal, i = insert, v/x = visual.

| Keys | Mode | Action |
| --- | --- | --- |
| `jk`, `kj` | i | Escape |
| `<leader>pv` | n | netrw file explorer |
| `J` | n | Join lines while preserving cursor |
| `J`, `K` | v | Move selected lines down/up |
| `Ctrl-d`, `Ctrl-u` | n | Half-page movement, centered |
| `n`, `N` | n | Center and reveal search match |
| `<leader>y`, `<leader>Y` | n/v, n | Yank selection/line to system clipboard |
| `<leader>p` | x | Paste without replacing the yank register |
| `<leader>r` | n | Prompt to replace word throughout file |
| `<leader>sv/sh/se/sx` | n | Vertical/horizontal split, equalize, close |
| `<leader>h/j/k/l` | n | Move between windows |
| `<leader>to/tx/tn/tp` | n | Create/close/next/previous tab |
| `<leader>ff`, `Ctrl-p` | n | Find files / Git files (fallback outside Git) |
| `<leader>ps`, `<leader>vh` | n | Prompted literal project search / help tags |
| `<leader>a`, `Ctrl-e` | n | Harpoon add / menu |
| `Ctrl-h/t/n/s` | n | Harpoon files 1/2/3/4 |
| `<leader>u` | n | Undo tree |
| `Ctrl-k`, `Ctrl-j` | n | Quickfix next/previous, centered |
| `\k`, `\j`, `\q` | n | Legacy location-list next/previous/diagnostics |
| `Ctrl-l`, `Ctrl-\` | n | Right / previous Vim or tmux pane |
| `gd/gD/gi/go/gr` | n, LSP attached | Definition/declaration/implementation/type/references |
| `K`, `gs`, `gl` | n | Hover / signature help / diagnostic details |
| `[d`, `]d` | n | Previous/next diagnostic |
| `F2`, `F3`, `F4` | n (F3/F4 also x) | Rename / format / code action |
| `Ctrl-p/n` | i | Previous/next completion |
| `Ctrl-y`, `Ctrl-Space`, `Ctrl-e` | i | Accept completion / open / dismiss |
| `Up`, `Down` | i | Previous/next completion when the menu is open |

Tab and Shift-Tab do not cycle completion items. Native Neovim snippets handle snippet
expansion. Ordinary Vim macros (`q`) continue to work, matching the old config's actual
behaviour: `unmap q` did not disable the built-in command.

### Conflicts corrected explicitly

- The dotfiles copy registered diagnostic keys **before** setting Space as leader,
  so they actually used `\`. Those aliases remain, and `<leader>q` now also opens
  buffer diagnostics. `<leader>h/j/k/l` continue to navigate windows.
- tmux-navigator's automatic `Ctrl-h/j/k` mappings competed with Harpoon and quickfix.
  Your explicit Harpoon/quickfix shortcuts win consistently. All four tmux directions
  remain accessible through new `<leader>wh/wj/wk/wl` bindings. Your tmux configuration
  must forward those keys to Neovim if you want to use them across panes.
- The old completion mapping table was created but never passed to cmp; it is now
  applied explicitly, including `Ctrl-Space` and `Ctrl-y` with selection enabled.
- Formatting now has one Conform pipeline, replacing overlapping Conform/lsp-zero/
  clangd save hooks. C/C++ and Java use the attached LSP when no external formatter
  is configured. Prettier is preferred for the web files.

Useful additions: `<leader>fg` live grep, `<leader>fb` buffers, `<leader>dk/dj` location
list navigation, `<leader>dq` workspace diagnostics, and `<leader>lf` formatting.
`:FormatToggle` turns format-on-save off/on for the session.

## Layout and future AI tools

| File/directory | Purpose |
| --- | --- |
| `init.lua` | Leader keys and startup order |
| `lua/config/options.lua` | Editor preferences |
| `lua/config/keymaps.lua` | Core shortcuts |
| `lua/config/autocmds.lua` | Yank highlight and diagnostic float |
| `lua/config/lazy.lua` | Plugin manager bootstrap |
| `lua/config/tools.lua` | Language servers, formatters, parser lists |
| `lua/config/lsp.lua` | Native server settings and LSP mappings |
| `lua/plugins/*.lua` | One area of functionality per plugin module |
| `lua/plugins/ai.lua` | Empty extension point for future AI integrations |
| `lazy-lock.json` | Reproducible plugin revisions |

Add future AI specs to `lua/plugins/ai.lua` and use `<leader>z...` for new AI shortcuts;
this avoids delaying or repurposing Harpoon's `<leader>a`. No AI providers, credentials,
or paid subscriptions are required for this configuration.

## Troubleshooting and validation

- `:checkhealth config` checks external prerequisites, including the Java runtime.
- `:Mason` / `:MasonLog` show binary installation status and errors.
- `:checkhealth vim.lsp` / `:LspInfo` show attached servers and root detection.
- `:ConformInfo` shows the formatter selected for the current file.
- `:checkhealth nvim-treesitter` and `:TSUpdate` diagnose/update parsers.
- `:Lazy restore` reinstalls the tested plugin revisions.
- If startup reports `install` is nil in `treesitter.lua`, an older Treesitter API
  is still installed. Run `:Lazy restore nvim-treesitter`, wait until it finishes,
  then fully restart Neovim. Next run `:TSUpdate go` and reopen your Go file.
  Changing the config branch alone does not replace an installed plugin checkout.
  If it persists, inspect `:lua vim.print(vim.api.nvim_get_runtime_file("lua/nvim-treesitter/query_predicates.lua", true))`
  for a legacy Packer copy; the pinned main implementation does not contain that file.
- If `Ctrl-s` freezes your terminal, disable terminal flow control with `stty -ixon`.

For manually managed tools or offline validation, launch with
`nvim --cmd 'let g:auto_install_tools = v:false'` to skip automatic binary/parser
installation (plugins must already be installed). Missing servers then stay disabled
instead of generating errors; restart after installing them manually.

Run the included headless checks from the config directory after installing plugins:

```sh
nvim --headless --cmd 'let g:auto_install_tools = v:false' '+luafile tests/smoke.lua'
nvim --headless --cmd 'let g:auto_install_tools = v:false' '+luafile tests/lsp.lua'
nvim --headless --cmd 'let g:auto_install_tools = v:false' '+luafile tests/treesitter.lua'
```

The smoke check loads every plugin, exercises the preserved keymaps, and checks that
one formatter hook owns saving. The LSP integration check creates disposable projects
and verifies server attachment, requests, and returned diagnostics. It requires the
configured language-server binaries to be installed; it never pretends a missing
server passed. Tests exit nonzero on failure and do not edit your real projects.

To include ESLint and Tailwind project fixtures, prepare temporary web dependencies
and point the test at their `node_modules` directory:

```sh
test_deps=$(mktemp -d)
npm install --prefix "$test_deps" eslint tailwindcss@3 svelte
NVIM_TEST_WEB_DEPS="$test_deps/node_modules" nvim --headless \
  --cmd 'let g:auto_install_tools = v:false' '+luafile tests/lsp.lua'
```

Without that variable the integration test explicitly skips those two project fixtures.
The Compose filetype is registered for `compose.yaml/yml` and `docker-compose.yaml/yml`,
so its server attaches without a manual `:set filetype` command.

