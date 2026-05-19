--[[
 ███╗   ██╗██████╗  ██████╗ ████████╗
 ████╗  ██║██╔══██╗██╔═══██╗╚══██╔══╝
 ██╔██╗ ██║██║  ██║██║   ██║   ██║
 ██║╚██╗██║██║  ██║██║   ██║   ██║
 ██║ ╚████║██████╔╝╚██████╔╝   ██║
 ╚═╝  ╚═══╝╚═════╝  ╚═════╝    ╚═╝

        NDOT_BRNDL ADMIN HUB
        Delta / Hydrogen / Fluxus
        Mobile + PC Support
]]

repeat task.wait() until game:IsLoaded()

---------------------------------------------------
-- SERVICES
---------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer

---------------------------------------------------
-- SAFE CHARACTER
---------------------------------------------------

local function Char()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function HRP()
    return Char():WaitForChild("HumanoidRootPart")
end

local function Hum()
    return Char():WaitForChild("Humanoid")
end

---------------------------------------------------
-- NOTIFY
---------------------------------------------------

local function Notify(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title = "NDOT_BRNDL",
            Text = tostring(txt),
            Duration = 4
        })
    end)
end

Notify("NDOT_BRNDL Loaded")

---------------------------------------------------
-- PREFIX
---------------------------------------------------

local Prefix = ";"

---------------------------------------------------
-- COMMAND LIST
---------------------------------------------------

local HelpText = [[

========== NDOT_BRNDL ==========
;help
;speed NUMBER
;jump NUMBER
;ws default
;jp default
;fly
;unfly
;noclip
;clip
;sit
;unsit
;reset
;rejoin
;to PLAYER
;spin
;unspin
;float
;unfloat
;invis
;visible
;hipheight NUMBER
;god
;ungod
;cmds

================================

]]

print(HelpText)

---------------------------------------------------
-- VARIABLES
---------------------------------------------------

getgenv().NDOT_FLY = false
getgenv().NDOT_NOCLIP = false
getgenv().NDOT_SPIN = false
getgenv().NDOT_FLOAT = false

local FlyBV
local FlyBG
local SpinConn

---------------------------------------------------
-- FLY SYSTEM
---------------------------------------------------

local function StartFly()

    if getgenv().NDOT_FLY then
        return
    end

    getgenv().NDOT_FLY = true

    local hrp = HRP()

    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    FlyBV.Velocity = Vector3.zero
    FlyBV.Parent = hrp

    FlyBG = Instance.new("BodyGyro")
    FlyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    FlyBG.CFrame = hrp.CFrame
    FlyBG.Parent = hrp

    task.spawn(function()

        while getgenv().NDOT_FLY do
            task.wait()

            local cam = workspace.CurrentCamera
            local move = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move += cam.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move -= cam.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move -= cam.CFrame.RightVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move += cam.CFrame.RightVector
            end

            FlyBV.Velocity = move * 80
            FlyBG.CFrame = cam.CFrame
        end

    end)

    Notify("Fly Enabled")
end

local function StopFly()

    getgenv().NDOT_FLY = false

    if FlyBV then
        FlyBV:Destroy()
    end

    if FlyBG then
        FlyBG:Destroy()
    end

    Notify("Fly Disabled")
end

---------------------------------------------------
-- NOCLIP LOOP
---------------------------------------------------

