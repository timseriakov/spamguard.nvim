local expect, child = MiniTest.expect, MiniTest.new_child_neovim()

describe("spamguard.nvim", function()
	before_each(function()
		child.restart()
		child.set_size(40, 120)
		child.cmd("set rtp+=. | runtime plugin/spamguard.lua")
	end)

	after_each(function()
		child.stop()
	end)

	it("should not trigger spam warning before threshold", function()
		child.lua([[require('spamguard').setup({
      keys = { j = { threshold = 4, suggestion = 'use count!' } }
    })]])

		-- simulate 3 presses, below threshold
		for _ = 1, 3 do
			child.feed("j")
		end

		local messages = child.cmd_capture("messages")
		expect(messages).not_to_match("use count!")
	end)

	it("should trigger spam warning at threshold", function()
		child.lua([[require('spamguard').setup({
      keys = { j = { threshold = 3, suggestion = 'use count!' } }
    })]])

		for _ = 1, 3 do
			child.feed("j")
		end

		child.sleep(50) -- give vim.schedule() time
		local messages = child.cmd_capture("messages")
		expect(messages).to_match("Too much j")
	end)

	it("should skip filetypes in excluded list", function()
		child.lua([[require('spamguard').setup({
      keys = { j = { threshold = 1, suggestion = 'nope' } },
      excluded_filetypes = { 'NvimTree' }
    })]])

		child.cmd("setfiletype NvimTree")
		child.feed("j")
		child.sleep(30)

		local messages = child.cmd_capture("messages")
		expect(messages).not_to_match("nope")
	end)

	it("should skip when vim.b.disable_spamguard = true", function()
		child.lua([[require('spamguard').setup({
      keys = { j = { threshold = 1, suggestion = 'nope' } }
    })]])

		child.lua("vim.b.disable_spamguard = true")
		child.feed("j")
		child.sleep(30)

		local messages = child.cmd_capture("messages")
		expect(messages).not_to_match("nope")
	end)
end)
