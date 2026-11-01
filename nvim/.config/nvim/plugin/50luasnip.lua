vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
})

-- auto-build jsregexp C extension if missing
local function ensure_jsregexp_built()
	local luasnip_lua_path = vim.api.nvim_get_runtime_file("lua/luasnip/init.lua", false)[1]
	if not luasnip_lua_path then
		return
	end

	local luasnip_root = vim.fn.fnamemodify(luasnip_lua_path, ":h:h:h")
	local artifact = luasnip_root .. "/deps/jsregexp/jsregexp.so"

	if vim.fn.has("win32") == 1 then
		artifact = luasnip_root .. "/deps/jsregexp/jsregexp.dll"
	end

	if not vim.uv.fs_stat(artifact) then
		vim.notify("Building LuaSnip jsregexp in the background...", vim.log.levels.INFO)
		vim.system({ "make", "install_jsregexp" }, { cwd = luasnip_root }, function(out)
			vim.schedule(function()
				if out.code == 0 then
					vim.notify("LuaSnip jsregexp built successfully!", vim.log.levels.INFO)
				else
					vim.notify(
						"Failed to build LuaSnip jsregexp:\n" .. (out.stderr or out.stdout or ""),
						vim.log.levels.ERROR
					)
				end
			end)
		end)
	end
end
ensure_jsregexp_built()

-- Path to snippets
local snippet_path = vim.fn.stdpath("config") .. "/lua/luasnip/"
require("luasnip.loaders.from_lua").lazy_load({ paths = { snippet_path } })

local ls = require("luasnip")
local types = require("luasnip.util.types")

-- luasnip settings
ls.setup({
	update_events = { "TextChanged", "TextChangedI" },
	enable_autosnippets = true,
	-- visual: selecciona, <Tab>, escribe el trigger (sq, lr(), mbb, //...) y la seleccion queda dentro
	store_selection_keys = "<Tab>",
	-- al salir del snippet (<Esc> + moverte, o volver a insertar en otro lado) se olvida:
	-- <Tab> ya no salta de vuelta a snippets viejos
	region_check_events = { "CursorMoved", "CursorHold", "InsertEnter" },
	delete_check_events = { "TextChanged", "InsertLeave" },
	-- snippets dentro de snippets: termina el de adentro y luego sigue con el de afuera
	exit_roots = true,
	keep_roots = false,
	link_roots = false,
	link_children = false,
})

-- <Tab> / <S-Tab> los maneja blink.cmp (plugin/09autocompletion.lua)

-- Keymaps for LuaSnip chioce nodes snippets
vim.keymap.set({ "i", "s", "n" }, "<C-e>", function()
	if require("luasnip").choice_active() then
		require("luasnip").change_choice(1)
	end
end, { silent = true })
-- Display dialogue box for chioces
-- TODO: change C-z for other cuz that keybind suspends bash current program
vim.keymap.set(
	{ "i", "s" },
	"<C-b>",
	"<cmd>lua require('luasnip.extras.select_choice')()<cr>",
	{ noremap = true, desc = "ui select for choice node" }
)
