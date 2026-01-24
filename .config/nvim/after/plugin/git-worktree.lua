local ok, _ = pcall(require, 'git-worktree')
if not ok then
	return
end

local telescope = require('telescope')

-- Cargar extension de telescope
telescope.load_extension('git_worktree')

-- Registrar hooks para mejor UX
local Hooks = require('git-worktree.hooks')
local config = require('git-worktree.config')

-- Hook al cambiar de worktree: actualiza el buffer actual
Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
	vim.notify('Switched to worktree: ' .. path)
	Hooks.builtins.update_current_buffer_on_switch(path, prev_path)
end)

-- Hook al borrar worktree
Hooks.register(Hooks.type.DELETE, function()
	vim.cmd(config.update_on_change_command)
end)

-- Keymaps
vim.keymap.set('n', '<Leader>wt', function()
	telescope.extensions.git_worktree.git_worktree()
end, { desc = 'Switch worktree' })

-- Create worktree: select branch -> creates in /media/luis/exOS/GitHub/worktrees/<branch>/backend
local function create_worktree_custom()
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local git_worktree = require('git-worktree')

	local worktree_base = '/media/luis/exOS/GitHub/worktrees'

	require('telescope.builtin').git_branches({
		attach_mappings = function(_, map)
			-- Crear rama nueva con C-n
			map({ 'i', 'n' }, '<C-n>', actions.git_create_branch)

			-- Enter: crear worktree con la rama seleccionada/escrita
			actions.select_default:replace(function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local current_line = action_state.get_current_line()
				actions.close(prompt_bufnr)

				local branch = selection and selection.value or current_line
				if not branch or branch == '' then
					vim.notify('No branch selected', vim.log.levels.ERROR)
					return
				end

				-- Limpiar nombre de rama (quitar origin/, espacios, etc)
				branch = branch:gsub('^origin/', ''):gsub('^remotes/origin/', ''):gsub('%s+', '')

				local worktree_path = worktree_base .. '/' .. branch .. '/backend'

				-- Verificar si ya existe
				if vim.fn.isdirectory(worktree_path) == 1 then
					vim.notify('Worktree already exists: ' .. worktree_path, vim.log.levels.WARN)
					return
				end

				-- Crear directorio padre si no existe
				vim.fn.mkdir(worktree_base .. '/' .. branch, 'p')

				-- Crear worktree
				git_worktree.create_worktree(worktree_path, branch)
				vim.notify('Creating worktree: ' .. worktree_path)
			end)
			return true
		end,
	})
end

vim.keymap.set('n', '<Leader>wc', create_worktree_custom, { desc = 'Create worktree' })

-- Branches con Telescope builtin + crear ramas con <C-n>
vim.keymap.set('n', '<Leader>gb', function()
	local actions = require('telescope.actions')
	require('telescope.builtin').git_branches({
		attach_mappings = function(_, map)
			-- <C-n> para crear rama nueva con el texto escrito
			map({ 'i', 'n' }, '<C-n>', actions.git_create_branch)
			return true
		end,
	})
end, { desc = 'Git branches (Enter=checkout, C-n=create)' })
