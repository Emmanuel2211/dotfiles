vim.pack.add({
	"https://github.com/christoomey/vim-tmux-navigator",
})

vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>", {
	noremap = true,
	silent = true,
})
vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>", {
	noremap = true,
	silent = true,
})
vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>", {
	noremap = true,
	silent = true,
})
vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>", {
	noremap = true,
	silent = true,
})
