-- spec/plugins_spec.lua
local helpers = require("plenary.busted")

describe("plugin setup", function()
  local original_pcall = pcall
  local original_require = require
  local original_nvim_create_autocmd = vim.api.nvim_create_autocmd

  before_each(function()
    -- Clear the test environment
    helpers.clear()
  end)

  after_each(function()
    -- Restore original functions
    pcall = original_pcall
    require = original_require
    vim.api.nvim_create_autocmd = original_nvim_create_autocmd
  end)

  describe("conform.nvim setup", function()
    it("should load and configure conform.nvim", function()
      -- Mock `require` to simulate conform.nvim
      require = function(mod)
        if mod == "conform" then
          return {
            setup = function(config)
              assert.equals("stylua", config.formatters_by_ft.lua[1])
              assert.equals("prettier", config.formatters_by_ft.css[1])
              assert.equals(1000, config.format_on_save.timeout_ms)
            end,
          }
        end
        error("Module not found: " .. mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        local success, result = original_pcall(func)
        return success, result
      end

      -- Load the plugin setup script
      dofile(vim.fn.getcwd() .. "/lua/plugins/diagnostics.lua")
    end)
  end)

  describe("nvim-lint setup", function()
    it("should load and configure nvim-lint", function()
      -- Mock `require` to simulate nvim-lint
      require = function(mod)
        if mod == "lint" then
          return {
            linters_by_ft = {},
            linters = {
              markdownlint = {
                args = {},
              },
            },
            try_lint = function() end,
          }
        end
        error("Module not found: " .. mod)
      end

      -- Mock `vim.api.nvim_create_autocmd` to avoid actual autocmd creation
      vim.api.nvim_create_autocmd = function(events, opts)
        assert.equals("BufWritePost", events[1])
        assert.is_function(opts.callback)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        local success, result = original_pcall(func)
        return success, result
      end

      -- Load the plugin setup script
      dofile(vim.fn.getcwd() .. "/lua/plugins/diagnostics.lua")
    end)
  end)

  describe("trouble.nvim setup", function()
    it("should load and configure trouble.nvim", function()
      -- Mock `require` to simulate trouble.nvim
      require = function(mod)
        if mod == "trouble" then
          return {
            setup = function()
              return true
            end,
          }
        end
        error("Module not found: " .. mod)
      end

      -- Mock `pcall` to simulate successful loading
      pcall = function(func)
        local success, result = original_pcall(func)
        return success, result
      end

      -- Load the plugin setup script
      dofile(vim.fn.getcwd() .. "/lua/plugins/diagnostics.lua")
    end)
  end)
end)
