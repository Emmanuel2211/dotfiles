vim.loader.enable()

-- Main settings
require("plugin.00options")
require("plugin.02autocmds")
require("plugin.03baseKeymaps")
require("plugin.04statusLine")
require("plugin.05theme")
-- PLUGINS (native vim.pack)
-- LSP
require("plugin.10LSP")
-- Others
require("plugin.20nvim-treesitter")
require("plugin.30fzf-lua")
require("plugin.40mini")
require("plugin.50luasnip")
require("plugin.60vim-tmux-navigator")
require("plugin.80nvim-tree")
require("plugin.90floatingTerminal")
require("plugin.99gitsigns")
