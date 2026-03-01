-- Bootstrap lazy.nvim and load configuration
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Load core configuration
require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
