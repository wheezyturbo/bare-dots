-- NOTE: fzf-lua plugin spec (fzf.lua) already declares lazy-load keys for:
--   <leader><leader>  →  FzfLua files
--   <leader>/         →  FzfLua live_grep
--   <leader>,         →  FzfLua buffers
--   <leader>:         →  FzfLua command_history
-- Do NOT re-declare those here — duplicates break lazy-loading and
-- cause the plugin to be required eagerly on startup.

-- ─── Window Navigation ────────────────────────────────────────────────────
-- Neovim has NO built-in <C-h/j/k/l> mappings (only <C-w>h etc.),
-- so no need to delete anything before setting these.
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- Terminal → window navigation (same keys work inside toggleterm)
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- ─── Window / Buffer Management ──────────────────────────────────────────
vim.keymap.set("n", "<leader>wd", "<C-w>q",          { noremap = true, silent = true, desc = "Close Window" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>",      { desc = "Quit All" })

-- ─── Buffer Tabs (BufferLine) ─────────────────────────────────────────────
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
-- Move the current buffer left/right in the bufferline
vim.keymap.set("n", "<leader>t[", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>t]", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })

-- ─── Line Movement ────────────────────────────────────────────────────────
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>==",        { desc = "Move Line Down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>==",        { desc = "Move Line Up" })
vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv",        { desc = "Move Selection Down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv",        { desc = "Move Selection Up" })

-- ─── Extra FZF Bindings (not covered by fzf.lua plugin spec) ─────────────
-- <leader><leader>, <leader>/, <leader>,, <leader>: are in fzf.lua keys={}.
-- Only add bindings here that fzf.lua does NOT already declare.
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>fb", fzf.buffers,      { desc = "Fzf Buffers (alt)" })
vim.keymap.set("n", "<leader>fr", fzf.resume,       { desc = "Fzf Resume" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword,   { desc = "Fzf Grep Word Under Cursor" })
vim.keymap.set("n", "<leader>fc", fzf.lgrep_curbuf, { desc = "Fzf Search Current Buffer" })
vim.keymap.set("n", "<leader>fo", fzf.oldfiles,     { desc = "Fzf Recent Files" })
vim.keymap.set("n", "<leader>gf", fzf.git_files,    { desc = "Fzf Git Files" })
vim.keymap.set("n", "<leader>uC", "<cmd>FzfLua colorschemes<cr>", { desc = "Colorschemes" })

-- ─── Git / Terminal ──────────────────────────────────────────────────────
-- <leader>gg  →  LazyGit         ─┐
-- <leader>gL  →  LazyGit log      ├─ All declared in snacks.lua keys={}
-- <leader>gl  →  LazyGit log file ─┘
-- <C-/>/<C-_> →  Toggle terminal  ─┘
