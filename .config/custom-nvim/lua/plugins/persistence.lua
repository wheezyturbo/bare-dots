return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    -- Directory to store sessions
    dir = vim.fn.stdpath("state") .. "/sessions/",
    -- Minimum number of file buffers that need to be open to save
    need = 1,
    -- Don't save if only these are open
    branch = true,
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
  },
}
