local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- webdev stuff
  -- b.formatting.deno_fmt,
  -- b.formatting.prettier,

  -- Lua
  b.formatting.stylua,

  -- Shell
  b.formatting.shfmt,
  -- b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  -- b.diagnostics.golangci_lint.with({
  --   args = {"run", "--out-format=json", "--path-prefix", vim.fn.getcwd(), "--concurrency", "16"},
  --   method = null_ls.methods.diagnostics_on_save,
  --   timeout = 20000,
  -- }),
  b.formatting.gofmt,
}

null_ls.setup {
  debug = false,
  sources = sources,
}
