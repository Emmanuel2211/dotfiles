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

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "fallback" },
		["<C-y>"] = { "accept", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<Tab>"] = {
			"snippet_forward",
			-- Esta funcion es para salir de un parentesis (), {} con <Tab>
			function(cmp)
				local col = vim.fn.col(".")
				local line = vim.fn.getline(".")
				local next_char = string.sub(line, col, col)
				local closing_pairs = {
					["]"] = true,
					[")"] = true,
					["}"] = true,
					['"'] = true,
					["'"] = true,
					["`"] = true,
				}

				-- Si hay un paréntesis/comilla a la derecha, salta sobre él
				if closing_pairs[next_char] then
					local right_key = vim.api.nvim_replace_termcodes("<Right>", true, true, true)
					vim.api.nvim_feedkeys(right_key, "n", true)
					return true -- Le dice a blink que ya manejamos la tecla
				end
			end,
			"fallback", -- Si no hay snippet ni paréntesis, inserta un Tab normal
		},
		["<S-Tab>"] = { "snippet_backward", "fallback" },
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
