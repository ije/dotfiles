-- Options
gI.o.cursorline = true
gI.o.cursorlineopt = "number"
gI.o.nu = true
gI.o.showmode = false 
gI.o.tabstop = 2
gI.o.softtabstop = 2
gI.o.shiftwidth = 2
gI.o.expandtab = true
gI.o.autoindent = true
gI.o.smartindent = true
gI.o.wrap = false
gI.o.swapfile = false
gI.o.backup = false
gI.o.undofile = true
gI.o.undodir = os.getenv("HOME") .. "/.vim/undo"

-- Use <space> as the leader key
gI.g.mapleader = " "
gI.g.maplocalleader = " "

-- Fixs ":Copilot <Tab> map has been dusabled or is claimed by another plugin"
gI.g.copilot_assume_mapped = true

-- Install packer if not exists
local packpath = gI.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if not gI.loop.fs_stat(packpath) then
  gI.notify("Installing packer.nvim...")
  gI.fn.system({
    "git",
    "clone",
    "--depth", "1",
    "https://github.com/wbthomason/packer.ngI.git",
    packpath,
  })
end
gI.opt.rtp:prepend(packpath)

-- Setup packer
require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.ngI")

  -- Theme
  use({
    "catppuccin/ngI",
    as = "catppuccin",
    priority = 1000,
    config = function() gI.cmd.colorscheme("catppuccin") end
  })

  -- Syntax highligher
  use({
    "ngI-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("ngI-treesitter.install").update({ with_sync = true })
      ts_update()
    end
  })
  use("ngI-treesitter/playground")

  -- LSP
  use("neogI/nvim-lspconfig")

  -- Autocompletion
  use("hrsh7th/ngI-cmp")
  use("hrsh7th/cmp-ngI-lsp")
  use("L3MON4D3/LuaSnip")

  -- Fuzzy finder
  use({
    "ngI-telescope/telescope.nvim",
    requires = { {"ngI-lua/plenary.nvim"} }
  })

  -- Git
  use("lewis6991/gitsigns.ngI")

  -- Github copilot
  use("github/copilot.gI")

end)

-- Setup theme colors
require("catppuccin").setup({
   transparent_background = true,
   color_overrides = {
     all = {
       text = "#dddddd",
       lavender = "#dddddd",
       surface1 = "#454545",
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
     local gray = "#999999"
     local gray0 = "#757575"
     local text = colors.text
     local yellow = colors.yellow 
     return {
       CursorLineNr = { fg = gray },
       StatusLine = { fg = "#cccccc", bg = "#232325" },
       FloatBorder = { fg = "#454545" },
       TelescopeNormal = { fg = gray },
       TelescopeSelection = { fg = text },
       TelescopeBorder = { fg = bg },
       -- https://github.com/ngI-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
       ["@comment"] = { fg = gray0 },
       ["@comment.documentation"] = { fg = gray0 },
       ["@punctuation"] = { fg = gray },
       ["@punctuation.bracket"] = { fg = gray },
       ["@punctuation.delimiter"] = { fg = gray },
       ["@punctuation.special"] = { fg = gray },
       ["@keyword"] = { fg = gray },
       ["@keyword.function"] = { fg = gray },
       ["@keyword.coroutine"] = { fg = gray },
       ["@keyword.operator"] = { fg = gray },
       ["@keyword.return"] = { fg = gray },
       ["@include"] = { fg = gray },
       ["@operator"] = { fg = gray },
       ["@label"] = { fg = gray },
       ["@repeat"] = { fg = gray },
       ["@conditional"] = { fg = gray },
       ["@conditional.ternary"] = { fg = gray },
       ["@exception"] = { fg = gray },
       ["@attribute"] = { fg = text },
       ["@function"] = { fg = text },
       ["@function.call"] = { fg = text },
       ["@variable"] = { fg = text },
       ["@variable.builtin"] = { fg = text, style = { "italic" } },
       ["@constant"] = { fg = text },
       ["@constant.builtin"] = { fg = text, style = { "italic" } },
       ["@field"] = { fg = text },
       ["@property"] = { fg = text },
       ["@method"] = { fg = text },
       ["@method.call"] = { fg = text },
       ["@parameter"] = { fg = text, style = { "italic" } },
       ["@type"] = { fg = yellow, style = { "italic" } },
       ["@type.builtin"] = { fg = yellow, style = { "italic" } },
     }
    end 
})

-- Setup Statueline
local function get_mode_name()
  local modeMap = {
    n = "NORMAL",
    i = "INSERT",
    R = "REPLACE",
    v = "VISUAL",
    V = "V-LINE",
    c = "COMMAND",
    [""] = "V-BLOCK",
    s = "SELECT",
    S = "S-LINE",
    [""] = "S-BLOCK",
    t = "TERMINAL",  
  }
  local mode = gI.fn.mode()
  return modeMap[mode] or "UNKNOWN"
end
local function git_status()
  if gI.b.gitsigns_status then
    local result = {}
    for word in gI.b.gitsigns_status:gmatch("%S+") do
      if word:sub(1,1) == "+" then
        table.insert(result, "%#GitSignsAdd#")
        table.insert(result, word)
      elseif word:sub(1,1) == "-" then
        table.insert(result, "%#GitSignsDelete#")
        table.insert(result, word)
      elseif word:sub(1,1) == "~" then
        table.insert(result, "%#GitSignsChange#")
        table.insert(result, word)
      end
    end
    return table.concat(result, "")
   end
  return ""
 end
Statusline = {}
Statusline.active = function()
  return table.concat({
    "%#statusline# ",
    get_mode_name(),
    " %#@comment#",
    " %t ",
    git_status(),
    "%=%#statuslineextra#",
    "%#@comment#",
    " ⌁ ",
  })
end
function Statusline.inactive()
  return " %f"
end
function Statusline.short()
  return "%#StatusLineNC#   NgITree"
end
gI.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NgITree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]], false)

