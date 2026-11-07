local twoslash = require("twoslash-queries")
local prelude = require("imranbarbhuiya.prelude")
local copy_line_diagnostics_to_clipboard = prelude.copy_line_diagnostics_to_clipboard
local open_link = prelude.open_link

local M = {}

vim.keymap.set("n", "<space>", "<nop>", { desc = "Disable space (leader) in normal mode" })
vim.keymap.set("n", "<C-/>", "<nop>")

vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })

vim.keymap.set("n", "<leader>'", "<C-^>", { desc = "Switch to last buffer" })

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false, desc = "Save current buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false, desc = "Quit current buffer" })

vim.keymap.set("n", "<leader>e", function()
    require("oil").toggle_float()
end, { desc = "Toggle Oil file explorer" })

vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })

vim.keymap.set("n", "<leader>ti", ":TwoslashQueriesInspect<CR>", { desc = "[I]nspect [T]woslash Query" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to next paragraph and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Search previous and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Search next and center" })
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to beginning of file and center" })
vim.keymap.set("n", "gd", "gdzz", { desc = "Go to definition and center" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Jump forward in jump list and center" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Jump backward in jump list and center" })
vim.keymap.set("n", "%", "%zz", { desc = "Jump to matching bracket and center" })
vim.keymap.set("n", "*", "*zz", { desc = "Search for word under cursor and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search backward for word under cursor and center" })

vim.keymap.set("n", "S", function()
    local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
    local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end, { desc = "Quick find/replace word under cursor" })

vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
vim.keymap.set("n", "H", "^", { desc = "Jump to beginning of line" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo last change" })

vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>", { desc = "Toggle search highlighting" })

vim.keymap.set("n", "<leader>ts", function()
    if twoslash.config.is_enabled then
        vim.cmd("TwoslashQueriesDisable")
        Snacks.notify.info("Two Slash queries disabled")
        return
    end

    vim.cmd(":TwoslashQueriesEnable")
    Snacks.notify.info("Two Slash queries enabled")
end, { desc = "Toggle [T]wo [S]lash queries" })

vim.keymap.set("n", "]d", function()
    local ok = pcall(vim.diagnostic.jump, { count = 1, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to next diagnostic and center" })

vim.keymap.set("n", "[d", function()
    local ok = pcall(vim.diagnostic.jump, { count = -1, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to previous diagnostic and center" })

vim.keymap.set("n", "]e", function()
    local ok = pcall(vim.diagnostic.jump, { count = 1, severity = vim.diagnostic.severity.ERROR, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to next error diagnostic and center" })

vim.keymap.set("n", "[e", function()
    local ok = pcall(vim.diagnostic.jump, { count = -1, severity = vim.diagnostic.severity.ERROR, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to previous error diagnostic and center" })

vim.keymap.set("n", "]w", function()
    local ok = pcall(vim.diagnostic.jump, { count = 1, severity = vim.diagnostic.severity.WARN, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to next warning diagnostic and center" })

vim.keymap.set("n", "[w", function()
    local ok = pcall(vim.diagnostic.jump, { count = -1, severity = vim.diagnostic.severity.WARN, float = false })
    if ok then
        vim.api.nvim_feedkeys("zz", "n", false)
    end
end, { desc = "Go to previous warning diagnostic and center" })

vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Open diagnostic float with rounded border" })

vim.keymap.set("n", "<leader>cd", copy_line_diagnostics_to_clipboard, { desc = "[C]opy line [D]iagnostics" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setqflist, { desc = "Populate quickfix list with diagnostics" })

vim.keymap.set("n", "<leader>cn", ":cnext<cr>zz", { desc = "Go to next quickfix item and center" })
vim.keymap.set("n", "<leader>cp", ":cprevious<cr>zz", { desc = "Go to previous quickfix item and center" })
vim.keymap.set("n", "<leader>co", ":copen<cr>zz", { desc = "Open quickfix list and center" })
vim.keymap.set("n", "<leader>cc", ":cclose<cr>zz", { desc = "Close quickfix list" })

vim.keymap.set("n", "<leader>m", ":MaximizerToggle<cr>", { desc = "Toggle window maximization" })
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Equalize split window sizes" })

vim.keymap.set("n", "<leader>f", function()
    require("conform").format({
        async = true,
        timeout_ms = 500,
        lsp_format = "fallback",
    })
end, { desc = "Format the current buffer" })

vim.keymap.set("n", "gx", open_link, { silent = true, desc = "Open link under cursor (supports markdown and parens)" })

vim.keymap.set("n", "<leader>tc", ":TSC<cr>", { desc = "Run TypeScript compile" })

vim.keymap.set("n", "<leader>ho", function()
    require("harpoon.ui").toggle_quick_menu()
end, { desc = "Toggle Harpoon quick menu" })

vim.keymap.set("n", "<leader>ha", function()
    require("harpoon.mark").add_file()
end, { desc = "Add current file to Harpoon" })

vim.keymap.set("n", "<leader>hr", function()
    require("harpoon.mark").rm_file()
end, { desc = "Remove current file from Harpoon" })

vim.keymap.set("n", "<leader>hc", function()
    require("harpoon.mark").clear_all()
end, { desc = "Clear all Harpoon marks" })

vim.keymap.set("n", "<leader>1", function()
    require("harpoon.ui").nav_file(1)
end, { desc = "Navigate to Harpoon file 1" })

vim.keymap.set("n", "<leader>2", function()
    require("harpoon.ui").nav_file(2)
end, { desc = "Navigate to Harpoon file 2" })

vim.keymap.set("n", "<leader>3", function()
    require("harpoon.ui").nav_file(3)
end, { desc = "Navigate to Harpoon file 3" })

vim.keymap.set("n", "<leader>4", function()
    require("harpoon.ui").nav_file(4)
end, { desc = "Navigate to Harpoon file 4" })

vim.keymap.set("n", "<leader>5", function()
    require("harpoon.ui").nav_file(5)
end, { desc = "Navigate to Harpoon file 5" })

vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "Search open buffers" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "Search files" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Search help tags" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "Live grep search" })
vim.keymap.set("n", "<leader>sc", require("telescope.builtin").git_bcommits, { desc = "[S]earch buffer [C]ommits" })

vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown({ previewer = false })
    )
end, { desc = "Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>ss", function()
    require("telescope.builtin").spell_suggest(require("telescope.themes").get_dropdown({ previewer = false }))
end, { desc = "Spell suggestions search" })

M.map_lsp_keybinds = function(buffer_number)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol", buffer = buffer_number })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action", buffer = buffer_number })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition", buffer = buffer_number })
    vim.keymap.set(
        "n",
        "gr",
        require("telescope.builtin").lsp_references,
        { desc = "LSP: Go to references", buffer = buffer_number }
    )
    vim.keymap.set(
        "n",
        "gi",
        require("telescope.builtin").lsp_implementations,
        { desc = "LSP: Go to implementations", buffer = buffer_number }
    )
    vim.keymap.set(
        "n",
        "<leader>bs",
        require("telescope.builtin").lsp_document_symbols,
        { desc = "LSP: Document symbols", buffer = buffer_number }
    )
    vim.keymap.set(
        "n",
        "<leader>ps",
        require("telescope.builtin").lsp_workspace_symbols,
        { desc = "LSP: Workspace symbols", buffer = buffer_number }
    )

    local signature_help = function()
        return vim.lsp.buf.signature_help({ border = "rounded" })
    end

    local hover = function()
        return vim.lsp.buf.hover({ border = "rounded" })
    end

    vim.keymap.set("n", "K", hover, { desc = "LSP: Signature help", buffer = buffer_number })
    vim.keymap.set("i", "<C-k>", signature_help, { desc = "LSP: Signature help", buffer = buffer_number })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration", buffer = buffer_number })
    vim.keymap.set("n", "td", vim.lsp.buf.type_definition, { desc = "LSP: Type definition", buffer = buffer_number })
end

vim.keymap.set("i", "jj", "<esc>", { desc = "Exit insert mode (jj)" })
vim.keymap.set("i", "JJ", "<esc>", { desc = "Exit insert mode (JJ)" })

vim.keymap.set("v", "<space>", "<nop>", { desc = "Disable space (leader) in visual mode" })
vim.keymap.set("v", "L", "$<left>", { desc = "Move to end of line in visual mode" })
vim.keymap.set("v", "H", "^", { desc = "Move to beginning of line in visual mode" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected block down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected block up" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

vim.keymap.set("x", "<<", function()
    vim.cmd("normal! <<")
    vim.cmd("normal! gv")
end, { desc = "Indent left and reselect visual block" })

vim.keymap.set("x", ">>", function()
    vim.cmd("normal! >>")
    vim.cmd("normal! gv")
end, { desc = "Indent right and reselect visual block" })

return M