-- Detectar si estamos en un worktree
local function worktree_info()
	local cwd = vim.fn.getcwd()
	-- Buscar TID-XXX en el path del directorio actual
	local task_id = cwd:match('/worktrees/(TID%-[^/]+)')
	if task_id then
		return '[' .. task_id .. ']'
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
