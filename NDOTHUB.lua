--// NDOT HUB HYPEROS ULTIMATE
--// Android Optimized
--// HyperOS Safe Edition
--// Anti Lag + FPS Unlock + Anti Crash

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/shlexware/Rayfield/main/source'
    ))()
end)

if not success then
    warn("Rayfield gagal dimuat")
    return
end

---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

---------------------------------------------------
-- SAFE FUNCTIONS
---------------------------------------------------

local function SafeCall(func)
    pcall(func)
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB | HYPEROS",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Android Ultimate Edition",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NDOTHUB_ANDROID",
        FileName = "MobileConfig"
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false,
})

---------------------------------------------------
-- TABS
---------------------------------------------------

local Main = Window:CreateTab("Main", 4483362458)
local Mobile = Window:CreateTab("Android", 4483362458)
local Misc = Window:CreateTab("Misc", 4483362458)

---------------------------------------------------
-- TOUCH FRIENDLY GUI
---------------------------------------------------

Mobile:CreateButton({
    Name = "Touch Friendly UI",

    Callback = function()

        SafeCall(function()

            for _,v in pairs(game.CoreGui:GetDescendants()) do

                if v:IsA("TextButton") then
                    v.TextSize = 20
                    v.Size = UDim2.new(
                        v.Size.X.Scale,
                        v.Size.X.Offset,
                        v.Size.Y.Scale,
                        45
                    )
                end

                if v:IsA("TextLabel") then
                    v.TextSize = 18
                end
            end

        end)

        Rayfield:Notify({
            Title = "NDOT HUB",
            Content = "Touch UI aktif",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

---------------------------------------------------
-- ANTI LAG MODE
---------------------------------------------------

Mobile:CreateButton({
    Name = "Anti Lag Mode",

    Callback = function()

        SafeCall(function()

            for _,v in pairs(workspace:GetDescendants()) do

                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end

                if v:IsA("Texture") then
                    v:Destroy()
                end

                if v:IsA("Decal") then
                    v.Transparency = 1
                end

                if v:IsA("ParticleEmitter") then
                    v.Enabled = false
                end

                if v:IsA("Trail") then
                    v.Enabled = false
                end
            end

            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
            Lighting.Brightness = 1

            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01

        end)

        Rayfield:Notify({
            Title = "NDOT HUB",
            Content = "Anti Lag aktif",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

---------------------------------------------------
-- FPS UNLOCK
---------------------------------------------------

Mobile:CreateButton({
    Name = "FPS Unlock",

    Callback = function()

        SafeCall(function()

            if setfpscap then
                setfpscap(120)
            end

            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01

        end)

        Rayfield:Notify({
            Title = "NDOT HUB",
            Content = "FPS Unlock aktif",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

---------------------------------------------------
-- ANTI CRASH EXECUTOR
---------------------------------------------------

Mobile:CreateToggle({
    Name = "Anti Crash",
    CurrentValue = true,

    Callback = function(Value)

        if Value then

            RunService.RenderStepped:Connect(function()

                SafeCall(function()

                    settings().Rendering.QualityLevel =
                        Enum.QualityLevel.Level01

                end)
            end)
        end
    end,
})

---------------------------------------------------
-- AUTO RECONNECT
---------------------------------------------------

Misc:CreateToggle({
    Name = "Auto Reconnect",
    CurrentValue = true,

    Callback = function(Value)

        if Value then

            game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)

                if child.Name == "ErrorPrompt" then

                    SafeCall(function()

                        TeleportService:Teleport(
                            game.PlaceId,
                            player
                        )

                    end)
                end
            end)
        end
    end,
})

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------

Misc:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,

    Callback = function(Value)

        if Value then

            player.Idled:Connect(function()

                SafeCall(function()

                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())

                end)
            end)
        end
    end,
})

---------------------------------------------------
-- SAVE CONFIG ANDROID
---------------------------------------------------

Misc:CreateButton({
    Name = "Save Config",

    Callback = function()

        Rayfield:Notify({
            Title = "NDOT HUB",
            Content = "Config Android tersimpan",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

---------------------------------------------------
-- LOW GRAPHIC LOOP
---------------------------------------------------

RunService.RenderStepped:Connect(function()

    SafeCall(function()

        settings().Rendering.QualityLevel =
            Enum.QualityLevel.Level01

    end)
end)

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "HyperOS Ultimate Loaded",
    Duration = 6,
    Image = 4483362458,
})
