local M = {}

local venv = require("utils.python_venv")

-- common utilities {{{

-- Track the running server process
local server_job_id = nil

-- Function to activate the virtual environment for Mkdocs commands
local function activate_venv()
	if not venv.is_active() then
		venv.activate()
	end
end

-- Function to deactivate the virtual environment if active
local function deactivate_venv()
	if venv.is_active() then
		venv.deactivate()
	end
end

-- Check if MkDocs is installed in the current virtual environment
function M.is_installed()
	if not venv.is_active() then
		vim.notify("No active virtual environment", vim.log.levels.WARN)
		return false
	end

	local cmd = venv.get_python_path() .. " -m pip show mkdocs"
	local result = vim.fn.system(cmd)
	return vim.v.shell_error == 0 and result:find("Name: mkdocs") ~= nil
end

-- Function to check if MkDocs is installed and notify the user
function M.check_mkdocs_installed()
	if not M.is_installed() then
		vim.notify("MkDocs is not installed. Run :MkdocsInstall first", vim.log.levels.ERROR)
		return false
	end
	return true
end

-- }}}

-- Install MkDocs for standard mkdocs-material {{{

--- Install MkDocs and the Material theme, ensuring a virtual environment is active.
--- @return boolean Indicates success or failure of the installation process.
function M.material()
	-- Activate the virtual environment
	activate_venv()

	-- Check if the virtual environment is active
	if not venv.is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Check if MkDocs is installed
	if M.is_installed() then
		vim.notify("MkDocs is already installed", vim.log.levels.INFO)
		return true
	end

	-- Construct the command to install MkDocs and Material theme
	local cmd = venv.get_python_path() .. " -m pip install --upgrade pip"
	vim.fn.system(cmd)

	cmd = venv.get_python_path() .. " -m pip install mkdocs mkdocs-material"
	-- Notify user about the installation process
	vim.notify("Installing MkDocs and Material theme...", vim.log.levels.INFO)

	-- Execute the installation command with verbose output
	local result = vim.fn.system(cmd .. " --verbose")

	-- Check if the installation was successful
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to install MkDocs. Error:\n" .. result, vim.log.levels.ERROR)
		return false
	else
		-- Path to the template mkdocs.yml file
		local template_path = vim.fn.stdpath("config") .. "/lua/utils/template/material-mkdocs.yml"
		local target_path = vim.fn.getcwd() .. "/mkdocs.yml"

		-- Only proceed with file copying if the file doesn't exist
		if vim.fn.filereadable(target_path) == 0 then
			if vim.fn.filereadable(template_path) == 1 then
				local copy_cmd = "cp " .. vim.fn.shellescape(template_path) .. " " .. vim.fn.shellescape(target_path)
				local copy_result = vim.fn.system(copy_cmd)

				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to copy template:\n" .. copy_result, vim.log.levels.ERROR)
					return false
				end
				vim.notify("Copied mkdocs.yml in the project root", vim.log.levels.INFO)
			else
				vim.notify("No mkdocs.yml template found at: " .. template_path, vim.log.levels.WARN)
			end
		else
			vim.notify("mkdocs.yml already exists - skipping template copy", vim.log.levels.INFO)
		end

		-- Ensure docs directory exists
		local docs_dir = vim.fn.getcwd() .. "/docs"
		if vim.fn.isdirectory(docs_dir) == 0 then
			vim.fn.mkdir(docs_dir, "p")
			vim.notify("Created docs directory: " .. docs_dir, vim.log.levels.INFO)
		end

		-- Path to the material-index.md file
		local index_template_path = vim.fn.stdpath("config") .. "/lua/utils/template/material-index.md"
		local index_target_path = docs_dir .. "/index.md"

		-- Only proceed with file copying if the file doesn't exist
		if vim.fn.filereadable(index_target_path) == 0 then
			if vim.fn.filereadable(index_template_path) == 1 then
				local copy_index_cmd = "cp "
					.. vim.fn.shellescape(index_template_path)
					.. " "
					.. vim.fn.shellescape(index_target_path)
				local index_result = vim.fn.system(copy_index_cmd)

				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to copy index template:\n" .. index_result, vim.log.levels.ERROR)
					return false
				end
				vim.notify("Copied template to docs/index.md", vim.log.levels.INFO)
			else
				vim.notify("No material-index.md template found at: " .. index_template_path, vim.log.levels.WARN)
			end
		else
			vim.notify("docs/index.md already exists - skipping copy", vim.log.levels.INFO)
		end

		vim.notify("Successfully installed MkDocs and Material theme", vim.log.levels.INFO)
		return true
	end
end

-- }}}

