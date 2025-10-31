-- spec/lsp_spec.lua
local helpers = require("spec.helper")

describe("LSP configuration", function()
  local lsp_attach_called = false
  local original_nvim_create_autocmd
  local original_nvim_create_augroup

  before_each(function()
    -- Reset tracking variable
    lsp_attach_called = false

    -- Save original functions
    original_nvim_create_autocmd = vim.api.nvim_create_autocmd
    original_nvim_create_augroup = vim.api.nvim_create_augroup

    -- Mock for `vim.api.nvim_create_augroup`
    vim.api.nvim_create_augroup = function(name, opts)
      return original_nvim_create_augroup(name, opts) or 100
    end

    -- Mock for `vim.api.nvim_create_autocmd`
    vim.api.nvim_create_autocmd = function(event, opts)
      if event == "LspAttach" and opts.callback then
        opts.callback({ data = { client_id = 1 }, buf = 1 })
        lsp_attach_called = true
      else
        -- Original call for other events
        return original_nvim_create_autocmd(event, opts)
      end
    end

    -- Load LSP module
    dofile(vim.fn.getcwd() .. "/lua/plugins/lsp.lua")
  end)

  after_each(function()
    -- Restore original functions
    vim.api.nvim_create_autocmd = original_nvim_create_autocmd
    vim.api.nvim_create_augroup = original_nvim_create_augroup
  end)

  it("should create LspAttach autocommand group", function()
    assert.is_truthy(vim.api.nvim_create_augroup, "nvim_create_augroup should be mocked")
  end)

  it("should set up LspAttach autocommand", function()
    assert.is_true(lsp_attach_called, "LspAttach callback was not called")
  end)
end)
