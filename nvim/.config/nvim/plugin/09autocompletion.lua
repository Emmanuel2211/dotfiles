vim.pack.add({
	"https://github.com/micangl/cmp-vimtex",
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.compat",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
})

require("blink.compat").setup({})

local closing_chars = {
	["]"] = true,
	[")"] = true,
	["}"] = true,
	["|"] = true,
	["$"] = true,
	['"'] = true,
	["'"] = true,
	["`"] = true,
}

-- blink corre estas funciones dentro de un mapping <expr> (texto bloqueado):
-- mover el cursor o saltar se hace con vim.schedule, igual que blink.snippet_forward
local function step_over()
	vim.schedule(function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
	end)
	return true
end

-- true si el caracter en (row, col) esta dentro del rango del nodo/snippet
local function contains(node, row, col)
	local ok, from, to = pcall(node.get_buf_position, node)
	if not ok then
		return false
	end
	local after_start = row > from[1] or (row == from[1] and col >= from[2])
	local before_end = row < to[1] or (row == to[1] and col < to[2])
	return after_start and before_end
end

-- Logica de <Tab> (pasos 1-5, ver keymap abajo)
local function smart_tab(cmp)
	local ls = require("luasnip")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local next_char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
	local is_closer = closing_chars[next_char] == true

	-- 1. el cierre esta DENTRO del campo actual o de algun campo que lo contiene
	--    (ej. "(x^{2})" en el campo f(x) de dint: tras expandir "sr" el nodo actual es el
	--    final del snippet "sr", pero el ")" pertenece al campo f(x) de afuera)
	if is_closer and ls.in_snippet() then
		local node = ls.session.current_nodes[vim.api.nvim_get_current_buf()]
		while node do
			if contains(node, row, col) then
				return step_over()
			end
			local snip = node.parent and node.parent.snippet
			-- si el cierre es texto del propio snippet (el "}" de \sqrt{...}) no es tuyo: saltar
			if not snip or contains(snip, row, col) then
				break
			end
			-- el cierre esta despues del snippet: subir al campo donde se expandio (nil si es raiz)
			node = snip.parent_node
		end
	end

	-- 2. siguiente campo del snippet
	--    (saltando paradas en el mismo lugar: el i(2) final de \sqrt{...} y el fin del snippet)
	if ls.locally_jumpable(1) then
		vim.schedule(function()
			local buf = vim.api.nvim_get_current_buf()
			for _ = 1, 10 do
				ls.jump(1)
				-- (se mira la posicion del nodo, no el cursor: al seleccionar texto por defecto
				-- LuaSnip mueve el cursor despues, con feedkeys)
				local node = ls.session.current_nodes[buf]
				-- nil: el salto llego al final del snippet raiz y LuaSnip ya salio de el
				if not node then
					break
				end
				local ok, from, to = pcall(node.get_buf_position, node)
				local empty_here = ok
					and from[1] == row
					and from[2] == col
					and to[1] == from[1]
					and to[2] == from[2]
				if not empty_here or not ls.locally_jumpable(1) then
					break
				end
			end
		end)
		return true
	end

	-- 3. menu de completado abierto
	if cmp.is_menu_visible() then
		return cmp.select_next()
	end

	-- 4. saltar un cierre fuera de cualquier snippet
	if is_closer then
		return step_over()
	end
end

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "fallback" },
		["<C-y>"] = { "accept", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		-- <Tab>, en este orden (el snippet manda sobre el menu; <C-n>/<C-p> siempre mueven el menu):
		--   1. cierre dentro del campo   -> saltar el ) ] } | $ que escribiste dentro del campo
		--   2. snippet con campo siguiente -> saltar al siguiente campo
		--   3. menu abierto              -> siguiente item (se inserta solo, sigue escribiendo)
		--   4. cierre fuera de snippet   -> saltar el cierre
		--   5. nada de lo anterior       -> Tab normal
		["<Tab>"] = {
			function(cmp)
				return smart_tab(cmp)
			end,
			"snippet_forward", -- en modo select (campo con texto por defecto) solo corre esto
			"fallback",
		},
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	snippets = {
		preset = "luasnip",
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
		active = function(filter)
			if filter and filter.direction then
				return require("luasnip").locally_jumpable(filter.direction)
			end
			return require("luasnip").in_snippet()
		end,
		jump = function(direction)
			require("luasnip").jump(direction)
		end,
	},
	sources = {
		default = { "lsp", "path", "cmdline", "snippets", "buffer", "vimtex" },
		providers = {
			snippets = {
				score_offset = 10,
				opts = {
					use_show_condition = false,
				},
			},
			vimtex = {
				name = "vimtex",
				module = "blink.compat.source",
				score_offset = 15,
			},
		},
	},
	signature = { enabled = true },
	completion = {
		-- <Tab> recorre la lista e inserta el item; no hace falta <C-y> (solo para snippets)
		list = { selection = { preselect = false, auto_insert = true } },
		-- dentro de $...$ mandan los autosnippets: el menu no aparece solo (<C-Space> lo abre)
		menu = {
			auto_show = function()
				return not require("luasnip.locals").in_math()
			end,
		},
		documentation = {
			auto_show = true,
			window = { border = "single" },
		},
	},
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})
