return {
    {
        "Wansmer/langmapper.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("langmapper").setup({})

            vim.keymap.set("i", "ло", "<esc>", { silent = true })
            vim.keymap.set("i", "ол", "<esc>", { silent = true })
        end,
    },
}
