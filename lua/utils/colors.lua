-- lua/utils/colors.lua

-- Get hexadecimal of a Neovim highlight group
local M = {}

--- Get the color of a specific point (foreground or background) of a highlight group.
--- @param highlight_group string The name of the highlight group (e.g. 'Normal', 'Comment', etc.)
--- @param point string The point to retrieve the color for ('fg' for foreground, 'bg' for background)
--- @return string|nil The color of the specified point in the format '#rrggbb', or nil if not found
--- @return string|nil An error message if the highlight group or point does not exist, or nil if successful
function M.get_col(highlight_group, point)
	-- Use Neovim's API to get highlight group details
	local hl = vim.api.nvim_get_hl(0, { name = highlight_group, link = false })
	-- Verify highlight group retrieval
	if hl then
		local color_value = hl[point] -- Access the specified point ('fg' or 'bg')
		-- Verify color value exists
		if color_value then
			return string.format("#%06x", color_value), nil -- No error message, returns color
		else
			return nil, "Color point does not exist" -- Return nil for color, with an error message
		end
	else
		return nil, "Highlight group does not exist" -- Return nil for color, with an error message
	end
end

return M
