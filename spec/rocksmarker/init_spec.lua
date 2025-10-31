-- spec/init_spec.lua
describe("init.lua", function()
  -- Helper function to setup mocks
  local function setup_mocks(simulate_installed)
    -- Clear the test environment
    require("plenary.busted").clear()

    -- Mock for `vim.uv.fs_stat`
    vim.uv = vim.uv or {}
    vim.uv.fs_stat = function(path)
      if path:match("rocks%.nvim") then
        return simulate_installed and { type = "directory" } or nil
      end
      return { type = "directory" }
    end

    -- Mock for `vim.fn.system`
    local original_system = vim.fn.system
    vim.fn.system = function(cmd)
      if type(cmd) == "table" and cmd[1] == "git" and cmd[3] and cmd[3]:match("rocks%.nvim") then
        print("MOCK: Simulating git clone of rocks.nvim")
        -- Create a mock directory and bootstrap.lua file
        local mock_rocks_path = vim.fn.stdpath("cache") .. "/rocks.nvim"
        vim.fn.mkdir(mock_rocks_path, "p")
        local bootstrap_file = io.open(mock_rocks_path .. "/bootstrap.lua", "w")
        if bootstrap_file then
          bootstrap_file:write("-- Mock bootstrap.lua file\n")
          bootstrap_file:close()
        end
        return 0
      end
      return original_system(cmd)
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
  end

  -- Scenario 1: rocks.nvim is not installed
  describe("when rocks.nvim is not installed", function()
    before_each(function()
      setup_mocks(false)
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
      setup_mocks(true)
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