-- Install MkDocs for RockyDocs {{{

--- Set up MkDocs for Rocky Documentation with the specified templates and themes.
--- @return boolean Indicates success or failure of the setup process
function M.rockydocs()
	-- Get paths
	local config_path = vim.fn.stdpath("config")
	local template_dir = config_path .. "/lua/utils/template"

	-- Source paths
	local requirements_path = template_dir .. "/rockydocs-requirements.txt"
	local template_path = template_dir .. "/rockydocs-mkdocs.yml"
	local theme_path = template_dir .. "/theme"
	local index_template_path = template_dir .. "/rockydocs-index.md"

	-- Target paths
	local target_path = vim.fn.getcwd()
	local mkdocs_target = target_path .. "/mkdocs.yml"
	local theme_target = target_path .. "/theme"
	local docs_dir = target_path .. "/docs"
	local docs_docs_dir = docs_dir .. "/docs" -- This folder will be created for rockydocs
	local index_target = docs_docs_dir .. "/index.md"

	activate_venv() -- Activate the virtual environment

	-- Check if the virtual environment is active
	if not venv.is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Verify if the requirements template exists
	if vim.fn.filereadable(requirements_path) == 0 then
		vim.notify("Requirements template not found: " .. requirements_path, vim.log.levels.ERROR)
		return false
	end

	-- Install requirements (always run this part)
	vim.notify("Installing RockyDocs environments...", vim.log.levels.INFO)

	local pip_cmd = venv.get_python_path() .. " -m pip install -r " .. vim.fn.shellescape(requirements_path)
	local install_result = vim.fn.system(pip_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to install requirements:\n" .. install_result, vim.log.levels.ERROR)
		return false
	end

	-- Verify MkDocs installation
	local verify_cmd = venv.get_python_path() .. " -m pip show mkdocs >/dev/null 2>&1"
	vim.fn.system(verify_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("MkDocs not found after installation. Aborting setup.", vim.log.levels.ERROR)
		return false
	end

	-- Only proceed with file copying if the files don't exist
	local files_copied = false

	-- Copy rocky-mkdocs.yml template if it doesn't exist
	if vim.fn.filereadable(mkdocs_target) == 0 then
		if vim.fn.filereadable(template_path) == 1 then
			local copy_cmd = "cp " .. vim.fn.shellescape(template_path) .. " " .. vim.fn.shellescape(mkdocs_target)
			local copy_result = vim.fn.system(copy_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy template:\n" .. copy_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
		else
			vim.notify("No rocky-mkdocs.yml template found at: " .. template_path, vim.log.levels.ERROR)
			return false -- Abort if the template does not exist
		end
	else
		vim.notify("mkdocs.yml already exists - skipping template copy", vim.log.levels.INFO)
	end

	-- Copy theme folder if it doesn't exist
	if vim.fn.isdirectory(theme_target) == 0 then
		if vim.fn.isdirectory(theme_path) == 1 then
			-- Create target directory if it doesn't exist
			if vim.fn.isdirectory(theme_target) == 0 then
				vim.fn.mkdir(theme_target, "p")
			end

			local copy_theme_cmd = "rsync -a "
				.. vim.fn.shellescape(theme_path)
				.. "/ "
				.. vim.fn.shellescape(theme_target)
				.. "/"
			local theme_result = vim.fn.system(copy_theme_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy theme:\n" .. theme_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
			vim.notify("Successfully copied theme folder to project root", vim.log.levels.INFO)
		else
			vim.notify("No theme folder found at: " .. theme_path, vim.log.levels.ERROR)
			return false -- Abort if the theme folder does not exist
		end
	else
		vim.notify("theme folder already exists - skipping copy", vim.log.levels.INFO)
	end

	-- Copy rocky-index.md to docs/docs/index.md if it doesn't exist
	if vim.fn.filereadable(index_target) == 0 then
		if vim.fn.filereadable(index_template_path) == 1 then
			-- Ensure docs/docs directory exists
			if vim.fn.isdirectory(docs_docs_dir) == 0 then
				vim.fn.mkdir(docs_docs_dir, "p")
			end

			local copy_index_cmd = "cp "
				.. vim.fn.shellescape(index_template_path)
				.. " "
				.. vim.fn.shellescape(index_target)
			local index_result = vim.fn.system(copy_index_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy index template:\n" .. index_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
			vim.notify("Successfully copied template to docs/docs/index.md", vim.log.levels.INFO)
		else
			vim.notify("No rocky-index.md template found at: " .. index_template_path, vim.log.levels.ERROR)
			return false -- Abort if the index template does not exist
		end
	else
		vim.notify("docs/docs/index.md already exists - skipping copy", vim.log.levels.INFO)
	end

	if files_copied then
		vim.notify(
			"Successfully set up MkDocs with:\n- Rocky configuration\n- Theme folder\n- Documentation index",
			vim.log.levels.INFO
		)
	else
		vim.notify(
			"Requirements installed successfully, but no files were copied as they already exist",
			vim.log.levels.INFO
		)
	end

	return true
end

-- }}}

-- Create a new MkDocs project in the current directory {{{
function M.new_project()
	activate_venv()
	if not venv.is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Check if MkDocs is installed
	if not M.check_mkdocs_installed() then
		return false
	end

	local cmd = venv.get_python_path() .. " -m mkdocs new ."
	vim.notify("Creating new MkDocs project...", vim.log.levels.INFO)

	vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to create MkDocs project", vim.log.levels.ERROR)
		return false
	else
		vim.notify("Successfully created MkDocs project", vim.log.levels.INFO)
		return true
	end
end

-- }}}

-- Serve the MkDocs documentation {{{

function M.serve()
	activate_venv() -- Activate the virtual environment
	if not venv.is_active() then -- Check if the virtual environment is now active
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	if not M.is_installed() then -- Check if MkDocs is installed in the active virtual environment
		vim.notify("MkDocs is not installed. Run :MkdocsInstall first", vim.log.levels.ERROR)
		return false
	end

	if vim.fn.filereadable("mkdocs.yml") ~= 1 then -- Ensure mkdocs.yml is present
		vim.notify("No mkdocs.yml found in the current directory", vim.log.levels.ERROR)
		return false
	end

	-- Stop any existing server first if already running
	if server_job_id and vim.fn.jobwait({ server_job_id }, 0)[1] == -1 then
		vim.fn.jobstop(server_job_id)
	end

	local cmd = venv.get_python_path() .. " -m mkdocs serve -q --dirty"
	vim.notify("Starting MkDocs server...", vim.log.levels.INFO)

	-- Start the server as a background job
	server_job_id = vim.fn.jobstart(cmd, {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line:find("Serving") then
						vim.notify(line, vim.log.levels.INFO)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,
		on_exit = function()
			deactivate_venv()
			server_job_id = nil
		end,
	})

	return true
end

-- }}}

-- Stop the running MkDocs server {{{

function M.stop_serve()
	if not server_job_id then
		vim.notify("No MkDocs server is currently running", vim.log.levels.WARN)
		return false
	end

	-- Check if the job is still running
	if vim.fn.jobwait({ server_job_id }, 0)[1] == -1 then
		vim.fn.jobstop(server_job_id)
		vim.notify("Stopped MkDocs server", vim.log.levels.INFO)
		server_job_id = nil
		deactivate_venv() -- Automatically deactivate the virtual environment after stopping
		return true
	else
		vim.notify("MkDocs server is not running", vim.log.levels.WARN)
		server_job_id = nil
		return false
	end
end

-- }}}

-- Build the MkDocs documentation {{{

function M.build()
	activate_venv()
	if not venv.is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	if not M.is_installed() then
		vim.notify("MkDocs is not installed. Run :MkdocsInstall first", vim.log.levels.ERROR)
		return false
	end

	if vim.fn.filereadable("mkdocs.yml") ~= 1 then
		vim.notify("No mkdocs.yml found in current directory", vim.log.levels.ERROR)
		return false
	end

	local cmd = venv.get_python_path() .. " -m mkdocs build"
	vim.notify("Building MkDocs documentation...", vim.log.levels.INFO)

	vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to build documentation", vim.log.levels.ERROR)
		return false
	else
		vim.notify("Successfully built documentation in site/ directory", vim.log.levels.INFO)
		return true
	end
end

-- }}}

-- Setup commands for Neovim {{{

function M.setup()
	vim.api.nvim_create_user_command("MkSetupMaterial", M.material, {})
	vim.api.nvim_create_user_command("MkSetupRockydocs", M.rockydocs, {})
	vim.api.nvim_create_user_command("MkSetupStandard", M.new_project, {})
	vim.api.nvim_create_user_command("MkdocsServe", M.serve, {})
	vim.api.nvim_create_user_command("MkdocsStop", M.stop_serve, {})
	vim.api.nvim_create_user_command("MkdocsBuild", M.build, {})
	vim.api.nvim_create_user_command("MkdocsStatus", function()
		local status = "MkDocs status:\n"

		if not venv.is_active() then
			status = status .. "No active virtual environment\n"
		else
			status = status .. "Virtual environment: " .. vim.env.VIRTUAL_ENV .. "\n"
			status = status .. "MkDocs installed: " .. (M.is_installed() and "Yes" or "No") .. "\n"

			if vim.fn.filereadable("mkdocs.yml") == 1 then
				status = status .. "MkDocs project detected in current directory\n"
			else
				status = status .. "No MkDocs project in current directory\n"
			end
		end

		if server_job_id and vim.fn.jobwait({ server_job_id }, 0)[1] == -1 then
			status = status .. "MkDocs server: Running\n"
		else
			status = status .. "MkDocs server: Not running\n"
		end

		vim.notify(status, vim.log.levels.INFO)
	end, {})
end

-- }}}

return M
