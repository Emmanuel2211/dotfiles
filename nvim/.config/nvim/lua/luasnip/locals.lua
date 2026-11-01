-- lua/luasnip/tex/locals.lua
local M = {}

-- VimTex & Markdown "math zone" detection (sin tener en cuenta \text{})
local function raw_in_math()
	-- 1. Si es un archivo TeX nativo, usamos VimTeX
	if vim.bo.filetype == "tex" then
		return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
	end

	-- 2. Si es Markdown, aplicamos la detección directa
	if vim.bo.filetype == "markdown" then
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]

		local before = line:sub(1, col)
		local after = line:sub(col + 1)

		-- A) INLINE HTML (<span class="math ..."> ... </span> en una sola línea)
		local last_span_open = before:match(".*()<span%s+class=[\"']math")
		if last_span_open then
			local close_before = before:find("</span>", last_span_open, true)
			local close_after = after:find("</span>", 1, true)
			if not close_before and close_after then
				return true
			end
		end

		-- B) INLINE ($ ... $ o $$ ... $$ en una sola línea)
		local clean_before = before:gsub("\\%$", ""):gsub("%$%$", "$")
		local clean_after = after:gsub("\\%$", ""):gsub("%$%$", "$")

		local _, dollars_before = clean_before:gsub("%$", "")
		local _, dollars_after = clean_after:gsub("%$", "")

		if dollars_before % 2 == 1 and dollars_after > 0 then
			return true
		end

		-- C) MODO BLOQUE MULTI-LÍNEA ($$ ... $$ y <span class="math display"> ... </span>)
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)

		local block_count = 0
		local in_html_math = false

		for _, l in ipairs(lines) do
			-- 1. Conteo de bloques $$ (con soporte para callouts '>')
			if l:match("^%s*>?[%s]*%$%$") then
				block_count = block_count + 1
			end

			-- 2. Rastreo de estado para <span class="math ...">
			if l:match("<span%s+class=[\"']math") then
				in_html_math = true
			end
			-- Si la línea cierra el span (ej. </span> o <\span>), apagamos el estado
			if in_html_math and (l:find("</span>", 1, true) or l:find("<\\span>", 1, true)) then
				in_html_math = false
			end
		end

		-- Verificamos también en la línea actual antes del cursor (por si abriste o cerraste ahí mismo)
		if before:match("<span%s+class=[\"']math") then
			in_html_math = true
		end
		if in_html_math and (before:find("</span>", 1, true) or before:find("<\\span>", 1, true)) then
			in_html_math = false
		end

		if (block_count % 2 == 1) or in_html_math then
			return true
		end
	end

	return false
end

-- Comandos cuyo argumento es texto normal: dentro de ellos no hay modo matematico
local TEXT_CMDS = {
	text = true,
	textbf = true,
	textit = true,
	texttt = true,
	textrm = true,
	mbox = true,
	operatorname = true,
	mathrm = true,
}

