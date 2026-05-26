--[[
███╗   ██╗██████╗  ██████╗ ████████╗
████╗  ██║██╔══██╗██╔═══██╗╚══██╔══╝
██╔██╗ ██║██║  ██║██║   ██║   ██║
██║╚██╗██║██║  ██║██║   ██║   ██║
██║ ╚████║██████╔╝╚██████╔╝   ██║
╚═╝  ╚═══╝╚═════╝  ╚═════╝    ╚═╝

        
]]--
        NDOT_BRNDL ADMIN HUB
        Android + PC
        Delta / Hydrogen / Codex / Fluxus
        Mobile + PC Support
        Optimized Stable Edition
]]

repeat task.wait() until game:IsLoaded()

---------------------------------------------------
-- SAFE LOAD RAYFIELD
---------------------------------------------------

local Rayfield
local Success = false

local Sources = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
}

for _,url in ipairs(Sources) do
    local ok,lib = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if ok and lib then
        Rayfield = lib
        Success = true
        break
    end
end

if not Success then
    warn("Rayfield gagal dimuat")
    return
end

---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------
-- CHARACTER FUNCTIONS
---------------------------------------------------

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local Char = GetCharacter()
    return Char:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
    local Char = GetCharacter()
    return Char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- VALUES
---------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 60

local InfiniteJump = false
local Noclip = false
local Fly = false
local ESPEnabled = false
local JumpPowerEnabled = false

---------------------------------------------------
-- GOD MODE
---------------------------------------------------

local GodMode = false
local GodConnection

local function EnableGod()

    GodMode = true

    local Hum = GetHumanoid()

    if Hum then

        Hum.MaxHealth = math.huge
        Hum.Health = math.huge

        if GodConnection then
            GodConnection:Disconnect()
        end

        GodConnection = Hum.HealthChanged:Connect(function()

            if GodMode and Hum.Health < Hum.MaxHealth then
                Hum.Health = Hum.MaxHealth
            end
        end)
    end
end

local function DisableGod()

    GodMode = false

    local Hum = GetHumanoid()

    if Hum then

        if GodConnection then
            GodConnection:Disconnect()
            GodConnection = nil
        end

        Hum.MaxHealth = 100
        Hum.Health = 100
    end
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB SAFE V3",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Universal Edition",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NDOT_HUB",
        FileName = "SAFE_CONFIG"
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

---------------------------------------------------
-- APPLY PLAYER STATS
---------------------------------------------------

local function ApplyStats()

    local Hum = GetHumanoid()

    if Hum then

        Hum.WalkSpeed = WalkSpeed
        Hum.UseJumpPower = true

        if JumpPowerEnabled then
            Hum.JumpPower = JumpPower
        else
            Hum.JumpPower = 50
        end
    end
end

---------------------------------------------------
-- RESPAWN FIX
---------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    ApplyStats()

    if GodMode then
        EnableGod()
    end
end)

---------------------------------------------------
-- WALKSPEED
---------------------------------------------------

local DefaultSpeed = 16
local BoostSpeed = 80

PlayerTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,

    Callback = function(State)

        local Hum = Humanoid()

        if not Hum then
            return
        end

        if State then
            Hum.WalkSpeed = BoostSpeed
        else
            Hum.WalkSpeed = DefaultSpeed
        end
    end
})

---------------------------------------------------
-- JUMP POWER
---------------------------------------------------

local DefaultJump = 50
local BoostJump = 140

PlayerTab:CreateToggle({
    Name = "Jump Power",
    CurrentValue = false,

    Callback = function(State)

        local Hum = Humanoid()

        if not Hum then
            return
        end

        Hum.UseJumpPower = true

        if State then
            Hum.JumpPower = BoostJump
        else
            Hum.JumpPower = DefaultJump
        end
    end
})

---------------------------------------------------
-- GOD MODE TOGGLE
---------------------------------------------------

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,

    Callback = function(v)

        if v then
            EnableGod()

            Rayfield:Notify({
                Title = "NDOT HUB",
                Content = "God Mode Enabled",
                Duration = 3
            })

        else
            DisableGod()

            Rayfield:Notify({
                Title = "NDOT HUB",
                Content = "God Mode Disabled",
                Duration = 3
            })
        end
    end
})

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

UIS.JumpRequest:Connect(function()

    if InfiniteJump then

        local Hum = GetHumanoid()

        if Hum then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
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
-- FLY SYSTEM
---------------------------------------------------

local Fly = false
local FlySpeed = 60

local BodyVelocity
local BodyGyro
local FlyConnection

local function StopFly()

    Fly = false

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
end

PlayerTab:CreateToggle({
    Name = "Mobile Fly",
    CurrentValue = false,

    Callback = function(State)

        Fly = State

        if not State then
            StopFly()
            return
        end

        local HRP = Root()

        if not HRP then
            return
        end

        local Hum = Humanoid()

        if not Hum then
            return
        end

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = HRP

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 10000
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        BodyGyro.Parent = HRP

        FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()

            if not Fly then
                return
            end

            local MoveDirection = Hum.MoveDirection
            local Camera = workspace.CurrentCamera

            if MoveDirection.Magnitude > 0 then

                -- Arah sesuai joystick mobile
                local Direction =
                    (Camera.CFrame.LookVector * MoveDirection.Z)
                    + (Camera.CFrame.RightVector * MoveDirection.X)

                -- Geser atas = naik
                Direction = Direction + Vector3.new(0, MoveDirection.Z * -1, 0)

                BodyVelocity.Velocity = Direction * FlySpeed

            else
                BodyVelocity.Velocity = Vector3.zero
            end

            BodyGyro.CFrame = Camera.CFrame
        end)
    end
})

