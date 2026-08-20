-- Theme and Transparency
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

local function set_transparent() -- set UI component to transparent
	local groups = {
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
	for _, g in ipairs(groups) do
		vim.api.nvim_set_hl(0, g, { bg = "none" })
	end
	vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = "#6c7086" })        -- Visible grey
	vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = "#cba6f7", bold = true }) -- Bright Mocha purple
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()
