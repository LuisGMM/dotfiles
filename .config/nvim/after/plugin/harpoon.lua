-- Setup Harpoon keybindings
-- Terminal commands

--[[ local harpoon = require("harpoon") ]]
--[[]]
--[[ harpoon:setup({}) ]]
--[[]]
--[[ -- Keymaps for adding files and toggling the menu ]]
--[[ vim.keymap.set("n", "<C-a>", function() ]]
--[[ 	harpoon:list():add() ]]
--[[ end, { desc = "[A]dd mark" }) ]]
--[[]]
--[[ vim.keymap.set("n", "<C-f>", function() ]]
--[[ 	harpoon.ui:toggle_quick_menu(harpoon:list()) ]]
--[[ end, { desc = "[F]ind files" }) ]]
--[[]]
--[[ -- Keymaps for selecting files ]]
--[[ vim.keymap.set("n", "<C-h>", function() ]]
--[[ 	harpoon:list():select(1) ]]
--[[ end) ]]
--[[ vim.keymap.set("n", "<C-j>", function() ]]
--[[ 	harpoon:list():select(2) ]]
--[[ end) ]]
--[[ vim.keymap.set("n", "<C-k>", function() ]]
--[[ 	harpoon:list():select(3) ]]
--[[ end) ]]
--[[ vim.keymap.set("n", "<C-l>", function() ]]
--[[ 	harpoon:list():select(4) ]]
--[[ end) ]]

-- Set transparent background for floating windows
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })

-- Setup Harpoon keybindings
local harpoon = require("harpoon")

-- Custom key function: use git remote URL so all worktrees share marks
-- Falls back to cwd if not in a git repo
local function get_project_key()
	-- Try to get the git remote URL (consistent across worktrees)
	local remote = vim.fn.system('git config --get remote.origin.url 2>/dev/null'):gsub('\n', '')
	if remote ~= '' then
		-- Normalize: extract repo name from URL
		-- Handles: git@github.com:user/repo.git, https://github.com/user/repo.git
		local repo = remote:match('/([^/]+)%.git$') or remote:match(':([^/]+/[^/]+)%.git$') or remote
		return repo
	end
	-- Fallback to cwd
	return vim.uv.cwd()
end

harpoon:setup({
	settings = {
		key = get_project_key,
	},
})

-- Keymaps for adding files and toggling the menu
vim.keymap.set("n", "<C-s>", function()
	harpoon:list():add()
end, { desc = "[S]ave mark" })

vim.keymap.set("n", "<C-f>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "[F]ind files" })

-- Keymaps for selecting files
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-j>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-k>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-l>", function()
	harpoon:list():select(4)
end)

local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