---------------------------------------------------
-- NOCLIP
---------------------------------------------------

RunService.Stepped:Connect(function()

    if Noclip then

        local Char = GetCharacter()

        for _,Part in ipairs(Char:GetDescendants()) do

            if Part:IsA("BasePart") then
                Part.CanCollide = false
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
-- ESP
---------------------------------------------------

local function CreateESP(Player)

    if Player == LocalPlayer then return end

    local function Add()

        if not ESPEnabled then return end

        local Char = Player.Character
        if not Char then return end

        if Char:FindFirstChild("NDOT_ESP") then
            return
        end

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "NDOT_ESP"
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = Char
    end

    Add()

    Player.CharacterAdded:Connect(function()
        task.wait(1)
        Add()
    end)
end

VisualTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,

    Callback = function(v)

        ESPEnabled = v

        for _,Plr in ipairs(Players:GetPlayers()) do

            if Plr.Character and Plr.Character:FindFirstChild("NDOT_ESP") then
                Plr.Character.NDOT_ESP:Destroy()
            end
        end

        if v then
            for _,Plr in ipairs(Players:GetPlayers()) do
                CreateESP(Plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(CreateESP)

---------------------------------------------------
-- FULLBRIGHT
---------------------------------------------------

VisualTab:CreateButton({
    Name = "FullBright",

    Callback = function()

        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end
})

---------------------------------------------------
-- FPS BOOST
---------------------------------------------------

UtilityTab:CreateButton({
    Name = "FPS Boost",

    Callback = function()

        for _,v in ipairs(workspace:GetDescendants()) do

            pcall(function()

                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end

                if v:IsA("Decal")
                or v:IsA("Texture") then
                    v.Transparency = 1
                end

                if v:IsA("ParticleEmitter")
                or v:IsA("Trail") then
                    v.Enabled = false
                end
            end)
        end

        pcall(function()
            if setfpscap then
                setfpscap(30)
            end
        end)
    end
})

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------

pcall(function()

    LocalPlayer.Idled:Connect(function()

        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

---------------------------------------------------
-- COPY JOBID
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Copy JobId",

    Callback = function()

        if setclipboard then

            setclipboard(game.JobId)

            Rayfield:Notify({
                Title = "Copied",
                Content = "JobId copied",
                Duration = 3
            })
        end
    end
})

---------------------------------------------------
-- REJOIN
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Rejoin",

    Callback = function()

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            LocalPlayer
        )
    end
})

---------------------------------------------------
-- RESET
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Reset Character",

    Callback = function()

        local Hum = GetHumanoid()

        if Hum then
            Hum.Health = 0
        end
    end
})

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "Loaded Successfully",
    Duration = 5,
    Image = 4483362458
})end

---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------
-- CHARACTER FUNCTIONS
---------------------------------------------------

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local Char = GetCharacter()
    return Char:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
    local Char = GetCharacter()
    return Char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- VALUES
---------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 60

local InfiniteJump = false
local Noclip = false
local Fly = false
local ESPEnabled = false
local JumpPowerEnabled = false

---------------------------------------------------
-- GOD MODE
---------------------------------------------------

local GodMode = false
local GodConnection

local function EnableGod()

    GodMode = true

    local Hum = GetHumanoid()

    if Hum then

        Hum.MaxHealth = math.huge
        Hum.Health = math.huge

        if GodConnection then
            GodConnection:Disconnect()
        end

        GodConnection = Hum.HealthChanged:Connect(function()

            if GodMode and Hum.Health < Hum.MaxHealth then
                Hum.Health = Hum.MaxHealth
            end
        end)
    end
end

local function DisableGod()

    GodMode = false

    local Hum = GetHumanoid()

    if Hum then

        if GodConnection then
            GodConnection:Disconnect()
            GodConnection = nil
        end

        Hum.MaxHealth = 100
        Hum.Health = 100
    end
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB SAFE V3",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Universal Edition",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NDOT_HUB",
        FileName = "SAFE_CONFIG"
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

---------------------------------------------------
-- APPLY PLAYER STATS
---------------------------------------------------

local function ApplyStats()

    local Hum = GetHumanoid()

    if Hum then

        Hum.WalkSpeed = WalkSpeed
        Hum.UseJumpPower = true

        if JumpPowerEnabled then
            Hum.JumpPower = JumpPower
        else
            Hum.JumpPower = 50
        end
    end
end

---------------------------------------------------
-- RESPAWN FIX
---------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    ApplyStats()

    if GodMode then
        EnableGod()
    end
