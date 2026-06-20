repeat task.wait() until game:IsLoaded()

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer

-- Character helpers
local function char()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function hum()
    return char():FindFirstChildWhichIsA("Humanoid")
end

local function root()
    return char():FindFirstChild("HumanoidRootPart")
end

------------------------------------------------
-- WINDOW
------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB SIMPLE",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Simple Edition",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

------------------------------------------------
-- VALUES
------------------------------------------------
local ws = 16
local jp = 50
local noclip = false
local esp = false

------------------------------------------------
-- WALK + JUMP
------------------------------------------------
Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    CurrentValue = 16,
    Callback = function(v)
        ws = v
        local h = hum()
        if h then h.WalkSpeed = v end
    end
})

Tab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 150},
    CurrentValue = 50,
    Callback = function(v)
        jp = v
        local h = hum()
        if h then h.JumpPower = v end
    end
})

LP.CharacterAdded:Connect(function()
    task.wait(1)
    local h = hum()
    if h then
        h.WalkSpeed = ws
        h.JumpPower = jp
    end
end)

------------------------------------------------
-- NOCLIP
------------------------------------------------
RunService.Stepped:Connect(function()
    if noclip then
        for _,v in pairs(char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclip = v
    end
})

------------------------------------------------
-- ESP SIMPLE
------------------------------------------------
local function espPlayer(plr)
    if plr == LP then return end

    plr.CharacterAdded:Connect(function(c)
        task.wait(1)
        if c:FindFirstChild("ESP") then return end

        local h = Instance.new("Highlight")
        h.Name = "ESP"
        h.Parent = c
    end)
end

Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v)
        esp = v

        if v then
            for _,p in pairs(Players:GetPlayers()) do
                espPlayer(p)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(p)
    if esp then espPlayer(p) end
end)

------------------------------------------------
-- FULLBRIGHT
------------------------------------------------
Tab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Callback = function(v)
        if v then
            Lighting.Brightness = 5
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
        else
            Lighting.Brightness = 2
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end
    end
})

------------------------------------------------
-- REJOIN
------------------------------------------------
Tab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LP)
    end
})
