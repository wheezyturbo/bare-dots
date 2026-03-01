return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "NvimTree Find File" },
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Load default mappings first
        api.config.mappings.default_on_attach(bufnr)

        -- Navigation with h/l (vim-style)
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open/Expand"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
        vim.keymap.set("n", "L", api.tree.expand_all, opts("Expand All"))

        -- File operations
        vim.keymap.set("n", "a", api.fs.create, opts("Create File/Folder"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.fs.rename_full, opts("Rename (Full Path)"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

        -- Open in splits/tabs
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))

        -- Filters
        vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))

        -- Other
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<Esc>", api.tree.close, opts("Close"))
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        -- Sync with project root
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        -- UI
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
          indent_markers = {
            enable = true,
          },
        },
        -- Git integration
        git = {
          enable = true,
          ignore = false,
        },
        -- Filters
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" },
        },
        -- Actions
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
        -- View
        view = {
          width = 35,
          side = "left",
        },
      })
    end,
  },
}