RunService.Stepped:Connect(function()

    if getgenv().NDOT_NOCLIP then

        for _,v in pairs(Char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

    end

end)

---------------------------------------------------
-- SPIN
---------------------------------------------------

local function StartSpin()

    if SpinConn then
        SpinConn:Disconnect()
    end

    getgenv().NDOT_SPIN = true

    SpinConn = RunService.RenderStepped:Connect(function()

        if getgenv().NDOT_SPIN then
            HRP().CFrame *= CFrame.Angles(0, math.rad(25), 0)
        end

    end)

    Notify("Spin Enabled")
end

local function StopSpin()

    getgenv().NDOT_SPIN = false

    if SpinConn then
        SpinConn:Disconnect()
    end

    Notify("Spin Disabled")
end

---------------------------------------------------
-- FLOAT
---------------------------------------------------

local FloatPart

local function StartFloat()

    if FloatPart then
        FloatPart:Destroy()
    end

    FloatPart = Instance.new("Part")
    FloatPart.Size = Vector3.new(6,1,6)
    FloatPart.Transparency = 1
    FloatPart.Anchored = true
    FloatPart.Parent = workspace

    getgenv().NDOT_FLOAT = true

    task.spawn(function()

        while getgenv().NDOT_FLOAT do
            task.wait()

            FloatPart.Position =
                HRP().Position - Vector3.new(0,3.5,0)

        end

    end)

    Notify("Float Enabled")
end

local function StopFloat()

    getgenv().NDOT_FLOAT = false

    if FloatPart then
        FloatPart:Destroy()
    end

    Notify("Float Disabled")
end

---------------------------------------------------
-- INVIS
---------------------------------------------------

local function Invis()

    for _,v in pairs(Char():GetDescendants()) do

        if v:IsA("BasePart") then

            if v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1
            end

        end

    end

    Notify("Invisible")
end

local function Visible()

    for _,v in pairs(Char():GetDescendants()) do

        if v:IsA("BasePart") then
            v.Transparency = 0
        end

    end

    Notify("Visible")
end

---------------------------------------------------
-- CHAT COMMANDS
---------------------------------------------------

LP.Chatted:Connect(function(msg)

    local args = msg:split(" ")
    local cmd = args[1]:lower()

    ---------------------------------------------------
    -- HELP
    ---------------------------------------------------

    if cmd == Prefix.."help" or cmd == Prefix.."cmds" then
        print(HelpText)
        Notify("Commands Printed")
    end

    ---------------------------------------------------
    -- SPEED
    ---------------------------------------------------

    if cmd == Prefix.."speed" then

        local n = tonumber(args[2])

        if n then
            Hum().WalkSpeed = n
            Notify("Speed "..n)
        end

    end

    ---------------------------------------------------
    -- JUMP
    ---------------------------------------------------

    if cmd == Prefix.."jump" then

        local n = tonumber(args[2])

        if n then
            Hum().JumpPower = n
            Notify("Jump "..n)
        end

    end

    ---------------------------------------------------
    -- DEFAULTS
    ---------------------------------------------------

    if cmd == Prefix.."ws" and args[2] == "default" then
        Hum().WalkSpeed = 16
        Notify("Default WalkSpeed")
    end

    if cmd == Prefix.."jp" and args[2] == "default" then
        Hum().JumpPower = 50
        Notify("Default JumpPower")
    end

    ---------------------------------------------------
    -- FLY
    ---------------------------------------------------

    if cmd == Prefix.."fly" then
        StartFly()
    end

    if cmd == Prefix.."unfly" then
        StopFly()
    end

    ---------------------------------------------------
    -- NOCLIP
    ---------------------------------------------------

    if cmd == Prefix.."noclip" then
        getgenv().NDOT_NOCLIP = true
        Notify("Noclip Enabled")
    end

    if cmd == Prefix.."clip" then
        getgenv().NDOT_NOCLIP = false
        Notify("Noclip Disabled")
    end

    ---------------------------------------------------
    -- SIT
    ---------------------------------------------------

    if cmd == Prefix.."sit" then
        Hum().Sit = true
    end

    if cmd == Prefix.."unsit" then
        Hum().Sit = false
    end

    ---------------------------------------------------
    -- RESET
    ---------------------------------------------------

    if cmd == Prefix.."reset" then
        Hum().Health = 0
    end

    ---------------------------------------------------
    -- REJOIN
    ---------------------------------------------------

    if cmd == Prefix.."rejoin" then
        TeleportService:Teleport(game.PlaceId, LP)
    end

    ---------------------------------------------------
    -- TELEPORT
    ---------------------------------------------------

    if cmd == Prefix.."to" then

        local target = args[2]

        if target then

            for _,plr in pairs(Players:GetPlayers()) do

                if plr.Name:lower():sub(1,#target)
                    == target:lower() then

                    if plr.Character and
                       plr.Character:FindFirstChild("HumanoidRootPart") then

                        HRP().CFrame =
                            plr.Character.HumanoidRootPart.CFrame
                            + Vector3.new(2,0,0)

                        Notify("Teleported")

                    end

                end

            end

        end

    end

    ---------------------------------------------------
    -- SPIN
    ---------------------------------------------------

    if cmd == Prefix.."spin" then
        StartSpin()
    end

    if cmd == Prefix.."unspin" then
        StopSpin()
    end

    ---------------------------------------------------
    -- FLOAT
    ---------------------------------------------------

    if cmd == Prefix.."float" then
        StartFloat()
    end

    if cmd == Prefix.."unfloat" then
        StopFloat()
    end

    ---------------------------------------------------
    -- INVIS
    ---------------------------------------------------

    if cmd == Prefix.."invis" then
        Invis()
    end

    if cmd == Prefix.."visible" then
        Visible()
    end

    ---------------------------------------------------
    -- HIPHEIGHT
    ---------------------------------------------------

    if cmd == Prefix.."hipheight" then

        local n = tonumber(args[2])

        if n then
            Hum().HipHeight = n
            Notify("HipHeight "..n)
        end

    end

    ---------------------------------------------------
    -- GOD MODE
    ---------------------------------------------------

    if cmd == Prefix.."god" then

        Hum().MaxHealth = math.huge
        Hum().Health = math.huge

        Notify("God Mode")
    end

    if cmd == Prefix.."ungod" then

        Hum().MaxHealth = 100
        Hum().Health = 100

        Notify("Ungod")
    end

end)

---------------------------------------------------
-- FINAL
---------------------------------------------------

Notify("Prefix : "..Prefix)
print("NDOT_BRNDL FULL ADMIN LOADED")