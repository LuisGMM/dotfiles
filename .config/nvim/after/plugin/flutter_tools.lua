require("lspconfig").dartls.setup({
	cmd = { "dart", "language-server", "--protocol=lsp" },
	lsp = {
		settings = {
			enableSnippets = true,
			updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
		},
	},
})

require("flutter-tools").setup({}) -- use defaults
