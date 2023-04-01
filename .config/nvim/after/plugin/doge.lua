-- Doge setting to build numpy doc by default
vim.g.doge_doc_standard_python = "numpy"
--

-- Keymap to autogenerate docstring
vim.keymap.set("n", "<F3>", ":DogeGenerate numpy<CR>")
