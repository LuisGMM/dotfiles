require("lspconfig").dartls.setup({
	cmd = { "dart", "language-server", "--protocol=lsp" },
})

require("flutter-tools").setup({}) -- use defaults
