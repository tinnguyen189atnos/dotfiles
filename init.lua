local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  { 
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.o.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
    end
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { "<C-b>", "<cmd>Neotree toggle position=float<cr>", desc = "NeoTree" },
      { "<C-f>", "<cmd>Neotree float reveal_file=%:p<cr>", desc = "NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
	window = {
		mappings = {
			["<C-t>"] = "open_tabnew",
		},
	}
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    config = function()
      local builtin = require("telescope.builtin")
      local type_filter_map = {
        javascript = "js",
	python = "py",
      }
      vim.keymap.set("n", "ff", builtin.find_files)
      vim.keymap.set("n", "fb", builtin.buffers)
      vim.keymap.set("n", "fg", builtin.live_grep)
      vim.keymap.set("n", "tfg", function()
        local type_filter = vim.bo.filetype
	type_filter = type_filter_map[type_filter] or type_filter
	if string.len(type_filter) <= 0 then
	  -- builtin.live_grep()
	  vim.notify("No file type detected", 1)
	else
	  builtin.live_grep({ type_filter = type_filter, prompt_title = "Grep " .. type_filter })
	end
      end)
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
	    require('gitsigns').setup({
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
  end
})
    end
  },

  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
    config = function() require('Comment').setup() end,
  },

  { "github/copilot.vim" }
}, {})

 if vim.fn.has('wsl') == 1 then
 	vim.g.clipboard = {
 		name = "WslClipboard",
 		copy = { ["+"] = { "clip.exe" },["*"] = { "clip.exe" } },
 		paste = {
 			    ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
 			    ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
 		},
 	}
 end

local keymap = vim.keymap
keymap.set("n", "<C-a>", "<C-Home>V<C-End>")
keymap.set("i", "<C-a>", "<Esc><C-Home>V<C-End>")
keymap.set("v", "<C-a>", "<Esc><C-Home>V<C-End>")

keymap.set("v", "<C-c>", "\"+y")

keymap.set("n", "<A-Down>", ":m .+1<CR>==")
keymap.set("n", "<A-Up>", ":m .-2<CR>==")
keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")

keymap.set("n", "<A-Right>", ":tabnext <CR>")
keymap.set("n", "<A-Left>", ":tabprevious <CR>")
keymap.set("i", "<A-Right>", "<Esc>:tabnext <CR>")
keymap.set("i", "<A-Left>", "<Esc>:tabprevious <CR>")

vim.cmd([[
	autocmd FileType xml setlocal shiftwidth=4 tabstop=4 expandtab foldmethod=indent 
	autocmd FileType py foldmethod=syntax 
]])
