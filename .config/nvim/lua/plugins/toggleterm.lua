local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 6
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.35
    end
  end,
  open_mapping = nil,
  insert_mappings = false,
  terminal_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = "rounded",
    winblend = 3,
  },
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert!")
  end,
})

-- persistent terminals: only one visible at a time (like IDE tabs)
local persistent = {}

local function toggle_persistent(id)
  if not persistent[id] then
    persistent[id] = Terminal:new({ id = id, direction = "horizontal" })
  end
  local term = persistent[id]
  if term:is_open() then
    term:close()
    return
  end
  for i, t in pairs(persistent) do
    if i ~= id and t:is_open() then
      t:close()
    end
  end
  term:open()
end

for i = 1, 5 do
  vim.keymap.set({ "n", "t" }, "<A-" .. i .. ">", function()
    if not vim.api.nvim_buf_get_name(0):match("toggleterm") then return end
    toggle_persistent(i)
  end, { desc = "Toggle persistent terminal #" .. i })
end
