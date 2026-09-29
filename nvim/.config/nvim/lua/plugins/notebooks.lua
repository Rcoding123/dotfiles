-- Jupyter notebooks:
--   jupytext.nvim converts .ipynb JSON to Markdown while editing
--   quarto-nvim + otter provide Python LSP features inside fenced cells
--   molten-nvim executes those cells with the existing Jupyter kernel

local python_host = vim.g.python3_host_prog
  or "/home/ron/miniforge3/envs/data-science/bin/python"
local python_bin = vim.fn.fnamemodify(python_host, ":h")

local function notebook_maps(buf)
  local runner = require("quarto.runner")
  local function bmap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
  end

  local function run_current_cell(advance)
    -- Modified Enter should execute from either editing or normal mode. Match
    -- Jupyter's behavior by returning to normal mode after execution.
    if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
      vim.cmd.stopinsert()
    end

    runner.run_cell()

    if advance then
      vim.schedule(function()
        if vim.api.nvim_get_current_buf() ~= buf then
          return
        end

        -- Jupytext's Markdown representation marks Python cells with fenced
        -- code blocks. Put the cursor on the first line of the next cell.
        local next_fence = vim.fn.search([[^```.*python.*$]], "W")
        if next_fence > 0 and next_fence < vim.api.nvim_buf_line_count(buf) then
          vim.api.nvim_win_set_cursor(0, { next_fence + 1, 0 })
        end
      end)
    end
  end

  -- Kernel lifecycle and output controls.
  bmap("n", "<localleader>mi", "<cmd>MoltenInit python3<CR>", "Start Python notebook kernel")
  bmap("n", "<localleader>mI", "<cmd>MoltenImportOutput<CR>", "Import saved notebook outputs")
  bmap("n", "<localleader>mE", "<cmd>MoltenExportOutput!<CR>", "Export outputs to notebook")
  bmap("n", "<localleader>mo", "<cmd>noautocmd MoltenEnterOutput<CR>", "Open notebook output")
  bmap("n", "<localleader>mh", "<cmd>MoltenHideOutput<CR>", "Hide notebook output")
  bmap("n", "<localleader>mx", "<cmd>MoltenInterrupt<CR>", "Interrupt notebook kernel")
  bmap("n", "<localleader>mr", "<cmd>MoltenRestart<CR>", "Restart notebook kernel")
  bmap("n", "<localleader>mq", "<cmd>MoltenDeinit<CR>", "Stop notebook kernel")

  -- Cell execution. The first run prompts to initialize if <leader>mi was not
  -- used yet; with this setup the available/default kernel is python3.
  bmap("n", "<localleader>rc", runner.run_cell, "Run current notebook cell")
  bmap("n", "<localleader>ra", runner.run_above, "Run current cell and above")
  bmap("n", "<localleader>rb", runner.run_below, "Run current cell and below")
  bmap("n", "<localleader>rA", runner.run_all, "Run all Python cells")
  bmap("n", "<localleader>rl", runner.run_line, "Run current line")
  bmap("v", "<localleader>r", runner.run_range, "Run visual selection")

  -- Familiar Jupyter bindings. Modern terminals expose modified Enter keys
  -- through CSI-u/modifyOtherKeys; the leader mappings above remain fallbacks.
  bmap({ "n", "i" }, "<C-CR>", function()
    run_current_cell(false)
  end, "Run current cell and stay")
  bmap({ "n", "i" }, "<S-CR>", function()
    run_current_cell(true)
  end, "Run current cell and move to next")
end

return {
  {
    -- This maintained implementation can use an absolute Jupytext path and
    -- safely preserves existing notebook outputs when the Markdown is saved.
    "goerz/jupytext.nvim",
    version = "0.2.0",
    lazy = false,
    opts = {
      jupytext = python_bin .. "/jupytext",
      format = "md:markdown",
      update = true,
      autosync = true,
    },
  },

  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    lazy = false,
    build = ":UpdateRemotePlugins",
    init = function()
      -- Text output is dependable in every terminal. Inline images require a
      -- terminal-specific backend, so leave the provider disabled by default.
      vim.g.molten_image_provider = "none"
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_text_max_lines = 20
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_wrap_output = true
      vim.g.molten_output_show_more = true
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_output_win_border = "rounded"
      vim.g.molten_tick_rate = 200
    end,
  },

  {
    "quarto-dev/quarto-nvim",
    version = "^2.0.0",
    lazy = false,
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local quarto = require("quarto")
      quarto.setup({
        lspFeatures = {
          enabled = true,
          chunks = "all",
          languages = { "python" },
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = { enabled = true },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
          never_run = { "yaml" },
        },
      })

      local group = vim.api.nvim_create_augroup("fc_notebooks", { clear = true })

      -- jupytext.nvim emits BufReadPost after converting the notebook, so this
      -- is the point where Quarto can discover the fenced Python cells.
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = group,
        pattern = "*.ipynb",
        callback = function(ev)
          vim.api.nvim_buf_call(ev.buf, function()
            quarto.activate()
          end)
          notebook_maps(ev.buf)
        end,
      })

      -- When a kernel starts, restore outputs already stored in the notebook.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MoltenKernelReady",
        callback = function()
          if vim.api.nvim_buf_get_name(0):match("%.ipynb$") then
            pcall(vim.cmd, "MoltenImportOutput")
          end
        end,
      })

      -- After Jupytext writes edited inputs, persist outputs from cells run in
      -- Molten. pcall keeps ordinary saves quiet when no kernel is active.
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = "*.ipynb",
        callback = function()
          local ok, status = pcall(require, "molten.status")
          if ok and status.initialized() == "Molten" then
            pcall(vim.cmd, "MoltenExportOutput!")
          end
        end,
      })
    end,
  },
}
