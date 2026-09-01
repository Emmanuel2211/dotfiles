-- lua/luasnip/md.lua
--
-- Usual LuaSnip Locals
local loc = require("luasnip.locals")

local s, t, i, f, d, c, sn, l, rep = loc.s, loc.t, loc.i, loc.f, loc.d, loc.c, loc.sn, loc.l, loc.rep
local postfix = loc.postfix
local fmta = loc.fmta
local in_md_math = loc.in_markdown_math
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
        <>
      \end{align}
      ]],
			{ i(1) }
		),
		{ condition = in_md_math }
	),
}

vim.list_extend(markdown_snippets, tex_math_snippets)

return markdown_snippets
