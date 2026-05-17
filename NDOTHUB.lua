--// NDOT HUB SAFE UNIVERSAL V2
--// Android + PC
--// Delta / Hydrogen / Codex Support
--// Stable Universal Edition

repeat task.wait() until game:IsLoaded()

---------------------------------------------------
-- LOAD UI LIBRARY
---------------------------------------------------

local Rayfield

local urls = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/shlexware/Rayfield/main/source"
}

for _,url in ipairs(urls) do

    local ok = pcall(function()
        Rayfield = loadstring(game:HttpGet(url))()
    end)

    if ok and Rayfield then
        break
    end
end

if not Rayfield then
    warn("UI gagal dimuat")
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
    return char:FindFirstChildWhichIsA("Humanoid")
end

local function Root()
    local char = Character()
    return char:FindFirstChild("HumanoidRootPart")
end

---------------------------------------------------
-- WINDOW
---------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB SAFE V2",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Universal Stable Edition",

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
-- PLAYER VALUES
---------------------------------------------------

local WalkSpeed = 16
local JumpPower = 50
local InfiniteJump = false
local Noclip = false
local Fly = false

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

local FlyConnection

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,

    Callback = function(v)

        Fly = v

        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end

        if Fly then

            FlyConnection = RunService.RenderStepped:Connect(function()

                local hrp = Root()

                if hrp then
                    hrp.Velocity = Vector3.new(0,35,0)
                end
            end)
        end
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
-- AVATAR COPIER
---------------------------------------------------

local AvatarLoop = false
local SelectedPlayer = nil

local AvatarTab = Window:CreateTab("Avatar", 4483362458)

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

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

AvatarTab:CreateDropdown({

    Name = "Select Player",
    Options = PlayerList,
    CurrentOption = nil,

    Callback = function(v)

        SelectedPlayer = Players:FindFirstChild(v)
    end
})

local function CopyAvatar(target)

    if not target then return end
    if not target.Character then return end

    local myChar = Character()
    local targetChar = target.Character

    ---------------------------------------------------
    -- REMOVE OLD
    ---------------------------------------------------

    for _,v in ipairs(myChar:GetChildren()) do

        if v:IsA("Shirt")
        or v:IsA("Pants")
        or v:IsA("Accessory") then

            v:Destroy()
        end
    end

    ---------------------------------------------------
    -- COPY NEW
    ---------------------------------------------------

    for _,v in ipairs(targetChar:GetChildren()) do

        if v:IsA("Shirt")
        or v:IsA("Pants")
        or v:IsA("Accessory") then

            local clone = v:Clone()
            clone.Parent = myChar
        end
    end
end

---------------------------------------------------
-- COPY ONCE
---------------------------------------------------

AvatarTab:CreateButton({

    Name = "Copy Once",

    Callback = function()

        if SelectedPlayer then
            CopyAvatar(SelectedPlayer)
        end
    end
})

---------------------------------------------------
-- REALTIME COPY
---------------------------------------------------

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

        table.insert(ESPStorage,h)
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

VisualTab:CreateButton({
    Name = "FullBright",

    Callback = function()

        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
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

                if v:IsA("Texture")
                or v:IsA("Decal") then

                    v.Transparency = 1
                end
            end)
        end

        pcall(function()
            setfpscap(30)
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
-- COPY JOB ID
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Copy JobId",

    Callback = function()

        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})

---------------------------------------------------
-- REJOIN
---------------------------------------------------

ServerTab:CreateButton({
    Name = "Rejoin",

    Callback = function()

        TeleportService:Teleport(
            game.PlaceId,
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

        local hum = Humanoid()

        if hum then
            hum.Health = 0
        end
    end
})

---------------------------------------------------
-- NOTIFY
---------------------------------------------------

Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "Loaded Successfully",
    Duration = 6,
    Image = 4483362458
})
