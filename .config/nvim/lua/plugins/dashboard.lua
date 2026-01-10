local function custom_startup()
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

  return {
    text = {
      {
        ("⚡ %d/%d plugins loaded in %sms"):format(stats.loaded, stats.count, ms),
        hl = "SnacksDashboardDesc",
        align = "center",
      },
      {
        "🎵 EUROBEAT INTENSIFIES 🎵",
        hl = "SnacksDashboardHeader",
        align = "center",
      },
    },
  }
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        -- Fujiwara Tofu Shop header (must be a single multi-line string)
        header = [[
                                                                      
   ┌──────────────────────────────────────────────────────────────┐   
   │                                                              │   
   │           藤 原 と う ふ 店    （ 自 家 用 ）                │   
   │                                                              │   
   ├──────────────────────────────────────────────────────────────┤   
   │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│   
   └──────────────────────────────────────────────────────────────┘   
                                                                      
                            🏎️  Eurobeat INTENSIFIES... (Deja Vu)  🏎️                           
]],
        -- Keys with icons
        keys = {
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":FzfLua files" },
          { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":FzfLua oldfiles" },
          { icon = "󰊄 ", key = "g", desc = "Live Grep", action = ":FzfLua live_grep" },
          { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "󰩈 ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        -- Or use custom function:
        -- custom_startup,
      },
    },
  },
}
