return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    -- textobjects queries must be on rtp before mini.ai starts
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local ts = require("nvim-treesitter")

    ts.setup({
      ensure_installed = {
        "lua", "vim", "vimdoc",
        -- Go
        "go", "gomod", "gosum", "gowork",
        -- Web / TS
        "typescript", "javascript", "tsx", "html", "css",
        -- Infra
        "terraform", "hcl", "dockerfile", "yaml", "json", "toml",
        -- Docs / Shell
        "markdown", "markdown_inline", "bash",
        -- Comment highlighting
        "comment",
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.language.inspect, lang) then
          vim.treesitter.start(args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
