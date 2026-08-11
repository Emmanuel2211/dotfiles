vim.pack.add({
	"https://www.github.com/echasnovski/mini.nvim",
})

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})

-- Surround
require("mini.surround").setup({})

require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.icons").setup({})

-- Notifications
require("mini.notify").setup({
	lsp_item = { duration = 3000 },
})

vim.keymap.set("n", "<leader>nh", function()
	MiniNotify.show_history() -- MiniNotify is the global the plugin creates
end, { desc = "Show Notification History" })
