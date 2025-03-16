return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            scroll = { enabled = false },
            image = { enabled = true },
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
