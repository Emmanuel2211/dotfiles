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

		-- Limpiamos dólares escapados (\$)
		before = before:gsub("\\%$", "")
		after = after:gsub("\\%$", "")

		-- MAGIA: Convertimos los $$ en $ para que la misma lógica funcione para ambos
		before = before:gsub("%$%$", "$")
		after = after:gsub("%$%$", "$")

		-- Contamos cuántos delimitadores hay antes y después
		local _, dollars_before = before:gsub("%$", "")
		local _, dollars_after = after:gsub("%$", "")

		-- INLINE: Si hay un número impar antes Y al menos uno cerrando después, estamos dentro.
		if dollars_before % 2 == 1 and dollars_after > 0 then
			return true
		end

		-- MODO BLOQUE MULTI-LÍNEA ($$ ... $$)
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)
		local block_count = 0

		for _, l in ipairs(lines) do
			-- El '>? ' le dice a Lua que puede haber un '>' (de callouts) opcional antes de los $$
			if l:match("^%s*>?[%s]*%$%$") then
				block_count = block_count + 1
			end
		end

		if block_count % 2 == 1 then
			return true
		end
	end

	return false
end

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

-- Function for NxM-sized matrices
M.generate_matrix = function(args, snip)
	local ls = require("luasnip")

	-- Protegemos la conversión asegurando que si snip.captures es nil o vacío, use 1 por defecto
	local rows = tonumber(snip.captures and snip.captures[2]) or 1
	local cols = tonumber(snip.captures and snip.captures[3]) or 1

	local nodes = {}
	local ins_indx = 1

	for j = 1, rows do
		table.insert(nodes, ls.restore_node(ins_indx, tostring(j) .. "x1", ls.insert_node(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, ls.text_node(" & "))
			table.insert(nodes, ls.restore_node(ins_indx, tostring(j) .. "x" .. tostring(k), ls.insert_node(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, ls.text_node({ "\\\\", "" }))
	end

	if #nodes > 0 then
		nodes[#nodes] = ls.text_node("\\\\")
	end

	return ls.snippet_node(nil, nodes)
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
