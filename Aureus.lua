-- Aureus Main Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

--------------------------------------------------
-- Greeting Function
--------------------------------------------------

local function greet(name)
    print("Hello, " .. name .. "!")
end

greet(player.Name)

--------------------------------------------------
-- List Players
--------------------------------------------------

local function listPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        print(p.Name .. " | Team: " .. tostring(p.Team))
    end
end

--------------------------------------------------
-- Player Join / Leave
--------------------------------------------------

Players.PlayerAdded:Connect(function(p)
    print("[+] " .. p.Name .. " joined")
    greet(p.Name)
end)

Players.PlayerRemoving:Connect(function(p)
    print("[-] " .. p.Name .. " left")
end)

--------------------------------------------------
-- Simple Loop
--------------------------------------------------

local ticks = 0

local conn = RunService.Heartbeat:Connect(function()
    ticks += 1

    if ticks % 60 == 0 then
        print("Update Tick:", ticks)
    end
end)

--------------------------------------------------
-- Spawn Part
--------------------------------------------------

local function dropPart()
    local part = Instance.new("Part")

    part.Size = Vector3.new(5, 1, 5)
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Bright red")
    part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)

    part.Parent = Workspace
end

--------------------------------------------------
-- Execute
--------------------------------------------------

listPlayers()
dropPart()
