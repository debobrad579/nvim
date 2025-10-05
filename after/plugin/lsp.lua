require('mason').setup()
require('mason-lspconfig').setup {
  automatic_installation = true,
  ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'pyright', 'gopls', 'html', 'cssls', 'sqls', 'clangd' },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
  bufmap('n', 'K', vim.lsp.buf.hover, 'Hover docs')
  bufmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
end

local servers = {
  ts_ls = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
    end,
    capabilities = capabilities,
  },
  eslint = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
  lua_ls = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        runtime = { version = 'LuaJIT' },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
  },
  pyright = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
        },
      },
    },
  },
  gopls = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
  html = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
  cssls = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
  emmet_ls = {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescriptreact' },
    init_options = {
      html = { options = { ['output.indent'] = '  ' } },
    },
  },
  clangd = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
}

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
