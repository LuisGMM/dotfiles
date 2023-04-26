-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd.packadd("packer.nvim")

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
local vim = vim
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	use({ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
	})

	-- A completion plugin for neovim coded in Lua.
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			-- nvim-cmp source for neovim builtin LSP client
			"hrsh7th/cmp-nvim-lsp",
			-- nvim-cmp source for nvim lua
			"hrsh7th/cmp-nvim-lua",
			-- nvim-cmp source for buffer words
			"hrsh7th/cmp-buffer",
			-- nvim-cmp source for filesystem paths
			"hrsh7th/cmp-path",
			-- nvim-cmp source for math calculation
			"hrsh7th/cmp-calc",

			"L3MON4D3/LuaSnip",
			-- LuaSnip completion source for nvim-cmp
			"saadparwaiz1/cmp_luasnip",
		},
		-- config = [[ require('plugins.cmp') ]]
	})

	-- Snippet Engine for Neovim written in Lua.
	use({
		"L3MON4D3/LuaSnip",
		requires = {
			-- Snippets collection for a set of different programming languages for faster development
			"rafamadriz/friendly-snippets",
		},
		-- config = [[ require('plugins.luasnip') ]]
	})

	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Git related plugins
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("lewis6991/gitsigns.nvim")

	use("navarasu/onedark.nvim") -- Theme inspired by Atom
	use("nvim-lualine/lualine.nvim") -- Fancier statusline
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically

	-- Harpoon. Navigation|terminal/file switching.
	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")
	use("mbbill/undotree")
	use("ThePrimeagen/vim-be-good")

	-- DoGe. docstring generation
	use({
		"kkoomen/vim-doge",
		run = ":call doge#install()",
	})

	-- markdown preview in browser.
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- Auto close parentheses and repeat by dot dot dot ...
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- ale linter
	use({
		"dense-analysis/ale",
		-- config = vim.cmd([[
		--         runtime 'lua/plugins/ale.rc.vim'
		--         ]])
	})

	-- highlight your todo comments in different styles
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
				-- configuration comes here
				-- or leave it empty to use the default setting
			})
		end,
	})

	use("xiyaowong/nvim-transparent")
	-- Fuzzy Finder (files, lsp, etc)
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})
