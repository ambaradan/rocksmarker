-- spec/minimal_init.lua

-- Salva le funzioni originali per ripristinarle dopo i test
local original_system = vim.fn.system
local original_fs_stat = vim.uv and vim.uv.fs_stat or function() end
local original_delete = vim.fn.delete
local original_notify = vim.notify

-- Mock per `vim.fn.system`
vim.fn.system = function(cmd)
  if type(cmd) == "table" and cmd[1] == "git" then
    print("MOCK: Simulating git command:", table.concat(cmd, " "))
    return 0 -- Simula successo
  end
  return original_system(cmd)
end

-- Mock per `vim.uv.fs_stat`
vim.uv = vim.uv or {}
vim.uv.fs_stat = function(path)
  if path:match("rocks%.nvim") then
    return nil -- Simula che rocks.nvim non sia installato
  end
  return { type = "directory" } -- Simula che il percorso esista
end

-- Mock per `vim.fn.delete`
vim.fn.delete = function(path, flags)
  print("MOCK: Simulating deletion of", path)
  return 0 -- Simula successo
end

-- Mock per `vim.notify`
vim.notify = function(msg, level)
  print("MOCK NOTIFY:", msg, level)
end

-- Carica il tuo `init.lua` reale
dofile(vim.fn.getcwd() .. "/init.lua")

-- Ripristina le funzioni originali dopo i test (opzionale)
-- _G.vim.fn.system = original_system
-- _G.vim.uv.fs_stat = original_fs_stat
-- _G.vim.fn.delete = original_delete
-- _G.vim.notify = original_notify
