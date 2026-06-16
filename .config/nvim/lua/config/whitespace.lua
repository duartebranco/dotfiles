-- highlight white space using pywal16's color4 (lualine section A background)
local colors = require("pywal16.core").get_colors()
vim.api.nvim_set_hl(0, "RedundantSpaces", { bg = colors.color4 })
vim.fn.matchadd("RedundantSpaces", [[\s\+$\| \+\ze\t]])

-- rm whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

