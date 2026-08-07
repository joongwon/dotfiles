-- dependencies: tree-sitter-cli, lua-language-server, ocaml-lsp-server, basedpyright, stylua, ruff, ocamlformat, zathura, fzf, fd, ripgrep

-- vim options
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
vim.opt.conceallevel = 2

-- vim conceal higlight
vim.api.nvim_set_hl(0, "Conceal", { fg = "#5c6370" })

-- vim diagnostic
vim.diagnostic.config { virtual_text = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- vim lsp keymaps
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- miscellaneous keymaps
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- jsonc disable false positive highlight
vim.api.nvim_create_autocmd("FileType", {
  pattern = "jsonc",
  callback = function()
    vim.api.nvim_set_hl(0, "jsonTrailingCommaError", {})
  end,
})

-- digraphs
require "digraphs"

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
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
  },
}
for name, config in pairs(lspcfgs) do
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

-- plugins
---@type table<string, function|boolean>
local plugins = {
  ["github/copilot.vim"] = function()
    vim.g.copilot_no_tab_map = true
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
  end,

  ["leanprover/lean.nvim"] = function()
    vim.g.lean_config = {
      mappings = true,
    }
  end,

  ["lervag/vimtex"] = function()
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_fold_manual = 1
    if vim.fn.executable "zathura" == 1 then
      vim.g.vimtex_view_method = "zathura"
    elseif vim.fn.has "mac" == 1 then
      vim.g.vimtex_view_method = "skim"
    end
    vim.g.vimtex_syntax_custom_cmds = {
      { name = "left", mathmode = 1, conceal = 1 },
      { name = "right", mathmode = 1, conceal = 1 },
    }
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      texTabularChar = 1,
      spacing = 1,
      greek = 1,
      math_bounds = 0,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 0,
      styles = 1,
    }

    -- vimtex output beside quickfix
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
  end,

  ["stevearc/aerial.nvim"] = function()
    require("aerial").setup {
      backends = { "lsp", "treesitter" },
    }
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Toggle code outline" })
  end,

  ["joongwon/overleaf-autosync.nvim"] = function()
    require("overleaf_autosync").setup {
      whitelist_file = ".overleafwl",
      auto_push = true,
      debounce_ms = 1500,
    }
  end,

  ["hrsh7th/cmp-nvim-lsp"] = true,
  ["hrsh7th/nvim-cmp"] = function()
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
  end,

  ["akinsho/bufferline.nvim"] = function()
    require("bufferline").setup {
      options = {
        mode = "tabs",
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
      },
    }
  end,

  ["nvim-lualine/lualine.nvim"] = function()
    local function vimtex_status()
      local vimtex = vim.b.vimtex
      local compiler = vimtex and vimtex.compiler

      if not compiler then
        return ""
      end

      return ({
        [1] = "TeX ⟳",
        [2] = "TeX ✓",
        [3] = "TeX ✗",
      })[compiler.status] or ""
    end
    local lualine = require "lualine"
    lualine.setup {
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
        lualine_x = { vimtex_status, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }
    vim.api.nvim_create_autocmd("User", {
      pattern = {
        "VimtexEventCompiling",
        "VimtexEventCompileSuccess",
        "VimtexEventCompileFailed",
        "VimtexEventCompileStopped",
      },
      callback = function()
        lualine.refresh {
          place = { "statusline" },
        }
      end,
    })
  end,

  ["stevearc/conform.nvim"] = function()
    local conform = require "conform"
    local formatters_inv = {
      trim_whitespace = { "*" },
      stylua = { "lua" },
      ruff_format = { "python" },
      ocamlformat = { "ocaml" },
      prettierd = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "yaml",
        "css",
        "html",
        "json",
        "jsonc",
      },
    }
    local formatters = {}
    for name, fts in pairs(formatters_inv) do
      for _, ft in ipairs(fts) do
        if not formatters[ft] then
          formatters[ft] = {}
        end
        table.insert(formatters[ft], name)
      end
    end
    conform.setup {
      formatters_by_ft = formatters,
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    }
    vim.keymap.set("n", "<leader>F", function()
      conform.format {
        async = true,
        lsp_fallback = true,
      }
    end, { desc = "Format file" })
  end,

  ["nvim-treesitter/nvim-treesitter"] = true,
  ["lewis6991/ts-install.nvim"] = function()
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
  end,

  ["stevearc/oil.nvim"] = function()
    require("oil").setup {
      view_options = {
        show_hidden = true,
      },
    }
  end,

  ["reasonml-editor/vim-reason-plus"] = true,

  ["ibhagwan/fzf-lua"] = function()
    local fzf = require "fzf-lua"

    local base_fd = "fd --color=never -tf -td -tl -u -E .git -E node_modules -E __pycache__ -E .venv -- . "
    local base_rg =
      "rg --color=never --hidden --glob '!.git/*' --glob '!node_modules/*' --glob '!__pycache__/*' --glob '!.venv/*' "
    vim.keymap.set("n", "<leader>ff", function()
      return fzf.fzf_exec(base_fd, { prompt = "files> ", actions = fzf.defaults.actions.files })
    end, { desc = "FZF Find files" })
    vim.keymap.set("n", "<leader>fc", function()
      return fzf.fzf_exec(base_fd .. "~/dotfiles", { prompt = "dotfiles> ", actions = fzf.defaults.actions.files })
    end, { desc = "FZF Find config files" })
    vim.keymap.set("n", "<leader>fg", function()
      return fzf.fzf_live(base_rg, { prompt = "grep> ", actions = fzf.defaults.actions.files })
    end, { desc = "FZF Ripgrep" })
  end,
}

---@type table<string, string>
local packs = {}

for name in pairs(plugins) do
  table.insert(packs, "https://github.com/" .. name)
end

vim.pack.add(packs)

for name, setup in pairs(plugins) do
  if type(setup) == "function" then
    local ok, err = pcall(setup)
    if not ok then
      vim.notify("Error setting up plugin " .. name .. ": " .. err, vim.log.levels.ERROR)
    end
  elseif setup ~= true then
    vim.notify("Invalid setup for plugin " .. name, vim.log.levels.ERROR)
  end
end
