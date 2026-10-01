vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = false,
  integrations = {
    blink_cmp = true,
    fidget = true,
    flash = true,
    gitsigns = true,
    lsp_trouble = true,
    mini = { enabled = true },
    render_markdown = true,
    telescope = { enabled = true },
    treesitter = true,
    which_key = true,
  },
})

vim.cmd.colorscheme('catppuccin')
