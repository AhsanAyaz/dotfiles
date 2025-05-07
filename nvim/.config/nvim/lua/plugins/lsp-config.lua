return {
  -- Mason manages LSP server installations
  {
    "williamboman/mason.nvim",
    lazy = false, -- Load Mason eagerly or on first command/event
    config = function()
      require("mason").setup({
        -- You can add UI preferences or other Mason settings here
        -- ui = { border = "rounded" }
      })
    end,
  },

  -- Mason-lspconfig bridges Mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false, -- Load early to ensure servers are ready
    opts = {
      -- A list of servers readily available from mason.nvim.
      -- Add any other LSPs you use here (e.g., 'cssls', 'html', 'jsonls', 'eslint', 'bashls', 'dockerls', 'yamlls')
      ensure_installed = {
        "tsserver",                 -- TypeScript/JavaScript Language Server
        "tailwindcss",            -- Tailwind CSS Language Server
        "lua_ls",                 -- Lua Language Server (for Neovim config)
        "cssls",
        "html",
        "jsonls",
        "eslint",
        "bashls",
        "dockerls",
        "yamlls",
        "python-lsp-server",

        -- "ruby_lsp",            -- Keep if you use Ruby
        -- Add Angular Language Service if needed (often works well with tsserver, but can provide more Angular specifics)
        "angularls",
      },
      -- Auto-install servers listed in ensure_installed (useful first time)
      automatic_installation = true, -- Renamed from auto_install in newer versions, check plugin docs if needed
    },
    -- No specific config function needed here anymore,
    -- as nvim-lspconfig below will handle the setup using mason-lspconfig's handlers.
  },

  -- nvim-lspconfig handles the actual configuration and attaching of LSPs
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Make sure you have nvim-cmp and this source installed
      -- Add other dependencies like cmp-buffer, cmp-path, luasnip if you use them
      "williamboman/mason-lspconfig.nvim", -- Ensures this runs after mason-lspconfig
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities() -- Use capabilities from nvim-cmp

      -- Optional: If you want specific settings for certain servers,
      -- you can still define them here or within the handlers below.
      -- Example: Overriding cmd for ruby_lsp if needed
      -- local servers = {
      --   ruby_lsp = {
      --     cmd = { "/home/typecraft/.asdf/shims/ruby-lsp" }
      --   }
      --   -- Add other server-specific overrides here
      -- }

      -- Define a shared on_attach function for consistent keymaps
      local on_attach = function(client, bufnr)
        -- Use the keymaps from the example, adapted slightly
        local opts = { buffer = bufnr, noremap = true, silent = true }
        local keymap = vim.keymap.set -- Use vim.keymap.set for Neovim 0.7+

        -- Note: Use <leader>gd if you prefer that over default gd
        -- keymap('n', 'gd', vim.lsp.buf.definition, opts) -- Built-in gd often works well
        keymap('n', '<leader>gd', '<cmd>Telescope lsp_definitions<CR>', opts) -- Or use Telescope
        keymap('n', 'K', vim.lsp.buf.hover, opts)
        keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts) -- Use Telescope for implementations
        keymap('n', '<leader>D', vim.lsp.buf.type_definition, opts) -- Go to Type Definition
        keymap('n', '<leader>ds', '<cmd>Telescope lsp_document_symbols<CR>', opts)
        keymap('n', '<leader>ws', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
        keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts) -- Use Telescope for references
        keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
        keymap('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts) -- Format buffer

        -- Diagnostics
        keymap('n', '<leader>d', vim.diagnostic.open_float, opts)
        keymap('n', '[d', vim.diagnostic.goto_prev, opts)
        keymap('n', ']d', vim.diagnostic.goto_next, opts)

        -- Optional: If the server supports inlay hints
        if client.supports_method("textDocument/inlayHint") then
            keymap('n', '<leader>ih', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, opts)
        end

        -- Set other buffer-local options if needed
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        print("LSP attached: " .. client.name)
      end

      -- Get the list of servers setup by mason-lspconfig
      local servers_to_setup = require("mason-lspconfig").get_installed_servers() -- Or use opts.ensure_installed if preferred

      for _, server_name in ipairs(servers_to_setup) do
        -- Default settings for most servers
        local server_opts = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        -- Apply specific overrides if needed (e.g., the ruby_lsp cmd path)
        if server_name == "ruby_lsp" then
          server_opts.cmd = { "/home/typecraft/.asdf/shims/ruby-lsp" }
        end
        if server_name == "lua_ls" then
          -- Apply specific settings for lua_ls needed for Neovim config development
           require('lspconfig').lua_ls.setup(vim.tbl_deep_extend("force", server_opts, {
              settings = {
                  Lua = {
                      runtime = { version = 'LuaJIT' },
                      diagnostics = { globals = {'vim'} },
                      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                      telemetry = { enable = false },
                  },
              },
          }))
        else
          -- Setup server with default opts
          lspconfig[server_name].setup(server_opts)
        end
      end
    end,
  },

  -- Make sure you have nvim-cmp configured as well
  -- Example minimal nvim-cmp setup (add this if you don't have one)
  -- {
  --   'hrsh7th/nvim-cmp',
  --   event = "InsertEnter",
  --   dependencies = {
  --     'hrsh7th/cmp-nvim-lsp', -- Source for LSP
  --     'hrsh7th/cmp-buffer',  -- Source for buffer words
  --     'hrsh7th/cmp-path',    -- Source for paths
  --     'L3MON4D3/LuaSnip',   -- Required for snippet support
  --     'saadparwaiz1/cmp_luasnip', -- Bridge between cmp and LuaSnip
  --   },
  --   config = function()
  --     local cmp = require('cmp')
  --     local luasnip = require('luasnip')
  --
  --     cmp.setup({
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ['<C-k>'] = cmp.mapping.select_prev_item(), -- Previous item
  --         ['<C-j>'] = cmp.mapping.select_next_item(), -- Next item
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --         ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
  --         ['<C-e>'] = cmp.mapping.abort(),      -- Close completion
  --         ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
  --         ["<Tab>"] = cmp.mapping(function(fallback) -- Tab completion / snippet navigation
  --           if cmp.visible() then
  --             cmp.select_next_item()
  --           elseif luasnip.expand_or_jumpable() then
  --             luasnip.expand_or_jump()
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --         ["<S-Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_prev_item()
  --           elseif luasnip.jumpable(-1) then
  --             luasnip.jump(-1)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --       }),
  --       sources = cmp.config.sources({
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'buffer' },
  --         { name = 'path' },
  --       }),
  --       -- Optional: Add nice borders and formatting
  --       -- window = {
  --       --   completion = cmp.config.window.bordered(),
  --       --   documentation = cmp.config.window.bordered(),
  --       -- },
  --     })
  --   end,
  -- },
}
