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
	vim.schedule(function()
		pcall(vim.cmd, 'Gitsigns refresh')
	end)
end)

-- Hook al borrar worktree
Hooks.register(Hooks.type.DELETE, function()
	vim.cmd(config.update_on_change_command)
	vim.schedule(function()
		pcall(vim.cmd, 'Gitsigns refresh')
	end)
end)

-- Keymaps
-- Custom worktree picker con keybinds que no conflictúan con i3 (Alt es el mod de i3)
vim.keymap.set('n', '<Leader>wt', function()
	local pickers = require('telescope.pickers')
	local finders = require('telescope.finders')
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local action_set = require('telescope.actions.set')
	local conf = require('telescope.config').values
	local utils = require('telescope.utils')
	local strings = require('plenary.strings')
	local git_worktree = require('git-worktree')

	local output = utils.get_os_command_output { 'git', 'worktree', 'list' }
	local results = {}
	local widths = { path = 0, sha = 0, branch = 0 }

	for _, line in ipairs(output) do
		local fields = vim.split(string.gsub(line, '%s+', ' '), ' ')
		local entry = { path = fields[1], sha = fields[2], branch = fields[3] }
		if entry.sha ~= '(bare)' then
			for key, val in pairs(widths) do
				widths[key] = math.max(val, strings.strdisplaywidth(entry[key] or ''))
			end
			table.insert(results, entry)
		end
	end

	local displayer = require('telescope.pickers.entry_display').create {
		separator = ' ',
		items = { { width = widths.branch }, { width = widths.path }, { width = widths.sha } },
	}

	pickers.new({}, {
		prompt_title = 'Git Worktrees',
		finder = finders.new_table {
			results = results,
			entry_maker = function(entry)
				entry.value = entry.branch
				entry.ordinal = entry.branch
				entry.display = function(e)
					return displayer {
						{ e.branch, 'TelescopeResultsIdentifier' },
						{ e.path },
						{ e.sha },
					}
				end
				return entry
			end,
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(_, map)
			-- Enter: switch worktree
			action_set.select:replace(function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection == nil then return end
				actions.close(prompt_bufnr)
				git_worktree.switch_worktree(selection.path)
			end)
			-- C-d: delete worktree (en lugar de M-d que conflictúa con i3)
			map({ 'i', 'n' }, '<C-d>', function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection == nil then return end
				local confirmed = vim.fn.input('Delete worktree ' .. selection.branch .. '? [y/n]: ')
				if string.lower(confirmed):sub(1, 1) ~= 'y' then
					print(' Cancelled')
					return
				end
				actions.close(prompt_bufnr)
				git_worktree.switch_worktree(nil) -- Cambiar al main antes de borrar
				git_worktree.delete_worktree(selection.path, false, {
					on_failure = function() print('Deletion failed') end,
					on_success = function() print('Worktree deleted') end,
				})
			end)
			-- C-n: create worktree (en lugar de M-c)
			map({ 'i', 'n' }, '<C-n>', function()
				telescope.extensions.git_worktree.create_git_worktree()
			end)
			return true
		end,
	}):find()
end, { desc = 'Switch worktree (C-d=delete, C-n=create)' })

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
