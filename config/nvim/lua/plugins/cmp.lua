return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        lazy = true,
        config = function()
            local luasnip = require("luasnip")
            luasnip.config.set_config({})

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { "~/.config/Code/User" },
                default_priority = 10000,
                -- override_priority = 10000,
            })

            vim.keymap.set({ "i", "s" }, "<M-n>", "<Plug>luasnip-next-choice")
            vim.keymap.set({ "i", "s" }, "<C-h>", "<cmd>lua require'luasnip'.jump(-1)<cr>")
        end,
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        lazy = true,
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "windwp/nvim-autopairs",
            "hrsh7th/cmp-buffer",
            -- "hrsh7th/cmp-path",
            "https://codeberg.org/FelipeLema/cmp-async-path",
            "hrsh7th/cmp-cmdline",
            "abecodes/tabout.nvim",
            "mtoohey31/cmp-fish",
        },
        config = function()
            local luasnip = require("luasnip")
            local cmp = require("cmp")

            require("nvim-autopairs").setup({})
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            local cmp_kinds = {
                Text = "  ",
                Method = "  ",
                Function = "  ",
                Constructor = "  ",
                Field = "  ",
                Variable = "  ",
                Class = "  ",
                Interface = "  ",
                Module = "  ",
                Property = "  ",
                Unit = "  ",
                Value = "  ",
                Enum = "  ",
                Keyword = "  ",
                Snippet = "  ",
                Color = "  ",
                File = "  ",
                Reference = "  ",
                Folder = "  ",
                EnumMember = "  ",
                Constant = "  ",
                Struct = "  ",
                Event = "  ",
                Operator = "  ",
                TypeParameter = "  ",
            }

            local shared_formatting = {
                fields = { "kind", "abbr", "menu" },
                -- fields = { "kind", "abbr" },
                format = function(entry, vim_item)
                    vim_item.menu = ({
                        luasnip = "snip",
                        nvim_lsp = "LSP",
                        nvim_lsp_signature_help = "signature",
                        nvim_lsp_document_symbol = "LSP",
                        buffer = "buf",
                        path = "path",
                        git = "git",
                        rg = "rg",
                        treesitter = "TS",
                        cmdline = "cmd",
                        cmdline_history = "hist",
                        spell = "spell",
                        dictionary = "dict",
                        crates = "crates",
                    })[entry.source.name]
                    vim_item.kind = (cmp_kinds[vim_item.kind] or "")
                    vim_item.dup = ({
                        dictionary = 0,
                    })[entry.source.name] or 0
                    if #vim_item.abbr > 40 then
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 40) .. "..."
                    end
                    return vim_item
                end,
            }

            local types = require("cmp.types")
            local modified_priority = {
                [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
                [types.lsp.CompletionItemKind.Snippet] = 0, -- top
                [types.lsp.CompletionItemKind.Keyword] = 0, -- top
                [types.lsp.CompletionItemKind.Text] = 100, -- bottom
            }
            local function modified_kind(kind)
                return modified_priority[kind] or kind
            end

            local cmp_buffer = require("cmp_buffer")
            cmp.setup({
                -- NOTE: this is needed so that it does not select second
                -- completion in some cases (particularly with gopls)
                preselect = cmp.PreselectMode.None,
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                -- NOTE: this is not very pretty
                experimental = {
                    ghost_text = true,
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        function(...)
                            return cmp_buffer:compare_locality(...)
                        end,
                        cmp.config.compare.recently_used,
                        function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
                            local kind1 = modified_kind(entry1:get_kind())
                            local kind2 = modified_kind(entry2:get_kind())
                            if kind1 ~= kind2 then
                                return kind1 - kind2 < 0
                            end
                        end,
                        cmp.config.compare.kind,
                        cmp.config.compare.score,
                        cmp.config.compare.order,
                        -- cmp.config.compare.sort_text,
                        -- cmp.config.compare.length,
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        -- NOTE: completion.completeopt should be set.
                        if cmp.visible() then
                            cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            -- NOTE: used by tabout.
                            fallback()
                        end
                    end, { "i", "s", "c" }),
                    ["<C-e>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            cmp.complete()
                        end
                    end, { "i", "s" }),
                    ["<C-M-e>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            cmp.complete()
                        end
                    end, { "i", "s" }),
                    ["<M-e>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                }),
                formatting = shared_formatting,
                performance = {
                    max_view_entries = 12,
                    throttle = 0,
                    debounce = 0,
                    fetching_timeout = 150,
                },
                sources = {
                    { name = "luasnip", priority = 11 },
                    { name = "nvim_lsp", priority = 10 },
                    { name = "nvim_lsp_signature_help" },
                    { name = "buffer", option = { keyword_length = 1 }, dup = 1 },
                    -- { name = "path" },
                    { name = "async_path" },
                    -- { name = "crates" },
                    { name = "fish" },

                    { name = "git" },

                    -- NOTE: useless with buffer source
                    -- { name = "treesitter" },

                    {
                        name = "rg",
                        keyword_length = 3,
                        debounce = 200,
                        option = {
                            additional_arguments = "--max-depth 5 -i --one-file-system --threads 6 -g '!.git/**'",
                        },
                    },
                },
            })

            cmp.setup.cmdline(":", {
                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
                },
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "cmdline", max_item_count = 10, priority = 10 },
                    { name = "cmdline_history", max_item_count = 10, priority = 9 },
                    -- { name = "path" },
                    { name = "async_path" },
                    { name = "nvim_lsp_document_symbol", max_item_count = 3 },
                    { name = "buffer", max_item_count = 3 },
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                completion = {
                    completeopt = "menu,menuone,noselect",
                },
                view = {
                    entries = { name = "custom", selection_order = "near_cursor" },
                },
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "nvim_lsp_document_symbol", max_item_count = 3 },
                    { name = "buffer", max_item_count = 3 },
                    { name = "treesitter", max_item_count = 3 },
                },
            })
        end,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        cond = CMPEnable,
        lazy = true,
    }, -- This is called by lsp_shim
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },
    {
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },
    {
        "ray-x/cmp-treesitter",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "dmitmel/cmp-cmdline-history",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },
    {
        "petertriho/cmp-git",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        config = true,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "lukas-reineke/cmp-rg",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = CMPEnable,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },
}
