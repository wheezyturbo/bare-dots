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
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>",      { desc = "Quit All" })

-- ─── Windows (<leader>w) ────────────────────────────────────────────────
-- Replicate bindings from screenshot and LazyVim
local function wm(lhs, rhs, desc)
  vim.keymap.set("n", "<leader>w" .. lhs, rhs, { desc = desc })
end

wm("w", "<C-W>p", "Other Window")
wm("d", "<C-W>c", "Delete Window")
wm("h", "<C-W>h", "Go to the left window")
wm("H", "<C-W>H", "Move window to far left")
wm("j", "<C-W>j", "Go to the down window")
wm("J", "<C-W>J", "Move window to far bottom")
wm("k", "<C-W>k", "Go to the up window")
wm("K", "<C-W>K", "Move window to far top")
wm("l", "<C-W>l", "Go to the right window")
wm("L", "<C-W>L", "Move window to far right")
wm("m", function() pcall(require("snacks").zen.zoom) end, "Enable Zoom Mode")
wm("o", "<C-W>o", "Close all other windows")
wm("q", "<C-W>q", "Quit a window")
wm("s", "<C-W>s", "Split window")
wm("T", "<C-W>T", "Break out into a new tab")
wm("v", "<C-W>v", "Split window vertically")
wm("x", "<C-W>x", "Swap current with next")
wm("+", "<cmd>resize +2<cr>", "Increase height")
wm("-", "<cmd>resize -2<cr>", "Decrease height")
wm("<", "<cmd>vertical resize -2<cr>", "Decrease width")
wm("=", "<C-W>=", "Equally high and wide")
wm(">", "<cmd>vertical resize +2<cr>", "Increase width")
wm("_", "<C-W>_", "Max out height")
wm("|", "<C-W>|", "Max out width")

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
