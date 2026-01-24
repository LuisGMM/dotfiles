local ok, diffview = pcall(require, 'diffview')
if not ok then
	return
end

diffview.setup({
	use_icons = false, -- Consistente con tu config (icons_enabled = false)
	keymaps = {
		view = {
			{ 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
		},
		file_panel = {
			{ 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
		},
		file_history_panel = {
			{ 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
		},
	},
})

-- Keymaps
vim.keymap.set('n', '<Leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Diffview: open diff' })
vim.keymap.set('n', '<Leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'Diffview: file history' })
vim.keymap.set('n', '<Leader>gH', '<cmd>DiffviewFileHistory<CR>', { desc = 'Diffview: branch history' })
vim.keymap.set('n', '<Leader>gq', '<cmd>DiffviewClose<CR>', { desc = 'Diffview: close' })
