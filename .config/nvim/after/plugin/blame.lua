require("blame").setup({
	mappings = {
		commit_info = "K", -- Open commit info with Shift+k
		stack_push = "<BS>", -- Push current state with the Tab key
		stack_pop = "<Del>", -- Pop the state with the Delete (supress) key
		show_commit = "<CR>", -- Keep default mapping for showing full commit info
		close = { "<esc>", "q" },
	},
	-- You can include any additional configuration options here
	-- For example:
	-- date_format = "%d.%m.%Y",
	-- virtual_style = "right_align",
	-- etc.
})

-- Optional: Map a keybinding to toggle the blame window.
vim.api.nvim_set_keymap('n', '<leader>gB', ':BlameToggle<CR>', { noremap = true, silent = true, desc = 'Toggle blame' })
