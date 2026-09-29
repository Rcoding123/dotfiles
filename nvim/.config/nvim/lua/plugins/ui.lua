-- lua/plugins/ui.lua

local function active_lsp_clients()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name ~= "copilot" then
      names[#names + 1] = client.name
    end
  end
  table.sort(names)
  return #names > 0 and ("lsp:" .. table.concat(names, ",")) or ""
end

local function python_environment()
  if vim.bo.filetype ~= "python" then
    return ""
  end
  local environment = vim.env.CONDA_DEFAULT_ENV or vim.env.VIRTUAL_ENV
  if environment and environment ~= "" then
    return "env:" .. vim.fn.fnamemodify(environment, ":t")
  end
  return ""
end

local statusline_colors = {
  bg = "#030712",
  surface = "#07121E",
  surface_blue = "#0D2030",
  fg = "#D6E6F0",
  muted = "#4E6A7D",
  blue = "#43D9FF",
  green = "#7CFFB2",
  amber = "#FFC857",
  pink = "#FF5FA3",
  purple = "#69A7FF",
}

local statusline_theme = {
  normal = {
    a = { fg = statusline_colors.bg, bg = statusline_colors.blue, gui = "bold" },
    b = { fg = statusline_colors.blue, bg = statusline_colors.surface_blue },
    c = { fg = statusline_colors.fg, bg = statusline_colors.surface },
  },
  insert = {
    a = { fg = statusline_colors.bg, bg = statusline_colors.green, gui = "bold" },
  },
  visual = {
    a = { fg = statusline_colors.bg, bg = statusline_colors.purple, gui = "bold" },
  },
  replace = {
    a = { fg = statusline_colors.bg, bg = statusline_colors.pink, gui = "bold" },
  },
  command = {
    a = { fg = statusline_colors.bg, bg = statusline_colors.amber, gui = "bold" },
  },
  inactive = {
    a = { fg = statusline_colors.muted, bg = statusline_colors.surface },
    b = { fg = statusline_colors.muted, bg = statusline_colors.surface },
    c = { fg = statusline_colors.muted, bg = statusline_colors.bg },
  },
}

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = statusline_theme,
        section_separators = "",     -- flat, no powerline arrows
        component_separators = "│",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = "[+]", readonly = "[RO]", unnamed = "[No Name]", newfile = "[New]" },
          },
        },
        lualine_x = {
          { "diagnostics", symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " } },
          python_environment,
          active_lsp_clients,
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Quiet LSP progress in the corner; disappears when work is finished.
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "LspAttach",
    opts = {
      progress = { display = { done_ttl = 1 } },
      notification = { window = { winblend = 0 } },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Keybind discovery popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = { border = "rounded" },
      icons = { mappings = false },
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>h", group = "Git hunks" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>t", group = "Toggle" },
        { "<leader>b", group = "Buffer" },
        { "<leader>m", group = "Notebook kernel" },
        { "<leader>r", group = "Notebook run" },
      },
    },
  },

  -- Project-wide diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (project)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Symbols outline" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
  },
}
