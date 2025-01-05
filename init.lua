local keymap = vim.keymap
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
  { "nvim-treesitter/nvim-treesitter" ,
    config = function()
      require("nvim-treesitter.configs").setup({
	highlight = {
	  enable = true,
	},
	indent = {
	  enable = true,
	},
      })
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  },
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
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
      -- some shorthands...
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local l = require("luasnip.extras").lambda
      local rep = require("luasnip.extras").rep
      local p = require("luasnip.extras").partial
      local m = require("luasnip.extras").match
      local n = require("luasnip.extras").nonempty
      local dl = require("luasnip.extras").dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local types = require("luasnip.util.types")
      local conds = require("luasnip.extras.conditions")
      local conds_expand = require("luasnip.extras.conditions.expand")
      
      
      -- Adjusted Odoo XML view snippet
      ls.add_snippets("xml", {
          s("odoo", fmt([[
      <?xml version="1.0" encoding="UTF-8"?>
      <odoo>
      
      </odoo>
          ]], {})),
          s("view", fmt([[
      <record id="{}" model="ir.ui.view">
          <field name="name">{}</field>
          <field name="model">{}</field>
          <field name="arch" type="xml">
          	
          </field>
      </record>
          ]], {
              i(1, "view_id"),            -- Placeholder for the record ID
              i(2, "view.name"),          -- Placeholder for the view name
              i(3, "model.name"),         -- Placeholder for the model name
          })),
          s("form", fmt([[
      <form string="{}">
          <header/>
          <sheet>
              <div class="oe_button_box" name="button_box"/>
          </sheet>
      </form>
          ]], {
              i(1, "Form Name"),            -- Placeholder for the record ID
          })),
          s("tree", fmt([[
      <tree string="{}">
      </tree>
          ]], {
              i(1, "Tree Name"),            -- Placeholder for the record ID
          })),
          s("inherit", fmt([[
      <field name="inherit_id" ref="{}"/>
          ]], {
      	i(1, "Inherit ID"),            -- Placeholder for the record ID
          })),
          s("xpath", fmt([[
      <xpath expr="{}" position="{}">
      
      </xpath>
          ]], {
      	i(1, "XPath Expression"),            -- Placeholder for the record ID
      	i(2, "Position"),            -- Placeholder for the record ID
          })),
          s("field", fmt([[
      <field name="{}"/>
          ]], {
      	i(1, "Field Name"),            -- Placeholder for the record ID
          })),
      })
      
      ls.add_snippets("python", {
          s("odoo", fmt([[
      import logging
      
      from odoo import models, fields, api
      
      _logger = logging.getLogger(__name__)
          ]], {})),
          s("m", fmt([[
      class {}(models.Model):
          _name = '{}'
          ]], {
      	i(1, "Model Name"),            -- Placeholder for the record ID
      	i(2, "Model Name"),            -- Placeholder for the record ID
          })),
          s("f", fmt([[
      {} = fields.{}(
          ]], {
      	i(1, "Field Name"),            -- Placeholder for the record ID
      	c(2, {
      	    t("Char"),
      	    t("Integer"),
      	    t("Float"),
      	    t("Boolean"),
      	    t("Date"),
      	    t("Datetime"),
      	    t("Selection"),
      	    t("Many2one"),
      	    t("One2many"),
      	    t("Many2many"),
      	}),	-- Placeholder for the record ID
          })),
	  s("compute", fmt([[
      @api.depends({})
      def _compute_{}(self):
          pass
	  ]], {
      	    i(1, "Field Name"),            -- Placeholder for the record ID
      	    i(2, "Compute Method Name"),            -- Placeholder for the record ID
	  })),
	  s("selection", fmt([[
      {} = fields.Selection([
      ], string='{}')
	  ]], {
      	    i(1, "Field Name"),            -- Placeholder for the record ID
      	    i(2, "Field Label"),            -- Placeholder for the record ID
	  })),
	  s("m2o", fmt([[
      {} = fields.Many2one('{}', string='{}')
	  ]], {
      	    i(1, "Field Name"),            -- Placeholder for the record ID
      	    i(2, "Model Name"),            -- Placeholder for the record ID
	    i(3, "Field Label"),            -- Placeholder for the record ID
	  })),
	  s("o2m", fmt([[
      {} = fields.One2many('{}', '{}', string='{}')
	  ]], {
      	    i(1, "Field Name"),            -- Placeholder for the record ID
      	    i(2, "Model Name"),            -- Placeholder for the record ID
	    i(3, "Comodel Name"),            -- Placeholder for the record ID
	    i(4, "Field Label"),            -- Placeholder for the record ID
	  })),
	  s("m2m", fmt([[
      {} = fields.Many2many('{}', string='{}')
	  ]], {
      	    i(1, "Field Name"),            -- Placeholder for the record ID
      	    i(2, "Model Name"),            -- Placeholder for the record ID
	    i(3, "Field Label"),            -- Placeholder for the record ID
	  })),
      })
      vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
      vim.keymap.set("i", "<C-Space>", function() 
        if ls.expand_or_jumpable() then 
          ls.expand_or_jump() 
        end 
      end, {silent = true})
      
      vim.keymap.set({"i", "s"}, "<C-E>", function()
      	if ls.choice_active() then
      		ls.change_choice(1)
      	end
      end, {silent = true})
      	end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    config = function()
      local builtin = require("telescope.builtin")
      keymap.set("n", "ff", builtin.find_files)
      keymap.set("n", "fb", builtin.buffers)
      keymap.set("n", "fg", builtin.live_grep)
      local function get_current_file_extension()
        local filename = vim.fn.expand("%:t") -- Get current file name
        return filename:match("^.+%.(.+)$")  -- Extract extension from file name
      end
      
      -- Function to grep files by extension
      local function grep_by_extension(extension)
        require('telescope.builtin').live_grep({
          prompt_title = "Grep for *." .. extension,
	  type_filter = extension,
        })
      end
      
      -- Create custom :Tfg command
      vim.api.nvim_create_user_command('Tfg', function(args)
        local ext = args.args
      
        -- If no argument is provided, get the current buffer's extension
        if ext == "" then
          ext = get_current_file_extension()
          if not ext then
            vim.notify("No file extension detected in the current buffer!", vim.log.levels.ERROR)
            return
          end
        end
      
        -- Run grep by the detected or provided extension
        grep_by_extension(ext)
      end, { nargs = "?" })  -- nargs=? means zero or one argument can be passed
      -- Replace the old tfg keymap with this function
      keymap.set("n", "tfg", function()
        local ext = get_current_file_extension()
        if ext then
          grep_by_extension(ext)
        else
          vim.notify("No file extension detected in the current buffer!", vim.log.levels.ERROR)
        end
      end, { noremap = true, silent = true })
      
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

keymap.set("n", "<C-a>", "<C-Home>V<C-End>")
keymap.set("i", "<C-a>", "<Esc><C-Home>V<C-End>")
keymap.set("v", "<C-a>", "<Esc><C-Home>V<C-End>")

keymap.set("v", "<C-c>", "\"+y")
keymap.set("v", "<C-s>", "\"+y")

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
  autocmd FileType xml setlocal shiftwidth=4 tabstop=4
  " autocmd FileType python setlocal foldmethod=indent
  " autocmd FileType javascript setlocal foldmethod=indent
]])

-- Auto-save on insert leave
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   pattern = "*",
--   command = "silent! write",
-- })
