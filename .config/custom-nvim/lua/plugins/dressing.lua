-- Dressing.nvim - Beautiful floating input/select prompts
-- CENTERED on screen, not cramped on the current window
return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
  opts = {
    input = {
      -- Enable input
      enabled = true,
      -- Default prompt string
      default_prompt = "Input",
      -- Trim trailing `:` from prompt
      trim_prompt = true,
      -- Title position: "left", "right", or "center"
      title_pos = "center",
      -- When true, input will start in insert mode
      start_in_insert = true,
      -- Border style
      border = "rounded",
      -- *** CENTERED ON ENTIRE EDITOR ***
      relative = "editor",
      -- Nice size that's not cramped
      prefer_width = 60,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 40, 0.3 },
      win_options = {
        wrap = false,
        list = true,
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },
      mappings = {
        n = {
          ["<Esc>"] = "Close",
          ["<CR>"] = "Confirm",
        },
        i = {
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
          ["<Up>"] = "HistoryPrev",
          ["<Down>"] = "HistoryNext",
        },
      },
    },
    select = {
      -- Enable select
      enabled = true,
      -- Priority list of backends
      backend = { "builtin", "fzf_lua", "nui" },
      -- Trim trailing `:` from prompt
      trim_prompt = true,
      -- Builtin selector options - CENTERED
      builtin = {
        show_numbers = true,
        -- *** CENTERED ON ENTIRE EDITOR ***
        relative = "editor",
        border = "rounded",
        -- Nice size
        width = nil,
        max_width = { 100, 0.8 },
        min_width = { 50, 0.3 },
        height = nil,
        max_height = 0.8,
        min_height = { 10, 0.2 },
        win_options = {
          cursorline = true,
          cursorlineopt = "both",
        },
        mappings = {
          ["<Esc>"] = "Close",
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
        },
      },
    },
  },
}
