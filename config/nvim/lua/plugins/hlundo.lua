return {
    {
        "tzachar/highlight-undo.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            duration = 300,
            pattern = { "*" },
        },
    },
}
