return {
    "ibhagwan/fzf-lua",
    lazy = true,
    cond = NotVSCode,
    cmd = "FzfLua",
    dependencies = {
        -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local actions = require("fzf-lua.actions")
        require("fzf-lua").setup({
            "telescope",
            fzf_opts = {
                ["--layout"] = "reverse",
                ["--marker"] = "+",
            },
            winopts = {
                height = 0.9, -- window height
                width = 0.5,
                row = 0.40,
                col = 0.45,
                preview = {
                    -- hidden = "hidden",
                    layout = "vertical", -- horizontal|vertical|flex
                    vertical = "down:35%", -- up|down:size
                    winopts = { -- builtin previewer window options
                        number = false,
                        relativenumber = false,
                        cursorline = false,
                        cursorcolumn = false,
                        signcolumn = "no",
                        list = false,
                    },
                },
                on_create = function()
                    -- creates a local buffer mapping translating <M-BS> to <C-u>
                    vim.keymap.set(
                        "t",
                        "<Tab>",
                        "<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)<CR>",
                        { nowait = true, buffer = true }
                    )
                    vim.keymap.set(
                        "t",
                        "<S-Tab>",
                        "<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', true)<CR>",
                        { nowait = true, buffer = true }
                    )
                    vim.keymap.set("t", "<C-l>", "<Esc>", { nowait = true, buffer = true })
                    vim.keymap.set("t", "<C-t>", "<Esc>", { nowait = true, buffer = true })
                    vim.keymap.set("t", "<C-h>", "<Esc>", { nowait = true, buffer = true })
                    vim.keymap.set("t", "<C-;>", "<Esc>", { nowait = true, buffer = true })
                    vim.keymap.set("t", "<C-q>", "<Nop>", { nowait = true, buffer = true })
                end,
            },
            grep = {
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -uu",
            },
            files = {
                git_icons = true,
                fd_opts = [[--color=never --hidden --no-ignore --type f --exclude .git --exclude .venv]],
            },
            git = {
                status = {
                    actions = {
                        ["right"] = false,
                        ["left"] = false,
                        ["ctrl-x"] = false,
                        ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
                    },
                },
            },
        })
    end,
}
