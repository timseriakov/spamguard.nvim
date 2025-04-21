# spamguard.nvim 🛡️

A minimal Neovim plugin that detects excessive key spamming (`jjjjjj`) and suggests more efficient alternatives.

## Features

- Detects spam on `j`, `k`, `h`, `l`, `w`
- Suggests better navigation techniques
- Daily and weekly key usage tracking
- Command `:SpamStats` to display stats

## Installation

```lua
{
  "yourname/spamguard.nvim",
  config = function()
    require("spamguard").setup()
  end,
}
```

## License

MIT
