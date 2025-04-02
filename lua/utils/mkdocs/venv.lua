local M = {}

-- Configuration {{{
local config = {
	venvs_dir = vim.fn.stdpath("data") .. "/venvs",
	-- Paths that should always be available (Mason binaries, system tools)
	preserved_paths = {
		vim.fn.stdpath("data") .. "/mason/bin", -- Mason binaries
		"/usr/local/bin", -- System tools
		"/usr/bin",
		os.getenv("HOME") .. "/.local/bin",
	},
}
-- }}}

-- State management {{{
local state = {
	original_path = vim.env.PATH,
	original_python_path = vim.fn.exepath("python"),
	active = false,
}
-- }}}

-- Utility functions {{{

-- Utility function to join paths with proper separators
local function path_join(...)
	return table.concat({ ... }, "/")
end

-- Get validated preserved paths (exists and is directory)
local function get_preserved_paths()
	local valid_paths = {}
	for _, path in ipairs(config.preserved_paths) do
		if vim.fn.isdirectory(path) == 1 then
			table.insert(valid_paths, path)
		end
	end
	return valid_paths
end

-- Get the current project's virtual environment path
local function get_project_venv_path()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	return path_join(config.venvs_dir, project_name)
end

-- Ensure the venvs directory exists
local function ensure_venvs_dir()
	if vim.fn.isdirectory(config.venvs_dir) == 0 then
		vim.fn.mkdir(config.venvs_dir, "p")
	end
end

-- Check if virtual environment exists for current project
function M.venv_exists()
	return vim.fn.isdirectory(get_project_venv_path()) == 1
end

-- Check if any virtual environment is active
function M.is_active()
	return state.active
end

-- Get current Python executable path
function M.get_python_path()
	return vim.fn.exepath("python")
end

-- }}}

-- Create a new virtual environment {{{

function M.create()
	-- Ensure that the directory for virtual environments exists
	ensure_venvs_dir()

	-- Get the path for the new virtual environment
	local venv_path = get_project_venv_path()

	-- Extract the virtual environment name from the path
	local venv_name = vim.fn.fnamemodify(venv_path, ":t")

	-- Check if a virtual environment already exists at the specified path
	if M.venv_exists() then
		vim.notify("Virtual environment already exists: " .. venv_name, vim.log.levels.WARN)
		return false
	end

	-- Construct the command to create a new virtual environment using the specified Python interpreter
	local cmd = string.format("python -m venv %s", vim.fn.shellescape(venv_path))

	-- Start a job to create the virtual environment and handle the exit event
	local job_id = vim.fn.jobstart(cmd, {
		on_exit = function(_, exit_code, _)
			-- Check the exit code to determine if the virtual environment creation was successful
			if exit_code ~= 0 then
				vim.notify("Failed to create virtual environment", vim.log.levels.ERROR)
			else
				vim.notify("Created virtual environment: " .. venv_name, vim.log.levels.INFO)
			end
		end,
	})

	-- If job_id is less than or equal to 0, the job failed to start
	if job_id <= 0 then
		vim.notify("Failed to start virtual environment creation job", vim.log.levels.ERROR)
		return false
	end

	-- Return true indicating that the job to create the virtual environment has been initiated
	return true
end

-- }}}

-- Activate virtual environment with Mason-aware PATH management {{{

function M.activate()
	-- Check if a virtual environment exists; if not, attempt to create one
	if not M.venv_exists() and not M.create() then
		return
	end

	-- Check if a virtual environment is already active
	if M.is_active() then
		-- Compare the currently active virtual environment with the one to be activated
		if vim.env.VIRTUAL_ENV == get_project_venv_path() then
			local venv_name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t") -- Extract name only
			vim.notify(string.format("Virtual environment '%s' is already active", venv_name), vim.log.levels.WARN)
		else
			local active_venv_name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
			vim.notify(
				string.format("Another virtual environment is already active: '%s'", active_venv_name),
				vim.log.levels.WARN
			)
		end
		return
	end

	-- Retrieve the path for the virtual environment
	local venv_path = get_project_venv_path()
	local venv_name = vim.fn.fnamemodify(venv_path, ":t") -- Extract name only

	-- Preserve existing paths to avoid losing them when modifying PATH
	local preserved_paths = table.concat(get_preserved_paths(), ":")

	-- Set the VIRTUAL_ENV variable to point to the active virtual environment
	vim.env.VIRTUAL_ENV = venv_path

	-- Update PATH to prioritize the virtual environment's bin directory
	vim.env.PATH = path_join(venv_path, "bin") .. ":" .. preserved_paths .. ":" .. state.original_path

	-- Set the state to indicate that the virtual environment is active
	state.active = true

	-- Notify the user that the virtual environment has been activated (name only)
	vim.notify(string.format("Activated virtual environment: '%s'", venv_name), vim.log.levels.INFO)
end

-- }}}

