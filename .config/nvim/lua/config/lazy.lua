local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "lewis6991/gitsigns.nvim" },
    { "sindrets/diffview.nvim" },
    { "navarasu/onedark.nvim" },
    {
      "neovim/nvim-lspconfig",
      tag = "v1.8.0",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("config.lsp")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("config.treesitter")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Telescope",
      config = function()
        require("telescope").setup({
          pickers = {
            colorscheme = {
              enable_preview = true,
            },
          },
        })
      end,
    },
  },
  install = {
    missing = true,
    colorscheme = { "habamax" },
  },
  checker = {
    enabled = true,
  },
  performance = {
    reset_packpath = false,
    rtp = {
      reset = false,
    },
  },
})
