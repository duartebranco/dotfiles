local root = vim.fn.stdpath("data")

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {
  -- add any other pugins here
  {
    'uZer/pywal16.nvim',
    config = function()
      vim.cmd.colorscheme("pywal16") -- already sets theme up
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'petertriho/nvim-scrollbar',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'kevinhwang91/nvim-hlslens',
    },
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<C-A-b>", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
}
require("lazy").setup(plugins, {
  root = root .. "/plugins",
})

-- add anything else here
vim.opt.termguicolors = true
