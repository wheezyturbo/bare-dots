return {
  "akinsho/toggleterm.nvim",
  version = "*",
  -- Load only when the commands are called or keys are pressed
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    -- Map both standard and fallback keys for normal and terminal modes
    { "<C-/>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
    { "<C-_>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
  },
  opts = {
    size = 20,
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true, -- Ensures the <C-/> key works INSIDE the terminal
    persist_size = true,
    close_on_exit = true,
    -- Configure the LazyVim-style rounded floating window
    float_opts = {
      border = "curved",      -- Gives it that smooth, modern look
      winblend = 0,
      title_pos = "center",
    },
  },
}
