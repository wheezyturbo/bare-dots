return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false, -- Load on startup to install parsers
  config = function()
    local ts = require("nvim-treesitter")

    -- Setup parser installation directory
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install parsers for your DevOps/Web stack
    ts.install({
      "lua",
      "vim",
      "vimdoc",
      "go",
      "gomod",
      "gosum",
      "terraform",
      "hcl",
      "typescript",
      "javascript",
      "tsx",
      "yaml",
      "dockerfile",
      "json",
      "markdown",
      "markdown_inline",
      "bash",
    })

    -- Enable treesitter highlighting and indentation for all filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        -- Check if parser exists for this filetype
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.language.inspect, lang) then
          -- Enable treesitter highlighting
          vim.treesitter.start(args.buf, lang)
          -- Enable treesitter-based indentation
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Enable treesitter-based folding (optional, disabled by default)
    -- vim.opt.foldmethod = "expr"
    -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- vim.opt.foldenable = false -- Start with folds open
  end,
}
