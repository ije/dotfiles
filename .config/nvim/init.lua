-- Options
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.nu = true
vim.o.showmode = false 
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fixs ":Copilot <Tab> map has been dusabled or is claimed by another plugin"
vim.g.copilot_assume_mapped = true

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

  -- Harpoon
  use("theprimeagen/harpoon")

  -- Github copilot
  use("github/copilot.vim")

end)

-- Setup the theme colors
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
       -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
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

-- Setup the Statueline
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
  local mode = vim.fn.mode()
  return modeMap[mode] or "UNKNOWN"
end
local function git_status()
  if vim.b.gitsigns_status then
    local result = {}
    for word in vim.b.gitsigns_status:gmatch("%S+") do
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
    " ⌁ ",
    "%#@comment#",
    " Copilot",
  })
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
  ensure_installed = { "lua", "markdown", "html", "css", "json", "javascript", "typescript", "tsx", "go", "rust", "zig" },
  auto_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
})

-- Setup cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
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
local lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lsp.zls.setup({capabilities = capabilities})
lsp.denols.setup({capabilities = capabilities})

-- Setup terminals
require("toggleterm").setup({size = vim.o.columns * 0.4})

local Terminal  = require("toggleterm.terminal").Terminal
local lg_term = Terminal:new({
  cmd = "lazygit",
  hidden = true,
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
vim.keymap.set({"n", "i", "v", "c"}, "<C-b>", "<Left>")
vim.keymap.set({"n", "i", "v", "c"}, "<C-f>", "<Right>")
vim.keymap.set({"n", "v", "c"}, "<C-a>", "^")
vim.keymap.set({"n", "v", "c"}, "<C-e>", "$")
vim.keymap.set({"n", "v"}, "<C-u>", "10kzz")
vim.keymap.set({"n", "v"}, "<C-d>", "10jzz")

-- Key bindings (normal)
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local ts = require("telescope.builtin")
local gs = require("gitsigns")
function list_files()
  if vim.b.gitsigns_head or vim.g.gitsigns_head then
    ts.git_files()
  else 
    ts.find_files()
  end
end
vim.keymap.set("n", "<C-c>", ":q<CR>")
vim.keymap.set("n", "<Leader>v", "<C-v>")
vim.keymap.set("n", "J", ":move +1<CR>")
vim.keymap.set("n", "K", ":move -2<CR>")
vim.keymap.set("n", "<C-j>", ":move +1<CR>")
vim.keymap.set("n", "<C-k>", ":move -2<CR>")
vim.keymap.set("n", "<Leader>fs", function() vim.api.nvim_command("write") end)
vim.keymap.set("n", "<Leader>a", "[[v]]")
vim.keymap.set("n", "<Leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<Leader>s", [[:%s///g<Left><Left><Left>]])
vim.keymap.set("n", "<Leader>d", "yyp")
vim.keymap.set("n", "<Leader><Enter>", "O<Esc>")
vim.keymap.set("n", "<Leader>G", lg_term_toggle)
vim.keymap.set("n", "<Leader>n", gs.next_hunk)
vim.keymap.set("n", "<Leader>i", gs.preview_hunk)
vim.keymap.set("n", "<Leader>u", gs.undo_stage_hunk)
vim.keymap.set("n", "<Leader>ff", list_files)
vim.keymap.set("n", "<Leader>t", ts.buffers)
vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover)
vim.keymap.set("n", "<Leader>g", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>e", ui.toggle_quick_menu)
vim.keymap.set("n", "<Leader>m", mark.add_file)
vim.keymap.set("n", "<Leader>j", function() ui.nav_file(1) end)
vim.keymap.set("n", "<Leader>k", function() ui.nav_file(2) end)
vim.keymap.set("n", "<Leader>l", function() ui.nav_file(3) end)
vim.keymap.set("n", "<Leader>;", function() ui.nav_file(4) end)
vim.keymap.set("n", "<Leader>//", "^i// <Esc>")
vim.keymap.set("n", "<Leader>\\\\", "^df ")
vim.keymap.set("n", "<Leader>wo", "<C-w>o")
vim.keymap.set("n", "<C-t>", ":TermExec cmd='zig test %' direction='vertical'<CR>")

-- Key bindings (insert)
vim.keymap.set("i", "<C-p>", "<Up>")
vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-d>", "<C-o>x")
vim.keymap.set("i", "<C-w>", "<C-o>diw")
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-k>", "<C-o>\"_dd")
vim.keymap.set("i", "<C-u>", "<C-o>k<C-o>$")

-- Key bindings (view)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<Leader>y", [["+y]])
vim.keymap.set("v", "<Leader>p", "\"_dP")
vim.keymap.set("v", "<Leader>s", [[:s///g<Left><Left><Left>]])
vim.keymap.set("v", "<Leader>//", "<C-v>I// <Esc>")
vim.keymap.set("v", "<Leader>\\\\", "<C-v>I<C-o>df <Esc>")

-- Done
print(":)")
