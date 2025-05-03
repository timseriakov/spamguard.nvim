local M = {}

local default_config = {
	keys = {
		j = { threshold = 9, suggestion = "use s / f instead of spamming jjjj 😎" },
		k = { threshold = 9, suggestion = "try 10k instead of spamming kkkk 😎" },
		h = { threshold = 9, suggestion = "use 10h or b / ge 😎" },
		l = { threshold = 9, suggestion = "try w / e — it's faster! 😎" },
		w = { threshold = 8, suggestion = "use s / f — more precise and quicker! 😎" },
	},
	excluded_filetypes = {
		"neo-tree",
		"NvimTree",
		"netrw",
		"aerial",
		"Outline",
		"TelescopePrompt",
		"starter",
		"lazy",
		"packer",
		"alpha",
	},
}

local config = nil
local enabled = false
local spam_stats = {}
local timers = {}
local history = {}

function M.setup(user_config)
	config = vim.tbl_deep_extend("force", {}, default_config, user_config or {})
	M.__loaded = true
end

local function get_today_key()
	return os.date("%Y-%m-%d")
end

local function reset_timer(key)
	if timers[key] then
		timers[key]:stop()
		timers[key]:close()
		timers[key] = nil
	end
end

local function is_excluded()
	if vim.b.disable_spamguard then
		return true
	end
	local ft = vim.bo.filetype
	for _, excluded in ipairs(config.excluded_filetypes or {}) do
		if ft == excluded or ft:match("^" .. excluded) then
			return true
		end
	end
	return false
end

local function on_key_press(key)
	if not spam_stats[key] then
		spam_stats[key] = { count = 0, total = 0 }
	end

	local today = get_today_key()
	history[today] = history[today] or {}
	history[today][key] = (history[today][key] or 0) + 1

	spam_stats[key].count = spam_stats[key].count + 1
	spam_stats[key].total = spam_stats[key].total + 1

	local key_cfg = config.keys[key]
	if key_cfg and spam_stats[key].count >= key_cfg.threshold then
		vim.schedule(function()
			vim.notify(string.format("Too much %s — %s", key, key_cfg.suggestion), vim.log.levels.WARN)
		end)
		spam_stats[key].count = 0
	end

	reset_timer(key)
	timers[key] = vim.loop.new_timer()
	timers[key]:start(1000, 0, function()
		spam_stats[key].count = 0
	end)
end

function M.enable()
	if enabled or not config then
		return
	end
	enabled = true

	for key, _ in pairs(config.keys) do
		pcall(vim.keymap.del, "n", key)
		vim.keymap.set("n", key, function()
			if is_excluded() then
				return key
			end

			on_key_press(key)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", false)
			return ""
		end, { expr = true, noremap = true, silent = true })
	end

	vim.api.nvim_create_user_command("SpamStats", function(opts)
		local lines = { "📊 Key spam statistics:" }

		local today = get_today_key()
		lines[#lines + 1] = "\n📅 Today:"
		for key, count in pairs(history[today] or {}) do
			lines[#lines + 1] = string.format("%s: %d", key, count)
		end

		lines[#lines + 1] = "\n🗓️ Last 7 days:"
		local week_total = {}
		for i = 0, 6 do
			local date = os.date("%Y-%m-%d", os.time() - i * 86400)
			if history[date] then
				for key, count in pairs(history[date]) do
					week_total[key] = (week_total[key] or 0) + count
				end
			end
		end
		for key, count in pairs(week_total) do
			lines[#lines + 1] = string.format("%s: %d", key, count)
		end

		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "SpamStats" })
	end, {})
end

return M
