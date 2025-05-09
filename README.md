# 🌟 My Neovim Configuration

Welcome to my personalized Neovim setup! This configuration is built with modern plugins,
performance in mind, and focused support for multiple programming languages with useful IDE-like
features.

## ✨ Features

- Fast startup and lazy-loading with [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP integration and auto-completion with [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- Debugging support with [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- Syntax highlighting via [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Integrated terminal and REPL support
- Notebook-like workflows and visual output

## 🧠 Language Support

### 🐍 Python
- LSP: `pyright`
- Formatter: `black`, `isort`
- Debugger: `debugpy`
- Jupyter notebook support via `.ipynb` files using [magma-nvim](https://github.com/dccsillag/magma-nvim)

### 📊 R
- Full REPL and interactive support via [R.nvim](https://github.com/R-nvim/R.nvim)
- Chunk sending, knitting (RMarkdown/Quarto), and object viewing
- Custom keymaps with `user_maps_only = true`

### 💻 C
- LSP: `clangd`
- Formatter: `clang-format`
- Debugger: `lldb`/`gdb` via `nvim-dap`

### ☕ Java
- LSP: `jdtls` with full language features (code actions, refactoring)
- Debug support (optional setup with `java-debug` and `nvim-dap`)

### 📄 LaTeX
- Plugin: `vimtex`
- PDF sync via `zathura` or `Skim`
- Autocompletion, live compilation

### 📓 Jupyter Notebooks (`.ipynb`)
- Interactive cells and outputs with `magma-nvim`
- Compatible with Python and R cells
- Inline plotting and evaluation

### 🌀 Lua
- LSP: `lua-language-server`
- Formatter: `stylua`
- Treesitter support for better highlighting and folding

### 🦀 Rust
- LSP: `rust-analyzer`
- Plugin: `rust-tools.nvim` for inlay hints, cargo commands
- Debugging: `lldb-vscode` via `nvim-dap`

## 🗝️ Keybindings

Custom leader bindings (`<leader>`) and filetype-specific mappings for:
- Code evaluation
- File running/building
- Terminal toggles
- R chunk execution and data inspection

## 🚀 Getting Started

1. Clone this repo into your Neovim config path:

```sh
git clone https://github.com/KylesCorner/nvim ~/.config/nvim
```
