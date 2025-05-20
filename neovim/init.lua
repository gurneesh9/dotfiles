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
    use 'wbthomason/packer.nvim'                   -- Package manager itself
    use 'bluz71/vim-nightfly-guicolors'            -- Cyberpunk color scheme
    use 'folke/tokyonight.nvim'                    -- Tokyo Night colorscheme
    use 'rebelot/kanagawa.nvim'                    -- Kanagawa colorscheme
    use 'EdenEast/nightfox.nvim'                   -- Nightfox colorscheme
    use 'projekt0n/github-nvim-theme'              -- GitHub theme
    use 'catppuccin/nvim'                          -- Catppuccin theme
    use 'dracula/vim'                              -- Dracula theme

    use 'kyazdani42/nvim-tree.lua'                 -- File explorer
    use 'preservim/nerdtree'                       -- NERDTree file explorer
    use 'nvim-lua/plenary.nvim'                    -- Required by many plugins
    use 'nvim-telescope/telescope.nvim'            -- Fuzzy finder
    use 'neovim/nvim-lspconfig'                    -- LSP configurations
    use 'hrsh7th/nvim-cmp'                         -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'                     -- LSP source for nvim-cmp
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  -- Treesitter for enhanced syntax highlighting
    use 'joshuavial/aider.nvim'                    -- Aider plugin

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Basic Neovim settings
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.termguicolors = true

-- Enable syntax highlighting
vim.cmd [[syntax enable]]
vim.cmd [[filetype plugin indent on]]

-- Set colorscheme function
local function set_colorscheme(name)
    local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. name)
    if not status_ok then
       print("Colorscheme " .. name .. " not found!")
    end
end

-- Change colorscheme here
set_colorscheme('dracula')

-- Function to enable transparency
local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
end

enable_transparency()

-- set_colorscheme('dracula')
