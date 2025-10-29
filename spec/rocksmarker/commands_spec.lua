local helper = require("spec.helper")

describe("Rocksmarker autocommands", function()
  before_each(function()
    -- Pulizia degli autocommands esistenti
    vim.cmd("au! RocksmarkerSet")

    -- Carica il file di configurazione
    dofile(vim.fn.stdpath("config") .. "/lua/commands.lua")
  end)

  after_each(function()
    -- Pulizia dopo ogni test
    vim.cmd("au! RocksmarkerSet")
    helper.teardown()
  end)

  it("should create autocommands in the RocksmarkerSet group", function()
    -- Verifica che l'autogroup esista
    local augroup_exists = false
    local groups = vim.fn.getcompletion("", "augroup")
    for _, group in ipairs(groups) do
      if group == "RocksmarkerSet" then
        augroup_exists = true
        break
      end
    end
    assert.is_true(augroup_exists, "RocksmarkerSet augroup does not exist")
  end)

  it("should reload files on FocusGained", function()
    -- Simula un buffer normale
    vim.o.buftype = ""

    -- Verifica che l'autocommando esista
    local autocmds = vim.api.nvim_get_autocmds({
      group = "RocksmarkerSet",
      event = "FocusGained",
    })
    assert.are.same(1, #autocmds, "FocusGained autocmd not found")

    -- Verifica che la callback sia impostata
    assert.is_function(autocmds[1].callback, "FocusGained callback is not a function")
  end)

  it("should allow closing specific buffers with 'q'", function()
    -- Create a buffer with a filetype that matches the pattern
    local buf = helper.setup_buffer("")
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = "help"

    -- Manually simulate the callback of the autocmd
    local autocmds = vim.api.nvim_get_autocmds({
      group = "RocksmarkerSet",
      event = "FileType",
    })

    for _, autocmd in ipairs(autocmds) do
      if autocmd.desc == "Allow closing specific utility buffers with 'q' key" then
        -- Execute the callback manually
        local success, err = pcall(function()
          autocmd.callback({ buf = buf })
        end)

        if not success then
          print("Error executing callback:", err)
        end
      end
    end

    -- Check if the 'q' keymap exists
    local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")

    local found = false
    for _, keymap in ipairs(keymaps) do
      -- Check if the keymap is 'q' and if rhs contains a close command
      if keymap.lhs == "q" and keymap.rhs:lower():match("<cmd>.-%s*close%s*<cr>") then
        found = true
        break
      end
    end
    assert.is_true(found, "Keymap 'q' to close buffer not found")
  end)

  it("should highlight on yank", function()
    -- Mock di `vim.highlight.on_yank`
    local called = false
    local original_on_yank = vim.highlight.on_yank
    vim.highlight.on_yank = function()
      called = true
    end

    -- Trigger dell'autocommando
    vim.cmd("normal! yiw")

    -- Ripristina la funzione originale
    vim.highlight.on_yank = original_on_yank

    -- Verifica che sia stato chiamato
    assert.is_true(called, "on_yank was not called")
  end)

  it("should open help in a vertical split", function()
    -- Crea un buffer di tipo help
    local buf = helper.setup_buffer("")
    vim.bo[buf].filetype = "help"

    -- Mock di `vim.cmd.wincmd`
    local wincmd_calls = {}
    local original_wincmd = vim.cmd.wincmd
    vim.cmd.wincmd = function(cmd)
      table.insert(wincmd_calls, cmd)
    end

    -- Trigger dell'autocommando
    vim.cmd("doautocmd FileType help")

    -- Ripristina la funzione originale
    vim.cmd.wincmd = original_wincmd

    -- Verifica che `wincmd` sia stato chiamato con 'L' e '='
    assert.is_true(vim.tbl_contains(wincmd_calls, "L"), "wincmd 'L' was not called")
    assert.is_true(vim.tbl_contains(wincmd_calls, "="), "wincmd '=' was not called")
  end)

  it("should disable cursorline in markdown buffers", function()
    -- Crea un buffer di tipo markdown
    local buf = helper.setup_buffer("")
    vim.bo[buf].filetype = "markdown"

    -- Trigger dell'autocommando
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("doautocmd BufEnter")

    -- Verifica che cursorline sia disabilitato
    assert.is_false(vim.wo.cursorline, "Cursorline was not disabled in markdown buffer")
  end)

  it("should enable cursorline in non-markdown buffers", function()
    -- Crea un buffer di tipo non-markdown
    local buf = helper.setup_buffer("")
    vim.bo[buf].filetype = "lua"

    -- Trigger dell'autocommando
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("doautocmd BufEnter")

    -- Verifica che cursorline sia abilitato
    assert.is_true(vim.wo.cursorline, "Cursorline was not enabled in non-markdown buffer")
  end)
end)
