-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
--   callback = function(args)
--     -- the buffer where the lsp attached
--     ---@type number
--     local buffer = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--     local augroup_id = vim.api.nvim_create_augroup("FormatModificationsDocumentFormattingGroup", { clear = false })
--     vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = buffer })
--
--     vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--       group = augroup_id,
--       buffer = buffer,
--       callback = function()
--         local lsp_format_modifications = require("lsp-format-modifications")
--         lsp_format_modifications.format_modifications(client, buffer)
--       end,
--     })
--   end,
-- })

local function format_modified_lines()
  local bufnr = vim.api.nvim_get_current_buf()
  local hunks = require("gitsigns").get_hunks(bufnr)
  print(vim.inspect(hunks))
  if not hunks then
    return
  end

  for _, hunk in ipairs(hunks) do
    if hunk.added and hunk.added.start and hunk.added.count then
      local range_start = hunk.added.start - 1
      local range_end = hunk.added.start - 1 + hunk.added.count
      print("Formatting range:", range_start, range_end)
      vim.lsp.buf.format({
        range = {
          ["start"] = { range_start, 0 },
          ["end"] = { range_end, 0 },
        },
        async = false,
      })
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    format_modified_lines()
  end,
})
