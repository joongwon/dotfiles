-- dependencies: tree-sitter-cli, lua-language-server, ocaml-lsp-server, basedpyright, stylua, ruff, ocamlformat, zathura
vim.pack.add {
  "https://github.com/github/copilot.vim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/lervag/vimtex",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/akinsho/bufferline.nvim",
}

local cmp = require "cmp"
cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping.confirm { select = true },
    ["<C-Space>"] = cmp.mapping.complete(),
  },
  sources = {
    { name = "nvim_lsp" },
  },
}

require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    show_buffer_icons = false,
    show_buffer_close_icons = false,
  },
}

require("lualine").setup {
  options = {
    theme = "auto",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        symbols = {},
      },
    },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}

local conform = require "conform"
conform.setup {
  formatters_by_ft = {
    ["*"] = { "trim_whitespace" },
    lua = { "stylua" },
    python = { "ruff_format" },
    ocaml = { "ocamlformat" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

for _, viewer in ipairs { "zathura", "skim" } do
  if vim.fn.executable(viewer) == 1 then
    vim.g.vimtex_view_method = viewer
    break
  end
end

vim.g.copilot_no_tab_map = true

local ts = require "nvim-treesitter"
ts.setup {}
local ts_filetypes = {
  "python",
  "lua",
  "vim",
  "ocaml",
}
ts.install(ts_filetypes)
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

require("oil").setup {}

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.list = true
vim.opt.listchars = "tab:→ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨"
vim.opt.showbreak = "+++>"

---@type table<string, vim.lsp.Config>
local lspcfgs = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json" }, { ".luarc.jsonc" } },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
      },
    },
  },
  ocamllsp = {
    cmd = { "opam", "exec", "--", "ocamllsp" },
    filetypes = { "ocaml" },
    root_markers = { { "dune-project" }, { "_opam" } },
  },
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { { "pyproject.toml" }, { "setup.py" } },
  },
}
for name, config in pairs(lspcfgs) do
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

local fzf = require "fzf-lua"

vim.diagnostic.config {
  virtual_text = true,
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<leader>fc", function()
  fzf.files { cwd = "~/.config", follow = true }
end, { desc = "Find config files" })
vim.keymap.set("n", "<leader>f", function()
  conform.format {
    async = true,
    lsp_fallback = true,
  }
end, { desc = "Format file" })
vim.keymap.set("i", "<C-M-;>", 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false,
  desc = "Accept Copilot suggestion",
})
vim.keymap.set("i", "<M-;>", "<plug>(copilot-accept-word)", {
  desc = "Accept Copilot suggestion word by word",
})
vim.keymap.set("i", "<C-;>", "<plug>(copilot-accept-line)", {
  desc = "Accept Copilot suggestion line by line",
})
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
