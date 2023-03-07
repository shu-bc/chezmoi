local present, trouble = pcall(require, "trouble")

if not present then
  return
end

local options = {
  auto_preview = false,
}


trouble.setup(options)
