local loc = require("luasnip.locals")

local s, t, i, f, d, c, sn, l, rep = loc.s, loc.t, loc.i, loc.f, loc.d, loc.c, loc.sn, loc.l, loc.rep
local postfix = loc.postfix
local fmta = loc.fmta
local in_math = loc.in_math
local gen_matrix = loc.generate_matrix
--
--
-- Función auxiliar para detectar si estamos en un callout
local function get_callout_prefix()
	local line = vim.api.nvim_get_current_line()
	-- Busca cualquier combinación de espacios y el símbolo '>' al inicio de la línea
	local prefix = line:match("^[%s>]+")

	-- Si la línea realmente tiene un '>', devolvemos ese prefijo exacto
	if prefix and prefix:find(">") then
		return prefix
	end

	-- Si es una linea de texto normal, no agregamos nada
	return ""
end

-- Math snippets!!

return {

	-- == Math mode ==
	s(
		{ trig = "mk", snippetType = "autosnippet", desc = "inline math mode", wordTrig = true },
		fmta("$<>$", { i(1, "Inline math!") })
	),
	-- display math dinamico! detecta ">" de callouts
	s(
		{ trig = "dm", snippetType = "autosnippet", wordTrig = true },
		fmta(
			[[
        $$
        <><>
        <>$$
        ]],
			{
				f(function()
					return get_callout_prefix()
				end), -- Inyecta el '>' en la línea del medio
				i(1), -- Tu cursor va aquí
				f(function()
					return get_callout_prefix()
				end), -- Inyecta el '>' en la última línea
			}
		)
	),

	-- == Letras Griegas ==
	s(
		{ trig = "a;", snippetType = "autosnippet", desc = "alpha", wordTrig = false },
		{ t("\\alpha ") },
		{ condition = in_math }
	),
	s(
		{ trig = "b;", snippetType = "autosnippet", desc = "beta", wordTrig = false },
		{ t("\\beta ") },
		{ condition = in_math }
	),
	s(
		{ trig = "g;", snippetType = "autosnippet", desc = "gamma", wordTrig = false },
		{ t("\\gamma ") },
		{ condition = in_math }
	),
	s(
		{ trig = "G;", snippetType = "autosnippet", desc = "Gamma", wordTrig = false },
		{ t("\\Gamma ") },
		{ condition = in_math }
	),
	s(
		{ trig = "d;", snippetType = "autosnippet", desc = "delta", wordTrig = false },
		{ t("\\delta ") },
		{ condition = in_math }
	),
	s(
		{ trig = "D;", snippetType = "autosnippet", desc = "Delta", wordTrig = false },
		{ t("\\Delta ") },
		{ condition = in_math }
	),
	s(
		{ trig = "E;", snippetType = "autosnippet", desc = "epsilon", wordTrig = false },
		{ t("\\epsilon ") },
		{ condition = in_math }
	),
	s(
		{ trig = "e;", snippetType = "autosnippet", desc = "varepsilon", wordTrig = false },
		{ t("\\varepsilon ") },
		{ condition = in_math }
	),
	s(
		{ trig = "p;", snippetType = "autosnippet", desc = "varphi", wordTrig = false },
		{ t("\\varphi ") },
		{ condition = in_math }
	),
	s(
		{ trig = "z;", snippetType = "autosnippet", desc = "zeta", wordTrig = false },
		{ t("\\zeta") },
		{ condition = in_math }
	),
	s(
		{ trig = "t;", snippetType = "autosnippet", desc = "theta", wordTrig = false },
		{ t("\\theta ") },
		{ condition = in_math }
	),
	s(
		{ trig = "T;", snippetType = "autosnippet", desc = "Theta", wordTrig = false },
		{ t("\\Theta ") },
		{ condition = in_math }
	),
	s(
		{ trig = ";t", snippetType = "autosnippet", desc = "vartheta", wordTrig = false },
		{ t("\\vartheta ") },
		{ condition = in_math }
	),
	s(
		{ trig = "i;", snippetType = "autosnippet", desc = "iota", wordTrig = false },
		{ t("\\iota") },
		{ condition = in_math }
	),
	s(
		{ trig = "k;", snippetType = "autosnippet", desc = "kappa", wordTrig = false },
		{ t("\\kappa") },
		{ condition = in_math }
	),
	s(
		{ trig = "l;", snippetType = "autosnippet", desc = "lambda", wordTrig = false },
		{ t("\\lambda ") },
		{ condition = in_math }
	),
	s(
		{ trig = "L;", snippetType = "autosnippet", desc = "Lambda", wordTrig = false },
		{ t("\\Lambda ") },
		{ condition = in_math }
	),
	s(
		{ trig = "s;", snippetType = "autosnippet", desc = "sigma", wordTrig = false },
		{ t("\\sigma ") },
		{ condition = in_math }
	),
	s(
		{ trig = "S;", snippetType = "autosnippet", desc = "Sigma", wordTrig = false },
		{ t("\\Sigma ") },
		{ condition = in_math }
	),
	s(
		{ trig = "u;", snippetType = "autosnippet", desc = "upsilon", wordTrig = false },
		{ t("\\upsilon ") },
		{ condition = in_math }
	),
	s(
		{ trig = "U;", snippetType = "autosnippet", desc = "Upsilon", wordTrig = false },
		{ t("\\Upsilon ") },
		{ condition = in_math }
	),
	s(
		{ trig = "o;", snippetType = "autosnippet", desc = "omega", wordTrig = false },
		{ t("\\omega ") },
		{ condition = in_math }
	),
	s(
		{ trig = "O;", snippetType = "autosnippet", desc = "Omega", wordTrig = false },
		{ t("\\Omega ") },
		{ condition = in_math }
	),

	-- == Tipografia ==
	-- ++ mathbb
	s(
		{ trig = "mbb", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathbb{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "RR", snippetType = "autosnippet", desc = "Real numbers set", wordTrig = false },
		{ t("\\mathbb{R}") },
		{ condition = in_math }
	),
	s(
		{ trig = "CC", snippetType = "autosnippet", desc = "Complex numbers set", wordTrig = false },
		{ t("\\mathbb{C}") },
		{ condition = in_math }
	),
	s(
		{ trig = "FF", snippetType = "autosnippet", desc = "Field", wordTrig = false },
		{ t("\\mathbb{F}") },
		{ condition = in_math }
	),
	s(
		{ trig = "NN", snippetType = "autosnippet", desc = "Naturals", wordTrig = false },
		{ t("\\mathbb{N}") },
		{ condition = in_math }
	),
	s(
		{ trig = "ZZ", snippetType = "autosnippet", desc = "Integers", wordTrig = false },
		{ t("\\mathbb{Z}") },
		{ condition = in_math }
	),
	s(
		{ trig = "QQ", snippetType = "autosnippet", desc = "Rationals", wordTrig = false },
		{ t("\\mathbb{Q}") },
		{ condition = in_math }
	),
	--
	-- ++ mathcal
	s(
		{ trig = "mcal", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathcal{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "LL", snippetType = "autosnippet", desc = "Some L", wordTrig = false },
		{ t("\\mathcal{L}") },
		{ condition = in_math }
	),
	s(
		{ trig = "PP", snippetType = "autosnippet", desc = "Partition or Power set", wordTrig = false },
		{ t("\\mathcal{P}") },
		{ condition = in_math }
	),

	-- ++ mathscr
	s(
		{ trig = "mscr", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathscr{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	-- ++ mathcal
	s(
		{ trig = "mcal", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathcal{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	-- ++ mathfrak
	s(
		{ trig = "mfrak", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathfrak{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	-- ++ mathrm
	s(
		{ trig = "mrm", snippetType = "autosnippet", desc = "mathbb", wordTrig = false },
		{ t("\\mathrm{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),

	-- == Logica y Notaciones ==
	s(
		{ trig = "!=", snippetType = "autosnippet", desc = "Diferente de", wordTrig = false },
		{ t("\\neq ") },
		{ condition = in_math }
	),
	s(
		{ trig = ">=", snippetType = "autosnippet", desc = "Mayor o igual", wordTrig = false },
		{ t("\\geq ") },
		{ condition = in_math }
	),
	s(
		{ trig = "<=", snippetType = "autosnippet", desc = "Menor o igual", wordTrig = false },
		{ t("\\leq ") },
		{ condition = in_math }
	),
	s(
		{ trig = "iff", snippetType = "autosnippet", desc = "si y solo si", wordTrig = false },
		{ t("\\iff ") },
		{ condition = in_math }
	),
	s(
		{ trig = "thrf", snippetType = "autosnippet", desc = "Por lo tanto", wordTrig = false },
		{ t("\\therefore ") },
		{ condition = in_math }
	),
	s(
		{ trig = "=>", snippetType = "autosnippet", desc = "Implicacion", wordTrig = false },
		{ t("\\implies ") },
		{ condition = in_math }
	),
	s(
		{ trig = "=<", snippetType = "autosnippet", desc = "Implied by", wordTrig = false },
		{ t("\\impliedby ") },
		{ condition = in_math }
	),
	s(
		{ trig = "and", snippetType = "autosnippet", desc = "and logical symbol", wordTrig = false },
		{ t("\\land") },
		{ condition = in_math }
	),
	s(
		{ trig = "or", snippetType = "autosnippet", desc = "or logical symbol", wordTrig = false },
		{ t("\\lor") },
		{ condition = in_math }
	),
	s(
		{ trig = "inn", snippetType = "autosnippet", desc = "membership relation", wordTrig = false },
		{ t("\\in ") },
		{ condition = in_math }
	),
	s(
		{ trig = "notin", snippetType = "autosnippet", desc = "not a member", wordTrig = false },
		{ t("\\not\\in") },
		{ condition = in_math }
	),
	s(
		{ trig = "not", snippetType = "autosnippet", desc = "not a member", wordTrig = false },
		{ t("\\not") },
		{ condition = in_math }
	),
	s(
		{ trig = "fall", snippetType = "autosnippet", desc = "for all", wordTrig = false },
		{ t("\\forall ") },
		{ condition = in_math }
	),
	s(
		{ trig = "exs", snippetType = "autosnippet", desc = "Exists", wordTrig = false },
		{ t("\\exists ") },
		{ condition = in_math }
	),
	s(
		{ trig = "mid", snippetType = "autosnippet", desc = "tal que", wordTrig = false },
		{ t("\\mid ") },
		{ condition = in_math }
	),
	s(
		{ trig = "...", snippetType = "autosnippet", desc = "tal que", wordTrig = false },
		{ t("\\dots") },
		{ condition = in_math }
	),
	s(
		{ trig = "vdots", snippetType = "autosnippet", desc = "tal que", wordTrig = false },
		{ t("\\vdots") },
		{ condition = in_math }
	),
	s(
		{ trig = "ooo", snippetType = "autosnippet", desc = "tal que", wordTrig = false },
		{ t("\\infty") },
		{ condition = in_math }
	),
	s(
		{ trig = "dis", snippetType = "autosnippet", desc = "tamaño normal", wordTrig = false },
		{ t("\\displaystyle ") },
		{ condition = in_math }
	),

	-- == Conjuntos ==
	s(
		{ trig = "cap", snippetType = "autosnippet", desc = "Set intersection", wordTrig = false },
		{ t("\\cap ") },
		{ condition = in_math }
	),
	s({
		trig = "bcap",
		snippetType = "autosnippet",
		priority = 2000,
		wordTrig = false,
	}, fmta([[\bigcap_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(4) }), { condition = in_math }),
	s(
		{ trig = "cup", snippetType = "autosnippet", desc = "Set union", wordTrig = false },
		{ t("\\cup ") },
		{ condition = in_math }
	),
	s({
		trig = "bcup",
		snippetType = "autosnippet",
		priority = 2000,
		wordTrig = false,
	}, fmta([[\bigcup_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(4) }), { condition = in_math }),
	s(
		{ trig = "smi", snippetType = "autosnippet", desc = "Set difference", wordTrig = false },
		{ t("\\setminus ") },
		{ condition = in_math }
	),
	s(
		{ trig = "ssmi", snippetType = "autosnippet", desc = "Diferencia Simetrica", wordTrig = false },
		{ t("\\vartriangle") },
		{ condition = in_math }
	),
	s(
		{ trig = "sub=", snippetType = "autosnippet", desc = "Subset", wordTrig = false },
		{ t("\\subseteq ") },
		{ condition = in_math }
	),
	s(
		{ trig = "sup=", snippetType = "autosnippet", desc = "Supset", wordTrig = false },
		{ t("\\supseteq ") },
		{ condition = in_math }
	),
	s(
		{ trig = "eset", snippetType = "autosnippet", desc = "Empty set", wordTrig = false },
		{ t("\\varnothing") },
		{ condition = in_math }
	),
	s(
		{ trig = "set", snippetType = "autosnippet", desc = "Set braces", wordTrig = false },
		{ t("\\{ "), i(1), t(" \\}") },
		{ condition = in_math }
	),

	-- == Operaciones Basicas ==
	s(
		{ trig = "rd", snippetType = "autosnippet", desc = "Squared", wordTrig = false },
		{ t("^{"), i(1, "n"), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "sr", snippetType = "autosnippet", desc = "Squared", wordTrig = false },
		t("^{2}"),
		{ condition = in_math }
	),
	s(
		{ trig = "cb", snippetType = "autosnippet", desc = "Cubed", wordTrig = false },
		t("^{3}"),
		{ condition = in_math }
	),
	s(
		{ trig = "sq", snippetType = "autosnippet", desc = "Raiz Cuadrada", wordTrig = false },
		{ t("\\sqrt{"), i(1, "x"), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "//", snippetType = "autosnippet", desc = "Fraction", wordTrig = true },
		fmta("\\frac{<>}{<>}", { i(1), i(2) }),
		{ condition = in_math }
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
	}, { condition = in_math }),
	s(
		{ trig = "*", snippetType = "autosnippet", desc = "producto o multiplicacion", wordTrig = false },
		{ t("\\cdot") },
		{ condition = in_math }
	),
	s(
		{ trig = "\\cdot\\cdot\\cdot", snippetType = "autosnippet", desc = "productos", wordTrig = false },
		{ t("\\cdots") },
		{ condition = in_math }
	),
	s(
		{ trig = "perp", snippetType = "autosnippet", desc = "Ortogonal", wordTrig = false },
		{ t("\\perp") },
		{ condition = in_math }
	),
	s(
		{ trig = "indp", snippetType = "autosnippet", desc = "Probabilidad Independiente", wordTrig = false },
		{ t("\\perp\\!\\!\\!\\perp ") },
		{ condition = in_math }
	),
	s({
		trig = "sum",
		snippetType = "autosnippet",
		wordTrig = false,
	}, fmta([[\sum_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(4) }), { condition = in_math }),
	s({
		trig = "prod",
		snippetType = "autosnippet",
		wordTrig = false,
	}, fmta([[\prod_{<>=<>}^{<>} <>]], { i(1, "i"), i(2, "1"), i(3, "n"), i(4) }), { condition = in_math }),
	s(
		{ trig = "_", snippetType = "autosnippet", desc = "Arbitrary Index", wordTrig = false },
		fmta("_{<>}", { i(1, "i") }),
		{ condition = in_math }
	),
	s(
		{
			-- El patrón: (Grupo 1: letra o paréntesis/corchete de cierre) seguido de (Grupo 2: un dígito)
			-- Indices o Index
			trig = "([%a%)%]%}])(%d)",
			regTrig = true,
			wordTrig = false,
			snippetType = "autosnippet",
			desc = "Number Index Function",
		},
		fmta("<>_{<>}<>", {
			f(function(_, snip)
				return snip.captures[1]
			end), -- Devuelve la letra (ej. 'x')
			f(function(_, snip)
				return snip.captures[2]
			end), -- Devuelve el número (ej. '3')
			i(1),
		}),
		{ condition = in_math }
	),

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
		{ show_condition = in_math }
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
		{ condition = in_math }
	),

	-- == Calculo y Funciones ==
	s(
		{ trig = "->", snippetType = "autosnippet", desc = "Implies", wordTrig = false },
		{ t("\\to ") },
		{ condition = in_math }
	),
	s({
		trig = "ope",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\operatorname{"), i(1), t("} "), i(2) }, { condition = in_math }),
	s({
		trig = "dom",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\operatorname{Dom} \\{"), i(1), t("\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "img",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\operatorname{Im} \\{"), i(1), t("\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "min",
		snippetType = "autosnippet",
		wordTrig = false,
		desc = "minimo",
	}, { t("\\min \\left\\{"), i(1, "f"), t("\\right\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "max",
		snippetType = "autosnippet",
		wordTrig = false,
		desc = "maximo",
	}, { t("\\max \\left\\{"), i(1, "f"), t("\\right\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "sup",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\sup \\left\\{"), i(1, "f"), t("\\right\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "inf",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\inf \\left\\{"), i(1, "f"), t("\\right\\} "), i(2) }, { condition = in_math }),
	s({
		trig = "log",
		snippetType = "autosnippet",
		wordTrig = false,
		desc = "logaritmo",
	}, { t("\\log \\left("), i(1, "x"), t("\\right)"), i(2) }, { condition = in_math }),
	s({
		trig = "ln",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\ln \\left("), i(1, "x"), t("\\right)"), i(2) }, { condition = in_math }),
	s({
		trig = "exp",
		snippetType = "autosnippet",
		wordTrig = false,
	}, { t("\\exp \\left("), i(1, "x"), t("\\right)"), i(2) }, { condition = in_math }),
	s({
		trig = "lim",
		snippetType = "autosnippet",
		desc = "Limite",
		wordTrig = false,
	}, fmta([[\lim_{<> \to <>} <>]], { i(1, "n"), i(2, "\\infty"), i(3, "f(x)") }), { condition = in_math }),
	s(
		{
			trig = "dint",
			snippetType = "autosnippet",
			desc = "Integrals",
			wordTrig = false,
		},
		fmta([[\int_{<>}^{<>} <> \, d<> <>]], { i(1, "a"), i(2, "b"), i(3, "f(x)"), i(4, "x"), i(5) }),
		{ condition = in_math }
	),
	s({
		trig = "der",
		snippetType = "autosnippet",
		desc = "Derivada",
		wordTrig = false,
	}, { t("\\frac{d}{d"), i(1, "x"), t("}"), i(2) }, { condition = in_math }),

	-- == Trigonometricas
	s(
		{ trig = "sin", snippetType = "autosnippet", desc = "seno", wordTrig = false },
		{ t("\\sin("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "arcsin", snippetType = "autosnippet", desc = "arcoseno", wordTrig = false },
		{ t("\\arcsin("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "hsin", snippetType = "autosnippet", priority = 2000, desc = "seno", wordTrig = false },
		{ t("\\sinh("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "cos", snippetType = "autosnippet", desc = "coseno", wordTrig = false },
		{ t("\\cos("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "arccos", snippetType = "autosnippet", desc = "arcocoseno", wordTrig = false },
		{ t("\\arccos("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "hcos", snippetType = "autosnippet", priority = 2000, desc = "coseno", wordTrig = false },
		{ t("\\cosh("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "tan", snippetType = "autosnippet", desc = "tangente", wordTrig = false },
		{ t("\\tan("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "arctan", snippetType = "autosnippet", desc = "arcotangente", wordTrig = false },
		{ t("\\arctan("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "htan", snippetType = "autosnippet", priority = 2000, desc = "tangente", wordTrig = false },
		{ t("\\tanh("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "csc", snippetType = "autosnippet", desc = "cosecante", wordTrig = false },
		{ t("\\csc("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "sec", snippetType = "autosnippet", desc = "secante", wordTrig = false },
		{ t("\\sec("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "cot", snippetType = "autosnippet", desc = "cotangente", wordTrig = false },
		{ t("\\cot("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "hct", snippetType = "autosnippet", desc = "cotangente", wordTrig = false },
		{ t("\\coth("), i(1, "\\theta"), t(")"), i(2) },
		{ condition = in_math }
	),

	-- == Acentos ==
	postfix({
		trig = "hat",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix hat when in math mode",
	}, { l("\\hat{" .. l.POSTFIX_MATCH .. "}") }, { condition = in_math }),

	postfix({
		trig = "vec",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix vec when in math mode",
	}, { l("\\vec{" .. l.POSTFIX_MATCH .. "}") }, { condition = in_math }),

	postfix({
		trig = "bar",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix bar when in math mode",
	}, { l("\\bar{" .. l.POSTFIX_MATCH .. "}") }, { condition = in_math }),

	postfix({
		trig = "dott",
		match_pattern = [[[\\%w%.%_%-%"%']+$]],
		snippetType = "autosnippet",
		desc = "postfix dot when in math mode",
	}, { l("\\dot{" .. l.POSTFIX_MATCH .. "}") }, { condition = in_math }),

	-- == Parentesis Dinamicos ==
	s(
		{ trig = "lr()", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left( <> \right)<>]], { i(1), i(2) }),
		{ condition = in_math }
	),

	-- Corchetes dinámicos: lr[ -> \left[ ... \right]
	s(
		{ trig = "lr[]", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left[ <> \right]<>]], { i(1), i(2) }),
		{ condition = in_math }
	),

	-- Llaves dinámicas: lr{ -> \left\{ ... \right\}
	s(
		{ trig = "lr{}", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left\{ <> \right\}<>]], { i(1), i(2) }),
		{ condition = in_math }
	),
	-- Span < >
	s(
		{ trig = "span", snippetType = "autosnippet", wordTrig = false },
		fmta([[\langle <> \rangle<>]], { i(1), i(2) }),
		{ condition = in_math }
	),

	-- Valor absoluto dinámico: lr| -> \left| ... \right|
	s(
		{ trig = "lr|", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left| <> \right|<>]], { i(1), i(2) }),
		{ condition = in_math }
	),

	-- Angulares (producto interno, física): lra -> \left\langle ... \right\rangle
	s(
		{ trig = "lra", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left\langle <> \right\rangle<>]], { i(1), i(2) }),
		{ condition = in_math }
	),
	-- Para la barra de restricción de una funcíon, muy usada en Analisis y Calculo
	s(
		{ trig = "lre", snippetType = "autosnippet", wordTrig = false },
		fmta([[\left. <> \right|_{<>}<>]], { i(1), i(2), i(3) }),
		{ condition = in_math }
	),

	-- == Herramientas Latex y formatting ==
	s(
		{ trig = '""', snippetType = "autosnippet", desc = "text", wordTrig = false },
		{ t("\\text{  "), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "over", snippetType = "autosnippet", desc = "something over", wordTrig = false },
		{ t("\\overset{"), i(1), t("}{"), i(2), t("}"), i(3) },
		{ condition = in_math }
	),
	s(
		{ trig = "und", snippetType = "autosnippet", desc = "something under", wordTrig = false },
		{ t("\\underset{"), i(1), t("}{"), i(2), t("}"), i(3) },
		{ condition = in_math }
	),
	s(
		{ trig = "ubrace", snippetType = "autosnippet", desc = "under braces", wordTrig = false },
		{ t("\\underbrace{"), i(1), t("}_{"), i(2, "n\\text{-veces}"), t("}"), i(3) },
		{ condition = in_math }
	),
	s(
		{ trig = "obrace", snippetType = "autosnippet", desc = "over braces", wordTrig = false },
		{ t("\\overbrace{"), i(1), t("}_{"), i(2, "n\\text{-veces}"), t("}"), i(3) },
		{ condition = in_math }
	),
	s(
		{ trig = "uline", snippetType = "autosnippet", desc = "under line", wordTrig = false },
		{ t("\\underline{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "oline", snippetType = "autosnippet", desc = "over line", wordTrig = false },
		{ t("\\overline{"), i(1), t("}"), i(2) },
		{ condition = in_math }
	),
	s(
		{ trig = "==", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
        \\[0.5em]
        <> &<> <>
        ]],
			{ i(1), i(2, "="), i(3) }
		),
		{ condition = in_math }
	),
}
