-- [SETTINGS]

-- lines/editor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.termguicolors = true
vim.opt.winborder = "rounded"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cinwords = "<"
vim.opt.indentexpr = ""

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.updatetime = 50

vim.opt.swapfile = false

-- [KEYBINDS]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- centering the screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)", silent = true, noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)", silent = true, noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)", silent = true, noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)", silent = true, noremap = true })
vim.keymap.set("n", "<S-g>", "<S-g>zz", { desc = "Go to end of file (centered)", silent = true, noremap = true })

-- quality of life
vim.keymap.set("n", "Y", "yy", { desc = "Yank whole line", silent = true, noremap = true })
vim.keymap.set("n", "D", "dd", { desc = "Delete whole line", silent = true, noremap = true })
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Ctrl + backspace to delete whole word", silent = true })
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>", { desc = "Source current file", noremap = true })
vim.keymap.set("n", "<leader><S-d>", "godG", { desc = "Delete whole file", silent = true, noremap = true })
vim.keymap.set({ "v", "n" }, "<leader>d", "\"_d", { desc = "Delete to void buffer", silent = true, noremap = true })

vim.keymap.set("i", "<C-h>", "<C-o>h", { desc = "Move cursor left", silent = true, noremap = true })
vim.keymap.set("i", "<C-j>", "<C-o>j", { desc = "Move cursor down", silent = true, noremap = true })
vim.keymap.set("i", "<C-k>", "<C-o>k", { desc = "Move cursor up", silent = true, noremap = true })
vim.keymap.set("i", "<C-l>", "<C-o>l", { desc = "Move cursor right", silent = true, noremap = true })

-- functionality
vim.keymap.set({ "v", "n" }, "<leader>y", "\"+y", { desc = "Copy to system clipboard", silent = true, noremap = true })
vim.keymap.set({ "v", "n" }, "<leader>p", "\"+p", { desc = "Copy to system clipboard", silent = true, noremap = true })

-- tabs
vim.keymap.set("n", "<leader>tc", ":tabnew<CR>", { desc = "Open new tab", silent = true, noremap = true })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab", silent = true, noremap = true })
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab", silent = true, noremap = true })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab", silent = true, noremap = true })
vim.keymap.set("n", "<leader>ti", ":tabnew %<CR>",
    { desc = "Open current buffer in new tab", silent = true, noremap = true })

-- [PLUGINS]
vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/EdenEast/nightfox.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { src = "https://github.com/nvim-telescope/telescope.nvim",   branch = "0.1.x" },
    { src = "https://github.com/mattn/emmet-vim" },
    { src = "https://github.com/williamboman/mason.nvim" },
})

-- [LSP]
vim.lsp.enable({ "lua_ls", "cssls", "html", "ts_ls", "rust_analyzer", "glsl_analyzer", "pyright" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format current file using lsp" })
vim.g.rust_recommended_style = 0

require("mason").setup()

vim.keymap.set("n", "<leader>ma", ":Mason<CR>", { desc = "Open Mason panel", silent = true, noremap = true })

require("oil").setup({
    default_file_explorer = true,
    view_options = {
        show_hidden = true,
    },
})
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open Oil file explorer", silent = true, noremap = true })

-- color scheme
vim.cmd.colorscheme("carbonfox")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- status line
local function get_git_branch()
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    return branch ~= "" and "  " .. branch or ""
end

local mode_map = {
    ['n'] = { label = 'NORMAL', color = '#569cd6' },
    ['i'] = { label = 'INSERT', color = '#d8a657' },
    ['v'] = { label = 'VISUAL', color = '#c678dd' },
    ['V'] = { label = 'V-LINE', color = '#c678dd' },
    [''] = { label = 'V-BLOCK', color = '#c678dd' },
    ['R'] = { label = 'REPLACE', color = '#d16969' },
    ['c'] = { label = 'COMMAND', color = '#4ec9b0' },
    ['t'] = { label = 'TERMINAL', color = '#4ec9b0' },
}

local update_statusline = function()
    local mode = vim.api.nvim_get_mode().mode
    local current_mode = mode_map[mode] or { label = mode, color = '#d4d4d4' }

    -- Build statusline without string.format
    vim.opt.statusline = ""
        .. "%#StatusLineMode#" .. " " .. current_mode.label .. " " .. "%#StatusLine#"
        .. " %t%m%r"
        .. "%#StatusLineNC#"
        .. "%=%{&fileencoding} %{&fileformat} %y" .. get_git_branch()
        .. " %#StatusLine#"
        .. " %l:%c %P"
end

vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufEnter' }, {
    callback = update_statusline
})

-- Initial call
update_statusline()

-- Colors
vim.cmd([[
  highlight StatusLine      guibg=NONE guifg=#c0c0c0 gui=bold
  highlight StatusLineNC    guibg=NONE guifg=#6e6a86
  highlight StatusLineMode  guibg=NONE guifg=#3c63f0 gui=bold
  augroup ModeColors
    autocmd!
    autocmd ModeChanged *:[n]* hi! StatusLineMode guifg=#3c63f0
    autocmd ModeChanged *:[i]* hi! StatusLineMode guifg=#ab3cf0
    autocmd ModeChanged *:[vV]* hi! StatusLineMode guifg=#f03c6f
    autocmd ModeChanged *:[R]* hi! StatusLineMode guifg=#f0603c
    autocmd ModeChanged *:[c]* hi! StatusLineMode guifg=#3caef0
    autocmd ModeChanged *:[t]* hi! StatusLineMode guifg=#08c918
  augroup END
]])

-- telescope setup
local tele = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

tele.setup({
    defaults = {
        path_display = { "smart" },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
        },
    },
})

vim.keymap.set("n", "<leader>sf", builtin.find_files,
    { desc = "Fuzzy find files in current directory", silent = true, noremap = true })
vim.keymap.set("n", "<leader>ss", function()
    builtin.grep_string({ search = vim.fn.input("Grep -> ") })
end)

-- treesitter setup
local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    ensure_installed = {
        "python",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "query",
        "vimdoc",
        "c",
        "rust",
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<BS>",
        },
    },
})

-- tab setup
_G.custom_tabline = function()
    local line = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]

        local bufname = ""
        if bufnr and vim.fn.buflisted(bufnr) == 1 then
            bufname = vim.fn.bufname(bufnr) or ""
        end

        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"

        if i == vim.fn.tabpagenr() then
            line = line .. "%#TabLineSel# " .. filename .. " %#TabLine#"
        else
            line = line .. "%#TabLine# " .. filename .. " "
        end
    end
    return line .. "%#TabLineFill#"
end

vim.opt.tabline = "%!v:lua.custom_tabline()"
vim.opt.showtabline = 2

vim.cmd("highlight TabLineSel guibg=#282828 guifg=#c0c0c0 gui=bold")
vim.cmd("highlight TabLine guibg=#141414 guifg=#808080")
vim.cmd("highlight TabLineFill guibg=none")

-- auto commands
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("UserConfig", {}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({
            filter = function(client)
                if client.name == "eslint" then
                    return true
                end
                return client.name ~= "eslint"
            end,
            async = false,
        })
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})
vim.cmd("set completeopt+=noselect")
