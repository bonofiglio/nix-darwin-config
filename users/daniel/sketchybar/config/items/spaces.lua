local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local space_brackets = {}

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers, size = 15 },
			string = i,
			padding_left = 8,
			padding_right = 3,
			color = colors.white,
			highlight_color = colors.blue,
			y_offset = 0,
		},
		label = {
			color = colors.white,
			highlight_color = colors.blue,
			font = "sketchybar-app-font:Regular:17.0",
		},
		padding_right = 0,
		padding_left = 0,
		background = {
			color = colors.transparent,
			border_width = 0,
			height = 26,
		},
		popup = { background = { border_width = 5, border_color = colors.black } },
	})

	spaces[i] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.transparent,
			corner_radius = 8,
			height = 4,
			y_offset = -16,
		},
	})

	space_brackets[i] = space_bracket.name

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		local color = selected and colors.grey or colors.bg2
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.black or colors.bg2 },
		})
		-- space_bracket:set({
		-- 	background = {
		-- 		color = selected and colors.magenta or colors.transparent,
		-- 	},
		-- })
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			space_popup:set({ background = { image = "space." .. env.SID } })
			space:set({ popup = { drawing = "toggle" } })
		elseif env.BUTTON == "left" then
			sbar.exec("/run/current-system/sw/bin/yabai -m space --focus " .. env.SID)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

space_window_observer:subscribe("space_windows_change", function(env)
	local icon_line = ""
	-- for app, count in pairs(env.INFO.apps) do
	-- 	local lookup = app_icons[app]
	-- 	local icon = ((lookup == nil) and app_icons["Default"] or lookup)
	-- 	icon_line = icon_line .. icon
	-- end

	sbar.animate("sin", 10, function()
		spaces[env.INFO.space]:set({ label = icon_line })
	end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
