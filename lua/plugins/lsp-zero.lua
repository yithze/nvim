return {
        {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v4.x", -- Ubah ke branch v4.x
            lazy = true,
            config = function()
                local lsp_zero = require('lsp-zero')

                -- Konfigurasi LSP seperti attach function dan keymap
                local lsp_attach = function(client, bufnr)
                    -- Konfigurasi keymap di sini
                    lsp_zero.default_keymaps({ buffer = bufnr })
                end

                lsp_zero.extend_lspconfig({
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),
                    lsp_attach = lsp_attach,
                    float_border = 'rounded',
                    sign_text = true,
                })
            end,
        },

        -- Plugin Mason untuk install LSP server
        {
            "williamboman/mason.nvim",
            lazy = false,
            config = true,
        },

        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                { "L3MON4D3/LuaSnip" },
                { "rafamadriz/friendly-snippets" },
                { "saadparwaiz1/cmp_luasnip" },
                { "hrsh7th/cmp-path" },
                { "hrsh7th/cmp-buffer" },
            },
            config = function()
                local cmp = require("cmp")
                require("luasnip.loaders.from_vscode").lazy_load()

                cmp.setup({
                    completion = {
                        completeopt = "menu,menuone,noinsert",
                    },
                    sources = {
                        { name = "path" },
                        { name = "nvim_lsp" },
                        { name = "luasnip", keyword_length = 2 },
                        { name = "buffer",  keyword_length = 3 },
                    },
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-d>"] = cmp.mapping.scroll_docs(4),
                        ["<C-f>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.confirm({ select = true })
                            else
                                fallback()
                            end
                        end),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    }),
                })
            end,
        },

        -- LSP
        {
            "neovim/nvim-lspconfig",
            cmd = { "LspInfo", "LspInstall", "LspStart" },
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                { "hrsh7th/cmp-nvim-lsp" },
                { "williamboman/mason-lspconfig.nvim" },
            },
            config = function()
                local lsp_zero = require("lsp-zero")

                -- Extend nvim-lspconfig dan setup keymap
                lsp_zero.extend_lspconfig()

                local lsp_attach = function(client, bufnr)
                    lsp_zero.default_keymaps({ buffer = bufnr })
                end

                require("mason-lspconfig").setup({
                    ensure_installed = {}, -- List of LSP servers to auto-install
                    handlers = {
                        lsp_zero.default_setup,
                        lua_ls = function()
                            local lua_opts = lsp_zero.nvim_lua_ls()
                            require("lspconfig").lua_ls.setup(lua_opts)
                        end,
                    },
                })
            end,
        },
    },

    -- Konfigurasi diagnostic
    vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = true,
    })
