vim.pack.add({
	"https://www.github.com/folke/flash.nvim",
})

require("flash").setup({
	labels = "asdfghjklqwertyuiop",
	highlight = {
		-- Oscurece el texto de fondo que no coincide
		backdrop = true,
	},
	modes = {
		char = {
			-- Opcional: si también quieres que se oscurezca el fondo cuando usas 'f', 'F', 't', 'T'
			enabled = true,
			highlight = { backdrop = true },
		},
	},
})

-- Mapeo principal en <CR> para Flash.nvim
vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
	require("flash").jump()
end, { desc = "Flash Jump" })
