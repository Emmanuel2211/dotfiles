vim.pack.add({
	"https://github.com/micangl/cmp-vimtex",
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.compat",
})

local cmp = require("blink.cmp")
require("blink.compat").setup({})
cmp.setup({
	keymap = {
		preset = "default",
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
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
			snippets = { score_offset = 10 },
			vimtex = {
				name = "vimtex",
				module = "blink.compat.source",
				score_offset = 15,
			},
		},
	},
	signature = { enabled = true },
	completion = {
		documentation = {
			auto_show = true,
			window = { border = "single" },
		},
	},
})
