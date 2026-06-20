-- dependencies: tree-sitter-cli, lua-language-server, ocaml-lsp-server, basedpyright, stylua, ruff, ocamlformat, zathura
local packspec = [[
  copilot.vim
  ibhagwan/fzf-lua
  stevearc/oil.nvim
  nvim-treesitter/nvim-treesitter
  lervag/vimtex
  stevearc/conform.nvim
  nvim-lualine/lualine.nvim
  hrsh7th/nvim-cmp
  hrsh7th/cmp-nvim-lsp
  akinsho/bufferline.nvim
  stevearc/aerial.nvim
  joongwon/overleaf-autosync.nvim
]]

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
vim.opt.title = true

vim.g.copilot_no_tab_map = true

if vim.fn.executable "zathura" == 1 then
  vim.g.vimtex_view_method = "zathura"
elseif vim.fn.has "mac" == 1 then
  vim.g.vimtex_view_method = "skim"
end

local packs = {}
for p in packspec:gmatch "%S+" do
  table.insert(packs, "https://github.com/" .. p)
end
vim.pack.add(packs)

local function safesetup(f)
  local ok, err = pcall(f)
  if not ok then
    vim.notify("Error setting up plugin: " .. err, vim.log.levels.ERROR)
  end
end

safesetup(function()
  require("overleaf_autosync").setup {
    whitelist_file = ".overleafwl",
    auto_push = true,
    debounce_ms = 1500,
  }
end)

safesetup(function()
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
end)

safesetup(function()
  require("bufferline").setup {
    options = {
      mode = "tabs",
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      show_buffer_icons = false,
      show_buffer_close_icons = false,
    },
  }
end)

safesetup(function()
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
end)

safesetup(function()
  local conform = require "conform"
  local formatters = {
    ["*"] = { "trim_whitespace" },
    lua = { "stylua" },
    python = { "ruff_format" },
    ocaml = { "ocamlformat" },
    yaml = { "prettierd" },
  }
  for _, ft in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact" } do
    formatters[ft] = { "prettierd" }
  end
  conform.setup {
    formatters_by_ft = formatters,
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
  }
  vim.keymap.set("n", "<leader>f", function()
    conform.format {
      async = true,
      lsp_fallback = true,
    }
  end, { desc = "Format file" })
end)

safesetup(function()
  local ts = require "nvim-treesitter"
  ts.setup {}
  local ts_filetypes = {
    "python",
    "lua",
    "vim",
    "ocaml",
    "javascript",
    "typescript",
  }
  ts.install(ts_filetypes)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ts_filetypes,
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end)

safesetup(function()
  require("oil").setup {}
end)

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
    root_markers = { { "dune-project" } },
  },
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { { "pyproject.toml" }, { "setup.py" }, { "pyrightconfig.json" } },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { { "package.json" } },
  },
}
for name, config in pairs(lspcfgs) do
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

safesetup(function()
  local fzf = require "fzf-lua"
  vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "List buffers" })
  vim.keymap.set("n", "<leader>fc", function()
    fzf.files { cwd = "~/.config", follow = true }
  end, { desc = "Find config files" })
end)

vim.diagnostic.config {
  virtual_text = true,
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
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
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
