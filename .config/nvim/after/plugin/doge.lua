-- Doge setting to build numpy doc by default
vim.g.doge_doc_standard_python = "numpy"

vim.g.doge_python_settings = {
	single_quotes = 0,
	omit_redundant_param_types = 0,
}

--

-- Keymap to autogenerate docstring
vim.keymap.set("n", "<F3>", ":DogeGenerate numpy<CR>")
