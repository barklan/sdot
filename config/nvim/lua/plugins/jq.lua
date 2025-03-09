return {
    {
        "yochem/jq-playground.nvim",
        lazy = true,
        event = "VeryLazy",
        cond = NotVSCode,
        cmd = "JqPlayground",
        opts = {
            cmd = { "jaq" },
            disable_default_keymap = true,
        },
    },
}
