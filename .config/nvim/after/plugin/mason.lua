-- Silenciar warning de deprecación de lspconfig (hasta migrar a vim.lsp.config)
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
	if plugin == 'nvim-lspconfig' then
		return
	end
	return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gT", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},

	-- pylsp = {
	--   pylsp = {
	--     -- configurationSources = {"flake8"},
	--     plugins = {
	--       pycodestyle = {enabled = false},
	--       flake8 = {
	--         -- enabled = true,
	--         -- enabled = true,
	--         enabled = false,
	--         -- ignore = {},
	--         -- maxLineLength = 100,
	--         -- maxComplexity = 10
	--       },
	--       -- mypy = {enabled = true, live_mode = true},
	--       mypy = {enabled = false, live_mode = true},
	--       -- isort = {enabled = true},
	--       isort = {enabled = false},
	--       yapf = {enabled = false},
	--       pylint = {enabled = false},
	--       pydocstyle = {
	--         -- enabled = true,
	--         enabled = false,
	--       --  ignore = {"D100"}
	--       },
	--       pyflakes = { enabled = false },
	--       mccabe = {enabled = false},
	--       preload = {enabled = false},
	--       rope_completion = {enabled = false}
	--     }
	--   }
	-- },
	pyright = {},
	-- pylyzer = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
		},
	},
	-- markdownlint = {},
	marksman = {},
	-- selene = {},
	-- stylua = {},
	bashls = {},

	ts_ls = {},
	eslint = {},
}

-- Setup neovim lua configuration
require("neodev").setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = false,
})

-- Configurar cada servidor manualmente (nueva API de mason-lspconfig)
local lspconfig = require('lspconfig')
for server_name, server_settings in pairs(servers) do
	lspconfig[server_name].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = server_settings,
	})
end

-- Configure flutter tools
-- Because it is not directly supported by Mason, it needs to be directly configured
-- with the same keybinding (on_attach method) and capabilities.
require("flutter-tools").setup({
	lsp = {

		on_attach = on_attach,
		capabilities = capabilities,

		color = { -- show the derived colours for dart variables
			enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
			background = false, -- highlight the background
			background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
			foreground = false, -- highlight the foreground
			virtual_text = true, -- show the highlight using virtual text
			virtual_text_str = "■■■■■", -- the virtual text character to highlight
		},

		statusline = {
			-- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
			-- this will show the current version of the flutter app from the pubspec.yaml file
			app_version = true,
			-- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
			-- this will show the currently running device if an application was started with a specific
			-- device
			device = true,
			-- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
			-- this will show the currently selected project configuration
			project_config = false,
		},
		widget_guides = {
			enabled = true,
		},
		closing_tags = {
			highlight = "ErrorMsg", -- highlight for the closing tag
			prefix = ">", -- character to use for close tag e.g. > Widget
			priority = 10, -- priority of virtual text in current line
			-- consider to configure this when there is a possibility of multiple virtual text items in one line
			-- see `priority` option in |:help nvim_buf_set_extmark| for more info
			enabled = true, -- set to false to disable

			dart = {
				analysisExcludedFolders = {
					-- point at your pub-cache
					vim.fn.expand("~/.pub-cache"),
				},
			},
		},

		settings = {
			enableSnippets = true,
			updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
		},
	},
})

-- Turn on lsp status information
require("fidget").setup()
