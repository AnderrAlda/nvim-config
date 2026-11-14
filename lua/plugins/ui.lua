return {
    -- Tema de colores
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = { nvimtree = true, telescope = true, cmp = true, treesitter = true, gitsigns = true, which_key = true },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Árbol de archivos
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>",   desc = "Abrir/cerrar árbol" },
            { "<leader>o", "<cmd>NvimTreeFindFile<CR>", desc = "Mostrar archivo en árbol" },
        },
        lazy = false,
        opts = {
            view = { width = 32 },
            renderer = { group_empty = true, highlight_git = true },
            filters = { dotfiles = false },
            git = { ignore = false },
            update_focused_file = { enable = true },
        },
    },

    -- Barra de estado y pestañas de buffers
    { "nvim-lualine/lualine.nvim", opts = { options = { theme = "catppuccin-mocha", globalstatus = true } } },
    { "akinsho/bufferline.nvim",   enabled = false,                                                         opts = { options = { offsets = { { filetype = "NvimTree", text = "Archivos" } } } } },

    -- Buscador
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Buscar archivos" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Buscar texto" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnósticos" },
            { "<leader>fm", "<cmd>Telescope man_pages sections={'1','2','3','4','5','7','8'}<CR>", desc = "Buscar en man" },
        },
    },

    { "lewis6991/gitsigns.nvim",             opts = {} },
    { "folke/which-key.nvim",                event = "VeryLazy",    opts = {} },
    { "windwp/nvim-autopairs",               event = "InsertEnter", opts = {} },
    { "numToStr/Comment.nvim",               opts = {} },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",          opts = { scope = { enabled = true, show_start = false, show_end = false } } },
}
