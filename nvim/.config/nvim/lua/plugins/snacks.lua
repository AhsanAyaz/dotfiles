return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
                                              
       ████ ██████           █████      ██
      ███████████             █████ 
      █████████ ███████████████████ ███   ███████████
     █████████  ███    █████████████ █████ ██████████████
    █████████ ██████████ █████████ █████ █████ ████ █████
  ███████████ ███    ███ █████████ █████ █████ ████ █████
 ██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    git = { enabled = true },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            -- Replace <C-S-h> with <C-S-v>
            ["<C-b>"] = { "edit_split", mode = { "i", "n" } }, 
            -- Add any other custom input keys here
          }
        }
      },
      list = {
        keys = {
          -- Also replace <C-S-h> with <C-S-v> here if you want it
          -- to work when the list is focused too
          ["<C-b>"] = { "edit_split", mode = { "i", "n" } },
          -- Add any other custom list keys here
        }
      }
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    { "<leader>sf",       function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
    { "<leader>S",        function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
    { "<leader>gl",       function() Snacks.lazygit.log_file() end,   desc = "Lazygit Log (cwd)" },
    { "<leader>lg",       function() Snacks.lazygit() end,            desc = "Lazygit" },
    { "<C-p>",            function() Snacks.picker.pick("files") end, desc = "Find Files" },
    { "<leader><leader>", function() Snacks.picker.recent() end,      desc = "Recent Files" },
    { "<leader>fb",       function() Snacks.picker.buffers() end,     desc = "Buffers" },
    -- { "<leader>fg",       function() Snacks.picker.grep() end,        desc = "Grep Files" },
    { "<C-n>",            function() Snacks.explorer() end,           desc = "Explorer" },
  }
}
