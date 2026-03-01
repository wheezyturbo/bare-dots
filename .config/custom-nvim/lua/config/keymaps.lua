
local fzf = require("fzf-lua")
map = vim.keymap.set


map("n", "vig", "ggVG", { noremap = true })
map("n", "yig", "ggVGy", { noremap = true })
-- map("n", "<leader>e", ":Lexplore 20<CR>", { noremap = true, silent = true })
-- map("n", "<C-/>", ":term<CR>", { noremap = true })

pcall(vim.keymap.del, "n", "<C-h>")
pcall(vim.keymap.del, "n", "<C-j>")
pcall(vim.keymap.del, "n", "<C-k>")
pcall(vim.keymap.del, "n", "<C-L>")

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Terminal window navigation
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

map("n", "<leader>wd", "<C-w>q", { noremap = true, silent = true })
map("n", "<leader>wd", "<C-w>q", { noremap = true, silent = true })


-- Move lines up and down in Normal mode
map("n", "<M-j>", "<cmd>m .+1<cr>== ", { desc = "Move Down" })
map("n", "<M-k>", "<cmd>m .-2<cr>== ", { desc = "Move Up" })

-- Move lines up and down in Insert mode
map("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

-- Move selection up and down in Visual mode
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })



-- quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })


-- General Search
map("n", "<leader><leader>", function() fzf.files() end, { desc = "Fzf Files" })
map("n", "<leader>/", function() fzf.live_grep() end, { desc = "Fzf Live Grep" })
map("n", "<leader>fb", function() fzf.buffers() end, { desc = "Fzf Buffers" })
map("n", "<leader>fr", function() fzf.resume() end, { desc = "Fzf Resume" })

-- Code & Cursor
map("n", "<leader>fw", function() fzf.grep_cword() end, { desc = "Fzf Grep Word" })
map("n", "<leader>fc", function() fzf.lgrep_curbuf() end, { desc = "Fzf Search Buffer" })

-- History & Git
map("n", "<leader>fo", function() fzf.oldfiles() end, { desc = "Fzf Recent Files" })
map("n", "<leader>gf", function() fzf.git_files() end, { desc = "Fzf Git Files" })

vim.keymap.set("n", "<leader>uC", "<cmd>FzfLua colorschemes<cr>", { desc = "Colorschemes" })


-- Navigate Tabs with Shift + h/l
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Go to left buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Go to right buffer" })
-- Optional: Move current tab left or right (like moving chrome tabs)
vim.keymap.set("n", "<leader>t[", "<cmd>-tabmove<cr>", { desc = "Move tab left" })
vim.keymap.set("n", "<leader>t]", "<cmd>+tabmove<cr>", { desc = "Move tab right" })


map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer and Close Tab" })


-- lazygit
map("n", "<leader>gg", "<cmd>LazyGit<cr>", {desc = "Spawn lazygit"})
