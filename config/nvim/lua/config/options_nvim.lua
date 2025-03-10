-- vim.opt.fixendofline = true
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.showtabline = 1
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.number = true -- Option is set as local on autocmd
vim.opt.relativenumber = false
vim.opt.swapfile = false -- fuck swap files
vim.opt.scrolloff = 6
vim.opt.smartindent = true
vim.o.timeout = true
vim.o.timeoutlen = 300 -- this is for which-key.nvim and jk escape
vim.opt.signcolumn = "yes"
vim.o.numberwidth = 1
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

vim.opt.jumpoptions = "stack" -- go back with <C-o> even if buffer has been closed

vim.opt.cmdheight = 1
vim.opt.scroll = 15
vim.opt.mousescroll = "ver:5"
vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.spell = true
vim.opt.cursorline = true
vim.opt.spelllang = "en_us,ru"

-- vim.opt.textwidth = 120 -- live the dream

vim.opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 500

vim.opt.laststatus = 0

vim.o.lazyredraw = false
vim.o.ttyfast = true

vim.diagnostic.config({
    underline = false,

    -- NOTE: handled by lsp_lines
    virtual_text = false,

    signs = false,
    update_in_insert = false,
})

-- Don't display `~` at the end of buffer.
vim.opt.fillchars = { eob = " " }

if IsCMDLineEditor() == true or IsScrollbackPager() == true then
    vim.cmd([[
        set background=dark
        colorscheme tokyonight
    ]])
else
    vim.cmd([[
    if strftime("%H") >= 6 && strftime("%H") < 18
        " set background=light
        set background=dark

        " colorscheme rose-pine
        colorscheme tokyonight-moon
        " colorscheme wildcharm
        " colorscheme kanagawa
    else
        " set background=light
        set background=dark

        " colorscheme kanagawa
        colorscheme tokyonight-moon
    endif
    ]])
end

local function cwd()
    local full_cwd = vim.fn.getcwd()
    local cwd_table = Split(full_cwd, "/")
    return cwd_table[#cwd_table]
end

-- Set window title.
local title = cwd() .. [[\ -\ NVIM]]
vim.cmd([[set title titlestring=]] .. title)

-- https://github.com/kovidgoyal/kitty/issues/108
vim.cmd([[
" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''
]])

---------------------
--- RU layout support (used by plugin in rus.lua)
---------------------

local function escape(str)
    -- You need to escape these characters to work correctly
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift)
        .. ";"
        .. escape(en_shift),
    escape(ru) .. ";" .. escape(en),
}, ",")
