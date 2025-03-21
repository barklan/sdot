local silent = { silent = true }

vim.keymap.set("n", "<leader>z", ":Lazy<cr>")

local close_current_buffer = function()
    if vim.bo.filetype == "qf" then
        vim.cmd("cclose")
    elseif vim.bo.filetype == "fugitive" then
        vim.cmd("bdelete")
    elseif vim.bo.filetype == "Trouble" then
        vim.cmd(":q")
    elseif vim.bo.readonly == true then
        require("mini.bufremove").delete(0)
    else
        vim.cmd(":update")
        require("mini.bufremove").delete(0)
    end
end

vim.keymap.set({ "n" }, "<F12>", ":WhichKey<cr>")

------------------------
--- VSCode-like mappings
------------------------

vim.keymap.set("i", "<C-BS>", "<C-W>", silent)
vim.keymap.set("c", "<C-BS>", "<C-W>", silent)

vim.keymap.set("n", "<C-q>", "<cmd>qall<cr>", { silent = true, desc = "Quit Neovim" })

-------------------------------
-- Buffer and window management
-------------------------------

vim.keymap.set("n", "<A-k>", function()
    local ext = vim.bo.filetype
    if ext == "neo-tree" then
        vim.notify("call this from buffer", "info", { timeout = 1000 })
    else
        vim.cmd(":bnext")
    end
end, { silent = true, desc = "Next buffer" })

-- Go to previous buffer.
vim.keymap.set("n", "<A-j>", function()
    local ext = vim.bo.filetype
    if ext == "neo-tree" then
        vim.notify("call this from buffer", "info", { timeout = 1000 })
    else
        vim.cmd(":bprevious")
    end
end, { silent = true, desc = "Previous buffer" })

-- Delete all buffers except the current one.
vim.keymap.set("n", "<leader>1", function()
    require("close_buffers").delete({ type = "other" })
end, { desc = "Close other buffers" })

if IsGitEditor() == true or IsCMDLineEditor() == true then
    vim.keymap.set("n", "<BS>", "<cmd>wqall<cr>", { silent = true, desc = "Quit Neovim" })
else
    vim.keymap.set("n", "<BS>", close_current_buffer, { silent = true, desc = "Close buffer" })
end

vim.keymap.set("n", "<M-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<M-l>", "<C-w>l", { silent = true })

local function is_split_open()
  local win_count = 0

  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win_id)
    local buf_bt = vim.bo[buf].buftype
    local buf_ft = vim.bo[buf].filetype

    -- Count windows with regular files, ignoring 'neo-tree' and special buffers
    if buf_bt == '' and buf_ft ~= 'neo-tree' then
      win_count = win_count + 1
    end
  end

  return win_count > 1
end

vim.keymap.set("n", "<C-\\>", function()
    if is_split_open() then
        vim.cmd("wincmd q")
    else
        vim.cmd("wincmd v")
    end
end, { silent = true })

--------------
--- Navigation
--------------

vim.keymap.set("n", "<leader>a", ":Telescope<cr>", { silent = true, desc = "Telescope (all)" })

vim.keymap.set("n", "<C-h>", ":FzfLua buffers<cr>", { silent = true, desc = "switch to buffer" })

vim.keymap.set("n", "<C-l>", function()
    require("fzf-lua").files({
        silent = true,
        actions = {
            ["default"] = function(selected, opts)
                local file = require("fzf-lua").path.entry_to_file(selected[1], opts)
                local action_key = ChooseFileAction(file.path)
                if action_key == "edit" then
                    require("fzf-lua").actions.file_edit(selected, opts)
                elseif action_key == "open" then
                    vim.cmd([[silent !fish -ic "xdg-open ]] .. file.path .. [[" &]])
                elseif action_key == "none" then
                else
                    vim.notify("Unknown action key! FIX THIS BUG.")
                end
            end,
        },
    })
end, { silent = true, desc = "open file" })

vim.keymap.set("n", "<C-M-l>", function()
    require("fzf-lua").files({
        silent = true,
        fd_opts = [[--color=never --type f -e go]],
    })
end, { silent = true, desc = "Find files" })

