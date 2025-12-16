-- Git Status settings
th.git = th.git or {}
th.git.modified = ui.Style():fg("yellow")
th.git.added = ui.Style():fg("green")
th.git.untracked = ui.Style():fg("magenta")
th.git.ignored = ui.Style():fg("darkgray")
th.git.deleted = ui.Style():fg("red")
th.git.updated = ui.Style():fg("yellow")

-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

require("full-border"):setup()
require("git"):setup()
