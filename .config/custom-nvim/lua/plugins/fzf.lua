return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>,", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
    opts = function()
      local actions = require("fzf-lua.actions")
      
      return {
        global_resume = true,
        global_resume_query = true,
        
        keymap = {
          builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-f"] = "preview-page-down",
            ["ctrl-b"] = "preview-page-up",
          },
        },

        winopts = {
          height = 0.85,
          width = 0.90,
          row = 0.35,
          col = 0.50,
          border = "rounded",
          preview = {
            layout = "horizontal",
            horizontal = "right:50%",
            border = "rounded",
            wrap = "wrap",
            scrollbar = "border",
            delay = 50,
          },
          hls = {
            normal = "Normal",
            border = "FloatBorder",
            cursor = "Cursor",
            cursorline = "CursorLine",
            cursorlinenr = "CursorLineNr",
            search = "IncSearch",
          },
        },
        fzf_opts = {
          ["--ansi"] = true,
          ["--info"] = "inline-right",
          ["--height"] = "100%",
          ["--layout"] = "reverse",
          ["--border"] = "none",
          ["--prompt"] = "❯ ",
          ["--pointer"] = "▶",
          ["--marker"] = "✓",
          ["--no-scrollbar"] = true,
        },
        actions = {
          files = {
            ["default"] = actions.file_edit,      -- FIXED: Opens in current buffer for Bufferline
            ["ctrl-v"]  = actions.file_vsplit,    -- Vertical Split
            ["ctrl-s"]  = actions.file_split,     -- Horizontal Split
            ["ctrl-t"]  = actions.file_tabedit,   -- Added: Press Ctrl-t if you actually want a real tab
            ["ctrl-q"]  = actions.file_sel_to_qf, -- Send to quickfix list
          },
          buffers = {
            ["default"] = actions.buf_edit,
            ["ctrl-d"]  = actions.buf_del,
            ["ctrl-v"]  = actions.buf_vsplit,
            ["ctrl-s"]  = actions.buf_split,
          },
        },
        files = {
          prompt = "Files❯ ",
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        },
        grep = {
          prompt = "Grep❯ ",
          rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]],
        },
      }
    end,
  }
}
