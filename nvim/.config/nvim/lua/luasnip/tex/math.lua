local loc = require("luasnip.locals")

local s, t, i, f, d, c, sn, l, rep = loc.s, loc.t, loc.i, loc.f, loc.d, loc.c, loc.sn, loc.l, loc.rep
local postfix = loc.postfix
local fmta = loc.fmta
local in_math = loc.in_math
local gen_matrix = loc.generate_matrix

-- Math snippets!!

return {

	-- == Math mode ==
	s(
		{ trig = "mk", snippetType = "autosnippet", desc = "inline math mode", wordTrig = true },
		fmta("$<>$", { i(1, "Inline math!") })
	),
	s(
		{ trig = "dm", snippetType = "autosnippet", desc = "math mode block", wordTrig = true },
		fmta(
			[[
      $$
      <>
      $$
      ]],
			{ i(1, "Math block!") }
		)
	),

	-- == Letras Griegas ==
	s(
		{ trig = "a;", snippetType = "autosnippet", desc = "alpha", wordTrig = false },
		{ t("\\alpha") },
		{ condition = in_math }
	),
	s(
		{ trig = "b;", snippetType = "autosnippet", desc = "beta", wordTrig = false },
		{ t("\\beta") },
		{ condition = in_math }
	),
	s(
		{ trig = "g;", snippetType = "autosnippet", desc = "gamma", wordTrig = false },
		{ t("\\gamma") },
		{ condition = in_math }
	),
	s(
		{ trig = "G;", snippetType = "autosnippet", desc = "Gamma", wordTrig = false },
		{ t("\\Gamma") },
		{ condition = in_math }
	),
	s(
		{ trig = "d;", snippetType = "autosnippet", desc = "delta", wordTrig = false },
		{ t("\\delta") },
		{ condition = in_math }
	),
	s(
		{ trig = "D;", snippetType = "autosnippet", desc = "Delta", wordTrig = false },
		{ t("\\Delta") },
		{ condition = in_math }
	),
	s(
		{ trig = "E;", snippetType = "autosnippet", desc = "epsilon", wordTrig = false },
		{ t("\\epsilon") },
		{ condition = in_math }
	),
	s(
		{ trig = "e;", snippetType = "autosnippet", desc = "varepsilon", wordTrig = false },
		{ t("\\varepsilon") },
		{ condition = in_math }
	),
	s(
		{ trig = "p;", snippetType = "autosnippet", desc = "varphi", wordTrig = false },
		{ t("\\varphi") },
		{ condition = in_math }
	),
	s(
		{ trig = "z;", snippetType = "autosnippet", desc = "zeta", wordTrig = false },
		{ t("\\zeta") },
		{ condition = in_math }
	),
	s(
		{ trig = "t;", snippetType = "autosnippet", desc = "theta", wordTrig = false },
		{ t("\\theta") },
		{ condition = in_math }
	),
	s({ trig = "T;", snippetType = "autosnippet", desc = "Theta", wordTrig = false }, { t("\\Theta") }),
	s({ trig = ";t", snippetType = "autosnippet", desc = "vartheta", wordTrig = false }, { t("\\vartheta") }),
	s({ trig = "i;", snippetType = "autosnippet", desc = "iota", wordTrig = false }, { t("\\iota") }),
	s({ trig = "k;", snippetType = "autosnippet", desc = "kappa", wordTrig = false }, { t("\\kappa") }),
	s({ trig = "l;", snippetType = "autosnippet", desc = "lambda", wordTrig = false }, { t("\\lambda") }),
	s({ trig = "L;", snippetType = "autosnippet", desc = "Lambda", wordTrig = false }, { t("\\Lambda") }),
	s({ trig = "s;", snippetType = "autosnippet", desc = "sigma", wordTrig = false }, { t("\\sigma") }),
	s({ trig = "S;", snippetType = "autosnippet", desc = "Sigma", wordTrig = false }, { t("\\Sigma") }),
	s({ trig = "u;", snippetType = "autosnippet", desc = "upsilon", wordTrig = false }, { t("\\upsilon") }),
	s({ trig = "U;", snippetType = "autosnippet", desc = "Upsilon", wordTrig = false }, { t("\\Upsilon") }),
	s({ trig = "o;", snippetType = "autosnippet", desc = "omega", wordTrig = false }, { t("\\omega") }),
	s({ trig = "O;", snippetType = "autosnippet", desc = "Omega", wordTrig = false }, { t("\\Omega") }),

	-- == Tipografia ==
	-- ++ mathbb
	s(
		{ trig = "RR", snippetType = "autosnippet", desc = "Real numbers set", wordTrig = false },
		{ t("\\mathbb{R}") },
		{ condition = math }
	),
	s(
		{ trig = "CC", snippetType = "autosnippet", desc = "Complex numbers set", wordTrig = false },
		{ t("\\mathbb{C}") },
		{ condition = math }
	),
	s(
		{ trig = "FF", snippetType = "autosnippet", desc = "Field", wordTrig = false },
		{ t("\\mathbb{F}") },
		{ condition = math }
	),
	s(
		{ trig = "NN", snippetType = "autosnippet", desc = "Naturals", wordTrig = false },
		{ t("\\mathbb{N}") },
		{ condition = math }
	),
	s(
		{ trig = "ZZ", snippetType = "autosnippet", desc = "Integers", wordTrig = false },
		{ t("\\mathbb{Z}") },
		{ condition = math }
	),
	s(
		{ trig = "QQ", snippetType = "autosnippet", desc = "Rationals", wordTrig = false },
		{ t("\\mathbb{Q}") },
		{ condition = math }
	),
	-- ++ mathcal
	s(
		{ trig = "LL", snippetType = "autosnippet", desc = "Some L", wordTrig = false },
		{ t("\\mathcal{L}") },
		{ condition = math }
	),
	s(
		{ trig = "PP", snippetType = "autosnippet", desc = "Partition or Power set", wordTrig = false },
		{ t("\\mathcal{P}") },
		{ condition = math }
	),

	-- == Logica ==
	s(
		{ trig = "=>", snippetType = "autosnippet", desc = "Implies", wordTrig = false },
		{ t("\\implies") },
		{ condition = math }
	),
	s(
		{ trig = "=<", snippetType = "autosnippet", desc = "Implied by", wordTrig = false },
		{ t("\\impliedby") },
		{ condition = math }
	),
	s(
		{ trig = "and", snippetType = "autosnippet", desc = "and logical symbol", wordTrig = false },
		{ t("\\land") },
		{ condition = math }
	),
	s(
		{ trig = "or", snippetType = "autosnippet", desc = "or logical symbol", wordTrig = false },
		{ t("\\lor") },
		{ condition = math }
	),
	s(
		{ trig = "inn", snippetType = "autosnippet", desc = "membership relation", wordTrig = false },
		{ t("\\in") },
		{ condition = math }
	),
	s(
		{ trig = "notin", snippetType = "autosnippet", desc = "not a member", wordTrig = false },
		{ t("\\not\\in") },
		{ condition = math }
	),

	-- == Conjuntos ==
	s(
		{ trig = "cap", snippetType = "autosnippet", desc = "Set intersection", wordTrig = false },
		{ t("\\cap") },
		{ condition = math }
	),
	s(
		{ trig = "cup", snippetType = "autosnippet", desc = "Set union", wordTrig = false },
		{ t("\\cup") },
		{ condition = math }
	),
	s(
		{ trig = "smi", snippetType = "autosnippet", desc = "Set difference", wordTrig = false },
		{ t("\\setminus") },
		{ condition = math }
	),
	s(
		{ trig = "sub=", snippetType = "autosnippet", desc = "Subset", wordTrig = false },
		{ t("\\subseteq") },
		{ condition = math }
	),
	s(
		{ trig = "sup=", snippetType = "autosnippet", desc = "Supset", wordTrig = false },
		{ t("\\supseteq") },
		{ condition = math }
	),
	s(
		{ trig = "eset", snippetType = "autosnippet", desc = "Empty set", wordTrig = false },
		{ t("\\varnothing") },
		{ condition = math }
	),
	s(
		{ trig = "set", snippetType = "autosnippet", desc = "Set braces", wordTrig = false },
		{ t("\\{ "), i(1), t(" \\}") },
		{ condition = math }
	),

	-- == Operadores y Operaciones Basicas ==
	s(
		{ trig = "rd", snippetType = "autosnippet", desc = "Arbitrary exponent", wordTrig = false },
		fmta("^{<>}", { i(1, "n") }),
		{ condition = math }
	),
	s(
		{ trig = "sr", snippetType = "autosnippet", desc = "Squared", wordTrig = false },
		t("^{2}"),
		{ condition = math }
	),
	s({ trig = "cb", snippetType = "autosnippet", desc = "Cubed", wordTrig = false }, t("^{3}"), { condition = math }),
	s(
		{ trig = "//", snippetType = "autosnippet", desc = "Fraction", wordTrig = true },
		fmta("\\frac{<>}{<>}", { i(1), i(2) }),
		{ condition = math }
	),
	postfix({
		trig = "//",
		snippetType = "autosnippet",
		desc = "Also fraction, but introduces the previous written characters in the first {} of \\frac",
		wordTrig = false,
	}, {
		f(function(_, parent)
			return "\\frac{" .. parent.snippet.env.POSTFIX_MATCH .. "}{"
		end, {}),
		i(1),
		t("}"),
	}, { condition = math }),

	-- == Linear Algebra ==
	-- matrix dynamic node
	s(
		{
			trig = "([%sbBpvV])mat(%d+)x(%d+)",
			snippetType = "autosnippet",
			regTrig = true,
			wordTrig = false,
			dscr = "[bBpvV]matrix of A x B size",
		},
		fmta(
			[[
    \begin{<>}
    <>
    \end{<>}]],
			{
				f(function(_, snip)
					if snip.captures[1] == " " then
						return "matrix"
					else
						return snip.captures[1] .. "matrix"
					end
				end),
				d(1, gen_matrix),
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
			}
		),
		{ show_condition = math }
	),
	s(
		{
			trig = "cases",
			snippetType = "autosnippet",
			desc = "Cases for functions or multicase equations",
			wordTrig = false,
		},
		fmta(
			[[
    \begin{cases}
      <>
    \end{cases}
    ]],
			{ i(1) }
		),
		{ condition = math }
	),

	-- == Calculus ==
	s(
		{
			trig = ";I",
			snippetType = "autosnippet",
			desc = "Integrals",
			wordTrig = false,
		},
		c(1, {
			sn(nil, { t("\\int_{-\\infty}^\\infty"), i(1) }),
			sn(nil, { t("\\int_{"), i(1, "a"), t("}^{"), i(2, "b"), t("}") }),
		}),
		{ condition = math }
	),
	-- s({
	-- 	trig = ";D",
	-- 	desc = "Derivates, derivadas",
	-- 	wordTrig = false,
	-- }),

	-- == Acentos ==
	s(
		{ trig = "over", snippetType = "autosnippet", desc = "Set braces", wordTrig = false },
		{ t("\\overset{"), i(1), t("}{"), i(2), t("}") },
		{ condition = math }
	),
	postfix({
		trig = "hat",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix hat when in math mode",
	}, { l("\\hat{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),

	postfix({
		trig = "vec",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix vec when in math mode",
	}, { l("\\vec{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),

	postfix({
		trig = "bar",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix bar when in math mode",
	}, { l("\\bar{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),

	postfix({
		trig = "dott",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix dot when in math mode",
	}, { l("\\dot{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),

	-- == Texto ==
	--
	-- To bold text: First select, Tab, textbf
	-- Para cuando tengo algo ya escrito y quiero hacerlo en negritas
	s(
		{ trig = "textbf", dscr = "Textbf, either in insert mode or selecting text" },
		fmta("\\textbf{<>}", { d(1, visualSelectionOrInsert) })
	),
	s(
		{ trig = "emph", dscr = "the emph command, either in insert mode or wrapping a visual selection" },
		fmta("\\emph{<>}", { d(1, visualSelectionOrInsert) })
	),

	-- == Environments ==
	s(
		{ trig = "env", snippetType = "snippet", desc = "Begin and end an arbitrary environment" },
		fmta(
			[[
      \begin{<>}
        <>
      \end{<>}
      ]],
			{ i(1), i(2), rep(1) }
		)
	),

	s(
		{ trig = "fig", snippetType = "snippet", desc = "A basic figure environment" },
		fmta(
			[[
      \begin{figure}
      \centering
      \includegraphics[width=0.9\linewidth]{<>}
      \caption{
        \textbf{<>}
        <>
        }
      \label{fig:<>}
      \end{figure}

      ]],
			{
				i(1, "filename"),
				i(2, "captionBold"),
				i(3, "captionText"),
				i(4, "figureLabel"),
			}
		)
	),
}
