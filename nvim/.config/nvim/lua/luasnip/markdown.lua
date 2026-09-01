-- lua/luasnip/md.lua
--
-- Usual LuaSnip Locals
local loc = require("luasnip.locals")

local s, t, i, f, d, c, sn, l, rep = loc.s, loc.t, loc.i, loc.f, loc.d, loc.c, loc.sn, loc.l, loc.rep
local postfix = loc.postfix
local fmta = loc.fmta
local in_math = loc.in_math
local gen_matrix = loc.generate_matrix

-- Require Latex math snippets, with 'locals' math function working for .md & VimTex
local tex_math_snippets = require("luasnip.tex.math")

-- Markdown Snippets!

local markdown_snippets = {
	s(
		{
			trig = "align",
			snippetType = "autosnippet",
			desc = "Align Environment",
			wordTrig = false,
		},
		fmta(
			[[
      \begin{align}
        <> &<> <>
      \end{align}
      ]],
			{ i(1), i(2, "="), i(3) }
		),
		{ condition = in_math }
	),
	s({
		trig = "QED",
		snippetType = "autosnippet",
		desc = "End Proof Square",
		wordTrig = false,
	}, t("\\tag*{$\\blacksquare$}"), { condition = in_math }),

	s({
		trig = "thm",
		snippetType = "autosnippet",
		wordTrig = true,
	}, {
		t("> [!theorem] **"),
		i(1, "Teorema."),
		t("** ("),
		i(2),
		t(")"),
	}),

	s({
		trig = "exm",
		snippetType = "autosnippet",
		wordTrig = true,
	}, {
		t("> [!example]+ "),
		i(1, "Ejemplo."),
		t(" ("),
		i(2),
		t(")"),
	}),

	s({
		trig = "prf",
		snippetType = "autosnippet",
		wordTrig = true,
	}, {
		t("> [!proof]+ **Proof.**"),
		i(1),
	}),

	s({
		trig = "obss",
		snippetType = "autosnippet",
		wordTrig = true,
	}, {
		t("> [!observation]+ **Observación.**"),
		i(1),
	}),
}

vim.list_extend(markdown_snippets, tex_math_snippets)

return markdown_snippets
