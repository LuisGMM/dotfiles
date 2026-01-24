local ok, neogit = pcall(require, 'neogit')
if not ok then
	return
end

neogit.setup({
	integrations = {
		telescope = true,
		diffview = true,
	},
	-- Usar tab para abrir neogit
	kind = 'tab',
	-- Signs en el status buffer
	signs = {
		section = { '>', 'v' },
		item = { '>', 'v' },
	},
})

-- Keymaps
-- Reemplaza <Leader>gg de fugitive
vim.keymap.set('n', '<Leader>gg', function()
	neogit.open()
end, { desc = 'Neogit status' })
vim.keymap.set('n', '<Leader>gc', function()
	neogit.open({ 'commit' })
end, { desc = 'Neogit commit' })
vim.keymap.set('n', '<Leader>gp', function()
	neogit.open({ 'push' })
end, { desc = 'Neogit push' })
vim.keymap.set('n', '<Leader>gl', function()
	neogit.open({ 'log' })
end, { desc = 'Neogit log' })
vim.keymap.set('n', '<Leader>gP', function()
	neogit.open({ 'pull' })
end, { desc = 'Neogit pull' })
