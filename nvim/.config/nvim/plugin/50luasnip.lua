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

ls.setup({
	update_events = { "TextChanged", "TextChangedI" },
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
})

vim.keymap.set({ "i" }, "<C-k>", function() -- Does nothing!!!! ???
	ls.expand()
end, { silent = true, desc = "expand autocomplete" })

-- vim.keymap.set({ "i", "s" }, "<Tab>", function()
-- 	ls.jump(1)
-- end, { silent = true, desc = "next autocomplete" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function() -- the fuck what is this for?
	ls.jump(-1)
end, { silent = true, desc = "previous autocomplete" })

-- Keymaps for LuaSnip chioce nodes snippets
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