end)

---------------------------------------------------
-- WALKSPEED
---------------------------------------------------

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,150},
    Increment = 1,
    CurrentValue = 16,

    Callback = function(v)
        WalkSpeed = v
        ApplyStats()
    end
})

---------------------------------------------------
-- JUMPPOWER
---------------------------------------------------

PlayerTab:CreateToggle({
    Name = "Enable JumpPower",
    CurrentValue = false,

    Callback = function(v)

        JumpPowerEnabled = v
        ApplyStats()
    end
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50,250},
    Increment = 5,
    CurrentValue = 50,

    Callback = function(v)

        JumpPower = v

        if JumpPowerEnabled then
            ApplyStats()
        end
    end
})

---------------------------------------------------
-- GOD MODE TOGGLE
---------------------------------------------------

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,

    Callback = function(v)

        if v then
            EnableGod()

            Rayfield:Notify({
                Title = "NDOT HUB",
                Content = "God Mode Enabled",
                Duration = 3
            })

        else
            DisableGod()

            Rayfield:Notify({
                Title = "NDOT HUB",
                Content = "God Mode Disabled",
                Duration = 3
            })
        end
    end
})

---------------------------------------------------
-- INFINITE JUMP
---------------------------------------------------

UIS.JumpRequest:Connect(function()

    if InfiniteJump then

        local Hum = GetHumanoid()

        if Hum then
            Hum:ChangeState(Enum.HumanoidStateType.Jumping)
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
-- FLY SYSTEM
---------------------------------------------------

local FlyConnection
local BodyVelocity
local BodyGyro

local function StopFly()

    Fly = false

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
end

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20,200},
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

        if not v then
            StopFly()
            return
        end

        local Root = GetRoot()

        if not Root then return end

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = Root

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
        BodyGyro.P = 10000
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        BodyGyro.Parent = Root

        FlyConnection = RunService.RenderStepped:Connect(function()

            if not Fly then return end

            local Hum = GetHumanoid()
            local Cam = workspace.CurrentCamera

            if not Hum or not Root then
                StopFly()
                return
            end

            local MoveDirection = Hum.MoveDirection

            BodyVelocity.Velocity =
                ((Cam.CFrame.LookVector * MoveDirection.Z)
                + (Cam.CFrame.RightVector * MoveDirection.X))
                * FlySpeed

            BodyGyro.CFrame = Cam.CFrame
        end)
    end
})

---------------------------------------------------
-- NOCLIP
---------------------------------------------------

RunService.Stepped:Connect(function()

    if Noclip then

        local Char = GetCharacter()

        for _,Part in ipairs(Char:GetDescendants()) do

            if Part:IsA("BasePart") then
                Part.CanCollide = false
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
-- ESP
---------------------------------------------------

local function CreateESP(Player)

    if Player == LocalPlayer then return end

    local function Add()

        if not ESPEnabled then return end

        local Char = Player.Character
        if not Char then return end

        if Char:FindFirstChild("NDOT_ESP") then
            return
        end

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "NDOT_ESP"
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = Char
    end

    Add()

    Player.CharacterAdded:Connect(function()
        task.wait(1)
        Add()
    end)
end

VisualTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,

    Callback = function(v)

        ESPEnabled = v

        for _,Plr in ipairs(Players:GetPlayers()) do

            if Plr.Character and Plr.Character:FindFirstChild("NDOT_ESP") then
                Plr.Character.NDOT_ESP:Destroy()
            end
        end

        if v then
            for _,Plr in ipairs(Players:GetPlayers()) do
                CreateESP(Plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(CreateESP)

---------------------------------------------------
-- FULLBRIGHT
---------------------------------------------------

VisualTab:CreateButton({
    Name = "FullBright",

    Callback = function()

        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end
})

---------------------------------------------------
-- FPS BOOST
---------------------------------------------------

UtilityTab:CreateButton({
    Name = "FPS Boost",

    Callback = function()

        for _,v in ipairs(workspace:GetDescendants()) do

            pcall(function()

                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end

                if v:IsA("Decal")
                or v:IsA("Texture") then
                    v.Transparency = 1
                end

                if v:IsA("ParticleEmitter")
                or v:IsA("Trail") then
                    v.Enabled = false
                end
            end)
        end

        pcall(function()
            if setfpscap then
                setfpscap(30)
            end
        end)
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
-- COPY JOBID
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Copy JobId",

    Callback = function()

        if setclipboard then

            setclipboard(game.JobId)

            Rayfield:Notify({
                Title = "Copied",
                Content = "JobId copied",
                Duration = 3
            })
        end
    end
})

---------------------------------------------------
-- REJOIN
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Rejoin",

    Callback = function()

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            LocalPlayer
        )
    end
})

---------------------------------------------------
-- RESET
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Reset Character",

    Callback = function()

        local Hum = GetHumanoid()

        if Hum then
            Hum.Health = 0
        end
    end
})

---------------------------------------------------
-- NOTIFICATION
---------------------------------------------------

Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "Loaded Successfully",
    Duration = 5,
    Image = 4483362458
})
