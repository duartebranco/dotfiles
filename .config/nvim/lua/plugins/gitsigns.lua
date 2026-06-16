require('gitsigns').setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local map = function(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
  end,
})

require('scrollbar.handlers.gitsigns').setup()
