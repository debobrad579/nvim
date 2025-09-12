local conform = require('conform')

conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    python = { 'black' },
    go = { 'gofmt' },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },
}

vim.api.nvim_create_user_command('F', function()
  conform.format { async = true, lsp_fallback = true }
end, { desc = 'Format Current Buffer' })
