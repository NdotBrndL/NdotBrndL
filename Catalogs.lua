local StarterGui = game:GetService("StarterGui")

local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Catalog Avatar Creator",
            Text = tostring(msg),
            Duration = 5
        })
    end)
end

task.wait(3)

local success, catalogModule = pcall(function()
    return filtergc("table", {
        Keys = {"CanItemBeShown"}
    }, true)
end)

if not success or not catalogModule then
    notify("Catalog module not found")
    return
end

if typeof(catalogModule.CanItemBeShown) ~= "function" then
    notify("CanItemBeShown invalid")
    return
end

local oldFunction = catalogModule.CanItemBeShown

hookfunction(oldFunction, newcclosure(function(...)
    return true
end))

notify("Hook successful")
