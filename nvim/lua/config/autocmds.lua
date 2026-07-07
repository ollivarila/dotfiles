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
        vim.hl.on_yank()
      end,
    })
    vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
      pattern = '*',
      command = "if mode() != 'c' | checktime | endif",
    })

    -- 2-space indent for these filetypes (replaces per-filetype after/ftplugin files)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'css', 'javascript', 'json', 'nix', 'typescript', 'typescriptreact' },
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
      end,
    })
  end,
}
