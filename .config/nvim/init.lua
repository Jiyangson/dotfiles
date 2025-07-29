vim.cmd([[hi! DiagnosticUnderlineWarn guifg = none guisp = #e5c07b]])
vim.cmd([[hi! DiagnosticUnderlineError guifg = none guisp = #e06c75]])
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
