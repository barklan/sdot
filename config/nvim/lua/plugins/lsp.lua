return {
    {
        "ray-x/lsp_signature.nvim",
        cond = NotVSCode,
        lazy = true,
        keys = {
            { "<M-s>", "<cmd>lua require('lsp_signature').toggle_float_win()<cr>", mode = { "i", "n" } },
        },
        opts = {
            hint_enable = false,
            auto_close_after = 5,
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        enabled = false,
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000, -- needs to be loaded in first
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "powerline",
                options = {

                    multilines = {
                        -- Enable multiline diagnostic messages
                        enabled = true,

                        -- Always show messages on all lines for multiline diagnostics
                        always_show = true,
                    },
                },
            })
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        contig = true,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cond = NotVSCode,
        -- NOTE: do not lazy load this. I don't know why...
        lazy = false,
        -- event = "VeryLazy",
        dependencies = {
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
            "ray-x/lsp_signature.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local shared = require("config.lsp_shim")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- TODO: explore more servers
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            local servers = {
                "basedpyright",
                "ts_ls",
                "jsonls",
                "yamlls",
                "bashls",
            }

            local user = os.getenv("USER")
            if user ~= "barklan" then
                servers = {}
            end

            local nvim_lsp = require("lspconfig")

            for _, lsp in ipairs(servers) do
                if lsp == "yamlls" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemaStore = {
                                    url = "https://www.schemastore.org/api/json/catalog.json",
                                    enable = true,
                                },
                                format = {
                                    enable = true,
                                },
                            },
                        },
                    })
                elseif lsp == "jsonls" then
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                        settings = {
                            json = {
                                schemas = require("schemastore").json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    })
                else
                    nvim_lsp[lsp].setup({
                        on_attach = shared.on_attach,
                        capabilities = capabilities,
                    })
                end
            end

            nvim_lsp.lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        runtime = {
                            version = "LuaJIT",
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },
}
