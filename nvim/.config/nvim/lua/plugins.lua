return {
  "nvim-telescope/telescope-ui-select.nvim",
  "debugloop/telescope-undo.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },
  { 'joeveiga/ng.nvim'},
  { 'brenoprata10/nvim-highlight-colors' },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  }
}
