local opt = vim.opt
local autocmd = vim.api.nvim_create_autocmd

-- Indenting

autocmd("FileType", {
  pattern = "*.go",
  callback = function ()
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 4
    vim.opt.smartindent = true
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
  end,
})
