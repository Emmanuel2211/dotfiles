vim.pack.add({
	"https://github.com/jmbuhr/otter.nvim",
})

local otter = require("otter")

-- Opciones visuales base
otter.setup({
	lsp = {
		hover = { border = "rounded" },
		diagnostic_update_events = { "BufWritePost", "InsertLeave" },
	},
})

-- Automatización con el enfoque dinámico del autor
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	callback = function()
		-- Usamos 'nil' como dice la doc: activa todos los lenguajes disponibles dinámicamente
		otter.activate(nil, true, true, nil)
	end,
})
