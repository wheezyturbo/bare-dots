return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- ╔══════════════════════════════════════════════════════════════════════╗
    -- ║            藤原とうふ店 - FUJIWARA TOFU SHOP                         ║
    -- ╚══════════════════════════════════════════════════════════════════════╝

    local headers = {
      -- Main Fujiwara Tofu Shop logo
      tofu_shop = {
        [[                                                                        ]],
        [[  ╔════════════════════════════════════════════════════════════════╗   ]],
        [[  ║                                                                ║   ]],
        [[  ║                                                                ║   ]],
        [[  ║             藤 原 と う ふ 店  （自家用）                      ║   ]],
        [[  ║                                                                ║   ]],
        [[  ╠════════════════════════════════════════════════════════════════╣   ]],
        [[  ║████████████████████████████████████████████████████████████████║   ]],
        [[  ╚════════════════════════════════════════════════════════════════╝   ]],
        [[                                                                        ]],
        [[                        🏎️  AE86 TRUENO  🏎️                            ]],
        [[                                                                        ]],
      },

      -- Cleaner version
      tofu_clean = {
        [[                                                                      ]],
        [[   ┌──────────────────────────────────────────────────────────────┐   ]],
        [[   │                                                              │   ]],
        [[   │           藤 原 と う ふ 店    （ 自 家 用 ）                │   ]],
        [[   │                                                              │   ]],
        [[   ├──────────────────────────────────────────────────────────────┤   ]],
        [[   │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│   ]],
        [[   └──────────────────────────────────────────────────────────────┘   ]],
        [[                                                                      ]],
      },

      -- Compact
      compact = {
        [[                                                    ]],
        [[   ╔══════════════════════════════════════════╗     ]],
        [[   ║                                          ║     ]],
        [[   ║      藤原とうふ店  （自家用）            ║     ]],
        [[   ║                                          ║     ]],
        [[   ╠══════════════════════════════════════════╣     ]],
        [[   ║██████████████████████████████████████████║     ]],
        [[   ╚══════════════════════════════════════════╝     ]],
        [[                                                    ]],
      },

      -- Mini
      mini = {
        [[                                      ]],
        [[  ┌────────────────────────────────┐  ]],
        [[  │  藤原とうふ店  （自家用）      │  ]],
        [[  ├────────────────────────────────┤  ]],
        [[  │████████████████████████████████│  ]],
        [[  └────────────────────────────────┘  ]],
        [[                                      ]],
      },
    }

    -- Responsive header
    local function get_header()
      local height = vim.o.lines
      local width = vim.o.columns
      if height < 20 or width < 50 then
        return headers.mini
      elseif height < 30 or width < 70 then
        return headers.compact
      elseif height < 40 then
        return headers.tofu_clean
      else
        return headers.tofu_shop
      end
    end

    dashboard.section.header.val = get_header()

    -- Buttons with icons
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", "<cmd>FzfLua files<cr>"),
      dashboard.button("r", "󰋚  Recent files", "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("g", "󰊄  Live grep", "<cmd>FzfLua live_grep<cr>"),
      dashboard.button("c", "  Config", "<cmd>e $MYVIMRC<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("m", "  Mason", "<cmd>Mason<cr>"),
      dashboard.button("q", "󰩈  Quit", "<cmd>qa<cr>"),
    }

    -- Footer
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = {
          "",
          "⚡ " .. stats.loaded .. " plugins in " .. ms .. "ms",
          "🎵 EUROBEAT INTENSIFIES 🎵",
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    dashboard.section.footer.val = { "", "⚡ Loading...", "" }

    -- Highlights
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        -- Black and white like the real logo
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#f8f8f2", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f9e2af", bold = true })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6272a4", italic = true })
      end,
    })

    -- Layout
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.config)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
        vim.opt_local.laststatus = 0
        vim.opt_local.showtabline = 0
      end,
    })
  end,
}
