--// NDOT HUB UNIVERSAL SAFE EDITION
--// Android & PC Support
--// Universal Map Support
--// Anti Error Version

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/shlexware/Rayfield/main/source'
    ))()
end)

if not success then
    warn("Rayfield gagal dimuat")
    return
end

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- SAFE FUNCTIONS
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    local character = getCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

-- WINDOW
local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB | SAFE UNIVERSAL",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Universal Roblox Script",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NDOTHUB",
        FileName = "UniversalConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- TAB
local MainTab = Window:CreateTab("Main", 4483362458)
local FunTab = Window:CreateTab("Fun", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

---------------------------------------------------
-- SPEED
---------------------------------------------------

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,

    Callback = function(Value)

        local humanoid = getHumanoid()

        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

---------------------------------------------------
-- JUMP
---------------------------------------------------

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,

    Callback = function(Value)

        local humanoid = getHumanoid()

        if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

local InfiniteJump = false

UIS.JumpRequest:Connect(function()

    if InfiniteJump then

        local humanoid = getHumanoid()

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,

    Callback = function(Value)
        InfiniteJump = Value
    end,
})

---------------------------------------------------
-- FLY
---------------------------------------------------

local Fly = false
local BV

MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,

    Callback = function(Value)

        Fly = Value

        local hrp = getHRP()

        if not hrp then return end

        if Value then

            BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(
                math.huge,
                math.huge,
                math.huge
            )

            BV.Velocity = Vector3.new(0,50,0)
            BV.Parent = hrp

        else

            if BV then
                BV:Destroy()
                BV = nil
            end
        end
    end,
})

---------------------------------------------------
-- NOCLIP
---------------------------------------------------

local noclip = false

RunService.Stepped:Connect(function()

    if noclip then

        local character = getCharacter()

        for _,v in pairs(character:GetDescendants()) do

            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)
        noclip = Value
    end,
})

---------------------------------------------------
-- ESP
---------------------------------------------------

local ESPEnabled = false
local espTable = {}

local function clearESP()

    for _,v in pairs(espTable) do

        if v then
            v:Destroy()
        end
    end

    espTable = {}
end

local function createESP()

    clearESP()

    for _,plr in pairs(Players:GetPlayers()) do

        if plr ~= player and plr.Character then

            local h = Instance.new("Highlight")
            h.Parent = plr.Character

            table.insert(espTable,h)
        end
    end
end

MainTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,

    Callback = function(Value)

        ESPEnabled = Value

        if Value then
            createESP()
        else
            clearESP()
        end
    end,
})

---------------------------------------------------
-- CLONE AVATAR
---------------------------------------------------

FunTab:CreateButton({
    Name = "Clone Avatar",

    Callback = function()

        local character = getCharacter()

        if character and character.PrimaryPart then

            local clone = character:Clone()

            clone.Parent = workspace

            clone:SetPrimaryPartCFrame(
                character.PrimaryPart.CFrame
                * CFrame.new(5,0,0)
            )
        end
    end,
})

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------

player.Idled:Connect(function()

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

---------------------------------------------------
-- FPS BOOST
---------------------------------------------------

MiscTab:CreateButton({
    Name = "FPS Boost",

    Callback = function()

        for _,v in pairs(workspace:GetDescendants()) do

            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end

            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end

        settings().Rendering.QualityLevel =
            Enum.QualityLevel.Level01
    end,
})

---------------------------------------------------
-- REJOIN
---------------------------------------------------

MiscTab:CreateButton({
    Name = "Rejoin Server",

    Callback = function()

        TeleportService:Teleport(
            game.PlaceId,
            player
        )
    end,
})

---------------------------------------------------
-- RESET CHARACTER
---------------------------------------------------

MiscTab:CreateButton({
    Name = "Reset Character",

    Callback = function()

        local humanoid = getHumanoid()

        if humanoid then
            humanoid.Health = 0
        end
    end,
})

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "Universal Script Loaded",
    Duration = 6,
    Image = 4483362458,
})
