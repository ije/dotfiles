-- Options
vim.o.nu = true
-- vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.showmode = false 
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
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight") end
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

-- Setup the theme
require("tokyonight").setup({
  transparent = true,
  on_highlights = function(hl, c)
    hl.TelescopeNormal = {
      bg = "NONE",
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = "NONE",
      fg = "#181824",  -- Same as termnal background color
    }
    hl.TelescopeSelection = {
      bg = "NONE",
      fg = "#eeeeee",
    }
  end,
})

-- Statueline
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end
local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
      return ""
  end
  return fname .. " "
end
local function filetype()
  return string.format(" %s ", vim.bo.filetype):upper()
end
local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c "
end
Statusline = {}
Statusline.active = function()
  return table.concat {
    "%#Statusline#",
    "%#StatusLineAccent#",
    mode(),
    "%#Normal# ",
    filename(),
    "%=%#StatusLineExtra#",
    lineinfo(),
  }
end
function Statusline.inactive()
  return " %F"
end
function Statusline.short()
  return "%#StatusLineNC#   NvimTree"
end
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)

-- Setup treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "javascript", "typescript", "tsx", "rust", "zig", "go" },
  auto_install = false,
  highlight = { enable = true  },
})

-- Setup luasnip for cmp
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").config.setup({})

-- Setup cmp
local cmp = require("cmp")
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

-- Setup telescope
require("telescope").setup({
  pickers = {
    buffers = {
      previewer = false,
      theme = "dropdown",
      prompt_title = "";
      prompt_prefix = "";
    },
    git_files = {
      previewer = false,
      theme = "dropdown",
      prompt_title = "";
      prompt_prefix = "";
    }
  },
})

-- Setup Gitsigns
require("gitsigns").setup({})

-- Setup LSP
local lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lsp.zls.setup({capabilities = capabilities})
lsp.denols.setup({capabilities = capabilities})

-- Setup toggleterm
require("toggleterm").setup({
  float_opts = {
    border = "solid",
  }
})

local Terminal  = require("toggleterm.terminal").Terminal
local deno_term = Terminal:new({
  cmd = "deno",
  hidden = true,
  -- close_on_exit = false,
  direction = "float",
})
function deno_term_toggle() deno_term:toggle() end

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
vim.keymap.set("n", "<C-a>", "^", {})
vim.keymap.set("n", "<C-e>", "$", {})
vim.keymap.set("n", "<leader>fs", "<cmd>lua vim.api.nvim_command('write')<CR>", {})
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").git_files, {})
vim.keymap.set("n", "<leader>t", require("telescope.builtin").buffers, {})
vim.keymap.set("n", "<Leader>k", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<Leader>g", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<Leader>G", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "<leader>zt", vim.cmd.Zt, {})
vim.keymap.set("n", "<leader>dn", "<cmd>lua deno_term_toggle()<CR>", {})

-- Key bindings (insert)
vim.keymap.set("i", "<C-b>", "<Left>", {})
vim.keymap.set("i", "<C-f>", "<Right>", {})
vim.keymap.set("i", "<C-p>", "<Up>", {})
vim.keymap.set("i", "<C-n>", "<Down>", {})
vim.keymap.set("i", "<C-d>", "<C-o>x", {})
vim.keymap.set("i", "<C-w>", "<C-o>diw", {})
vim.keymap.set("i", "<C-a>", "<C-o>^", {})
vim.keymap.set("i", "<C-e>", "<C-o>$", {})

-- Key bindings (view)
vim.keymap.set("v", "<C-a>", "^", {})
vim.keymap.set("v", "<C-e>", "$", {})
vim.keymap.set("v", "<Leader>sp", '"+y', {})

-- Done
print(":)")
