local spam_stats = {}
local timers = {}
local history = {}

local keymap_config = {
	j = { threshold = 6, suggestion = "use s or f instead of spamming jjjj 😎" },
	k = { threshold = 6, suggestion = "try 10k instead of spamming kkkk 😎" },
	h = { threshold = 8, suggestion = "use 10h or b / ge 😎" },
	l = { threshold = 8, suggestion = "try w or e — it's faster!" },
	w = { threshold = 5, suggestion = "use s or f — more precise and quicker!" },
}

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

local function on_key_press(key)
	if not spam_stats[key] then
		spam_stats[key] = { count = 0, total = 0 }
	end

	local today = get_today_key()
	history[today] = history[today] or {}
	history[today][key] = (history[today][key] or 0) + 1

	spam_stats[key].count = spam_stats[key].count + 1
	spam_stats[key].total = spam_stats[key].total + 1

	local config = keymap_config[key]
	if config and spam_stats[key].count >= config.threshold then
		vim.schedule(function()
			vim.notify(string.format("Too much %s — %s", key, config.suggestion), vim.log.levels.WARN)
		end)
		spam_stats[key].count = 0
	end

	reset_timer(key)
	timers[key] = vim.loop.new_timer()
	timers[key]:start(1000, 0, function()
		spam_stats[key].count = 0
	end)
end

local M = {}

function M.setup()
	for key, _ in pairs(keymap_config) do
		vim.keymap.set("n", key, function()
			on_key_press(key)
			return key
		end, { expr = true, noremap = true })
	end

	vim.api.nvim_create_user_command("SpamStats", function()
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

		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
	end, {})
end

return M
