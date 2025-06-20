local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

local opts = {
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
  },
  on_attach = function(client, bufnr)
    print("LSP attached: " .. client.name)
    if client.supports_method("textDocument/formatting") then
      print(client.name .. " supports_formating")
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

return opts
