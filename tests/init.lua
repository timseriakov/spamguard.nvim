require("mini.test").setup()
require("tests.spamguard_spec")

vim.defer_fn(function()
	vim.cmd("qa")
end, 50)
