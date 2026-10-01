vim.pack.add({
  'https://github.com/folke/flash.nvim',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/folke/persistence.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})

require('which-key').add({
  { '<leader>x', group = 'Trouble' },
  { '<leader>p', group = '[P]ersistence (session)' },
})

-- flash: nhảy nhanh. Dùng `gs` vì `s` đang là tiền tố của mini.surround
require('flash').setup({
  modes = { search = { enabled = false } },
})
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function() require('flash').jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'gS', function() require('flash').treesitter() end, { desc = 'Flash treesitter' })

-- trouble: danh sách diagnostics/symbols/quickfix
require('trouble').setup({})
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (workspace)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Diagnostics (buffer)' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix list' })

-- undotree có sẵn trong Neovim 0.12
vim.cmd.packadd('nvim.undotree')
vim.keymap.set('n', '<leader>u', function() require('undotree').open() end, { desc = '[U]ndotree' })

-- persistence: lưu/khôi phục session theo thư mục làm việc
vim.o.sessionoptions = 'buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds'
require('persistence').setup({})
vim.keymap.set('n', '<leader>ps', function() require('persistence').load() end, { desc = 'Restore session (cwd)' })
vim.keymap.set('n', '<leader>pl', function() require('persistence').load({ last = true }) end, { desc = 'Restore last session' })
vim.keymap.set('n', '<leader>pd', function() require('persistence').stop() end, { desc = "Don't save current session" })

-- render-markdown: hiển thị markdown đẹp hơn ngay trong buffer
require('render-markdown').setup({})
