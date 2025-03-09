return {
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        -- lazy = false,
        event = "VeryLazy",
        cond = NotVSCode,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
            "ray-x/guihua.lua",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local shared = require("config.lsp_shim")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("go").setup({
                -- gopls_cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=20m" },
                gopls_cmd = { "gopls" },
                goimports = "gopls",
                max_line_len = 150, -- NOTE: should be in sync with null_ls golines
                gofmt = "golines",
                lsp_gofumpt = true,
                lsp_document_formatting = true,
                tag_options = "",
                verbose_tests = true,
                tag_transform = "camelcase",
                -- tag_transform = "snakecase",
                lsp_cfg = {
                    capabilities = capabilities,
                    on_attach = shared.on_attach,
                    settings = {
                        gopls = {
                            symbolScope = "workspace",
                        },
                    },
                },
                diagnostic = { -- set diagnostic to false to disable vim.diagnostic setup
                    hdlr = false, -- hook lsp diag handler and send diag to quickfix
                    underline = false,
                    -- virtual text setup
                    -- virtual_text = { spacing = 0, prefix = "■" },
                    signs = false,
                    update_in_insert = false,
                },
                lsp_inlay_hints = {
                    enable = false,
                    --     style = "inlay",
                },
            })
        end,
    },
}
