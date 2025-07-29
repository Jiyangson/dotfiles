-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
  callback = function(args)
    -- the buffer where the lsp attached
    ---@type number
    local buffer = args.buf
    local ruff_client = nil
    for _, client in pairs(vim.lsp.get_clients({ bufnr = buffer })) do
      if client.name == "ruff" then
        ruff_client = client
        break
      end
    end
    if not ruff_client then
      return
    end

    local augroup_id = vim.api.nvim_create_augroup("FormatModificationsDocumentFormattingGroup", { clear = false })
    vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = buffer })

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      group = augroup_id,
      buffer = buffer,
      callback = function()
        local lsp_format_modifications = require("lsp-format-modifications")
        lsp_format_modifications.format_modifications(ruff_client, buffer)
      end,
    })
  end,
})
