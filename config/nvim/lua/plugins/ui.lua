return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            scroll = { enabled = false },
        },
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        enabled = false,
        opts = {
            color_icons = false,
            strict = true,
            default = true,
        },
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                fps = 60,
                render = "simple",
                -- stages = "fade",
                stages = "static",
            })

            -- List of messages to ignore
            local ignored_messages = {
                -- "No information available",
            }

            -- vim.notify = require("notify")
            vim.notify = function(msg, ...)
                for _, ignored in ipairs(ignored_messages) do
                    if msg:match(ignored) then
                        return
                    end
                end
                require("notify")(msg, ...)
            end
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },
    {
        "kevinhwang91/nvim-bqf",
        cond = NotVSCode,
        ft = "qf",
        opts = {
            auto_enable = true,
        },
    },
    -- {
    --     "yorickpeterse/nvim-pqf",
    --     cond = NotVSCode,
    --     ft = "qf",
    --     config = true,
    -- },
    {
        "dstein64/nvim-scrollview",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            excluded_filetypes = { "neo-tree" },
            diagnostics_severities = { vim.diagnostic.severity.ERROR },
        },
    },
    {
        "lukas-reineke/headlines.nvim",
        cond = NotVSCode,
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("headlines").setup({
                markdown = {
                    fat_headlines = false,
                    codeblock_highlight = false,
                    quote_highlight = false,
                    bullets = {},
                },
            })
        end,
    },
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        cond = NotVSCode,
        config = function()
            require("illuminate").configure({
                -- under_cursor = false,
                -- delay = 100,
            })
        end,
    },
}
