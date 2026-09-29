-- lua/plugins/debugger.lua
-- On-demand Python/C++ debugging. The UI stays out of the way until a session starts.

return {
  {
    "mfussenegger/nvim-dap",
    cond = vim.fn.has("nvim-0.12") == 1,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: start / continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: terminate" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Debug: evaluate" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "||",
            play = ">",
            step_into = "↓",
            step_over = "→",
            step_out = "↑",
            step_back = "←",
            run_last = "↻",
            terminate = "■",
            disconnect = "×",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "stacks", size = 0.25 },
              { id = "breakpoints", size = 0.20 },
              { id = "watches", size = 0.20 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.55 },
              { id = "console", size = 0.45 },
            },
            position = "bottom",
            size = 12,
          },
        },
        floating = { border = "rounded" },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
      vim.fn.sign_define("DapLogPoint", { text = "!", texthl = "DiagnosticInfo" })

      local mason = vim.fn.stdpath("data") .. "/mason"
      local debugpy_python = mason .. "/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy_python)

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason .. "/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
