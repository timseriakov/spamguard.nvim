vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		local ok, sg = pcall(require, "spamguard")
		if ok and sg and not sg.__loaded then
			sg.setup()
			vim.defer_fn(function()
				sg.enable()
			end, 500)
		end
	end,
})
