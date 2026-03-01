return { 'nvim-mini/mini.nvim', version = false, config=function()
  require('mini.surround').setup({})
  require('mini.ai').setup({})
  require('mini.pairs').setup({})
  require('mini.align').setup({})
end; }
