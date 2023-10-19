-- Options
vim.o.nu = true
-- vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install packer if not exists
local packpath = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if not vim.loop.fs_stat(packpath) then
  vim.notify("Installing packer.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--depth", "1",
    "https://github.com/wbthomason/packer.nvim.git",
    packpath,
  })
end
vim.opt.rtp:prepend(packpath)

-- Setup packer
require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- Theme
  use({
    "rose-pine/neovim",
    as = "rose-pine",
    config = function()
      vim.cmd.colorscheme("rose-pine")
    end
  })

  -- Syntax highligher
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end
  })

  -- LSP Support
  use("neovim/nvim-lspconfig")

  -- Autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("L3MON4D3/LuaSnip")

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim", 
    tag = "0.1.4",
    requires = { {"nvim-lua/plenary.nvim"} }
   })
  
  -- Git
  use("lewis6991/gitsigns.nvim")

  -- Term
  use("akinsho/toggleterm.nvim")

end)

local treesitter = require("nvim-treesitter.configs")
local cmp = require("cmp")
local luasnip = require("luasnip")
local luasnip_loader = require("luasnip.loaders.from_vscode")
local lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local rose = require("rose-pine")
local gitsigns = require("gitsigns")
local builtin = require("telescope.builtin")
local toggleterm = require("toggleterm")
local Terminal  = require("toggleterm.terminal").Terminal

-- Setup the theme
rose.setup({
  disable_background = true,
})

-- Setup treesitter
treesitter.setup({
  ensure_installed = { "lua", "javascript", "typescript", "tsx", "rust", "zig", "go" },
  auto_install = false,
  highlight = { enable = true  },
})

-- Setup luasnip for cmp
luasnip_loader.lazy_load()
luasnip.config.setup({})

-- Setup Autocompletion
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete {},
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" }
  }
})

-- Setup Gitsigns 
gitsigns.setup({})

-- Setup LSP
lsp.zls.setup({capabilities = capabilities})

-- Setup toggleterm
toggleterm.setup({
  float_opts = {
      border = "curved",
  }
})

local deno_term = Terminal:new({ cmd = "deno", hidden = true, direction = "float" })
function deno_term_toggle() deno_term:toggle() end
vim.keymap.set("n", "<leader>dn", "<cmd>lua deno_term_toggle()<CR>", {})

-- My commands
vim.api.nvim_create_user_command(
  "Config",
  "e ~/.config/nvim/init.lua",
  {bang = true, desc = "Open init.lua Neovim config"}
)
vim.api.nvim_create_user_command(
  "Zt",
  "!zig test %",
  {bang = true, desc = "Run zig test for current file"}
)

-- Key bindings (normal)
vim.keymap.set("n", "<C-b>", "<Left>", {})
vim.keymap.set("n", "<C-f>", "<Right>", {})
vim.keymap.set("n", "<C-a>", "0", {})
vim.keymap.set("n", "<C-e>", "$", {})
vim.keymap.set("n", "<leader>ff", builtin.git_files, {})
vim.keymap.set("n", "<leader>t", builtin.buffers, {})
vim.keymap.set("n", "<Leader>k", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "<leader>zt", vim.cmd.Zt, {})

-- Key bindings (insert)
vim.keymap.set("i", "<C-b>", "<Left>", {})
vim.keymap.set("i", "<C-f>", "<Right>", {})
vim.keymap.set("i", "<C-p>", "<Up>", {})
vim.keymap.set("i", "<C-n>", "<Down>", {})
vim.keymap.set("i", "<C-d>", "<C-o>l<C-h>", {})
vim.keymap.set("i", "<C-a>", "<C-o>0", {})
vim.keymap.set("i", "<C-e>", "<C-o>$", {})

-- Done
print(":)")
