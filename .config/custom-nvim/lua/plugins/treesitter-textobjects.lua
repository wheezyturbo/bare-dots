-- nvim-treesitter-textobjects must NOT be lazy — mini.ai's gen_spec.treesitter
-- needs the query files registered at startup time.
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
