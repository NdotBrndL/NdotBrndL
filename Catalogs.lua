local StarterGui = game:GetService("StarterGui")

local catalogModule = filtergc("table", {
    Keys = {"CanItemBeShown"}
}, true)

local function notify(message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Catalog Avatar Creator",
            Text = tostring(message),
            Duration = 5
        })
    end)
end

if not catalogModule then
    notify("Couldn't find catalog module table.")
    return
end

if typeof(catalogModule.CanItemBeShown) ~= "function" then
    notify("CanItemBeShown is not a function.")
    return
end

local old
old = hookfunction(catalogModule.CanItemBeShown, newcclosure(function(...)
    return true, nil
end))

notify("Hooked CanItemBeShown successfully.")
