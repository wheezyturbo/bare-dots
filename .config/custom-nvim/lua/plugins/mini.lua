return {
  "echasnovski/mini.nvim",
  version = false,
  -- Must load after treesitter-textobjects so @-captures are registered
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  event = "VeryLazy",
  config = function()
    -- ─── mini.surround ──────────────────────────────────────────────────────
    require("mini.surround").setup({})

    -- ─── mini.pairs ─────────────────────────────────────────────────────────
    require("mini.pairs").setup({})

    -- ─── mini.align ─────────────────────────────────────────────────────────
    require("mini.align").setup({})

    -- ─── mini.ai ────────────────────────────────────────────────────────────
    --
    -- Text-object cheat-sheet (after this config):
    --
    --  f   function / method        yaf  daf  vif   (Go ✓ TS ✓ Lua ✓ etc.)
    --  c   class / struct / type    yac  dac  vic   (Go struct ✓ TS ✓)
    --  o   block (if/for/while…)    yao  dao  vio   (Go ✓ TS ✓ Lua ✓ etc.)
    --  a   argument / parameter     yaa  daa  via   (Go ✓ TS ✓)
    --  u   function call ()         yau  dau  viu   (any language)
    --  U   func call (no dot)       yaU  daU  viU
    --  t   HTML/JSX tag             yat  dat  vit   (HTML ✓ TSX ✓)
    --  d   digit sequence           yad  dad  vid
    --  e   CamelCase/camelCase word yae  dae  vie
    --  g   whole buffer             yag  dag  vig
    --
    --  Built-ins kept from mini.ai:
    --    ( ) [ ] { } < > " ' ` b B q
    --
    local ai = require("mini.ai")

    ai.setup({
      n_lines = 500,
      -- 'cover' means: prefer the smallest text-object that covers the cursor
      search_method = "cover_or_next",
      silent = true,

      custom_textobjects = {

        -- f – function / method
        --   Works for: Go (func), TypeScript (function/method/arrow),
        --   Lua (function), Terraform (resource block), etc.
        f = ai.gen_spec.treesitter({
          a = "@function.outer",
          i = "@function.inner",
        }),

        -- c – class / struct / type declaration
        --   Go: struct type definitions (via @class captures in go queries)
        --   TypeScript/JavaScript: class declarations
        c = ai.gen_spec.treesitter({
          a = "@class.outer",
          i = "@class.inner",
        }),

        -- o – any block: if, for, while, select, switch…
        --   Combines @block, @conditional, and @loop captures.
        --   This makes `dao` delete the nearest if/for/while block.
        --   Go: all three capture types are supported (see BUILTIN_TEXTOBJECTS.md)
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),

        -- a – argument / parameter
        --   yaa deletes a function argument including its comma.
        --   Go ✓ TypeScript ✓ Lua ✓
        a = ai.gen_spec.treesitter({
          a = "@parameter.outer",
          i = "@parameter.inner",
        }),

        -- u – function call (including dot-method calls)
        --   yau = yank around function call, e.g. `fmt.Println("hi")`
        u = ai.gen_spec.function_call(),

        -- U – function call (no dot, for simple names only)
        --   yaU = yank around `Println("hi")` without `fmt.`
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),

        -- t – HTML / JSX / TSX tag pair
        --   yat deletes <div>…</div>
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },

        -- d – digit run (number literal)
        --   yad yanks a sequence of digits, useful for editing constants
        d = { "%f[%d]%d+" },

        -- e – word with case (camelCase / PascalCase / snake_case segment)
        --   yae selects a single case-word within an identifier.
        --   Useful for renaming individual words inside camelCase names.
        e = {
          {
            "%u[%l%d]+%f[^%l%d]",           -- PascalWord
            "%f[%S][%l%d]+%f[^%l%d]",       -- camelWord
            "%f[%P][%l%d]+%f[^%l%d]",       -- after punctuation
            "^[%l%d]+%f[^%l%d]",            -- start of line word
          },
          "^().*()$",
        },

        -- g – whole buffer (great for formatting / replacing everything)
        --   yag yanks the entire file content.
        g = function(ai_type)
          local start_line = 1
          local end_line = vim.fn.line("$")
          if ai_type == "i" then
            -- "inner" buffer: skip leading/trailing blank lines
            while start_line <= end_line and vim.fn.getline(start_line):match("^%s*$") do
              start_line = start_line + 1
            end
            while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
              end_line = end_line - 1
            end
          end
          local to_col = math.max(vim.fn.getline(end_line):len(), 1)
          return {
            from = { line = start_line, col = 1 },
            to   = { line = end_line,   col = to_col },
          }
        end,
      },
    })
  end,
}
