-- ===== Opciones básicas =====
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1 -- desactivar netrw (usamos nvim-tree)
vim.g.loaded_netrwPlugin = 1

local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.wrap = false

-- Ajuste de línea visual
o.wrap = true
o.linebreak = true
o.breakindent = true

-- Go y C usan tabs / estilo propio
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go", "make" },
    callback = function() vim.opt_local.expandtab = false end,
})

-- C/C++: usar cindent (más fiable que el indent de treesitter mientras escribes)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.indentexpr = ""
        vim.opt_local.smartindent = false
        vim.opt_local.cindent = true
        vim.opt_local.cinoptions = ":0,l1,g0,N-s,(0,W4"
    end,
})

-- ===== Atajos generales =====
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Salir" })
map("n", "<C-h>", "<C-w>h"); map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j"); map("n", "<C-k>", "<C-w>k")
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Ver diagnóstico" })

vim.diagnostic.config({ virtual_text = true, severity_sort = true, float = { border = "rounded" } })

-- ===== lazy.nvim (gestor de plugins) =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    install = { colorscheme = { "catppuccin" } },
    change_detection = { notify = false },
})