-- true si la llave '{' mas interna sin cerrar (antes del cursor) pertenece a \text{...} o similar
local function in_text_cmd(before)
	local stack = {}
	local idx = 1
	while idx <= #before do
		local ch = before:sub(idx, idx)
		if ch == "\\" then
			local name = before:match("^%a+", idx + 1)
			if name then
				local next_idx = idx + 1 + #name
				if before:sub(next_idx, next_idx) == "{" then
					table.insert(stack, TEXT_CMDS[name] or false)
					next_idx = next_idx + 1
				end
				idx = next_idx
			else
				idx = idx + 2 -- caracter escapado: \{ \} \, \$ ...
			end
		else
			if ch == "{" then
				table.insert(stack, false)
			elseif ch == "}" then
				table.remove(stack)
			end
			idx = idx + 1
		end
	end
	return stack[#stack] == true
end
M.in_text_cmd = in_text_cmd

-- Cache: los ~190 autosnippets preguntan in_math() en cada tecla; se calcula una vez por tecla
local math_cache = { key = nil, value = false }

M.in_math = function()
	local buf = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local key = table.concat({ buf, vim.api.nvim_buf_get_changedtick(buf), cursor[1], cursor[2] }, ":")
	if math_cache.key == key then
		return math_cache.value
	end

	local value = raw_in_math()
	if value then
		local before = vim.api.nvim_get_current_line():sub(1, cursor[2])
		value = not in_text_cmd(before)
	end

	math_cache.key, math_cache.value = key, value
	return value
end

-- ============================================================================
-- "Expresion anterior": lo que esta pegado (sin espacios ni operadores) antes del cursor
-- ============================================================================
-- Atomos: \comando, letras/numeros, grupos balanceados (), [], {}, |...|, primas ' y !
-- y ^atomo / _atomo. La cadena se corta en espacios, operadores (+ - = , < > &), $ o
-- en un parentesis/llave abierto sin cerrar.

local CLOSE_TO_OPEN = { [")"] = "(", ["]"] = "[", ["}"] = "{" }
local OPENERS = { ["("] = true, ["["] = true, ["{"] = true }

-- s:sub(j, j) es un cierre; devuelve el indice de su apertura (o nil si no esta balanceado)
local function group_start(s, j)
	local stack = {}
	for k = j, 1, -1 do
		local ch = s:sub(k, k)
		if CLOSE_TO_OPEN[ch] then
			table.insert(stack, CLOSE_TO_OPEN[ch])
		elseif OPENERS[ch] then
			if stack[#stack] ~= ch then
				return nil
			end
			table.remove(stack)
			if #stack == 0 then
				-- incluye la barra de \{ y el \left / \big de \left( si estan pegados
				if ch == "{" and s:sub(k - 1, k - 1) == "\\" then
					k = k - 1
				end
				return k
			end
		end
	end
	return nil
end

-- Devuelve el inicio del ultimo atomo que termina en j, y si ese atomo es un grupo
local function atom_start(s, j)
	local ch = s:sub(j, j)
	if CLOSE_TO_OPEN[ch] then
		return group_start(s, j), true
	end
	if ch == "|" then
		local k = s:sub(1, j - 1):match(".*()|")
		return k, true
	end
	if ch == "'" or ch == "!" then
		return j, false
	end
	if ch:match("%w") then
		local k = j
		while k > 1 and s:sub(k - 1, k - 1):match("%w") do
			k = k - 1
		end
		if s:sub(k - 1, k - 1) == "\\" then
			k = k - 1
		end
		return k, false
	end
	return nil, false
end

-- Inicio (indice) de la expresion pegada al final de `s`, o nil si no hay expresion valida.
-- Tambien devuelve el inicio del ultimo grupo de parentesis (para \left \right).
function M.prev_expr(s)
	local j = #s
	local start, last_group = nil, nil
	local first = true
	while j >= 1 do
		local k, is_group = atom_start(s, j)
		if not k then
			break
		end
		if first and is_group then
			last_group = k
		end
		first = false
		start = k
		j = k - 1
		-- ^ o _ pegados: el atomo era un exponente/subindice, seguimos hacia la base
		local prev = s:sub(j, j)
		if prev == "^" or prev == "_" then
			j = j - 1
			start = nil -- una expresion no puede empezar con ^ o _
			if j < 1 then
				break
			end
		end
	end
	return start, last_group
end

-- Quita parentesis exteriores: (a+b) -> a+b, pero no (a)+(b)
local function strip_parens(expr)
	if expr:sub(1, 1) == "(" and group_start(expr, #expr) == 1 then
		return expr:sub(2, -2)
	end
	return expr
end

-- Fabrica de snippets "postfix": la expresion pegada antes del trigger se mete dentro del comando.
--   opts.trig      trigger (mismo nombre que el snippet prefijo: sq, //, mbb, ...)
--   opts.wrap      function(expr) -> nodos de LuaSnip con la expresion ya puesta
--   opts.strip     quitar parentesis exteriores (default true)
--   opts.exclude   triggers mas largos que terminan en este (no disparar dentro de ellos)
--   opts.group     solo envolver el ultimo grupo de parentesis (para lr)
-- Si no hay expresion pegada devuelve nil y se usa el snippet prefijo normal.
function M.wrap_postfix(opts)
	local ls = require("luasnip")
	return ls.snippet({
		trig = opts.trig,
		snippetType = "autosnippet",
		wordTrig = false,
		priority = opts.priority or 5000,
		desc = opts.desc or ("postfix " .. opts.trig),
		resolveExpandParams = function(_, line_to_cursor, match)
			-- Con texto seleccionado (visual + <Tab>) manda el snippet prefijo
			if pcall(vim.api.nvim_buf_get_var, 0, "LUASNIP_SELECT_RAW") then
				return nil
			end
			-- no disparar dentro de otro trigger mas largo (ej. "nom" dentro de "binom")
			for _, longer in ipairs(opts.exclude or {}) do
				if line_to_cursor:sub(-#longer) == longer then
					return nil
				end
			end
			local before = line_to_cursor:sub(1, #line_to_cursor - #match)
			local start, last_group = M.prev_expr(before)
			if opts.group then
				-- solo grupos de parentesis reales: ( [ \{ |   (no {} de argumentos)
				start = last_group and before:sub(last_group, last_group) ~= "{" and last_group or nil
			end
			if not start then
				return nil
			end
			local expr = before:sub(start)
			if opts.strip ~= false then
				expr = strip_parens(expr)
			end
			local row = vim.api.nvim_win_get_cursor(0)[1] - 1
			return {
				trigger = match,
				captures = {},
				clear_region = { from = { row, start - 1 }, to = { row, #line_to_cursor } },
				env_override = { POSTFIX_MATCH = expr },
			}
		end,
	}, {
		ls.dynamic_node(1, function(_, parent)
			return ls.snippet_node(nil, opts.wrap(parent.snippet.env.POSTFIX_MATCH))
		end),
	}, { condition = M.in_math })
end

-- This is the old math zone detection function, the new one also detects html math zone
-- -- VimTex & Markdown "math zone" detection
-- M.in_math = function()
-- 	-- 1. Si es un archivo TeX nativo, usamos VimTeX
-- 	if vim.bo.filetype == "tex" then
-- 		return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
-- 	end
--
-- 	-- 2. Si es Markdown, aplicamos la detección directa
-- 	if vim.bo.filetype == "markdown" then
-- 		local line = vim.api.nvim_get_current_line()
-- 		local col = vim.api.nvim_win_get_cursor(0)[2]
--
-- 		local before = line:sub(1, col)
-- 		local after = line:sub(col + 1)
--
-- 		-- Limpiamos dólares escapados (\$)
-- 		before = before:gsub("\\%$", "")
-- 		after = after:gsub("\\%$", "")
--
-- 		-- MAGIA: Convertimos los $$ en $ para que la misma lógica funcione para ambos
-- 		before = before:gsub("%$%$", "$")
-- 		after = after:gsub("%$%$", "$")
--
-- 		-- Contamos cuántos delimitadores hay antes y después
-- 		local _, dollars_before = before:gsub("%$", "")
-- 		local _, dollars_after = after:gsub("%$", "")
--
-- 		-- INLINE: Si hay un número impar antes Y al menos uno cerrando después, estamos dentro.
-- 		if dollars_before % 2 == 1 and dollars_after > 0 then
-- 			return true
-- 		end
--
-- 		-- MODO BLOQUE MULTI-LÍNEA ($$ ... $$)
-- 		local row = vim.api.nvim_win_get_cursor(0)[1]
-- 		local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)
-- 		local block_count = 0
--
-- 		for _, l in ipairs(lines) do
-- 			-- El '>? ' le dice a Lua que puede haber un '>' (de callouts) opcional antes de los $$
-- 			if l:match("^%s*>?[%s]*%$%$") then
-- 				block_count = block_count + 1
-- 			end
-- 		end
--
-- 		if block_count % 2 == 1 then
-- 			return true
-- 		end
-- 	end
--
-- 	return false
-- end

-- test whether the parent snippet has content from a visual selection.
M.visualSelectionOrInsert = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		local ls = require("luasnip")
		return ls.snippet_node(nil, ls.text_node(parent.snippet.env.LS_SELECT_RAW))
	else
		local ls = require("luasnip")
		return ls.snippet_node(nil, ls.insert_node(1))
	end
end

-- Variable declarations
local ls = require("luasnip")
local extras = require("luasnip.extras")

M.ls = ls
M.s = ls.snippet
M.sn = ls.snippet_node
M.isn = ls.indent_snippet_node
M.t = ls.text_node
M.i = ls.insert_node
M.f = ls.function_node
M.c = ls.choice_node
M.d = ls.dynamic_node
M.r = ls.restore_node
M.events = require("luasnip.util.events")
M.ai = require("luasnip.nodes.absolute_indexer")
M.opt = require("luasnip.nodes.optional_arg")
M.l = extras.lambda
M.rep = extras.rep
M.p = extras.partial
M.m = extras.match
M.n = extras.nonempty
M.dl = extras.dynamic_lambda
M.fmt = require("luasnip.extras.fmt").fmt
M.fmta = require("luasnip.extras.fmt").fmta
M.conds = require("luasnip.extras.expand_conditions")
M.postfix = require("luasnip.extras.postfix").postfix
M.types = require("luasnip.util.types")
M.parse = require("luasnip.util.parser").parse_snippet
M.ms = ls.multi_snippet
M.k = require("luasnip.nodes.key_indexer").new_key

return M
