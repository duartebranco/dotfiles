local colors = require("pywal16.core").get_colors()

require("scrollbar").setup({
  show_in_active_only = true,
  hide_if_all_visible = true,
  handle = { blend = 0 },
  handlers = {
    cursor     = true,
    diagnostic = true,
    gitsigns   = true,
    search     = true,
  },
  set_highlights = false,
})

require("scrollbar.handlers.search").setup()
require("scrollbar.handlers.gitsigns").setup()

local hl = vim.api.nvim_set_hl
hl(0, "ScrollbarHandle",          { bg = colors.color8, fg = colors.color7 })
hl(0, "ScrollbarCursorHandle",    { bg = colors.color8, fg = colors.color7 })
hl(0, "ScrollbarCursor",          { fg = colors.color7 })
hl(0, "ScrollbarSearch",          { link = "Search" })
hl(0, "ScrollbarSearchHandle",    { link = "Search" })
hl(0, "ScrollbarError",           { link = "DiagnosticVirtualTextError" })
hl(0, "ScrollbarErrorHandle",     { link = "DiagnosticVirtualTextError" })
hl(0, "ScrollbarWarn",            { link = "DiagnosticVirtualTextWarn" })
hl(0, "ScrollbarWarnHandle",      { link = "DiagnosticVirtualTextWarn" })
hl(0, "ScrollbarInfo",            { link = "DiagnosticVirtualTextInfo" })
hl(0, "ScrollbarInfoHandle",      { link = "DiagnosticVirtualTextInfo" })
hl(0, "ScrollbarHint",            { link = "DiagnosticVirtualTextHint" })
hl(0, "ScrollbarHintHandle",      { link = "DiagnosticVirtualTextHint" })
hl(0, "ScrollbarGitAdd",          { link = "GitSignsAdd" })
hl(0, "ScrollbarGitAddHandle",    { link = "GitSignsAdd" })
hl(0, "ScrollbarGitChange",       { link = "GitSignsChange" })
hl(0, "ScrollbarGitChangeHandle", { link = "GitSignsChange" })
hl(0, "ScrollbarGitDelete",       { link = "GitSignsDelete" })
hl(0, "ScrollbarGitDeleteHandle", { link = "GitSignsDelete" })
