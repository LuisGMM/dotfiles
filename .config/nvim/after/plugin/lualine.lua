-- Detectar si estamos en un worktree
local function worktree_info()
	local cwd = vim.fn.getcwd()
	-- Detectar cualquier worktree en /worktrees/
	local worktree_name = cwd:match('/worktrees/([^/]+)')
	if worktree_name then
		return '[' .. worktree_name .. ']'
	end
	return ''
end

require('lualine').setup({
	options = {
		icons_enabled = false,
		theme = 'onedark',
		component_separators = '|',
		section_separators = '',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', worktree_info },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
})
