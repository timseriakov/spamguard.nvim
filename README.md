# spamguard.nvim 🛡️

[![Awesome](https://awesome.re/badge.svg)](https://github.com/rockerBOO/awesome-neovim#motion)

A minimal Neovim plugin that detects excessive key spamming (`jjjjjj`) and suggests more efficient alternatives.

## 📿️ Demo (neovide)

![Demo of spamguard.nvim](./demo.gif)

## ✨ Features

- Detects spam on keys like `j`, `k`, `h`, `l`, `w`
- Displays suggestions for more effective motion usage (e.g. `use 10j`)
- Tracks daily and weekly key usage
- Command `:SpamStats` to view usage stats
- Fully configurable thresholds and suggestions 🌟
- Ignores common explorer/file manager filetypes (`neo-tree`, `NvimTree`, etc.)
- Can be disabled per-buffer with `vim.b.disable_spamguard = true`

---

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "timseriakov/spamguard.nvim",
  event = "VeryLazy",
  config = function()
    local spamguard = require("spamguard")
    spamguard.setup({
      keys = {
        j = { threshold = 9, suggestion = "use s / f instead of spamming jjjj 😎" },
        k = { threshold = 9, suggestion = "try { of ( instead of spamming kkkk 😎" },
        h = { threshold = 9, suggestion = "use b / 0 / ^ instead of spamming hhhh  😎" },
        l = { threshold = 9, suggestion = "try w / e / f — it's faster! 😎" },
        w = { threshold = 8, suggestion = "use s / f — more precise and quicker! 😎" },
      },
    })
    vim.schedule(function()
      spamguard.enable()
    end)
  end,
}
```

If a key is not listed in your config, it will fall back to the default behavior.

---

## 📊 Commands

- `:SpamStats` — Show usage stats:
  - 📅 For today
  - 🏓️ For the last 7 days

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
