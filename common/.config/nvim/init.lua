-- dependencies: tree-sitter-cli, lua-language-server, ocaml-lsp-server, basedpyright, stylua, ruff, ocamlformat, zathura
local packspec = [[
  github/copilot.vim
  ibhagwan/fzf-lua
  stevearc/oil.nvim
  lervag/vimtex
  stevearc/conform.nvim
  nvim-lualine/lualine.nvim
  hrsh7th/nvim-cmp
  hrsh7th/cmp-nvim-lsp
  akinsho/bufferline.nvim
  stevearc/aerial.nvim
  joongwon/overleaf-autosync.nvim
  julian/lean.nvim
  nvim-treesitter/nvim-treesitter
  lewis6991/ts-install.nvim
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
vim.opt.foldcolumn = "1"

vim.g.copilot_no_tab_map = true

vim.g.lean_config = {
  mappings = true,
}

vim.g.vimtex_fold_enabled = 1
vim.g.vimtex_fold_manual = 1
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
  require("aerial").setup {
    backends = { "lsp", "treesitter" },
  }
end)

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
  }
  for _, ft in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact", "yaml", "css" } do
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
  local ts_filetypes = {
    "lua",
    "vim",
    "python",
    "ocaml",
    "javascript",
    "typescript",
    "css",
    "html",
    "json",
    "lean",
  }

  require("ts-install").setup {
    install_dir = vim.fn.stdpath "data" .. "/ts-install",

    ensure_install = ts_filetypes,

    auto_install = true,
    auto_update = true,

    parsers = {
      lean = {
        install_info = {
          url = "https://github.com/Julian/tree-sitter-lean",
          branch = "main",
        },
      },
    },
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = ts_filetypes,
    callback = function(ev)
      pcall(vim.treesitter.start, ev.buf)

      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldenable = false
    end,
  })
end)

safesetup(function()
  require("oil").setup {
    view_options = {
      show_hidden = true,
    },
  }
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
    cmd = { "ocamllsp" },
    filetypes = { "ocaml" },
    root_markers = { { "dune-project" } },
  },
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { { "pyproject.toml" }, { "setup.py" }, { "pyrightconfig.json" } },
  },
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
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
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Toggle code outline" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.keymap.set("n", "<leader>lo", function()
      local tex = vim.api.nvim_get_current_win()
      local qf, out_buf, tmp_out_win

      -- 1. VimtexCompileOutput은 tex buffer/window에서 실행해야 함
      vim.api.nvim_win_call(tex, function()
        vim.cmd "VimtexCompileOutput"
        tmp_out_win = vim.api.nvim_get_current_win()
        out_buf = vim.api.nvim_win_get_buf(tmp_out_win)
      end)

      -- 2. quickfix window 찾기
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "quickfix" then
          qf = win
          break
        end
      end

      -- 3. quickfix가 없으면 아래에 열기
      if qf and vim.api.nvim_win_is_valid(qf) then
        vim.api.nvim_set_current_win(qf)
      else
        vim.api.nvim_set_current_win(tex)
        vim.cmd "botright copen | resize 10"
      end

      -- 4. quickfix 오른쪽에 split 만들고 output buffer 배치
      vim.cmd "rightbelow vertical new"
      local final_out_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(final_out_win, out_buf)

      -- 5. VimTeX가 임의 위치에 열어버린 임시 output 창 닫기
      if
        tmp_out_win
        and tmp_out_win ~= tex
        and tmp_out_win ~= final_out_win
        and vim.api.nvim_win_is_valid(tmp_out_win)
      then
        vim.api.nvim_win_close(tmp_out_win, true)
      end

      -- 6. tex window로 복귀
      pcall(vim.api.nvim_set_current_win, tex)
    end, {
      buffer = true,
      desc = "Open VimTeX output beside quickfix",
    })
  end,
})

-- digraphs
local digraphs = {
  ["O+"] = 0x2295, -- ⊕
  [".["] = 0x230A, -- ⌊
  [".]"] = 0x230B, -- ⌋
  ["[["] = 0x27E6, -- ⟦
  ["]]"] = 0x27E7, -- ⟧
  [".<"] = 0x27E8, -- ⟨
  [".>"] = 0x27E9, -- ⟩
}
for k, v in pairs(digraphs) do
  vim.cmd(("digraph %s %d"):format(k, v))
end
