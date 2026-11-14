return {
    -- Resaltado de sintaxis
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "go", "gomod", "gosum", "zig", "lua", "vim", "vimdoc", "make", "markdown", "json", "bash" },
                highlight = { enable = true },
                indent = { enable = true, disable = { "c", "cpp" } }, -- TS indent falla en C con código incompleto
            })
        end,
    },

    -- LSP: gopls, clangd, zls (instalados por Mason)
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                        usePlaceholders = true,
                        analyses = { unusedparams = true }
                    }
                },
            })
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--function-arg-placeholders=1",
                },
            })
            vim.lsp.config("zls", { settings = { zls = { enable_build_on_save = true } } })

            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "clangd", "zls", "lua_ls" },
                automatic_enable = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local m = function(k, f, d) vim.keymap.set("n", k, f, { buffer = ev.buf, desc = d }) end
                    m("gd", vim.lsp.buf.definition, "Ir a definición")
                    m("gr", vim.lsp.buf.references, "Referencias")
                    m("gi", vim.lsp.buf.implementation, "Implementación")
                    m("K", vim.lsp.buf.hover, "Documentación")
                    m("<leader>rn", vim.lsp.buf.rename, "Renombrar")
                    m("<leader>ca", vim.lsp.buf.code_action, "Acción de código")
                    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help,
                        { buffer = ev.buf, desc = "Firma de función" })
                end,
            })
        end,
    },

    -- Herramientas extra (formateadores)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = { ensure_installed = { "goimports", "gofumpt", "clang-format" } },
    },

    -- Formatear al guardar
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            formatters_by_ft = {
                go = { "goimports", "gofumpt" },
                c = { "clang-format" },
                zig = { "zigfmt" },
            },
            format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
        },
    },

    -- Autocompletado
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(a)
                        luasnip.lsp_expand(a.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                },
            })
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- Solo se carga al abrir archivos Lua
        opts = {
            library = {
                -- Carga tipos de luvit cuando se encuentra la palabra `vim.uv`
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
