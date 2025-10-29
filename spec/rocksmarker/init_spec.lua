-- spec/init_spec.lua
describe("init.lua", function()
  -- Scenario 1: rocks.nvim is not installed
  describe("when rocks.nvim is not installed", function()
    before_each(function()
      -- Clear the test environment
      require("plenary.busted").clear()

      -- Mock for `vim.uv.fs_stat` to simulate rocks.nvim not being installed
      vim.uv = vim.uv or {}
      vim.uv.fs_stat = function(path)
        if path:match("rocks%.nvim") then
          return nil -- Simulate that rocks.nvim is not installed
        end
        return { type = "directory" }
      end

      -- Mock for `vim.fn.system` to simulate successful git clone
      vim.fn.system = function(cmd)
        if type(cmd) == "table" and cmd[1] == "git" and cmd[3]:match("rocks%.nvim") then
          print("MOCK: Simulating git clone of rocks.nvim")
          return 0 -- Simulate success
        end
        return vim.fn.system(cmd)
      end

      -- Mock for `vim.fn.delete`
      vim.fn.delete = function(path, flags)
        print("MOCK: Simulating deletion of", path)
        return 0
      end

      -- Mock for `vim.notify`
      vim.notify = function(msg, level)
        print("MOCK NOTIFY:", msg, level)
      end

      -- Load your `init.lua`
      dofile(vim.fn.getcwd() .. "/init.lua")
    end)

    it("should install rocks.nvim", function()
      -- Verify that `rocks.nvim` is loaded correctly after installation
      assert.is_true(pcall(require, "rocks"))
    end)

    it("should add rocks.nvim to runtimepath after installation", function()
      -- Build the expected path
      local expected_rocks_path =
        vim.fs.joinpath(vim.fn.stdpath("data"), "rocks", "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")

      -- Verify that the rocks.nvim path is in runtimepath
      assert.is_true(string.find(vim.o.runtimepath, expected_rocks_path, 1, true) ~= nil)
    end)
  end)

  -- Scenario 2: rocks.nvim is already installed
  describe("when rocks.nvim is already installed", function()
    before_each(function()
      -- Clear the test environment
      require("plenary.busted").clear()

      -- Mock for `vim.uv.fs_stat` to simulate rocks.nvim being installed
      vim.uv = vim.uv or {}
      vim.uv.fs_stat = function(path)
        if path:match("rocks%.nvim") then
          return { type = "directory" } -- Simulate that rocks.nvim is installed
        end
        return { type = "directory" }
      end

      -- Mock for `vim.fn.system` (should not be called)
      vim.fn.system = function(cmd)
        if type(cmd) == "table" and cmd[1] == "git" then
          error("Unexpected git command in this scenario")
        end
        return vim.fn.system(cmd)
      end

      -- Mock for `vim.fn.delete`
      vim.fn.delete = function(path, flags)
        print("MOCK: Simulating deletion of", path)
        return 0
      end

      -- Mock for `vim.notify`
      vim.notify = function(msg, level)
        print("MOCK NOTIFY:", msg, level)
      end

      -- Load your `init.lua`
      dofile(vim.fn.getcwd() .. "/init.lua")
    end)

    it("should load rocks.nvim without installing", function()
      -- Verify that `rocks.nvim` is loaded correctly
      assert.is_true(pcall(require, "rocks"))
    end)

    it("should add rocks.nvim to runtimepath", function()
      -- Build the expected path
      local expected_rocks_path =
        vim.fs.joinpath(vim.fn.stdpath("data"), "rocks", "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")

      -- Verify that the rocks.nvim path is in runtimepath
      assert.is_true(string.find(vim.o.runtimepath, expected_rocks_path, 1, true) ~= nil)
    end)
  end)
end)
