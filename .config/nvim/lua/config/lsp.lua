local signs = { Error = '󰅙', Warn = '󰁪', Hint = '󰛩', Info = '󰋼' }
for t, i in pairs(signs) do
  vim.fn.sign_define('DiagnosticSign' .. t, { text = i, texthl = 'DiagnosticSign' .. t, numhl = 'DiagnosticSign' .. t })
end

vim.diagnostic.config {
  virtual_text = { prefix = '▎', spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { source = true, border = 'rounded' },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
  callback = function(args)
    local o = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, o)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, o)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, o)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, o)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, o)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, o)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, o)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, o)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, o)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, o)
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_caps = pcall(require, 'cmp_nvim_lsp')
if ok then capabilities = cmp_caps.default_capabilities() end

local zed = vim.fn.expand('~/.local/share/zed/languages')

local function ncmd(...)
  return vim.list_extend({ 'node' }, { ... })
end

vim.lsp.config('basedpyright', {
  cmd = ncmd(zed .. '/basedpyright/node_modules/basedpyright/langserver.index.js', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('basedpyright')

vim.lsp.config('bashls', {
  cmd = ncmd(zed .. '/bash-language-server/node_modules/bash-language-server/out/cli.js', 'start'),
  capabilities = capabilities,
})
vim.lsp.enable('bashls')

vim.lsp.config('clangd', {
  cmd = { zed .. '/clangd/clangd_22.1.6/bin/clangd' },
  capabilities = capabilities,
})
vim.lsp.enable('clangd')

vim.lsp.config('cssls', {
  cmd = ncmd(zed .. '/vscode-css-language-server/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('cssls')

vim.lsp.config('html', {
  cmd = ncmd(zed .. '/vscode-css-language-server/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('html')

vim.lsp.config('eslint', {
  cmd = ncmd(zed .. '/vscode-css-language-server/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('eslint')

vim.lsp.config('jsonls', {
  cmd = ncmd(zed .. '/json-language-server/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('jsonls')

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  capabilities = capabilities,
})
vim.lsp.enable('ruff')

vim.lsp.config('tailwindcss', {
  cmd = ncmd(zed .. '/tailwindcss-language-server/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server', '--stdio'),
  filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
  settings = { tailwindCSS = { includeLanguages = { vue = 'html', svelte = 'html' } } },
  capabilities = capabilities,
})
vim.lsp.enable('tailwindcss')

vim.lsp.config('vtsls', {
  cmd = ncmd(zed .. '/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('vtsls')

vim.lsp.config('yamlls', {
  cmd = ncmd(zed .. '/yaml-language-server/node_modules/yaml-language-server/bin/yaml-language-server', '--stdio'),
  capabilities = capabilities,
})
vim.lsp.enable('yamlls')

vim.lsp.config('denols', {
  cmd = { 'deno', 'lsp' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' },
  root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' },
  init_options = { lint = true, unstable = true, suggest = { completeFunctionCalls = true } },
  capabilities = capabilities,
})
vim.lsp.enable('denols')

vim.lsp.config('mdls', {
  cmd = ncmd(zed .. '/vscode-css-language-server/node_modules/vscode-langservers-extracted/bin/vscode-markdown-language-server', '--stdio'),
  filetypes = { 'markdown', 'md' },
  root_markers = { '.git' },
  capabilities = capabilities,
})
vim.lsp.enable('mdls')
