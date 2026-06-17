local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if not has_lspconfig then
  return
end

local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { source = "if_many" },
})

pcall(function()
  vim.opt.completeopt = { "menuone", "noselect", "popup" }
end)

local function saga_or(command, fallback)
  return function()
    if vim.fn.exists(":Lspsaga") == 2 then
      vim.cmd("Lspsaga " .. command)
    elseif fallback then
      fallback()
    end
  end
end

vim.keymap.set("n", "[d", saga_or("diagnostic_jump_prev", vim.diagnostic.goto_prev), { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", saga_or("diagnostic_jump_next", vim.diagnostic.goto_next), { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", saga_or("show_line_diagnostics", vim.diagnostic.open_float), { desc = "Line diagnostic" })
if vim.lsp.completion then
  vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.get()
  end, { desc = "LSP completion" })
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local opts = function(desc)
      return { buffer = event.buf, silent = true, desc = desc }
    end

    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    if vim.lsp.completion and client:supports_method("textDocument/completion", event.buf) then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    vim.keymap.set("n", "K", saga_or("hover_doc", vim.lsp.buf.hover), opts("LSP hover"))
    vim.keymap.set("n", "gd", saga_or("goto_definition", vim.lsp.buf.definition), opts("LSP definition"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("LSP declaration"))
    vim.keymap.set("n", "gi", saga_or("finder imp", vim.lsp.buf.implementation), opts("LSP implementation"))
    vim.keymap.set("n", "gp", saga_or("peek_definition", vim.lsp.buf.definition), opts("LSP peek definition"))
    vim.keymap.set("n", "gr", saga_or("finder ref", vim.lsp.buf.references), opts("LSP references"))
    vim.keymap.set("n", "<F2>", saga_or("rename", vim.lsp.buf.rename), opts("LSP rename"))
    vim.keymap.set("n", "<F12>", saga_or("goto_definition", vim.lsp.buf.definition), opts("LSP definition"))
    vim.keymap.set("n", "<S-F12>", saga_or("finder ref", vim.lsp.buf.references), opts("LSP references"))
    vim.keymap.set("n", "<leader>ds", saga_or("outline", vim.lsp.buf.document_symbol), opts("LSP document symbols"))
    vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts("LSP workspace symbols"))
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true, bufnr = event.buf })
    end, opts("LSP format"))
    vim.keymap.set("n", "<leader>rn", saga_or("rename", vim.lsp.buf.rename), opts("LSP rename"))
    vim.keymap.set({ "n", "v" }, "<leader>ca", saga_or("code_action", vim.lsp.buf.code_action), opts("LSP code action"))
    vim.keymap.set("n", "<RightMouse>", function()
      local left_mouse = vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
      vim.api.nvim_feedkeys(left_mouse, "n", false)
      vim.schedule(saga_or("code_action", vim.lsp.buf.code_action))
    end, opts("LSP code action"))

    if vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint", event.buf) then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      vim.keymap.set("n", "<leader>ih", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
      end, opts("Toggle inlay hints"))
    end
  end,
})

vim.filetype.add({
  extension = {
    bazel = "bzl",
    bzl = "bzl",
  },
  filename = {
    [".bazelrc"] = "bazelrc",
    ["BUILD"] = "bzl",
    ["BUILD.bazel"] = "bzl",
    ["MODULE.bazel"] = "bzl",
    ["WORKSPACE"] = "bzl",
    ["WORKSPACE.bazel"] = "bzl",
    ["compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
  },
  pattern = {
    [".*%.bazelrc"] = "bazelrc",
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
  },
})

if not configs.kotlin_lsp then
  configs.kotlin_lsp = {
    default_config = {
      cmd = { "kotlin-lsp" },
      filetypes = { "kotlin" },
      root_dir = util.root_pattern(
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
        ".git"
      ),
      single_file_support = true,
    },
  }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
  bazelrc_lsp = { cmd = { "bazelrc-lsp", "lsp" } },
  bashls = { cmd = { "bash-language-server", "start" } },
  clangd = { cmd = { "clangd" } },
  csharp_ls = { cmd = { "csharp-ls" } },
  cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
  docker_compose_language_service = { cmd = { "docker-compose-langserver", "--stdio" } },
  dockerls = { cmd = { "docker-langserver", "--stdio" } },
  gopls = { cmd = { "gopls" } },
  gradle_ls = { cmd = { "gradle-language-server" } },
  helm_ls = { cmd = { "helm_ls", "serve" } },
  html = { cmd = { "vscode-html-language-server", "--stdio" } },
  jdtls = {},
  jsonls = { cmd = { "vscode-json-language-server", "--stdio" } },
  kotlin_lsp = { cmd = { "kotlin-lsp" } },
  lemminx = { cmd = { "lemminx" } },
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
  starpls = { cmd = { "starpls" } },
  ts_ls = { cmd = { "typescript-language-server", "--stdio" } },
  vimls = { cmd = { "vim-language-server", "--stdio" } },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        schemas = {
          kubernetes = {
            "deploy/**/*.yaml",
            "deploy/**/*.yml",
            "k8s/**/*.yaml",
            "k8s/**/*.yml",
            "kubernetes/**/*.yaml",
            "kubernetes/**/*.yml",
            "manifests/**/*.yaml",
            "manifests/**/*.yml",
          },
        },
      },
    },
  },
}

for name, config in pairs(servers) do
  local executable = config.cmd and config.cmd[1] or name
  if vim.fn.executable(executable) == 1 then
    config.capabilities = capabilities
    lspconfig[name].setup(config)
  end
end
