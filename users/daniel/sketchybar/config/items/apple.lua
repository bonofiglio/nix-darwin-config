local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local popup_toggle = "sketchybar --set $NAME popup.drawing=toggle"

local apple = sbar.add("item", {
  icon = {
    font = { size = 18.0 },
    string = icons.apple,
    padding_right = 8,
    padding_left = 8,
  },
  label = { drawing = false },
  padding_left = 0,
  padding_right = 0,
  click_script = popup_toggle,
})

local apple_prefs = sbar.add("item", {
  position = "popup." .. apple.name,
  icon = icons.preferences,
  label = "Preferences",
})

apple_prefs:subscribe("mouse.clicked", function(_)
  sbar.exec("open -a 'System Preferences'")
  apple:set({ popup = { drawing = false } })
end)

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
