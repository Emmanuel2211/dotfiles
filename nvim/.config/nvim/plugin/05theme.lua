vim.pack.add({
	-- Nuevos temas de colores
	"https://www.github.com/vague2k/vague.nvim",
	"https://www.github.com/rebelot/kanagawa.nvim",
	"https://www.github.com/rose-pine/neovim",
	"https://www.github.com/folke/tokyonight.nvim",
})

-- Selector de temas con FZF-Lua
vim.keymap.set("n", "<leader>th", function()
	require("fzf-lua").colorschemes()
end, { desc = "Selector de Temas (Fzf)" })

-- 1. Cargar el tema inicial
vim.opt.termguicolors = true
vim.cmd.colorscheme("vague") -- "catpuccin", "vague" "kanagawa", "rose-pine", "tokyonight"

-- 2. Anclar la transparencia y Flash a los cambios de tema
local theme_augroup = vim.api.nvim_create_augroup("ThemeOverrides", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = theme_augroup,
	callback = function()
		-- Quitar fondos para transparencia
		local transparent_groups = {
			"Normal",
			"NormalNC",
			"EndOfBuffer",
			"NormalFloat",
			"FloatBorder",
			"SignColumn",
			"StatusLine",
			"StatusLineNC",
			"TabLine",
			"TabLineFill",
			"TabLineSel",
			"ColorColumn",
		}
		for _, g in ipairs(transparent_groups) do
			vim.api.nvim_set_hl(0, g, { bg = "none" })
		end

		-- Mantener fondos transparentes en las líneas numéricas sin forzar colores ajenos
		vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", bold = true })

		-- Forzar el color de fondo atenuado de Flash
		vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
	end,
})

-- Ejecutar manualmente la primera vez para aplicarlo al tema inicial
vim.api.nvim_exec_autocmds("ColorScheme", {})
