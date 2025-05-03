# spamguard.nvim 🛡️

A minimal Neovim plugin that detects excessive key spamming (`jjjjjj`) and suggests more efficient alternatives.

## 📟️ Demo (neovide)

![Demo of spamguard.nvim](./demo.gif)

## ✨ Features

- Detects spam on keys like `j`, `k`, `h`, `l`, `w`
- Displays suggestions for more effective motion usage (e.g. `use 10j`)
- Tracks daily and weekly key usage
- Command `:SpamStats` to view usage stats
- Command `:SpamStats!` to view usage stats in an editable buffer
- Fully configurable thresholds and suggestions 🌟
- Ignores common explorer/file manager filetypes (`neo-tree`, `NvimTree`, etc.)
- Can be disabled per-buffer with `vim.b.disable_spamguard = true`

---

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "timseriakov/spamguard.nvim",
  config = function()
    local spamguard = require("spamguard")
    spamguard.setup({
      keys = {
        j = { threshold = 6, suggestion = "use s or f instead of spamming jjjj 😎" },
        k = { threshold = 6, suggestion = "try 10k instead of spamming kkkk 😎" },
        h = { threshold = 8, suggestion = "use 10h or b / ge 😎" },
        l = { threshold = 8, suggestion = "try w or e — it's faster! 😎" },
        w = { threshold = 5, suggestion = "use s or f — more precise and quicker! 😎" },
      },
    })
    spamguard.enable()
  end,
}
```

If a key is not listed in your config, it will fall back to the default behavior.

---

## 📊 Commands

- `:SpamStats` — Show usage stats:
  - 📅 For today
  - 🏓️ For the last 7 days
- `:SpamStats!` — Show the same stats in a separate editable buffer (markdown view)

---

## 🧠 Disabling for specific buffers

You can disable `spamguard` in a specific buffer like this:

```lua
vim.b.disable_spamguard = true
```

This is useful for excluding special-purpose buffers or floating windows where tracking is not desired.

---

## 📄 License

MIT © [Tim Seriakov](https://github.com/timseriakov)
