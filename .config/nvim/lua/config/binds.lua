vim.keymap.set("n", "<F2>", ":set paste!<CR>")

-- clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- grep project (type term, case-insensitive)
-- vim.keymap.set("i", "<C-S-s>", function()
--   local term = vim.fn.input("Grep: ")
--   if term == "" then return end
--   vim.cmd("grep! -ri --exclude-dir=.git " .. vim.fn.shellescape(term) .. " .")
--   vim.cmd("copen 10")
-- end, { desc = "Grep project (case-insensitive)" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- copy
vim.keymap.set("v", "<C-c>", '"+y')

-- select all
vim.keymap.set("n", "<C-a>", "ggVG")

-- tree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- quick one-off terminals
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
vim.keymap.set({ "n", "t" }, "<C-A-b>", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
-- lazy git
--keys = {
--    { "<C-S-j>", "<cmd>LazyGit<cr>", desc = "LazyGit" }
--}

-- resize by bigger chunks
vim.keymap.set({ "n", "t" }, "<A-Up>", "<cmd>resize +5<CR>", { desc = "Increase height" })
vim.keymap.set({ "n", "t" }, "<A-Down>", "<cmd>resize -5<CR>", { desc = "Decrease height" })
vim.keymap.set({ "n", "t" }, "<A-Left>", "<cmd>vertical resize -5<CR>", { desc = "Decrease width" })
vim.keymap.set({ "n", "t" }, "<A-Right>", "<cmd>vertical resize +5<CR>", { desc = "Increase width" })

