local hlslens = require('hlslens')

local function map(l, r, desc)
  vim.keymap.set('n', l, r, { noremap = true, silent = true, desc = desc })
end

-- keep n/N working but activate hlslens on each jump
map('n', function()
  vim.cmd('normal! ' .. vim.v.count1 .. 'n')
  hlslens.start()
end, 'Next match')

map('N', function()
  vim.cmd('normal! ' .. vim.v.count1 .. 'N')
  hlslens.start()
end, 'Prev match')

-- * and # also show the lens
map('*',  function() vim.cmd('normal! *')  hlslens.start() end, 'Search word fwd')
map('#',  function() vim.cmd('normal! #')  hlslens.start() end, 'Search word bwd')
map('g*', function() vim.cmd('normal! g*') hlslens.start() end, 'Search word fwd (no boundary)')
map('g#', function() vim.cmd('normal! g#') hlslens.start() end, 'Search word bwd (no boundary)')
