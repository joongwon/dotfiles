vim.pack.add{
  'https://github.com/github/copilot.vim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

vim.keymap.set('i', '<C-M-;>', 'copilot#Accept("")', {
  expr = true, replace_keycodes = false,
  desc = 'Accept Copilot suggestion'
})
vim.keymap.set('i', '<M-;>', '<plug>(copilot-accept-word)', {
  desc = 'Accept Copilot suggestion word by word'
})
vim.keymap.set('i', '<C-;>', '<plug>(copilot-accept-line)', {
  desc = 'Accept Copilot suggestion line by line'
})
vim.g.copilot_no_tab_map = true

-- install: sudo pacman -S tree-sitter-cli
local ts = require 'nvim-treesitter'
ts.setup{}
local ts_filetypes = {
  'python',
  'lua',
  'vim',
}
ts.install(ts_filetypes)
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function ()
    pcall(vim.treesitter.start)
  end,
})

require 'oil'.setup{}

local cmp = require 'blink.cmp'
cmp.build():wait(60000)
cmp.setup{
  completion = {
    documentation = {
      auto_show = true,
    },
  },
}

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.list = true
vim.opt.listchars='tab:→ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨'
vim.opt.showbreak='+++>'

---@type table<string, vim.lsp.Config>
local lspcfgs = {
  -- install: sudo pacman -S lua-language-server
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json' }, { '.luarc.jsonc' } },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
      },
    },
  },
  -- install: opam install ocaml-lsp-server
  ocamllsp = {
    cmd = { 'opam', 'exec', '--', 'ocamllsp' },
    filetypes = { 'ocaml' },
    root_markers = { { 'dune-project' }, { '_opam' } },
  },
  -- install: yay -S basedpyright
  basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { { 'pyproject.toml' }, { 'setup.py' } },
  },
}
for name, config in pairs(lspcfgs) do
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

local fzf = require 'fzf-lua'
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'List buffers' })
vim.keymap.set('n', '<leader>fc', function ()
  fzf.files{
    cwd = '~/.config',
    follow = true,
  }
end, { desc = 'Find config files' })


vim.diagnostic.config{
  virtual_text = true,
}
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
