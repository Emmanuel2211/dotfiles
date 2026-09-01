-- lua/luasnip/tex/locals.lua
local M = {}

-- VimTex & Markdown "math zone" detection
M.math = function()
	-- Solo usa VimTeX. Si no estás en un archivo .tex o VimTeX no está activo,
	-- esto simplemente devolverá false o fallará de forma segura.
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

-- Función exclusiva para detectar matemáticas en Markdown
M.in_markdown_math = function()
	-- pcall evita que Neovim lance un error si Treesitter aún no carga
	local ok, node = pcall(vim.treesitter.get_node)
	if not ok or not node then
		return false
	end

	while node do
		local type = node:type()
		-- 'latex_block' y 'latex_math' vienen del parser de markdown_inline
		-- 'math_environment' y 'inline_formula' vienen del parser de latex (inyectado)
		if type == "latex_block" or type == "latex_math" or type == "math_environment" or type == "inline_formula" then
			return true
		end
		node = node:parent()
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
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
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
	nodes[#nodes] = ls.text_node("\\\\")
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
