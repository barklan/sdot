return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy", -- NOTE: used for lualine display
        cond = NotVSCode,
    },

    -- {
    --     "NeogitOrg/neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim", -- required
    --         "sindrets/diffview.nvim", -- optional - Diff integration
    --
    --         -- Only one of these is needed.
    --         "nvim-telescope/telescope.nvim", -- optional
    --         -- "ibhagwan/fzf-lua",      -- optional
    --         -- "echasnovski/mini.pick", -- optional
    --     },
    --     opts = {
    --         graph_style = "kitty",
    --         mappings = {
    --             commit_editor = {
    --                 ["q"] = "Close",
    --                 ["<C-g>c"] = "Submit",
    --                 ["<c-c><c-k>"] = "Abort",
    --                 ["<m-p>"] = "PrevMessage",
    --                 ["<m-n>"] = "NextMessage",
    --                 ["<m-r>"] = "ResetMessage",
    --             },
    --             commit_editor_I = {
    --                 ["<c-c><c-c>"] = "Submit",
    --                 ["<c-c><c-k>"] = "Abort",
    --             },
    --         },
    --     },
    -- },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
        cond = NotVSCode,
    },
    {
        "rhysd/git-messenger.vim",
        event = "VeryLazy",
        cond = NotVSCode,
        keys = {
            { "<C-g>i", "<Plug>(git-messenger)", mode = { "n" } },
        },
        init = function()
            vim.g.git_messenger_no_default_mappings = true
            vim.g.git_messenger_include_diff = "current"
            vim.g.git_messenger_max_popup_height = 30
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        cond = NotVSCode,
        opts = {
            current_line_blame_opts = {
                delay = 100,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "next_hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "prev_hunk" })

                -- Actions
                map({ "n", "v" }, "<C-g>ha", ":Gitsigns stage_hunk<CR>", { desc = "stage hunk" })
                map({ "n", "v" }, "<C-g>hr", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
                map("n", "<C-g>hu", gs.undo_stage_hunk, { desc = "unstage hunk" })
                map("n", "<C-g>hR", gs.reset_buffer, { desc = "reset buffer" })
                map("n", "<C-g>hp", gs.preview_hunk, { desc = "preview hunk" })
                map("n", "<C-g>hi", gs.preview_hunk_inline, { desc = "preview hunk inline" })
                map("n", "<C-g><C-g>", gs.preview_hunk_inline, { desc = "preview hunk inline" })
                map("n", "<C-g>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "blame line" })
                map("n", "<C-g>tb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
                map("n", "<C-g>td", gs.toggle_deleted, { desc = "toggle deleted" })
                map("n", "<C-g>tw", gs.toggle_word_diff, { desc = "toggle word diff" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
}
