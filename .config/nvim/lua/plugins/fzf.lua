return {
  "ibhagwan/fzf-lua",
  config = function()
    require("fzf-lua").setup({
      files = {
        hidden = true,
        git_icons = true,
      },
      grep = {
        additional_args = { "--hidden" },
      },
      live_grep = {
        additional_args = { "--hidden" },
      },
    })
  end,
}
