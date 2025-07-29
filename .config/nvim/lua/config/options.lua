-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.highlight.create("Container", { guifg = "#BADA55", guibg = "black" }, false)
vim.cmd([[hi IlluminatedWordRead guibg = #494949]])
vim.cmd([[hi IlluminatedWordText guibg = #494949]])
vim.cmd([[hi IlluminatedWordWrite guibg = #494949]])
vim.cmd([[hi DiagnosticUnderlineWarn guifg = none guisp = #e5c07b]])
vim.cmd([[hi DiagnosticUnderlineError guifg = none guisp = #e06c75]])

vim.g.autoformat = false
