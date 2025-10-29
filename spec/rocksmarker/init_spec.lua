describe("Neovim initialization with rocks.nvim", function()
	before_each(function()
		-- Clear any existing configuration
		package.path = ""
		package.cpath = ""
		vim.g.rocks_nvim = nil
	end)

	it("should set up rocks.nvim configuration correctly", function()
		-- Execute the initialization code
		dofile(vim.fn.stdpath("config") .. "/init.lua")

		-- Check if vim.g.rocks_nvim is set correctly
		assert.is_table(vim.g.rocks_nvim, "vim.g.rocks_nvim should be a table")
		assert.is_string(vim.g.rocks_nvim.rocks_path, "vim.g.rocks_nvim.rocks_path should be a string")

		-- Check if package.path is updated correctly
		local rocks_path = vim.g.rocks_nvim.rocks_path
		local expected_lua_path = {
			vim.fs.joinpath(rocks_path, "share", "lua", "5.1", "?.lua"),
			vim.fs.joinpath(rocks_path, "share", "lua", "5.1", "?", "init.lua"),
		}
		for _, path in ipairs(expected_lua_path) do
			assert.is_true(
				package.path:find(path, 1, true) ~= nil,
				string.format("package.path should contain %s", path)
			)
		end

		-- Check if package.cpath is updated correctly
		local expected_c_path = {
			vim.fs.joinpath(rocks_path, "lib", "lua", "5.1", "?.so"),
			vim.fs.joinpath(rocks_path, "lib64", "lua", "5.1", "?.so"),
		}
		for _, cpath in ipairs(expected_c_path) do
			assert.is_true(
				package.cpath:find(cpath, 1, true) ~= nil,
				string.format("package.cpath should contain %s", cpath)
			)
		end

		-- Check if rocks.nvim is in the runtimepath
		local rocks_runtimepath = vim.fs.joinpath(rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
		local runtimepaths = vim.opt.runtimepath:get()
		local found = false
		for _, rtp in ipairs(runtimepaths) do
			if rtp:find(rocks_runtimepath:gsub("%*", ""), 1, true) then
				found = true
				break
			end
		end
		assert.is_true(found, "runtimepath should contain rocks.nvim path")
	end)

	it("should load rocks.nvim successfully", function()
		-- Execute the initialization code
		dofile(vim.fn.stdpath("config") .. "/init.lua")

		-- Check if rocks.nvim can be required without errors
		local success, rocks = pcall(require, "rocks")
		assert.is_true(success, "rocks.nvim should be loadable")
		if success then
			assert.is_table(rocks, "require('rocks') should return a table")
		end
	end)

	it("should attempt to install rocks.nvim if not present", function()
		-- Mock vim.fn.system and vim.uv.fs_stat to simulate rocks.nvim not being installed
		local original_system = vim.fn.system
		local original_fs_stat = vim.uv.fs_stat
		local original_pcall = _G.pcall
		local original_source = vim.cmd.source
		local clone_called = false

		-- Mock pcall to simulate that rocks is not loadable
		_G.pcall = function(func, ...)
			local args = { ... }
			if func == require and args[1] == "rocks" then
				return false
			end
			return original_pcall(func, ...)
		end

		vim.fn.system = function(cmd)
			if type(cmd) == "table" and cmd[1] == "git" and cmd[2] == "clone" then
				clone_called = true
				return 0 -- Simulate successful clone by returning 0
			end
			return original_system(cmd)
		end

		vim.uv.fs_stat = function(path)
			-- Simulate that the rocks.nvim directory does not exist
			if type(path) == "string" and path:find("rocks%.nvim") then
				return nil
			end
			return { type = "directory" } -- Default return for other paths
		end

		-- Mock vim.cmd.source to avoid trying to load a non-existent file
		vim.cmd.source = function(_) end

		-- Execute the initialization code
		dofile(vim.fn.stdpath("config") .. "/init.lua")

		-- Check if git clone was called
		assert.is_true(clone_called, "git clone should be called to install rocks.nvim")

		-- Restore original functions
		_G.pcall = original_pcall
		vim.fn.system = original_system
		vim.uv.fs_stat = original_fs_stat
		vim.cmd.source = original_source
	end)
end)
