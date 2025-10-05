local cmp = require('cmp')
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
