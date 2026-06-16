vim.keymap.set("n", "<F2>", ":set paste!<CR>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("v", "<C-c>", '"+y')

vim.keymap.set("n", "<C-a>", "ggVG")

vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
-- vim.keymap.set("n", "<C-A-b>", ":botright vertical term opencode<CR>", { desc = "Open opencode in terminal" })

