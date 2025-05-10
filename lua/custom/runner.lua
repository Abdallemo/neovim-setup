local M = {}

M.get_cmd = function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand("%")
  local basename = vim.fn.expand("%:r")

  local commands = {
    java = {
      compile = "javac " .. filename,
      run = "java " .. basename,
      cleanup = "rm " .. basename .. ".class"
    },
    go = {
      run = "go run " .. filename
    },
    python = {
      run = "python " .. filename
    },
    javascript = {
      run = "node " .. filename
    },
    typescript = {
      run = "ts-node " .. filename
    },
       c = {
      compile = "gcc " .. filename .. " -o " .. basename,
      run = "./" .. basename,
      cleanup = "rm " .. basename
    },
    cpp = {
      compile = "g++ " .. filename .. " -o " .. basename,
      run = "./" .. basename,
      cleanup = "rm " .. basename
    }
  }

  local lang = commands[filetype]
  if not lang then return nil end

  local cmd = "clear && "
  if lang.compile then cmd = cmd .. lang.compile .. " && " end
  cmd = cmd .. lang.run
  if lang.cleanup then cmd = cmd .. " && " .. lang.cleanup end

  return cmd
end

M.run = function()
  local cmd = M.get_cmd()
  if not cmd then
    vim.notify("No runner configured for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  local term = require("nvterm.terminal")
  term.toggle("float")
  term.send(cmd, "float")
  vim.cmd("startinsert")
end

return M
