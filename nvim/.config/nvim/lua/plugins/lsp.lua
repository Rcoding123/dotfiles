-- lua/plugins/lsp.lua
-- mason installs servers, mason-lspconfig enables them, we layer settings on top.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Completion capabilities from nvim-cmp, applied to every server
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- clangd: the main event
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",             -- index whole project in background
          "--clang-tidy",                   -- inline clang-tidy diagnostics
          "--header-insertion=never",       -- complete only from existing includes
          "--all-scopes-completion=false",  -- hide out-of-scope index symbols
          "--completion-style=detailed",
          "--function-arg-placeholders",    -- completions insert arg placeholders
          "--fallback-style=llvm",          -- when no .clang-format exists
        },
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          offsetEncoding = { "utf-16" },
        }),
      })

      -- pyright: types, hover, go-to-def, completion (like clangd, minus diagnostics-as-lint)
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              autoImportCompletions = false,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- ruff: diagnostics/lint via LSP; formatting is handled separately by conform.nvim
      vim.lsp.config("ruff", {
        init_options = {
          settings = {
            -- pyright already does hover/type info; keep ruff to diagnostics
            hover = { enable = false },
          },
        },
      })

      -- lua_ls: teach it about the nvim runtime so this config gets completion
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Auto-install + auto-enable
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "lua_ls", "bashls", "pyright", "ruff" },
      })

      -- Diagnostics presentation
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = false,
        virtual_lines = false,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN]  = "W",
            [vim.diagnostic.severity.INFO]  = "I",
            [vim.diagnostic.severity.HINT]  = "H",
          },
        },
      })

      -- Buffer-local keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("fc_lsp_attach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local tb = require("telescope.builtin")
          local function bmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          bmap("n", "gd", tb.lsp_definitions,      "Goto definition")
          bmap("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
          bmap("n", "gr", tb.lsp_references,       "References")
          bmap("n", "gi", tb.lsp_implementations,  "Goto implementation")
          bmap("n", "K",  vim.lsp.buf.hover,       "Hover docs")
          bmap("n", "<leader>rn", vim.lsp.buf.rename,      "Rename symbol")
          bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          bmap("n", "<leader>cf", function()
            local ok, conform = pcall(require, "conform")
            if ok and #conform.list_formatters(buf) > 0 then
              conform.format({ async = true, lsp_fallback = true })
            else
              vim.lsp.buf.format({ async = true })
            end
          end, "Format (conform / clang-format / LSP)")
          bmap("n", "<leader>th", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
          end, "Toggle inlay hints")

          -- clangd extra: flip between .cpp and .h
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "clangd" then
            bmap("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<CR>",
              "Switch source/header")
          end
        end,
      })
    end,
  },
}
