vim.api.nvim_create_augroup("mynvim", {})

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     group = "main",
--     pattern = { "gitcommit", "markdown", "text" },
--     callback = function()
--         vim.opt_local.spell = false
--     end,
-- })

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "main",
    pattern = { "*:no*" },
    callback = function()
        vim.opt.relativenumber = true
    end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "main",
    pattern = { "no*:*" },
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "WinLeave" }, {
    group = "mynvim",
    pattern = "*",
    command = "checktime",
})

-- INFO: Main enter logic
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = "main",
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            GitFetchMainBranch()
        end, 700)
    end,
})

vim.api.nvim_create_augroup("neotree_autoopen", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", { -- Changed from BufReadPre
    desc = "Open neo-tree on enter",
    group = "neotree_autoopen",
    once = true,
    callback = function()
        local num_args = vim.fn.argc()
        if num_args == 0 and IsScrollbackPager() == false then
            if not vim.g.neotree_opened then
                vim.defer_fn(function()
                    vim.cmd("Neotree show")
                    vim.g.neotree_opened = true
                end, 0)
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = "main",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            vim.defer_fn(GitPushAsyncNotify, 0)
            vim.cmd(':execute "normal `A"')
            vim.cmd(":Neotree close")
            vim.cmd(":Neotree show")
        end, 200)
    end,
})

local git_notify_behind = function()
    require("plenary.job")
        :new({
            command = "git",
            args = { "notify-behind" },
            cwd = vim.fn.getcwd(),
            on_exit = function(j, return_val)
                if return_val ~= 0 then
                    vim.notify("Failed fetching default branch!", "warn")
                end
            end,
        })
        :start()
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = "main",
    pattern = "COMMIT_EDITMSG",
    callback = function()
        vim.defer_fn(function()
            git_notify_behind()
        end, 50)
        if IsGitEditor() == false then
            vim.cmd(":Neotree close")
            vim.cmd("only")
            vim.cmd(":Neotree git_status show left reveal=true")
        end
    end,
})

-- TODO: this messes up quickfix
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--     group = "main",
--     pattern = "*",
--     callback = function()
--         if vim.bo.filetype ~= nil and vim.bo.filetype ~= "neo-tree" then
--             vim.defer_fn(function()
--                 require("close_buffers").delete({ type = "nameless", force = true })
--             end, 50)
--         end
--     end,
-- })

-- Disable diagnostics on .env files
local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = ".env",
    group = group,
    callback = function(args)
        vim.diagnostic.disable(args.buf)
    end,
})

local refresh_neotree_git_status = function()
    pcall(function()
        require("neo-tree.sources.git_status").refresh()
    end)
end

local timer = vim.uv.new_timer()
timer:start(
    5000, -- initial delay
    6000, -- interval
    vim.schedule_wrap(function()
        -- vim.notify("refresh")
        refresh_neotree_git_status()
    end)
)
