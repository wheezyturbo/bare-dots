return {
  "folke/snacks.nvim",
  priority = 1000, -- load before everything else
  lazy = false,
  ---@type snacks.Config
  opts = {

    -- ─── Dashboard (replaces alpha-nvim) ──────────────────────────────────
    dashboard = {
      width    = 60,
      row      = nil,
      col      = nil,
      pane_gap = 4,

      preset = {
        -- Wire every pick action to fzf-lua
        pick = function(cmd, opts)
          return require("fzf-lua")[cmd](opts)
        end,

        -- ── Action menu ─────────────────────────────────────────────────
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua require('fzf-lua').files()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua require('fzf-lua').live_grep()" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua require('fzf-lua').oldfiles()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },

        -- ── Header ───────────────────────────────────────────────────────
        header = [[

  ╔════════════════════════════════════════════════════╗
  ║                                                    ║
  ║        藤 原 と う ふ 店  （ 自 家 用 ）           ║
  ║                                                    ║
  ╠════════════════════════════════════════════════════╣
  ║████████████████████████████████████████████████████║
  ╚════════════════════════════════════════════════════╝

]],
      },

      -- ── Formats: customise how keys look ─────────────────────────────
      formats = {
        key = function(item)
          return {
            { "  [ ", hl = "special" },
            { item.key, hl = "key" },
            { " ] ", hl = "special" },
          }
        end,
      },

      -- ── Layout ───────────────────────────────────────────────
      sections = {
        { section = "header" },
        { 
          section = "keys", 
          gap = 1, 
          padding = 1,
        },
        { section = "startup" },
      },
    },

    -- ─── Terminal (replaces toggleterm.nvim) ──────────────────────────────
    terminal = {
      win = {
        style    = "terminal",
        position = "bottom",
        height   = 0.35,
        border   = "rounded",
      },
    },

    -- ─── Lazygit (replaces kdheepak/lazygit.nvim) ─────────────────────────
    -- Auto-generates a lazygit theme from your Neovim colorscheme — much
    -- nicer than the plain grey default. Also wires up `nvim-remote` so
    -- editing files from inside lazygit opens them in the current Neovim.
    lazygit = {
      configure = true,
      config = {
        os  = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
      },
      win = { style = "lazygit" },
    },

    -- ─── Notifier ─────────────────────────────────────────────────────────
    notifier = {
      enabled = true,
      timeout = 3000,
      style   = "fancy",
    },

    -- ─── Words (highlights all instances of word under cursor) ─────────────
    words = { enabled = true },

    -- ─── Big file (disable slow features for huge files) ──────────────────
    bigfile = { enabled = true },

    -- ─── Scope (shows context indent guides) ──────────────────────────────
    scope = { enabled = true },

    -- ─── Scroll (smooth scrolling) ─────────────────────────────────────────
    scroll = { enabled = true },

    -- These are disabled — we have dedicated plugins for these already
    indent    = { enabled = false }, -- no indent-blankline replacement needed
    picker    = { enabled = false }, -- using fzf-lua
    statuscolumn = { enabled = false },
  },

  keys = {
    -- ─── Terminal ─────────────────────────────────────────────────────────
    -- <C-/> and <C-_> are the same key on most terminals; map both so it
    -- works regardless of how the terminal sends the key.
    { "<C-/>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle Terminal" },
    { "<C-_>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle Terminal" },

    -- ─── Lazygit ──────────────────────────────────────────────────────────
    { "<leader>gg", function() Snacks.lazygit() end,          desc = "LazyGit" },
    { "<leader>gL", function() Snacks.lazygit.log() end,      desc = "LazyGit Log" },
    { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "LazyGit Log (file)" },

    -- ─── Notifications ────────────────────────────────────────────────────
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>uN", function() Snacks.notifier.show_history() end, desc = "Notification History" },
  },
}
