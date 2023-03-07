local gotest = function (opt)
  -- running target test function name
  local target = opt.args

  local parent_dir = vim.fn.expand('%:p:h')
  local path = vim.fn.substitute(parent_dir, vim.fn.getcwd(), '.', '')
  local cmd = {"godotenv", "go", "test", path .. '/...' }

  if target ~= "" then
    table.insert(cmd, "-run")
    table.insert(cmd, target)
  end

  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.fn.jobstart({"go", "clean", "-testcache"})
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function (_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_stderr = function (_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_exit = function ()
      local total_lines = vim.api.nvim_buf_line_count(0)
      vim.api.nvim_win_set_cursor(win, {total_lines, 0})
    end
  })
end

vim.api.nvim_create_user_command("GoTest", gotest, {nargs = '?'})
