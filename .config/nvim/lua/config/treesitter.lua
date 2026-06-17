local has_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
if not has_treesitter then
  return
end

treesitter.setup({
  ensure_installed = {
    "bash",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
})
