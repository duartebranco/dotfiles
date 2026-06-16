local api = require("nvim-tree.api")

local function on_attach(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    local map = function(key, action)
      vim.keymap.set("n", key, action, { buffer = true, noremap = true, silent = true })
    end

    -- navigation
    map("l",    api.node.open.edit)
    map("h",    api.node.navigate.parent_close)
    map("<CR>", api.node.open.edit)

    -- file ops
    map("yy",      api.fs.copy.node)
    map("dd",      api.fs.cut)
    map("p",       api.fs.paste)
    map("dD",      api.fs.remove)
    map("a",       api.fs.rename)
    map("<Insert>",api.fs.create)

    -- bulk ops
    map("<Space>", api.marks.toggle)
    map("bmv",     api.marks.bulk.move)
    map("bd",      api.marks.bulk.delete)

    -- root
    map("]",    api.tree.change_root_to_node)
    map("[",    api.tree.change_root_to_parent)

    -- misc
    map("R",    api.tree.reload)
    map("q",    api.tree.close)
    map("?",    api.tree.toggle_help)
  end)
end

require("nvim-tree").setup({
  on_attach = on_attach,

  -- follow current file
  update_focused_file = {
    enable = true,
    update_root = false,
  },

  -- git integration
  git = {
    enable = true,
    ignore = false,
    show_on_dirs = true,
    timeout = 400,
  },

  renderer = {
    group_empty = true,        -- compact folders
    root_folder_label = ":t",  -- root just as folder name
  },
})

-- highlight current file
local colors = require("pywal16.core").get_colors()
vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = colors.color1, bold = true })


-- close nvim-tree if it's the last window
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local wins = vim.api.nvim_list_wins()
    local non_tree = vim.tbl_filter(function(w)
      return vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= "NvimTree"
    end, wins)
    if #non_tree == 1 then vim.cmd("NvimTreeClose") end
  end,
})

-- open tree on startup if no file was given
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

-- hide cursor
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function(data)
    local tree_api = require("nvim-tree.api")
    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
    if tree_api.tree.is_tree_buf(data.buf) then
      vim.api.nvim_set_hl(0, "Cursor", { blend = 100, fg = hl.fg, bg = hl.bg })
      vim.opt_local.guicursor:append("a:Cursor/lCursor")
    else
      vim.api.nvim_set_hl(0, "Cursor", { blend = 0, fg = hl.fg, bg = hl.bg })
      vim.opt_local.guicursor:remove("a:Cursor/lCursor")
    end
  end,
})
