vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/mikavilpas/yazi.nvim',
})

require('yazi').setup({
  open_for_directories = false,
})

vim.keymap.set('n', '<leader>e', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
vim.keymap.set('n', '<leader>E', '<cmd>Yazi cwd<cr>', { desc = 'Open yazi in working directory' })
