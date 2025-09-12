require('mason').setup()
require('mason-lspconfig').setup {
  automatic_installation = true,
  ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'pyright', 'gopls', 'html', 'cssls' },
}

local lspconfig = require 'lspconfig'

local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
  bufmap('n', 'K', vim.lsp.buf.hover, 'Hover docs')
  bufmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
end

lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
  end,
}
lspconfig.eslint.setup {}
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
}

lspconfig.gopls.setup {}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.emmet_ls.setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescriptreact' },
  init_options = {
    html = {
      options = {
        ['output.indent'] = '  ',
      },
    },
  },
}

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
  },
  formatting = {
    format = function(entry, vim_item)
      local max_width = 30
      local function truncate_end(str, len)
        return #str > len and '...' .. str:sub(-len + 3) or str
      end

      if entry.source.name == 'nvim_lsp' and entry.completion_item.detail then
        vim_item.menu = truncate_end(entry.completion_item.detail, max_width)
      elseif entry.source.name == 'path' then
        local relpath = vim.fn.fnamemodify(entry.completion_item.label, ':~:.')
        vim_item.menu = truncate_end(relpath, max_width)
      else
        local name = ({
          buffer = '[Buf]',
        })[entry.source.name] or string.format('[%s]', entry.source.name)
        vim_item.menu = truncate_end(name, max_width)
      end

      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
}
