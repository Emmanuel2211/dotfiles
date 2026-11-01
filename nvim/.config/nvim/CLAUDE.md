# Neovim config (Emmanuel)

Personal Neovim 0.12 config, mainly for **live math lecture notes** in Obsidian Markdown
(vault: `~/Documentos/Zettelkasten`, attachments in the vault root, images as
`![[name|center|300]]`) plus LaTeX via vimtex. It lives in `~/.dotfiles` (stow) and is
symlinked to `~/.config/nvim`. Code comments are in Spanish; keep that style.
User manual: `LECTURE.md`.

## Layout
- `init.lua` only enables `vim.loader`; everything in `plugin/` runs in filename order.
- Plugins are installed with the built-in `vim.pack.add` (lockfile `nvim-pack-lock.json`).
  Installed plugin sources: `~/.local/share/nvim/site/pack/core/opt/<name>`.
- Snippets: `lua/luasnip/` (loaded by `plugin/50luasnip.lua` through `from_lua`;
  `markdown.lua` adds all of `tex/math.lua`).

## Key pieces (don't break)
- `lua/luasnip/locals.lua`
  - `in_math()`: Markdown/TeX math detection (`$`, `$$`, `<span class="math">`),
    returns false inside `\text{}`-like commands (`in_text_cmd`), and is cached per
    (buf, changedtick, cursor).
  - `prev_expr(s)`: the "glued" expression before the cursor.
  - `wrap_postfix{trig, wrap, strip, group, exclude}`: postfix wrappers that use
    `resolveExpandParams`. They return nil (so the normal prefix snippet runs) when nothing
    is glued or there's a stored visual selection (`b:LUASNIP_SELECT_RAW`).
    Postfix triggers must not appear inside another trigger (use `exclude`, e.g. nom/binom).
  - `visualSelectionOrInsert`: used as `vis(n)` in `tex/math.lua` wrappers.
- `plugin/09autocompletion.lua`: a single `<Tab>` handler (`smart_tab`) in blink.cmp.
  blink runs keymap functions inside an `<expr>` mapping, so cursor moves and jumps
  **must** go through `vim.schedule`. `"snippet_forward"` stays in the list so blink also
  maps select mode. Order: closer inside a field (walking up nested snippets via
  `node.parent.snippet.parent_node`, but stopping if the closer is the inner snippet's own
  text) → jump (skipping empty stops at the cursor; `current_nodes[buf]` can be nil after
  leaving a root snippet) → menu → closer → fallback.
- `plugin/50luasnip.lua`: `region_check_events`/`delete_check_events` so old snippets are
  forgotten; `store_selection_keys = "<Tab>"`.
- `plugin/83lecture.lua`: `<A-b>/<A-i>/<A-=>/<A-m>` formatting (buffer-local `<C-e>` in Markdown
  changes the color of the `<mark>` under the cursor by editing the hex text; outside a mark it
  falls back to LuaSnip `change_choice`), `<leader>ip` photo import
  from `~/Descargas` (uses the **arrival** time: LocalSend keeps the original mtime;
  ImageMagick `magick`), `<leader>if` placeholders, `:LectureTodos`, `:CompressImages`.
  `g:lecture_vault` / `g:lecture_photo_dir` override the folders (for tests).
- `<A-h/j/k/l>` belong to mini.move and the line-move maps; don't reuse them.

## Testing
Unit-test helpers with `nvim --headless -c "luafile test.lua" -c qa`. To test typing for
real, start `nvim --headless --listen /tmp/<short>.sock file.md` and send keys one at a
time with `nvim --server SOCK --remote-send` (autosnippets need real TextChangedI), then
read `getline()` with `--remote-expr`. Don't send `<Esc>` together with the next key (it
becomes Alt). Keep the socket path short (< 108 chars).