vim.keymap.set("n", "<leader><leader>", ":Telescope resume<cr>", { silent = true, desc = "Telescope resume" })

-- TODO: replace with with fzflua
vim.keymap.set("n", "<C-p>", ":Telescope file_browser path=%:p:h<cr>", silent)

vim.keymap.set("n", "<leader>t", ":TodoTelescope keywords=TODO,FIX<cr>", { silent = true, desc = "Find TODOs" })

--------------
-- Diagnostics (also look in lsp_shim.lua)
--------------

vim.keymap.set("n", ";", function()
    vim.cmd("silent LspFormat")
    vim.cmd("silent update")
end, { silent = true, desc = "Format document" })

-- vim.keymap.set("n", "<C-t>", ":Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Find workspace symbols" })
vim.keymap.set("n", "<C-t>", ":FzfLua lsp_live_workspace_symbols<cr>", { desc = "Find workspace symbols" })

-- This or defined in lsp
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<cr>", { silent = true, desc = "Find  LSP definitions" })

vim.keymap.set("n", "gj", ":Telescope lsp_references<cr>", { silent = true, desc = "Find LSP references" })
vim.keymap.set("n", "gi", ":Telescope lsp_implementations<cr>", { silent = true, desc = "Find LSP implementations" })
vim.keymap.set("n", "<C-k>", function()
    local ext = vim.bo.filetype
    if ext == "neo-tree" then
        vim.notify("call this from buffer", "info", { timeout = 1000 })
    elseif ext == "markdown" then
        vim.cmd(":Telescope heading")
    elseif ext == "go" or ext == "rust" or ext == "python" or ext == "lua" or ext == "json" or ext == "yaml" then
        vim.cmd(":Telescope lsp_document_symbols")
    else
        vim.cmd(":Telescope treesitter")
    end
end, { silent = true, desc = "Go to symbol in buffer" })

local function toggle_lsp_lines()
    local lines_shown = require("lsp_lines").toggle()
    vim.diagnostic.config({ virtual_text = not lines_shown })
end
vim.keymap.set("n", "<Leader>dm", toggle_lsp_lines, { desc = "Toggle multiline diagnostics" })
vim.keymap.set("n", "<leader>dl", ":FzfLua diagnostics_workspace<cr>", { silent = true, desc = "Workspace diagnostics" })

local diagnostics_active = true
vim.keymap.set("n", "<leader>dt", function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end)

---------
-- Search
---------

vim.keymap.set("n", "<leader>s", ":Telescope search_history<cr>", { silent = true, desc = "Telescope search history" })

vim.keymap.set("n", "<C-f>", function()
    require("telescope.builtin").current_buffer_fuzzy_find({ layout_config = { width = 0.7, height = 0.7, preview_width = 0 } })
end, silent)
vim.keymap.set("n", "<C-M-f>", function()
    require("telescope.builtin").live_grep({
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git",
            "--glob=!node_modules",
        },
    })
end, { silent = true, desc = "Global search" })

vim.keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep({
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "-tgo",
        },
    })
end, { silent = true, desc = "Global search (.go)" })

vim.keymap.set("n", "<leader>fu", function()
    require("telescope.builtin").live_grep({
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "-uu",
        },
    })
end, { silent = true, desc = "Global search (unrestricted)" })
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").grep_string({ shorten_path = true, word_match = "-w", only_sort_text = true, search = "" })
end, { silent = true, desc = "Global search (fuzzy)" })
vim.keymap.set(
    "n",
    "<leader>fa",
    ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    { silent = true, desc = "Global search with args" }
)
vim.keymap.set("n", "<leader>fs", ":Telescope grep_string<cr>", { silent = true, desc = "grep string" })

-----------------
-- Misc
-----------------

local function toggle_quickfix()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            vim.cmd("cclose")
            return
        end
    end
    vim.cmd("copen")
end

vim.keymap.set("n", "<leader>q", toggle_quickfix, { silent = true, desc = "Open quickfix" })

vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { silent = true, desc = "Search undo history" })

vim.keymap.set("n", "<C-e>", function()
    if vim.bo.filetype == "neo-tree" then
        vim.cmd("wincmd l")
    else
        vim.cmd(":Neotree source=filesystem position=left action=focus reveal=true") -- source can be "last"
    end
end, { silent = true, desc = "Focus explorer" })

if IsCMDLineEditor() == true then
    vim.keymap.set("n", "<M-e>", "<cmd>wqall<cr>", { silent = true, desc = "Quit Neovim" })
else
    vim.keymap.set("n", "<M-e>", ":Neotree git_status toggle float focus reveal=true<cr>",
        { silent = true, desc = "git status float" })
end

vim.keymap.set("n", "<C-M-e>", ":Neotree source=diagnostics toggle float focus reveal=true<cr>",
    { silent = true, desc = "diasgnostic float" })

-- Clear stuff
vim.keymap.set("n", "<leader>l", function()
    vim.cmd("noh")
    vim.cmd("cclose")
    require("close_buffers").delete({ type = "nameless", force = true })
    vim.cmd("wall")
    -- vim.cmd("on") -- close other windows
    vim.cmd("echo")
end, { desc = "Clean shit" })

vim.keymap.set("n", "R", "<Nop>")
vim.keymap.set("n", "<C-CR>", "<Plug>(JqPlaygroundRunQuery)")

-----
--Git
-----

vim.keymap.set("n", "<C-g>o", "<cmd>silent !git-open<cr>")
vim.keymap.set("n", "<C-;>", ":FzfLua git_status<cr>", silent)
vim.keymap.set("n", "<C-g>s", ":FzfLua git_stash<cr>", silent)

vim.keymap.set("n", "<C-g>a", "<cmd>Git add %<cr>")
vim.keymap.set("n", "<C-g>j", function()
    vim.defer_fn(SmartCommit, 0)
end, { silent = true, desc = "Smart commit" })

vim.keymap.set("n", "<C-g>lf", "<cmd>FzfLua git_bcommits<cr>")

vim.keymap.set("n", "<C-g>k", "<cmd>Telescope git_branches<cr>")

vim.keymap.set("n", "<C-g>p", "<cmd>Git push<cr>", { desc = "git push" })

-- Git base
vim.keymap.set("n", "<C-g>bh", function()
    vim.cmd("Gitsigns change_base HEAD")
    vim.cmd("Neotree show git_base=HEAD")
end, { desc = "Change base to HEAD" })
vim.keymap.set("n", "<C-g>br", function()
    vim.cmd("Gitsigns change_base release")
    vim.cmd("Neotree show git_base=release")
end, { desc = "Change base to release" })

-----
-- Go
-----

vim.keymap.set("n", "<leader>gta", ":GoAddTest<cr>", { desc = "Add test for current function" })
vim.keymap.set("n", "<leader>gtc", ":GoCoverage -p<cr>", { desc = "Test and show coverage" })
vim.keymap.set("n", "<leader>gl", ":GoLint<cr>", { desc = "Lint" })

vim.keymap.set("n", "<leader>g<cr>", ":GoGenReturn<cr>", { silent = true })
vim.keymap.set("n", "<leader>gr", ":LspRestart<cr>", { silent = true })
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<cr>", { silent = true })
vim.keymap.set("n", "<leader>gp", ":GoFixPlurals<cr>", { silent = true })
vim.keymap.set("n", "<leader>gp", ":GoFixPlurals<cr>", { silent = true })
vim.keymap.set("n", "<leader>gj", ":GoAddTag<cr>")
-- vim.keymap.set("n", "<leader>gj", ":GoAlt<cr>")
vim.keymap.set("n", "<leader>ga", ":GoCodeLenAct<cr>")
vim.keymap.set(
    "n",
    "<leader>gm",
    [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]],
    { noremap = true, silent = true, desc = "Generate stub for interface on a type." }
)
vim.keymap.set("n", "<leader>gi", ":GoImports<cr>")
