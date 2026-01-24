-- Gitsigns
require('gitsigns').setup({
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	},
})

-- Stage/reset hunks (mantener estos, son utiles)
vim.keymap.set('n', '<Leader>gs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
vim.keymap.set('n', '<Leader>gr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
vim.keymap.set('n', '<Leader>gu', ':Gitsigns undo_stage_hunk<CR>', { desc = 'Undo stage hunk' })
vim.keymap.set('n', '<Leader>gS', ':Gitsigns stage_buffer<CR>', { desc = 'Stage buffer' })
vim.keymap.set('n', '<Leader>gR', ':Gitsigns reset_buffer<CR>', { desc = 'Reset buffer' })

-- Preview hunk (util para ver que cambiaste)
vim.keymap.set('n', '<Leader>gv', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })

-- Navegacion entre hunks
vim.keymap.set('n', ']g', ':Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '[g', ':Gitsigns prev_hunk<CR>', { desc = 'Prev hunk' })
