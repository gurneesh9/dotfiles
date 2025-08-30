-- ~/.config/nvim/init.lua

-- Ensure Packer is installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Packer configuration
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'                 -- Package manager itself
    use 'bluz71/vim-nightfly-guicolors'          -- Cyberpunk color scheme
    use 'folke/tokyonight.nvim'                  -- Tokyo Night colorscheme
    use 'rebelot/kanagawa.nvim'                  -- Kanagawa colorscheme
    use 'EdenEast/nightfox.nvim'                 -- Nightfox color scheme
    use 'projekt0n/github-nvim-theme'            -- GitHub theme
    use 'catppuccin/nvim'                        -- Catppuccin theme
    use 'dracula/vim'                            -- Dracula theme
    use "ellisonleao/gruvbox.nvim"               -- Gruvbox theme

    use 'kyazdani42/nvim-tree.lua'               -- File explorer
    use 'preservim/nerdtree'                     -- NERDTree file explorer
    use 'nvim-lua/plenary.nvim'                  -- Required by many plugins
    use 'nvim-telescope/telescope.nvim'          -- Fuzzy finder

    -- LSP and Autocompletion
    use 'neovim/nvim-lspconfig'                  -- LSP configurations
    use 'hrsh7th/nvim-cmp'                       -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'                   -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer'                     -- Buffer source for nvim-cmp
    use 'hrsh7th/cmp-path'                       -- Path source for nvim-cmp
    use 'L3MON4D3/LuaSnip'                       -- Snippet engine
    use 'saadparwaiz1/cmp_luasnip'               -- Snippets source for nvim-cmp

    -- Language Server Management
    use 'williamboman/mason.nvim'                -- Language server installer
    use 'williamboman/mason-lspconfig.nvim'      -- Bridges mason and lspconfig

    -- Syntax Highlighting and Diagnostics
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- Treesitter for enhanced syntax highlighting
    use {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'}
    use 'jose-elias-alvarez/null-ls.nvim'        -- For code formatting and linting (e.g., Prettier, ESLint)
    use 'mfussenegger/nvim-dap'                  -- Debugger
    use 'joshuavial/aider.nvim'                  -- Aider plugin
    use 'folke/trouble.nvim'                     -- For better diagnostics display

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Basic Neovim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.termguicolors = true
vim.opt.mouse = 'a' -- Enable mouse support
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true

-- Enable syntax highlighting
vim.cmd [[syntax enable]]
vim.cmd [[filetype plugin indent on]]

-- Set colorscheme
vim.cmd('colorscheme gruvbox')

-- Function to enable transparency
local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
end
-- enable_transparency()

-- Keymaps
vim.keymap.set('n', '<leader>nf', ':NERDTreeFocus<CR>', { desc = 'Focus NERDTree' })
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Live grep' })

-- LSP keymaps
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format' })
vim.keymap.set('n', '<leader>td', ':TroubleToggle<CR>', { desc = 'Toggle diagnostics' })

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "javascript", "typescript", "tsx", "json", "css", "html" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
}

-- Mason configuration
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "ts_ls", "eslint" },
    automatic_installation = true,
})

-- LSP and Formatter configuration
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
  -- If you want to use the LSP for formatting, uncomment the line below
  -- client.server_capabilities.documentFormattingProvider = true

  -- Keymaps for LSP actions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
end

-- Setup LSP servers
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- nvim-cmp configuration
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})
