-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- ["<Tab>"] = cmp.mapping(function(fallback)
		-- 	local copilot_keys = vim.fn["copilot#Accept"]()
		-- 	if cmp.visible() then
		-- 		cmp.select_next_item()
		-- 	elseif luasnip.expand_or_jumpable() then
		-- 		luasnip.expand_or_jump()
		-- 	elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
		-- 		vim.api.nvim_feedkeys(copilot_keys, "i", true)
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
		["<Tab>"] = cmp.mapping(function(fallback)
			local suggestion = require("copilot.suggestion")
			if suggestion.is_visible() then
				suggestion.accept()
			elseif cmp.visible() then
				cmp.confirm({ select = true })
			elseif cmp.has_words_before then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		--
		--
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
