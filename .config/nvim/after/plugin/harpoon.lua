-- Setup Harpoon keybindings
-- Terminal commands

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-a>", mark.add_file, { desc = "[A]dd mark" })
vim.keymap.set("n", "<C-f>", ui.toggle_quick_menu, { desc = "[F]ind files" })

vim.keymap.set("n", "<C-h>", function()
	ui.nav_file(1)
end, { desc = "First file" })
vim.keymap.set("n", "<C-j>", function()
	ui.nav_file(2)
end, { desc = "Second file" })
vim.keymap.set("n", "<C-k>", function()
	ui.nav_file(3)
end, { desc = "Third file" })
vim.keymap.set("n", "<C-l>", function()
	ui.nav_file(4)
end, { desc = "Fourth file" })
