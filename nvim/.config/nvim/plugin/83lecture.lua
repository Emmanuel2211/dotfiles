-- ============================================================================
-- Clases en vivo: negrita/cursiva/resaltado rapido y fotos del pizarron
-- ============================================================================

local VAULT = vim.g.lecture_vault or vim.fn.expand("~/Documentos/Zettelkasten")
local PHOTO_DIR = vim.g.lecture_photo_dir or vim.fn.expand("~/Descargas")
local PHOTO_MAX_AGE = 15 * 60 -- segundos
local DEFAULT_WIDTH = 300

-- Colores de <mark> (estilo Highlightr); el numero = count en normal/visual
local MARK_COLORS = {
	"#FFF3A3A6", -- 1 amarillo
	"#FF5582A6", -- 2 rojo
	"#BBFABBA6", -- 3 verde
	"#ADCCFFA6", -- 4 azul
	"#D2B3FFA6", -- 5 morado
}

local function mark_open(color)
	return '<mark style="background: ' .. color .. ';">'
end

-- ---------------------------------------------------------------------------
-- Envolver: en insert como snippet (<Tab> sale), en visual la seleccion, en normal la palabra
-- ---------------------------------------------------------------------------

local function insert_wrap(left, right)
	local ls = require("luasnip")
	ls.snip_expand(ls.snippet("", { ls.text_node(left), ls.insert_node(1), ls.text_node(right) }))
end

-- escribe el texto, <C-e> cambia el color (sin salir del texto), <Tab> sale
local function insert_mark()
	insert_wrap(mark_open(MARK_COLORS[1]), "</mark>")
end

