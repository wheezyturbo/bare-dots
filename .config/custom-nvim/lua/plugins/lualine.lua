return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Load immediately — statusline should always be visible
  lazy = false,
  opts = {
    options = {
      theme = "kanagawa",
      globalstatus = true,        -- single statusline across all splits
      component_separators = { left = "", right = "" },
      section_separators   = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "alpha", "dashboard", "NvimTree", "lazy" },
      },
    },

    sections = {
      lualine_a = { "mode" },

      lualine_b = {
        "branch",
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
        },
        {
          "diagnostics",
          symbols = { error = " ", warn = " ", info = " ", hint = "󰠠 " },
        },
      },

      lualine_c = {
        {
          "filename",
          path = 1,   -- 0=name only, 1=relative, 2=absolute
          symbols = {
            modified = "●",
            readonly = "",
            unnamed  = "[No Name]",
          },
        },
      },

      lualine_x = {
        -- Show the active LSP servers
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return "  " .. table.concat(names, ", ")
          end,
        },
        "encoding",
        {
          "fileformat",
          symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
        },
        "filetype",
      },

      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    inactive_sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
    },
  },
}
