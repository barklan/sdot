return {
    {
        "rebelot/kanagawa.nvim",
        compile = false,
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        config = function()
            require("kanagawa").setup({
                -- transparent = true,
                compile = false,
                dimInactive = false,
                globalStatus = true,
                theme = "wave", -- wave
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(_)
                    return {
                        Comment = { fg = "#FFB6C1" },
                        TSComment = { fg = "#FFB6C1" },
                        CursorLine = { bg = "#2A2A37" },
                        TelescopeBorder = { fg = "#DCD7BA" },
                        NeoTreeWinSeparator = { fg = "#54546D" },
                        HlSearchNear = { bg = "#2D4F67" },
                        HlSearchLens = { bg = "#2D4F67" },
                        HlSearchLensNear = { bg = "#2D4F67" },
                        ScrollView = { bg = "#54546D" },
                        Headline = { bg = "#333543" },
                        -- TODO: more subtle highlight bg color
                        IlluminatedWordText = { bg = "#333543" },
                        IlluminatedWordRead = { bg = "#333543" },
                        IlluminatedWordWrite = { bg = "#333543" },
                    }
                end,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        config = function()
            require("tokyonight").setup({
                day_brightness = 0.15,
                -- lualine_bold = true,
                on_highlights = function(hl, _)
                    hl.TSComment = {
                        fg = "#FFB6C1",
                    }
                    hl.Comment = {
                        fg = "#FFB6C1",
                    }
                    -- NOTE: this is used for terminal
                    -- hl.Normal = { bg = "none"}
                    -- hl.NormalNC = { bg = "none"}
                    -- hl.SignColumn = { bg = "none"}
                end,
            })
        end,
    },
    {
        "rose-pine/neovim",
        enabled = true,
        lazy = false,
        priority = 1000,
        cond = NotVSCode,
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                variant = "dawn", -- auto, main, moon, or dawn
                extend_background_behind_borders = true,
                styles = {
                    bold = true,
                    italic = false,
                    transparency = false,
                },
                highlight_groups = {
                    Comment = { fg = "love" },
                    TSComment = { fg = "love" },
                },
            })
        end,
    },
}
