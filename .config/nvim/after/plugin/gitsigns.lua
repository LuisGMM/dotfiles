-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

-- Git remaps
-- Stage/reset individual hunks under cursor in a file
vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>")
vim.keymap.set("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>")

-- Stage/reset all hunks in a file
vim.keymap.set("n", "<Leader>gS", ":Gitsigns stage_buffer<CR>")
vim.keymap.set("n", "<Leader>gU", ":Gitsigns reset_buffer_index<CR>")
vim.keymap.set("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>")

-- Open git status in interative window (similar to lazygit)
vim.keymap.set("n", "<Leader>gg", ":Git<CR>")

-- Show `git status output`
vim.keymap.set("n", "<Leader>gst", ":Git status<CR>")

-- Open commit window (creates commit after writing and saving commit msg)
vim.keymap.set("n", "<Leader>gc", ":Git commit | startinsert<CR>")

-- Other tools from fugitive
vim.keymap.set("n", "<Leader>gdf", ":Git difftool<CR>")
vim.keymap.set("n", "<Leader>gm", ":Git mergetool<CR>")
vim.keymap.set("n", "<Leader>g|", ":Gvdiffsplit<CR>")
vim.keymap.set("n", "<Leader>g_", ":Gdiffsplit<CR>")
