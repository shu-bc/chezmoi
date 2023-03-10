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
    -- gofmt
    vim.lsp.buf.format({ async = false})
    vim.lsp.buf.code_action({
      context = { only = { 'source.organizeImports' } },
      apply = true,
    })
  end,
})


-- auto go test
local augrp_go_test = vim.api.nvim_create_augroup("autocmdGoTest", {})

local auto_test = function()
  local buf = vim.api.nvim_get_current_buf()
  autocmd('BufWritePost', {
    group = augrp_go_test,
    pattern = '*.go',
    callback = function ()
      vim.api.nvim_buf_call(buf, function ()
        vim.cmd('GoTestFile')
      end)
    end
  })
end

vim.api.nvim_create_user_command("AutoGoTest", auto_test, {})
vim.api.nvim_create_user_command("AutoGoTestClear", function ()
  vim.api.nvim_clear_autocmds({
    group = augrp_go_test
  })
end, {})

