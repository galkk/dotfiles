local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if not has_lspconfig then
  return
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { source = "if_many" },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostic" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = function(desc)
      return { buffer = event.buf, silent = true, desc = desc }
    end

    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("LSP hover"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP definition"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP declaration"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("LSP implementation"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("LSP references"))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("LSP rename"))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("LSP code action"))
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
  bashls = { cmd = { "bash-language-server", "start" } },
  clangd = { cmd = { "clangd" } },
  gopls = { cmd = { "gopls" } },
  jsonls = { cmd = { "vscode-json-language-server", "--stdio" } },
  lua_ls = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = { enable = false },
      },
    },
  },
  pyright = { cmd = { "pyright-langserver", "--stdio" } },
  rust_analyzer = { cmd = { "rust-analyzer" } },
  ts_ls = { cmd = { "typescript-language-server", "--stdio" } },
  yamlls = { cmd = { "yaml-language-server", "--stdio" } },
}

for name, config in pairs(servers) do
  local executable = config.cmd and config.cmd[1]
  if executable and vim.fn.executable(executable) == 1 then
    config.capabilities = capabilities
    lspconfig[name].setup(config)
  end
end
