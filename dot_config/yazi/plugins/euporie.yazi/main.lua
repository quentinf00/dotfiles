-- Keep the plugin name so the existing E key binding continues to work.
local get_path = ya.sync(function()
	local hovered = cx.active.current.hovered
	return hovered and tostring(hovered.url.path) or nil
end)

local function quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

return {
	entry = function()
		local path = get_path()
		if not path then
			return
		end
		local config = os.getenv("YAZI_CONFIG_HOME")
		if not config or config == "" then
			local xdg = os.getenv("XDG_CONFIG_HOME")
			config = (xdg and xdg ~= "" and xdg or os.getenv("HOME") .. "/.config") .. "/yazi"
		end
		local launcher = config .. "/plugins/euporie.yazi/launch.py"
		local local_launcher = io.open(launcher, "r")
		if local_launcher then
			local_launcher:close()
		else
			launcher = config .. "/plugins/euporie.yazi/launch-portable.py"
		end
		ya.emit("shell", {
			"python3 " .. quote(launcher) .. " " .. quote(path),
			block = true,
		})
	end,
}
