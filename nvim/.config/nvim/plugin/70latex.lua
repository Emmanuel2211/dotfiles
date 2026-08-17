-- We need to configure vimtex globals BEFORE loading the plugin
vim.g.vimtex_imaps_enabled = 0 -- disable imaps (luasnip instead)

-- vimtex view settings... you'll need to configure based on your pdf viewer of choice
vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

vim.pack.add({
	"https://github.com/lervag/vimtex",
})
