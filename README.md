# spamguard.nvim 🛡️

A minimal Neovim plugin that detects excessive key spamming (`jjjjjj`) and suggests more efficient alternatives.

## 📽️ Demo (neovide)

![Demo of spamguard.nvim](./demo.gif)

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
return { "timseriakov/spamguard.nvim" }
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
        j = { threshold = 6, suggestion = "use s or f instead of spamming jjjj 😎" },
        k = { threshold = 6, suggestion = "try 10k instead of spamming kkkk 😎" },
        h = { threshold = 8, suggestion = "use 10h or b / ge 😎" },
        l = { threshold = 8, suggestion = "try w or e — it's faster! 😎" },
        w = { threshold = 5, suggestion = "use s or f — more precise and quicker! 😎" },
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
