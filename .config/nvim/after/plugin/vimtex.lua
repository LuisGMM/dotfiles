-- Vimtex config
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_enabled = 1

vim.keymap.set("n", "<leader>tc", ':!zathura <C-r>=expand("%:r")<cr>.pdf &<cr>')
