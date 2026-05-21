the search false positives in catalog avatar creator were annoying so i made this thing that bypasses it
```lua
local starterGui = game:GetService("StarterGui")
local catalogModule = filtergc("table", { Keys = { "CanItemBeShown" }}, true)

local function notify(message)
    starterGui:SetCore("SendNotification", {
        Title = "Catalog Avatar Creator",
        Text = message
    })
end

if not catalogModule then
    return notify("Couldn't find catalog module table.")
end

hookfunction(catalogModule.CanItemBeShown, newlclosure(function()
    return true, nil
end, "CanItemBeShown"))

notify("Hooked CanItemBeShown successfully.")
```
