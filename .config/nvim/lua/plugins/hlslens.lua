local hlslens = require('hlslens')

local function map(l, r, desc)
  vim.keymap.set('n', l, r, { noremap = true, silent = true, desc = desc })
end

map('n', function()
  vim.cmd('normal! ' .. vim.v.count1 .. 'n')
  hlslens.start()
end, 'Next match')

map('N', function()
  vim.cmd('normal! ' .. vim.v.count1 .. 'N')
  hlslens.start()
end, 'Prev match')

map('*', function() vim.cmd('normal! *') hlslens.start() end, 'Search word fwd')
