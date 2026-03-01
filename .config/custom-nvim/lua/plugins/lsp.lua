return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "vtsls",
          "terraformls",
          "yamlls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "ibhagwan/fzf-lua", -- Added as a dependency for the keymaps
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      -- LSP Keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local fzf = require("fzf-lua")

          -- Navigation (Now using FzfLua)
          vim.keymap.set("n", "gd", fzf.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Fzf Goto definition" }))
          vim.keymap.set("n", "gr", fzf.lsp_references, vim.tbl_extend("force", opts, { desc = "Fzf Show references" }))
          vim.keymap.set("n", "gi", fzf.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Fzf Goto implementation" }))
          vim.keymap.set("n", "gt", fzf.lsp_typedefs, vim.tbl_extend("force", opts, { desc = "Fzf Goto type definition" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

          -- Documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

          -- Actions (FzfLua provides a better UI for code actions via register_ui_select)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

          -- Symbols & Diagnostics via Fzf
          vim.keymap.set("n", "<leader>ss", fzf.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))
          vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
        end,
      })

      -- Define LSP server configurations
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        },
      })

      vim.lsp.config("vtsls", { capabilities = capabilities })
      vim.lsp.config("terraformls", { capabilities = capabilities })
      vim.lsp.config("yamlls", { capabilities = capabilities })

      -- Enable all configured LSP servers
      vim.lsp.enable({ "lua_ls", "gopls", "vtsls", "terraformls", "yamlls" })
    end,
  },
}
