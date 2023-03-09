local win
local buf

local gotest = function (opt)
  -- running target test function name
  local target = opt.args

  local parent_dir = vim.fn.expand('%:p:h')
  local path = vim.fn.substitute(parent_dir, vim.fn.getcwd(), '.', '')
  local cmd = {"godotenv", "go", "test", path .. '/...', '-json'}

  if target ~= "" then
    table.insert(cmd, "-run")
    table.insert(cmd, target)
  end


  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(true, true)
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  end

  if not win or not vim.api.nvim_win_is_valid(win) then
      -- vim.cmd('vsplit')
      -- local win = vim.api.nvim_get_current_win()
      -- vim.api.nvim_win_set_buf(win, buf)
    local current_win = vim.api.nvim_get_current_win()
    local height = vim.api.nvim_win_get_height(current_win)
    local width = vim.api.nvim_win_get_width(current_win)
    win = vim.api.nvim_open_win(buf, true, {
      relative='win',
      width=math.floor(width*0.45),
      height=math.floor(height*0.9),
      anchor='NW',
      col=math.floor(width*0.5),
      row=2,
      border='single'
    })
    vim.api.nvim_win_set_buf(win, buf)
  end


  local state = {
    bufnr = buf,
    tests = {},
  }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,

    on_stdout = function (_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        local decoded = vim.json.decode(line)

        if decoded.Action == "run" then
          state.tests[decoded.Test] = {
            name = decoded.Test,
            result = "",
            output = {},
          }
        elseif decoded.Action == "output" then
          if not decoded.Test then
            return
          end

          table.insert(state.tests[decoded.Test].output, vim.trim(decoded.Output))
        elseif decoded.Action == "fail" then
          state.tests[decoded.Test].result = "fail"
        end
      end
    end,

    on_stderr = function (_, data)
      if data then
        return
      end

      vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
    end,

    on_exit = function ()
      for _, test in pairs(state.tests) do
        if test.result == "fail" then
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, {test.name})
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, test.output)
        end
      end

      vim.api.nvim_buf_set_lines(buf, -1, -1, false, {"test completed"})

      local total_lines = vim.api.nvim_buf_line_count(buf)
      vim.api.nvim_win_set_cursor(win, {total_lines, 0})
    end,
  })
end

vim.api.nvim_create_user_command("GoTestCustom", gotest, {nargs = '?'})
