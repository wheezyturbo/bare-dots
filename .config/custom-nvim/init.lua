-- map leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- load the config
require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