-- <C-e> dentro de un <mark style="background: #...;">...</mark> de la linea actual:
-- pasa al siguiente color. Devuelve false si el cursor no esta dentro de ningun <mark>.
local function cycle_mark_color()
	local line = vim.api.nvim_get_current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local search_from = 1
	while true do
		local open_start, open_end, color = line:find('<mark style="background: (#%x+);">', search_from)
		if not open_start then
			return false
		end
		local _, close_end = line:find("</mark>", open_end + 1, true)
		close_end = close_end or #line
		-- col es 0-based: dentro si esta entre el "<" de <mark> y el ">" de </mark>
		if col + 1 >= open_start and col <= close_end then
			local idx = 1
			for k, c in ipairs(MARK_COLORS) do
				if c:upper() == color:upper() then
					idx = k
				end
			end
			local next_color = MARK_COLORS[idx % #MARK_COLORS + 1]
			local color_start = open_start + #'<mark style="background: ' - 1
			-- todos los colores miden lo mismo, asi que el cursor no se mueve
			vim.api.nvim_buf_set_text(0, row - 1, color_start, row - 1, color_start + #color, { next_color })
			return true
		end
		search_from = close_end + 1
	end
end

local function ctrl_e()
	if cycle_mark_color() then
		return
	end
	-- fuera de un <mark>: lo de siempre (cambiar la opcion de un choice node de LuaSnip)
	local ls = require("luasnip")
	if ls.choice_active() then
		ls.change_choice(1)
	end
end

-- texto entre las marcas '< y '> (charwise o linewise)
local function wrap_visual(left, right, mode)
	local buf = 0
	local s = vim.api.nvim_buf_get_mark(buf, "<")
	local e = vim.api.nvim_buf_get_mark(buf, ">")
	local end_line = vim.api.nvim_buf_get_lines(buf, e[1] - 1, e[1], true)[1]
	local start_col, end_col
	if mode == "V" then
		start_col, end_col = 0, #end_line
	else
		start_col = s[2]
		-- '> apunta al inicio del ultimo caracter (puede ser multibyte: á, é, ñ)
		end_col = math.min(e[2] + 1 + vim.str_utf_end(end_line, e[2] + 1), #end_line)
	end
	vim.api.nvim_buf_set_text(buf, e[1] - 1, end_col, e[1] - 1, end_col, { right })
	vim.api.nvim_buf_set_text(buf, s[1] - 1, start_col, s[1] - 1, start_col, { left })
end

local function visual_wrapper(get_left, right)
	return function()
		local mode = vim.fn.mode()
		local count = vim.v.count1
		vim.cmd("normal! \27") -- salir de visual para fijar '< y '>
		wrap_visual(get_left(count), right, mode)
	end
end

local function normal_wrapper(get_left, right)
	return function()
		local count = vim.v.count1
		vim.cmd("normal! viw\27")
		wrap_visual(get_left(count), right, "v")
	end
end

local function const(str)
	return function()
		return str
	end
end

local function mark_by_count(count)
	return mark_open(MARK_COLORS[count] or MARK_COLORS[1])
end

local formats = {
	-- tecla, izquierda, derecha, descripcion
	{ "<A-b>", const("**"), "**", "Negrita" },
	{ "<A-i>", const("*"), "*", "Cursiva" },
	{ "<A-=>", const("=="), "==", "Resaltado ==" },
	{ "<A-m>", mark_by_count, "</mark>", "Resaltado con color (count = color)" },
}

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("LectureFormat", { clear = true }),
	pattern = { "markdown", "quarto" },
	callback = function(args)
		local opts = function(desc)
			return { buffer = args.buf, silent = true, desc = desc }
		end
		for _, fmt in ipairs(formats) do
			local key, get_left, right, desc = fmt[1], fmt[2], fmt[3], fmt[4]
			if key == "<A-m>" then
				vim.keymap.set("i", key, insert_mark, opts(desc))
			else
				vim.keymap.set("i", key, function()
					insert_wrap(get_left(1), right)
				end, opts(desc))
			end
			vim.keymap.set("x", key, visual_wrapper(get_left, right), opts(desc))
			vim.keymap.set("n", key, normal_wrapper(get_left, right), opts(desc))
		end
		vim.keymap.set({ "i", "n" }, "<C-e>", ctrl_e, opts("Cambiar color del <mark> / opcion de LuaSnip"))
	end,
})

-- ---------------------------------------------------------------------------
-- Fotos del pizarron: ultima foto de LocalSend -> comprimida -> vault -> ![[...|center|300]]
-- ---------------------------------------------------------------------------

local IMAGE_EXT = { jpg = true, jpeg = true, png = true }

-- Fotos ya importadas pero aun comprimiendose (evita importarlas dos veces)
local in_progress = {}

-- Hora de LLEGADA del archivo: LocalSend conserva la fecha original de la foto (mtime),
-- asi que se usa la fecha de creacion/cambio del archivo en este disco
local function arrival_time(stat)
	return math.max(stat.birthtime and stat.birthtime.sec or 0, stat.ctime.sec, stat.mtime.sec)
end

-- Todas las fotos llegadas en los ultimos 15 min, de la mas vieja a la mas nueva
local function recent_photos()
	local photos = {}
	for name, type in vim.fs.dir(PHOTO_DIR) do
		local ext = name:match("%.(%w+)$")
		local path = PHOTO_DIR .. "/" .. name
		if type == "file" and ext and IMAGE_EXT[ext:lower()] and not in_progress[path] then
			local stat = vim.uv.fs_stat(path)
			if stat and os.time() - arrival_time(stat) <= PHOTO_MAX_AGE then
				table.insert(photos, { path = path, time = arrival_time(stat) })
			end
		end
	end
	table.sort(photos, function(x, y)
		return x.time < y.time
	end)
	return photos
end

-- prefijo de callout (">", "> >") de la linea actual, para que la imagen quede dentro
local function callout_prefix()
	local prefix = vim.api.nvim_get_current_line():match("^[%s>]+")
	return (prefix and prefix:find(">")) and prefix or ""
end

local function compress(src, dst, on_done)
	vim.system({
		"magick",
		src,
		"-auto-orient",
		"-resize",
		"1600x1600>",
		"-strip",
		"-quality",
		"70",
		dst,
	}, {}, function(out)
		vim.schedule(function()
			on_done(out.code == 0, out.stderr)
		end)
	end)
end

local function insert_lines_below(lines, start_insert)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)
	vim.api.nvim_win_set_cursor(0, { row + #lines, 0 })
	if start_insert then
		vim.cmd("startinsert!")
	end
end

local function paste_photo(width)
	local photos = recent_photos()
	if #photos == 0 then
		vim.notify("No hay fotos de los ultimos 15 min en " .. PHOTO_DIR, vim.log.levels.WARN)
		return
	end
	local note = vim.fn.expand("%:t:r")
	if note == "" then
		note = "Pizarron"
	end
	local stamp = os.date("%Y%m%d%H%M%S")
	local prefix = callout_prefix()

	-- todas las fotos pendientes, en el orden en que llegaron, una por linea
	local lines = {}
	for idx, photo in ipairs(photos) do
		local name = #photos == 1 and string.format("%s %s.jpg", note, stamp)
			or string.format("%s %s-%d.jpg", note, stamp, idx)
		photo.name = name
		in_progress[photo.path] = true
		table.insert(lines, string.format("%s![[%s|center|%d]]", prefix, name, width))
	end
	table.insert(lines, prefix)
	insert_lines_below(lines, true)

	-- se comprimen en segundo plano; Obsidian las muestra en cuanto aparece cada archivo
	for _, photo in ipairs(photos) do
		compress(photo.path, VAULT .. "/" .. photo.name, function(ok, err)
			in_progress[photo.path] = nil
			if ok then
				os.remove(photo.path)
				local kb = math.floor((vim.uv.fs_stat(VAULT .. "/" .. photo.name) or { size = 0 }).size / 1024)
				vim.notify(string.format("Foto guardada: %s (%d KB)", photo.name, kb))
			else
				vim.notify("Error comprimiendo " .. photo.path .. ":\n" .. (err or ""), vim.log.levels.ERROR)
			end
		end)
	end
end

-- Placeholder cuando no da tiempo de mandar la foto: se completa despues con :LectureTodos
local function figure_placeholder()
	local prefix = callout_prefix()
	insert_lines_below({ prefix .. "> [!figure] TODO: " }, true)
end

vim.keymap.set("n", "<leader>ip", function()
	-- 4<leader>ip -> ancho 400
	paste_photo(vim.v.count > 0 and vim.v.count * 100 or DEFAULT_WIDTH)
end, { desc = "Pegar foto del pizarron (count = ancho/100)" })
vim.keymap.set("i", "<A-p>", function()
	paste_photo(DEFAULT_WIDTH)
end, { desc = "Pegar foto del pizarron" })

vim.keymap.set("n", "<leader>if", figure_placeholder, { desc = "Placeholder de figura TODO" })
vim.keymap.set("i", "<A-f>", figure_placeholder, { desc = "Placeholder de figura TODO" })

vim.api.nvim_create_user_command("LectureTodos", function()
	require("fzf-lua").grep({ search = "\\[!figure\\] TODO", cwd = VAULT, no_esc = true })
end, { desc = "Listar figuras pendientes en el vault" })

-- Comprime en el lugar las jpg grandes (>500 KB) que ya estan en el vault
vim.api.nvim_create_user_command("CompressImages", function()
	local pending, saved = 0, 0
	for name, type in vim.fs.dir(VAULT) do
		local ext = (name:match("%.(%w+)$") or ""):lower()
		local path = VAULT .. "/" .. name
		local stat = vim.uv.fs_stat(path)
		if type == "file" and (ext == "jpg" or ext == "jpeg") and stat and stat.size > 500 * 1024 then
			pending = pending + 1
			local tmp = path .. ".tmp.jpg"
			compress(path, tmp, function(ok)
				local new = vim.uv.fs_stat(tmp)
				if ok and new and new.size < stat.size then
					os.rename(tmp, path)
					saved = saved + (stat.size - new.size)
				else
					os.remove(tmp)
				end
				pending = pending - 1
				if pending == 0 then
					vim.notify(string.format("CompressImages: %.1f MB ahorrados", saved / 1024 / 1024))
				end
			end)
		end
	end
	if pending == 0 then
		vim.notify("CompressImages: no hay jpg de mas de 500 KB")
	end
end, { desc = "Comprimir jpg grandes del vault" })
