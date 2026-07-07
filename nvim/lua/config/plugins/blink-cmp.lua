return { -- Autocompletion
  'saghen/blink.cmp',
  version = '1.*', -- use prebuilt fuzzy-matcher binary, no build step needed
  event = 'InsertEnter',
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {},
    },
    -- Snippet library used by blink's built-in snippet source
    'rafamadriz/friendly-snippets',
  },
  opts = {
    keymap = {
      preset = 'none',
      -- Select the [n]ext / [p]revious item
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      -- Accept ([y]es) the completion.
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
      -- Manually trigger a completion from blink.
      ['<C-space>'] = { 'show', 'fallback' },
      -- <c-l> moves to the right of your snippet expansion, <c-h> backwards.
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
    },
    completion = {
      menu = { auto_show = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lsp = {
          transform_items = function(ctx, items)
            -- Disable lsp provided snippets in rust atleast
            return vim.tbl_filter(function(item)
              return ctx.filetype ~= 'rust' or item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet
            end, items)
          end,
        },
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },
  },
}
