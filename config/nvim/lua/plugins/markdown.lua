return {
    {
        "lukas-reineke/headlines.nvim",
        enabled = true,
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
}
