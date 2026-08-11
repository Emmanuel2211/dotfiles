-- =====================================================================
-- Options
-- =====================================================================

vim.o.number = true -- line numbers
vim.o.relativenumber = true -- relative line numbers
vim.o.cursorline = true -- enlighten cursor line
vim.o.wrap = false -- do not wrap text
vim.o.scrolloff = 10 -- keep 10 lines above/below cursor
vim.o.sidescrolloff = 10 -- same left/right

-- Tabs
vim.o.tabstop = 2 -- 2 spaces tab
vim.o.shiftwidth = 2 -- indent width
vim.o.softtabstop = 2 -- In insert mode when <Tab> move cursor to next tab
vim.o.expandtab = true -- ?
vim.o.smartindent = true -- ?
vim.o.autoindent = true -- ?
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour

-- Search
vim.o.ignorecase = true -- search ignores cases
vim.o.smartcase = true -- ignores case if uppercase in searched string
vim.o.hlsearch = true -- highlight search
vim.o.incsearch = true -- highlight progressively as searching

-- Editor, PUM, conceal
vim.o.signcolumn = "yes" -- always show sign column
vim.o.colorcolumn = "80" -- show limit column at 100 char position
vim.o.cmdheight = 1 -- one line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- autocompletion menu (PUM) options
vim.o.showmode = false -- do not show mode, cuz I have it in statusline
vim.o.pumheight = 10 -- PUM max rows
vim.o.pumblend = 10 -- PUM transparency
vim.o.winblend = 0 -- floating window transparency
vim.o.conceallevel = 0 -- do not hide markup
vim.o.concealcursor = "" -- do not hide cursorline in markup
-- vim.o.lazyredraw = true -- do not redraw until finished (considered unnecessary for modern nvim configs)
vim.o.synmaxcol = 240 -- syntax highlight limit for a single line
vim.opt.fillchars = {
	eob = " ",
	vert = "│",
	horiz = "─",
} -- hide "~" on empty lines

-- Undofiles and Backups
vim.opt.backup = false -- do not create backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile... SO USE GIT INSTEAD
vim.opt.undofile = true -- do create a undo file (conserves undos even if nvim closed)

vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 0 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of nvim
vim.opt.autowrite = false -- do not auto-save (cuz LSP)

vim.opt.hidden = true -- buffer is hidden(still in RAM) when abandoned(change to other buffer)
vim.opt.iskeyword:append("-") -- include "-" in words: hola-Emma (one word)
vim.opt.path:append("**") -- include subdirs in search
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

-- Cursor Blink
vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"a:blinkwait700-blinkon400-blinkoff250",
}

-- clear hlsearch highlight
vim.cmd("packadd nohlsearch")

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.splitbelow = true -- horizontal split go below
vim.opt.splitright = true -- vertical split go right

vim.opt.wildmode = "longest:full,full" -- complete logest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display (for highlighting git changes)