-- Deactivate virtual environment {{{

function M.deactivate()
	-- Check if a virtual environment is currently active
	if not M.is_active() then
		vim.notify("No virtual environment is active", vim.log.levels.WARN)
		return
	end

	-- Restore the original environment variables
	local preserved_paths = get_preserved_paths()
	vim.env.PATH = table.concat(preserved_paths, ":") .. ":" .. state.original_path -- Restore the original PATH including preserved

	-- Clear the VIRTUAL_ENV variable to deactivate the virtual environment
	vim.env.VIRTUAL_ENV = nil
	state.active = false -- Update the state to indicate that no virtual environment is active

	-- Notify the user that the virtual environment has been deactivated
	vim.notify(
		string.format("Deactivated virtual environment\nRestored Python path: %s", M.get_python_path()),
		vim.log.levels.INFO
	)
end

-- }}}

-- List all virtual environments in the configured directory {{{

function M.list()
	-- Ensure the directory for virtual environments exists
	ensure_venvs_dir()

	-- Get a list of all virtual environments in the specified directory
	local venvs = vim.fn.glob(path_join(config.venvs_dir, "*"), false, true)

	-- Check if any virtual environments were found
	if #venvs == 0 then
		vim.notify("No virtual environments found in " .. config.venvs_dir, vim.log.levels.INFO)
		return
	end

	local venv_names = {}

	-- Iterate over each virtual environment path and extract just the name
	for _, path in ipairs(venvs) do
		table.insert(venv_names, vim.fn.fnamemodify(path, ":t")) -- Get the name of the virtual environment
	end

	-- Notify the user of the available virtual environments
	vim.notify("Available virtual environments:\n" .. table.concat(venv_names, "\n"), vim.log.levels.INFO)
end

-- }}}

-- Remove virtual environment {{{

function M.remove()
	-- Check if a virtual environment exists
	if not M.venv_exists() then
		local venv_name = vim.fn.fnamemodify(get_project_venv_path(), ":t") -- Extract name only
		vim.notify(string.format("No virtual environment '%s' found", venv_name), vim.log.levels.WARN)
		return false
	end

	-- Command to remove the virtual environment
	local venv_path = get_project_venv_path()
	local venv_name = vim.fn.fnamemodify(venv_path, ":t") -- Extract name only
	local cmd = "rm -rf " .. vim.fn.shellescape(venv_path)
	vim.fn.system(cmd) -- Execute the removal command

	-- Check if the removal command was successful
	if vim.v.shell_error ~= 0 then
		-- Build an error message based on the shell error
		vim.notify(
			string.format("Failed to remove virtual environment '%s' (error code: %d)", venv_name, vim.v.shell_error),
			vim.log.levels.ERROR
		)
		return false
	end

	-- Notify user of success in removing the virtual environment
	vim.notify(string.format("Removed virtual environment '%s'", venv_name), vim.log.levels.INFO)
	return true
end

-- }}}

-- Get status information {{{

function M.get_python_version(python_path)
	if not python_path or python_path == "" then
		return "unknown version (no path)"
	end

	local handle, err = io.popen(python_path .. " --version 2>&1")
	if not handle then
		return "unknown version (" .. (err or "failed to execute") .. ")"
	end

	local result = handle:read("*a")
	handle:close()

	return result:match("Python (%d+%.%d+%.%d+)") or "unknown version (invalid output)"
end

function M.status()
	local python_path, python_name, python_version
	local venv_name = ""

	-- Check if a virtual environment is currently active
	if M.is_active() then
		python_path = M.get_python_path()
		if not python_path or python_path == "" then
			return "Active venv but Python path not found"
		end

		if vim.env.VIRTUAL_ENV then
			venv_name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t") or "unnamed_venv"
		end

		python_name = vim.fn.fnamemodify(python_path, ":t") or "unknown_python"
		python_version = M.get_python_version(python_path)

		return string.format(
			"Active: '%s'\nPython: %s (%s) [from virtual environment]",
			venv_name,
			python_name,
			python_version
		)

	-- Check if a virtual environment exists but is not currently active
	elseif M.venv_exists() then
		python_path = state.original_python_path or ""
		local project_venv_path = get_project_venv_path()

		if project_venv_path then
			venv_name = vim.fn.fnamemodify(project_venv_path, ":t") or "unnamed_venv"
		end

		python_name = vim.fn.fnamemodify(python_path, ":t") or "system_python"
		python_version = M.get_python_version(python_path)

		return string.format(
			"Exists but inactive: '%s'\nPython: %s (%s) [from system]",
			venv_name,
			python_name,
			python_version
		)

	-- If no virtual environment exists at all
	else
		python_path = state.original_python_path or ""
		python_name = vim.fn.fnamemodify(python_path, ":t") or "system_python"
		python_version = M.get_python_version(python_path)

		return string.format("No virtual environment\nPython: %s (%s) [from system]", python_name, python_version)
	end
end

-- }}}

-- Setup commands {{{

function M.setup()
	vim.api.nvim_create_user_command("PyVenvCreate", M.create, {})
	vim.api.nvim_create_user_command("PyVenvActivate", M.activate, {})
	vim.api.nvim_create_user_command("PyVenvDeactivate", M.deactivate, {})
	vim.api.nvim_create_user_command("PyVenvStatus", function()
		vim.notify(M.status(), vim.log.levels.INFO)
	end, {})
	vim.api.nvim_create_user_command("PyVenvList", M.list, {})
	vim.api.nvim_create_user_command("PyVenvRemove", M.remove, {})
end

-- }}}

return M
