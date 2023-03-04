local M = {}

M.general = {
  n = {
    ["<leader>tr"] = {"<cmd>TroubleToggle<CR>", "TroubleToggle"},
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "find workspace symbols" },
  },
}

return M
