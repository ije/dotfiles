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
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function() vim.cmd.colorscheme("catppuccin") end
  })

  -- Syntax highligher
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end
  })
  use("nvim-treesitter/playground")

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
require("catppuccin").setup({
   transparent_background = true,
   color_overrides = {
		 all = {
       text = "#dddddd",
       lavender = "#dddddd",
       blue = "#B1FCE5",
       sky = "#B1FCE5",
       sapphire = "#B1FCE5",
       teal = "#B1FCE5",
       yellow = "#F6C99F",
       peach = "#F6C99F",
       rosewater = "#F6C99F",
       mauve = "#F6C99F",
       maroon = "#F6C99F",
       pink = "#F6C99F",
     },
   },
   custom_highlights = function(colors)
     local bg = "#101010"
     local gray = "#757575"
     local text = colors.text
     local yellow = colors.yellow 
     return {
       TelescopeNormal = { fg = gray },
       TelescopeSelection = { fg = text },
       TelescopeBorder = { fg = bg },
       StatusLine = { fg = "#cccccc", bg = "#232325" },
       -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
       ['@punctuation'] = { fg = gray0 },
       ['@punctuation.bracket'] = { fg = gray0 },
       ['@punctuation.delimiter'] = { fg = gray0 },
       ['@punctuation.special'] = { fg = gray0 },
       ['@comment'] = { fg = gray },
       ['@comment.documentation'] = { fg = "#757575" },
       ['@keyword'] = { fg = gray },
       ['@keyword.function'] = { fg = gray },
       ['@keyword.coroutine'] = { fg = gray },
       ['@keyword.operator'] = { fg = gray },
       ['@keyword.return'] = { fg = gray },
       ['@include'] = { fg = gray },
       ['@operator'] = { fg = gray },
       ['@label'] = { fg = gray },
       ['@repeat'] = { fg = gray },
       ['@conditional'] = { fg = gray },
       ['@conditional.ternary'] = { fg = gray },
       ['@exception'] = { fg = gray },
       ['@variable.builtin'] = { fg = yellow },
       ['@attribute'] = { fg = text },
       ['@function'] = { fg = text },
       ['@function.call'] = { fg = text },
       ['@variable'] = { fg = text },
       ['@constant'] = { fg = text },
       ['@constant.builtin'] = { fg = yellow },
       ['@field'] = { fg = text },
       ['@property'] = { fg = text },
       ['@method'] = { fg = text },
       ['@parameter'] = { fg = text, style = { "italic" } },
       ['@type'] = { fg = yellow, style = { "italic" } },
       ['@type.builtin'] = { fg = yellow, style = { "italic" } },
     }
    end 
})

-- statueline
local modes = {
  ["n"] = "normal",
  ["no"] = "normal",
  ["v"] = "visual",
  ["V"] = "visual line",
  [""] = "visual block",
  ["s"] = "select",
  ["S"] = "select line",
  [""] = "select block",
  ["i"] = "insert",
  ["ic"] = "insert",
  ["r"] = "replace",
  ["rv"] = "visual replace",
  ["c"] = "command",
  ["cv"] = "vim ex",
  ["ce"] = "ex",
  ["r"] = "prompt",
  ["rm"] = "moar",
  ["r?"] = "confirm",
  ["!"] = "shell",
  ["t"] = "terminal",
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
  return " %p %l:%c "
end
Statusline = {}
Statusline.active = function()
  return table.concat {
    "%#statusline#",
    "%#statuslineaccent#",
    mode(),
    "%#@comment# ",
    filename(),
    "%=%#statuslineextra#",
    lineinfo(),
  }
end
function Statusline.inactive()
  return " %f"
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
  highlight = { enable = true, additional_vim_regex_highlighting = false },
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
    border = "none",
  }
})

local Terminal  = require("toggleterm.terminal").Terminal
local lg_term = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  -- close_on_exit = false,
  direction = "float",
})
function lg_term_toggle() lg_term:toggle() end

-- My commands
vim.api.nvim_create_user_command(
  "Config",
  "e ~/.config/nvim/init.lua",
  {bang = true, desc = "Open init.lua Neovim config"}
)

-- Key bindings
vim.keymap.set({"n", "i", "v"}, "<C-b>", "<Left>", {})
vim.keymap.set({"n", "i", "v"}, "<C-f>", "<Right>", {})

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
vim.keymap.set("n", "<leader>lg", "<cmd>lua lg_term_toggle()<CR>", {})
vim.keymap.set("n", "<leader>c", ":", {})

-- Key bindings (insert)
vim.keymap.set("i", "<C-p>", "<Up>", {})
vim.keymap.set("i", "<C-n>", "<Down>", {})
vim.keymap.set("i", "<C-d>", "<C-o>x", {})
vim.keymap.set("i", "<C-w>", "<C-o>diw", {})
vim.keymap.set("i", "<C-a>", "<C-o>^", {})
vim.keymap.set("i", "<C-e>", "<C-o>$", {})
vim.keymap.set("i", "<C-q>", "<C-[>", {})

-- Key bindings (view)
vim.keymap.set("v", "<C-a>", "^", {})
vim.keymap.set("v", "<C-e>", "$", {})
vim.keymap.set("v", "<Leader>y", '"+y', {})
vim.keymap.set("v", "<Leader>p", '"+p', {})

-- Done
print(":)")
