local loc = require("luasnip.locals")

local s, t, i, f, d, c, sn, l, rep = loc.s, loc.t, loc.i, loc.f, loc.d, loc.c, loc.sn, loc.l, loc.rep
local postfix = loc.postfix
local fmta = loc.fmta
local in_math = loc.in_math

-- Formatting snippets!!!

return {
	-- begin/end arbitrary environment
	s(
		{
			trig = "begin",
			snippetType = "autosnippet",
			desc = "Arbitrary Environment",
			wordTrig = false,
		},
		fmta(
			[[
      \begin{<>}
        <>
      \end{<>}
      ]],
			{ i(1, "itemize"), i(2), rep(1) }
		)
	),

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
		)
	),
}
