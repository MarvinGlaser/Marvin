-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "
-- spawn windows
vim.keymap.set("n", "<M-m>", vim.cmd.split, { desc = "split new window" } )
vim.keymap.set("n", "<M-n>", function()
	vim.cmd.split()
	vim.cmd.terminal()
	vim.cmd.startinsert()
end, { desc = "split new terminal" } )
vim.keymap.set("n", "<C-M-m>", vim.cmd.vsplit, { desc = "vsplit new window" } )
vim.keymap.set("n", "<C-M-n>", function()
	vim.cmd.vsplit()
	vim.cmd.terminal()
	vim.cmd.startinsert()
end, { desc = "split new terminal" } )
-- Move between windows
vim.keymap.set("n", "<M-h>", [[<C-w>h]])
vim.keymap.set("n", "<M-j>", [[<C-w>j]])
vim.keymap.set("n", "<M-k>", [[<C-w>k]])
vim.keymap.set("n", "<M-l>", [[<C-w>l]])
-- Move windows
vim.keymap.set("n", "<C-M-H>", [[<C-w>H]])
vim.keymap.set("n", "<C-M-J>", [[<C-w>J]])
vim.keymap.set("n", "<C-M-K>", [[<C-w>K]])
vim.keymap.set("n", "<C-M-L>", [[<C-w>L]])
-- Move between windows while in terminal
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- Dignostics keybindings
vim.keymap.set("n", "<M-d>", vim.diagnostic.open_float, { desc = "show diagnostic" })
vim.keymap.set("n", "<M-k>", function()
  vim.diagnostic.jump({ count=1 })
end, { desc = "next diagnostic" })
vim.keymap.set("n", "<M-j>", function()
  vim.diagnostic.jump({ count=-1 })
end, { desc = "prev diagnostic" })
vim.keymap.set("n", "<M-f>", function()
  vim.lsp.buf.code_action( {
    context = { only = { "quickfix", "source.organizeImports" } },
    apply = true,
  })
end, { desc = "Quickfix issue" })

--  Telescope keybindings
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "open Telescope file_browser" })
vim.keymap.set("n", "<leader>FF", function()
  require("telescope").extensions.file_browser.file_browser()
end, { desc = "open Telescope file_browser" })

-- Terminal keybindings
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]],  {
  noremap = true, silent = true , desc = "bind Esc to escape terminal mode"
})

-- Goto bindings
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K",  vim.lsp.buf.hover)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Mason core plugin
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason + LSP integration
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "jdtls",
          "ts_ls",
          "bashls",
          "lua_ls",
        },
      })


    end,
  },

  -- LSP support
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },

  -- Git integration
  "tpope/vim-fugitive",
})

vim.lsp.config('rust_analyzer', {
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          check = { command = "clippy" },
        },
      },
})


vim.lsp.config('pyright', {})
vim.lsp.config('ts_ls', {})
vim.lsp.config('jdtls', {})
vim.lsp.config('bashls', {})
vim.lsp.config('lua_ls', {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

