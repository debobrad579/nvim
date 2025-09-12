require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'javascript', 'typescript', 'tsx', 'html', 'css', 'python', 'go' },
  auto_install = true,
  sync_install = false,
  ignore_install = { 'haskell' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  modules = {},
}
