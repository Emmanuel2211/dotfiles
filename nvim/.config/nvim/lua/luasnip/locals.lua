-- lua/luasnip/tex/locals.lua
local M = {}

-- VimTex & Markdown "math zone" detection
M.in_math = function()
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
