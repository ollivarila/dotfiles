return {
  defaults = function()
    -- [[ Basic Autocommands ]]
    --  See `:help lua-guide-autocommands`

    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
      desc = 'Highlight when yanking (copying) text',
      group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
      callback = function()
        vim.highlight.on_yank()
      end,
    })
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
      pattern = '*.foo',
      callback = function()
        vim.bo.filetype = 'foo'
      end,
    })

    vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
      pattern = '*',
      command = "if mode() != 'c' | checktime | endif",
    })
  end,
}
