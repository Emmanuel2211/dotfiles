-- lua/luasnip/tex/locals.lua
local M = {}

-- VimTex & Markdown "math zone" detection
M.in_math = function()
	if vim.bo.filetype == "markdown" then
		-- Get current line and cursor column
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]

		-- Simple, instant check: count dollar signs on the current line or context
		-- Or check if we are between $$ pairs
		local _, count = line:gsub("%$%", "")
		if count >= 2 then
			return true
		end

		-- Multi-line block check: look upwards for $$
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
		local block_count = 0
		for _, l in ipairs(lines) do
			if l:match("^%s*%$%$") then
				block_count = block_count + 1
			end
		end
		return (block_count % 2 == 1)
	end

	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
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
