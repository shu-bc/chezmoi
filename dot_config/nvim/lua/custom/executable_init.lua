local autocmd = vim.api.nvim_create_autocmd

local augrpGo = vim.api.nvim_create_augroup("autocmdGroupGo", {})

-- editor default config
autocmd("FileType", {
  group = augrpGo,
  pattern = "go",
  callback = function ()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.smartindent = true
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- goimport
autocmd('BufWritePre', {
  group = augrpGo,
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format({ async = false})
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' } },
      apply = true,
    })
  end,
})

