--// NDOT HUB UNIVERSAL FIXED
--// DELTA ANDROID + PC SUPPORT
--// ORION UI VERSION

if not game:IsLoaded() then
    game.Loaded:Wait()
end

---------------------------------------------------
-- LOAD ORION UI
---------------------------------------------------

local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/shlexware/Orion/main/source"
    ))()
end)

if not success or not OrionLib then
    warn("Failed load Orion UI")
    return
end

---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------
-- SAFE FUNCTIONS
---------------------------------------------------

local function Character()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function Humanoid()
    local char = Character()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function Root()
    local char = Character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = OrionLib:MakeWindow({

    Name = "NDOT_BRNDL",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

---------------------------------------------------
-- TABS
---------------------------------------------------

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local UtilityTab = Window:MakeTab({
    Name = "Utility",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ServerTab = Window:MakeTab({
    Name = "Server",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

---------------------------------------------------
-- VALUES
---------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local InfiniteJump = false
local Noclip = false

---------------------------------------------------
-- WALKSPEED
---------------------------------------------------

PlayerTab:AddSlider({

    Name = "WalkSpeed",
    Min = 16,
    Max = 120,
    Default = 16,
    Increment = 1,

    Callback = function(v)

        WalkSpeed = v

        local hum = Humanoid()

        if hum then
            hum.WalkSpeed = v
        end
    end
})

---------------------------------------------------
-- JUMPPOWER
---------------------------------------------------

PlayerTab:AddSlider({

    Name = "JumpPower",
    Min = 50,
    Max = 150,
    Default = 50,
    Increment = 1,

    Callback = function(v)

        JumpPower = v

        local hum = Humanoid()

        if hum then
            hum.JumpPower = v
        end
    end
})

---------------------------------------------------
-- APPLY AFTER RESPAWN
---------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    local hum = Humanoid()

    if hum then
        hum.WalkSpeed = WalkSpeed
        hum.JumpPower = JumpPower
    end
end)

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

UIS.JumpRequest:Connect(function()

    if InfiniteJump then

        local hum = Humanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:AddToggle({

    Name = "Infinite Jump",
    Default = false,

    Callback = function(v)
        InfiniteJump = v
    end
})

---------------------------------------------------
-- NOCLIP
---------------------------------------------------

RunService.Stepped:Connect(function()

    if Noclip then

        local char = Character()

        for _,v in ipairs(char:GetDescendants()) do

            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

PlayerTab:AddToggle({

    Name = "Noclip",
    Default = false,

    Callback = function(v)
        Noclip = v
    end
})

---------------------------------------------------
-- ESP
---------------------------------------------------

local ESPEnabled = false
local ESPStorage = {}

local function ClearESP()

    for _,v in pairs(ESPStorage) do

        if v then
            v:Destroy()
        end
    end

    ESPStorage = {}
end

local function AddESP(plr)

    if not ESPEnabled then return end
    if plr == LocalPlayer then return end

    local function Apply()

        local char = plr.Character

        if not char then return end

        if char:FindFirstChild("NDOT_ESP") then
            return
        end

        local h = Instance.new("Highlight")

        h.Name = "NDOT_ESP"
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = char

        table.insert(ESPStorage, h)
    end

    Apply()

    plr.CharacterAdded:Connect(function()

        task.wait(1)
        Apply()
    end)
end

VisualTab:AddToggle({

    Name = "ESP Player",
    Default = false,

    Callback = function(v)

        ESPEnabled = v

        ClearESP()

        if v then

            for _,plr in ipairs(Players:GetPlayers()) do
                AddESP(plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(plr)

    if ESPEnabled then
        AddESP(plr)
    end
end)

---------------------------------------------------
-- FULLBRIGHT
---------------------------------------------------

VisualTab:AddToggle({

    Name = "FullBright",
    Default = false,

    Callback = function(v)

        if v then

            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false

        else

            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
        end
    end
})

---------------------------------------------------
-- FPS BOOST
---------------------------------------------------

UtilityTab:AddButton({

    Name = "FPS Boost",

    Callback = function()

        for _,obj in ipairs(workspace:GetDescendants()) do

            pcall(function()

                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                end

                if obj:IsA("Texture")
                or obj:IsA("Decal") then

                    obj.Transparency = 1
                end
            end)
        end

        if typeof(setfpscap) == "function" then
            pcall(function()
                setfpscap(30)
            end)
        end
    end
})

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------

LocalPlayer.Idled:Connect(function()

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

---------------------------------------------------
-- SERVER
---------------------------------------------------

ServerTab:AddButton({

    Name = "Copy JobId",

    Callback = function()

        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})

ServerTab:AddButton({

    Name = "Rejoin",

    Callback = function()

        TeleportService:Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end
})

ServerTab:AddButton({

    Name = "Reset Character",

    Callback = function()

        local hum = Humanoid()

        if hum then
            hum.Health = 0
        end
    end
})

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

OrionLib:MakeNotification({

    Name = "NDOT_BRNDL",
    Content = "Loaded Successfully",
    Time = 5
})

---------------------------------------------------
-- INIT
---------------------------------------------------

OrionLib:Init()
---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------
-- SAFE FUNCTIONS
---------------------------------------------------

local function Character()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function Humanoid()
    local char = Character()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function Root()
    local char = Character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = Rayfield:CreateWindow({

    Name = "NDOT_BRNDL",
    LoadingTitle = "NDOT_BRNDL",
    LoadingSubtitle = "Universal Stable",

    ConfigurationSaving = {
        Enabled = false
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

---------------------------------------------------
-- TABS
---------------------------------------------------

local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local AvatarTab = Window:CreateTab("Avatar", 4483362458)

---------------------------------------------------
-- VALUES
---------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local InfiniteJump = false
local Noclip = false
local Fly = false
local FlySpeed = 60

---------------------------------------------------
-- WALKSPEED
---------------------------------------------------

PlayerTab:CreateSlider({

    Name = "WalkSpeed",
    Range = {16,120},
    Increment = 1,
    CurrentValue = 16,

    Callback = function(v)

        WalkSpeed = v

        local hum = Humanoid()

        if hum then
            hum.WalkSpeed = v
        end
    end
})

---------------------------------------------------
-- JUMPPOWER
---------------------------------------------------

PlayerTab:CreateSlider({

    Name = "JumpPower",
    Range = {50,150},
    Increment = 1,
    CurrentValue = 50,

    Callback = function(v)

        JumpPower = v

        local hum = Humanoid()

        if hum then
            hum.JumpPower = v
        end
    end
})

---------------------------------------------------
-- APPLY AFTER RESPAWN
---------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    local hum = Humanoid()

    if hum then
        hum.WalkSpeed = WalkSpeed
        hum.JumpPower = JumpPower
    end
end)

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

UIS.JumpRequest:Connect(function()

    if InfiniteJump then

        local hum = Humanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:CreateToggle({

    Name = "Infinite Jump",
    CurrentValue = false,

    Callback = function(v)
        InfiniteJump = v
    end
})

---------------------------------------------------
-- FLY
---------------------------------------------------

local BV
local BG
local FlyConnection

PlayerTab:CreateSlider({

    Name = "Fly Speed",
    Range = {20,150},
    Increment = 5,
    CurrentValue = 60,

    Callback = function(v)
        FlySpeed = v
    end
})

PlayerTab:CreateToggle({

    Name = "Fly",
    CurrentValue = false,

    Callback = function(v)

        Fly = v

        local hrp = Root()

        if not hrp then return end

        if not Fly then

            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end

            if BV then
                BV:Destroy()
                BV = nil
            end

            if BG then
                BG:Destroy()
                BG = nil
            end

            return
        end

        BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Velocity = Vector3.zero
        BV.Parent = hrp

        BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BG.P = 10000
        BG.CFrame = workspace.CurrentCamera.CFrame
        BG.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()

            if not Fly then return end

            local hum = Humanoid()

            if not hum then return end

            local cam = workspace.CurrentCamera
            local moveDir = hum.MoveDirection

            BV.Velocity = Vector3.new(
                moveDir.X * FlySpeed,
                0,
                moveDir.Z * FlySpeed
            )

            BG.CFrame = cam.CFrame
        end)
    end
})

---------------------------------------------------
-- NOCLIP
---------------------------------------------------

RunService.Stepped:Connect(function()

    if Noclip then

        local char = Character()

        for _,v in ipairs(char:GetDescendants()) do

            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

PlayerTab:CreateToggle({

    Name = "Noclip",
    CurrentValue = false,

    Callback = function(v)
        Noclip = v
    end
})

---------------------------------------------------
-- PLAYER ESP
---------------------------------------------------

local ESPEnabled = false
local ESPStorage = {}

local function ClearESP()

    for _,v in pairs(ESPStorage) do

        if v then
            v:Destroy()
        end
    end

    ESPStorage = {}
end

local function AddESP(plr)

    if not ESPEnabled then return end
    if plr == LocalPlayer then return end

    local function Apply()

        local char = plr.Character

        if not char then return end

        if char:FindFirstChild("NDOT_ESP") then
            return
        end

        local h = Instance.new("Highlight")

        h.Name = "NDOT_ESP"
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = char

        table.insert(ESPStorage, h)
    end

    Apply()

    plr.CharacterAdded:Connect(function()

        task.wait(1)
        Apply()
    end)
end

VisualTab:CreateToggle({

    Name = "ESP Player",
    CurrentValue = false,

    Callback = function(v)

        ESPEnabled = v

        ClearESP()

        if v then

            for _,plr in ipairs(Players:GetPlayers()) do
                AddESP(plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(plr)

    if ESPEnabled then
        AddESP(plr)
    end
end)

---------------------------------------------------
-- FULLBRIGHT
---------------------------------------------------

VisualTab:CreateToggle({

    Name = "FullBright",
    CurrentValue = false,

    Callback = function(v)

        if v then

            Lighting.Brightness = 5
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false

        else

            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
        end
    end
})

---------------------------------------------------
-- FPS BOOST
---------------------------------------------------

UtilityTab:CreateToggle({

    Name = "FPS Boost",
    CurrentValue = false,

    Callback = function(v)

        if v then

            for _,obj in ipairs(workspace:GetDescendants()) do

                pcall(function()

                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.Plastic
                        obj.Reflectance = 0
                    end

                    if obj:IsA("Texture")
                    or obj:IsA("Decal") then

                        obj.Transparency = 1
                    end
                end)
            end

            if typeof(setfpscap) == "function" then
                pcall(function()
                    setfpscap(30)
                end)
            end

        else

            warn("Rejoin game untuk restore graphics")
        end
    end
})

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------

LocalPlayer.Idled:Connect(function()

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

---------------------------------------------------
-- AVATAR COPIER
---------------------------------------------------

local AvatarLoop = false
local SelectedPlayer = nil
local PlayerList = {}

local function RefreshPlayers()

    PlayerList = {}

    for _,plr in ipairs(Players:GetPlayers()) do

        if plr ~= LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
end

RefreshPlayers()

Players.PlayerAdded:Connect(function()
    RefreshPlayers()
end)

Players.PlayerRemoving:Connect(function()
    RefreshPlayers()
end)

AvatarTab:CreateDropdown({

    Name = "Select Player",
    Options = PlayerList,
    CurrentOption = {},

    Callback = function(v)

        if typeof(v) == "table" then
            v = v[1]
        end

        SelectedPlayer = Players:FindFirstChild(v)
    end
})

local function CopyAvatar(target)

    if not target then return end
    if not target.Character then return end

    local myChar = Character()
    local targetChar = target.Character

    for _,v in ipairs(myChar:GetChildren()) do

        if v:IsA("Shirt")
        or v:IsA("Pants")
        or v:IsA("Accessory") then

            v:Destroy()
        end
    end

    for _,v in ipairs(targetChar:GetChildren()) do

        if v:IsA("Shirt")
        or v:IsA("Pants")
        or v:IsA("Accessory") then

            local clone = v:Clone()
            clone.Parent = myChar
        end
    end
end

AvatarTab:CreateButton({

    Name = "Copy Once",

    Callback = function()

        if SelectedPlayer then
            CopyAvatar(SelectedPlayer)
        end
    end
})

AvatarTab:CreateToggle({

    Name = "Realtime Avatar Copy",
    CurrentValue = false,

    Callback = function(v)

        AvatarLoop = v

        if AvatarLoop then

            task.spawn(function()

                while AvatarLoop do

                    pcall(function()

                        if SelectedPlayer then
                            CopyAvatar(SelectedPlayer)
                        end
                    end)

                    task.wait(2)
                end
            end)
        end
    end
})

---------------------------------------------------
-- SERVER
---------------------------------------------------

ServerTab:CreateButton({

    Name = "Copy JobId",

    Callback = function()

        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})

ServerTab:CreateButton({

    Name = "Rejoin",

    Callback = function()

        TeleportService:Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end
})

ServerTab:CreateButton({

    Name = "Reset Character",

    Callback = function()

        local hum = Humanoid()

        if hum then
            hum.Health = 0
        end
    end
})

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

Rayfield:Notify({

    Title = "NDOT_BRNDL",
    Content = "Loaded Successfully",
    Duration = 6,
    Image = 4483362458
})