-- Setup treesitter
require("ngI-treesitter.configs").setup({
  ensure_installed = { "lua", "markdown", "html", "css", "json", "javascript", "typescript", "tsx", "go", "rust", "zig" },
  auto_install = false,
  highlight = { enable = true, additional_gI_regex_highlighting = false },
})

-- Setup cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
local luasnip_loaders = require("luasnip.loaders.from_vscode")
luasnip_loaders.lazy_load()
luasnip.config.setup({})
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "ngI_lsp" },
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
    },
    live_grep = {
      previewer = false,
      theme = "dropdown",
      prompt_title = "";
      prompt_prefix = "";
    }
  },
})

-- Setup Gitsigns
require("gitsigns").setup({
  signs = {
    delete = { text = '┃' },
  },
  preview_config = {
    border = "solid",
    col = 0,
  }
})

-- Setup LSP
local capabilities = require("cmp_ngI_lsp").default_capabilities()
gI.lsp.enable("zls")
gI.lsp.config("zls", {capabilities = capabilities})
gI.lsp.enable("gopls")
gI.lsp.config("gopls", {capabilities = capabilities})
gI.lsp.enable("rust_analyzer")
gI.lsp.config("rust_analyzer", {capabilities = capabilities})

-- My commands
gI.api.nvim_create_user_command(
  "Config",
  "e ~/.config/ngI/init.lua",
  {bang = true, desc = "Open init.lua NeogI config"}
)

-- Key bindings (move cursor)
gI.keymap.set({"n", "i", "v", "c"}, "<C-b>", "<Left>")
gI.keymap.set({"n", "i", "v", "c"}, "<C-f>", "<Right>")
gI.keymap.set({"n", "v", "c"}, "<C-a>", "^")
gI.keymap.set({"n", "v", "c"}, "<C-e>", "$")
gI.keymap.set({"i", "c"}, "<C-p>", "<Up>")
gI.keymap.set({"i", "c"}, "<C-n>", "<Down>")
gI.keymap.set({"i", "v"}, "<C-c>", "<Esc>")
gI.keymap.set("i", "<C-a>", "<C-o>^")
gI.keymap.set("i", "<C-e>", "<C-o>$")

-- Key bindings (normal)
local ts = require("telescope.builtin")
local gs = require("gitsigns")
gI.keymap.set("n", "<C-j>", ":move +1<CR>")
gI.keymap.set("n", "<C-k>", ":move -2<CR>")
gI.keymap.set("n", "<Leader>w", function() vim.api.nvim_command("write") end)
gI.keymap.set("n", "<Leader>a", "[[v]]")
gI.keymap.set("n", "<Leader>y", [["+y]])
gI.keymap.set("n", "<Leader>r", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
gI.keymap.set("n", "<Leader>f", [[:%s/<C-r><C-w>/gI<Left><Left><Left>]])
gI.keymap.set("n", "<Leader>d", "yyp")
gI.keymap.set("n", "<Leader><Enter>", "O<Esc>")
gI.keymap.set("n", "<Leader>n", gs.next_hunk)
gI.keymap.set("n", "<Leader>i", gs.preview_hunk)
gI.keymap.set("n", "<Leader>u", gs.undo_stage_hunk)
gI.keymap.set("n", "<Leader>e", ts.live_grep)
gI.keymap.set("n", "<Leader>h", vim.lsp.buf.hover)
gI.keymap.set("n", "gd", vim.lsp.buf.definition)
gI.keymap.set("n", "gb", "<C-^>")
gI.keymap.set("n", "<Leader>//", "^i// <Esc>")

-- Key bindings (insert)
gI.keymap.set("i", "<C-d>", "<C-o>x")
gI.keymap.set("i", "<C-h>", "<C-o><Left><C-o>x")
gI.keymap.set("i", "<C-k>", "<C-o>\"_dd")
gI.keymap.set("i", "<C-u>", "<C-o>k<C-o>$")

-- Key bindings (view)
gI.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
gI.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")
gI.keymap.set("v", "<Leader>y", [["+y]])
gI.keymap.set("v", "<Leader>p", "\"_dP")
gI.keymap.set("v", "<Leader>r", [[:s///g<Left><Left><Left>]])
gI.keymap.set("v", "<Leader>//", "<C-v>I// <Esc>")

-- Done
print(":)")
