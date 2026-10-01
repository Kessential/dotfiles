-- Tắt bộ gõ (gõ tiếng Việt) khi thoát insert mode, bật lại khi vào insert nếu trước đó đang bật.
if vim.fn.executable('fcitx5-remote') == 1 then
  local was_on = false
  local group = vim.api.nvim_create_augroup('fcitx5-switch', { clear = true })

  vim.api.nvim_create_autocmd('InsertLeave', {
    group = group,
    callback = function()
      -- fcitx5-remote in ra 1 = đang tắt, 2 = đang bật
      was_on = vim.trim(vim.fn.system('fcitx5-remote')) == '2'
      if was_on then vim.fn.system('fcitx5-remote -c') end
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    group = group,
    callback = function()
      if was_on then vim.fn.system('fcitx5-remote -o') end
    end,
  })
end
