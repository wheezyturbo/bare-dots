-- mini.ai - Better text objects (standalone, no treesitter-textobjects needed)
-- Provides: af/if (around/inside function), ac/ic (around/inside class), etc.
return {
  "echasnovski/mini.ai",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  -- NO dependency on nvim-treesitter-textobjects (it's broken with new treesitter)
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        -- Use mini.ai's built-in treesitter spec (doesn't need the broken plugin)
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        o = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
        l = ai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
        a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        -- Whole buffer
        g = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
  end,
}
