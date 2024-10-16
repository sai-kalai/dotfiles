require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging

--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not



local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

local function clone_update(table, other_table)
    -- create a copy of the table
    local copy = {}
    for k, v in pairs(table) do
        copy[k] = v
    end
    -- insert new items
    for k, v in pairs(other_table) do
        copy[k] = v
    end
    return copy
end
vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, clone_update(opts, {desc='go to definition'}))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, clone_update(opts, {desc=''}))
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, clone_update(opts, {desc='[w]orkspace [s]ymbol'}))
        vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, clone_update(opts, {desc='[e]xplain diagnostic'}))
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, clone_update(opts, {desc='[c]ode [a]ctions'}))
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, clone_update(opts, {desc='[r]eferences'}))
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, clone_update(opts, {desc='[r]e[n]ame'}))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, clone_update(opts, {desc=''}))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, clone_update(opts, {desc='previous [d]iagnostic'}))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, clone_update(opts, {desc='next [d]iagnostic'}))
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
