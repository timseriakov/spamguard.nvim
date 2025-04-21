# spamguard.nvim 🛡️

A minimal Neovim plugin that detects excessive key spamming (`jjjjjj`) and suggests more efficient alternatives.

## ✨ Features

- Detects spam on keys like `j`, `k`, `h`, `l`, `w`
- Displays suggestions for more effective motion usage (e.g. `use 10j`)
- Tracks daily and weekly key usage
- Command `:SpamStats` to view usage stats
- Fully configurable thresholds and suggestions 🎯

---

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "timseriakov/spamguard.nvim",
  config = function()
    require("spamguard").setup()
  end,
}
```

---

## ⚙️ Configuration

You can pass custom thresholds and suggestions for specific keys:

```lua
return {
  "timseriakov/spamguard.nvim",
  config = function()
    require("spamguard").setup({
      keys = {
        j = { threshold = 3, suggestion = "try using 10j instead of jjj" },
        w = { threshold = 2, suggestion = "consider using f/t for precision" },
      },
    })
  end,
}
```

If a key is not listed in your config, it will fall back to the default behavior.

---

## 📊 Commands

`:SpamStats` — Show usage stats:

- 📅 For today
- 🗓️ For the last 7 days

---

## 🧠 Why?

This plugin encourages better navigation habits by gently reminding you to use more efficient motion commands instead of repeatedly mashing navigation keys.

---

## 📄 License

MIT © [Tim Seriakov](https://github.com/timseriakov)
