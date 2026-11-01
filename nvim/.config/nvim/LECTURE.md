# Live lecture manual

## 1. Wrapping: glued = wrap, space = new
Type the trigger **glued** to what you just wrote and it wraps it.
With a **space** before it, you get the normal empty snippet.

| You type | You get |
|---|---|
| `xsq` / `(x+1)sq` | `\sqrt{x}` / `\sqrt{x+1}` |
| `\alpha//` / `(a+b)//` | `\frac{\alpha}{|}` / `\frac{a+b}{|}` |
| `(a-b)lr` | `\left( a-b \right)` (also `[]`, `\{\}`, `||`) |
| `Rmbb` / `Fmcal` | `\mathbb{R}` / `\mathcal{F}` |
| `Aoline` / `Auline` / `xbox` | `\overline{A}` / `\underline{A}` / `\boxed{x}` |
| `xhat` `xvec` `xbar` `xdott` `xtld` | `\hat{x}` `\vec{x}` `\bar{x}` `\dot{x}` `\tilde{x}` |
| `Xund` / `=over` | `\underset{|}{X}` / `\overset{|}{=}` |
| `nbinom` / `xfloor` / `vnom` | `\binom{n}{|}` / `\lfloor x \rfloor` / `\left\| v \right\|` |

- **What gets wrapped:** everything glued before the trigger, back to the last space,
  operator (`+ - = , < > &`), `$`, or open `(` / `{`. So `a+bsq` → `a+\sqrt{b}`,
  and `2xsq` → `\sqrt{2x}`. If you only want `x`, write `2 xsq`.
- **Parentheses are for grouping:** they're dropped (`(a+b)//`), except with `lr`,
  which turns them into `\left( \right)`.
- **Already typed something long?** Select it (`vi(` = inside only, `va(` = with the
  parentheses), press `<Tab>`, then type the trigger (`sq`, `lr(`, `mbb`, `//`, `""`...).
- To get an empty `\left( \right)`, just type `lr(`. mini.pairs closes it.

## 2. Tab = "get me out of here", one level per press
In this order:
1. step over a `) ] } | $` that **you typed** inside the field
2. jump to the next field of the snippet
3. move through the completion menu, outside math (it inserts as it moves, so just keep typing)
4. step over a closer, outside snippets (also leaves `$`)
5. insert a normal Tab

- Each stop is a place you might want to type: after `\sqrt{…}` comes a stop where you'd
  type `^{2}`. Count one Tab per closer you see.
- `<S-Tab>` goes back. `<C-n>` / `<C-p>` always move the menu, and `<C-y>` accepts a snippet item.
- Cursor somewhere odd? Press `<Esc>` and move: the snippet is forgotten, so Tab won't jump back.
- The completion menu doesn't appear inside math. Open it with `<C-Space>`.

## 3. Text inside math
Inside `\text{…}`, `\textbf{…}`, `\operatorname{…}` and `\mathrm{…}` no math snippet fires,
so write normally. `""` → `\text{ | }`.

## 4. Formatting (Markdown)
| Key | Insert mode | Visual / normal (word) |
|---|---|---|
| `<A-b>` | `**|**` | wraps in `**` |
| `<A-i>` | `*|*` | wraps in `*` |
| `<A-=>` | `==|==` | wraps in `==` |
| `<A-m>` | `<mark>`: type, `<C-e>` cycles the color (without leaving the text), `<Tab>` | `N<A-m>` = color N |

Colors: 1 yellow, 2 red, 3 green, 4 blue, 5 purple. In insert mode, `<Tab>` leaves the format.
`<C-e>` with the cursor on any existing `<mark>` (insert or normal mode) changes its color.
In Neovim you see the hex code change; the color only shows in Obsidian.

## 5. Board photos
- Send the photos with LocalSend (they arrive in `~/Descargas`), then press `<leader>ip`
  (or `<A-p>` in insert mode). **Every** photo that arrived in the last 15 min is compressed
  locally (~1.8 MB → ~300 KB), saved in `Zettelkasten/images/`, and inserted in arrival order as
  `![[… |center|300]]`. The originals are deleted, so nothing is imported twice.
- `4<leader>ip` = width 400.
- No time for a photo? Use `<leader>if` / `<A-f>` for a `> [!figure] TODO:` placeholder.
  After class, `:LectureTodos` lists them.
- `:CompressImages` shrinks the jpg files over 500 KB already in the vault root and `images/` (in place).

## Best practices for typing fast
- Write the thing first, decide the decoration after: `x` → `xbar`, `(a+b)` → `(a+b)//`.
  No more going back to put `\sqrt{` in front.
- Use spaces as separators: a space means "start something new", glued means "apply to the previous".
- Use `a;`, `b;` ... for Greek letters and **never type `\command` by hand**. The snippets
  assume commands come from snippets (`\lim` typed by hand fires `lim`).
- Keep your hands on Tab: don't use `<Esc>` + arrows to leave brackets.
- If a photo would cost more than ~5 s, leave a `<A-f>` placeholder and keep listening.
