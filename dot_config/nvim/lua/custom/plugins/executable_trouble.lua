local present, trouble = pcall(require, "trouble")

if not present then
  return
end

local options = {
  auto_previe = false,
}


trouble.setup(options)
