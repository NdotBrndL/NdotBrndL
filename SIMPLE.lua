-- SIMPLE UNIVERSAL MENU
-- Jump Power + Anti AFK + God Mode

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.Text = "Simple Universal Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(45,45,45)

--------------------------------------------------
-- Jump Power
--------------------------------------------------

local jpEnabled = false
local jpButton = Instance.new("TextButton")

jpButton.Parent = frame
jpButton.Size = UDim2.new(0,180,0,35)
jpButton.Position = UDim2.new(0,20,0,45)
jpButton.Text = "Jump Power OFF"

jpButton.MouseButton1Click:Connect(function()
    jpEnabled = not jpEnabled

    if jpEnabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 120
        jpButton.Text = "Jump Power ON"
    else
        humanoid.JumpPower = 50
        jpButton.Text = "Jump Power OFF"
    end
end)

--------------------------------------------------
-- Anti AFK
--------------------------------------------------

local afkEnabled = false
local afkConnection

local afkButton = Instance.new("TextButton")
afkButton.Parent = frame
afkButton.Size = UDim2.new(0,180,0,35)
afkButton.Position = UDim2.new(0,20,0,90)
afkButton.Text = "Anti AFK OFF"

afkButton.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled

    if afkEnabled then
        afkConnection = player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)

        afkButton.Text = "Anti AFK ON"
    else
        if afkConnection then
            afkConnection:Disconnect()
        end

        afkButton.Text = "Anti AFK OFF"
    end
end)

--------------------------------------------------
-- God Mode
--------------------------------------------------

local godEnabled = false

local godButton = Instance.new("TextButton")
godButton.Parent = frame
godButton.Size = UDim2.new(0,180,0,35)
godButton.Position = UDim2.new(0,20,0,135)
godButton.Text = "God Mode OFF"

godButton.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled

    if godEnabled then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        godButton.Text = "God Mode ON"
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        godButton.Text = "God Mode OFF"
    end
end)

--------------------------------------------------
-- No Slide / Reset Character
--------------------------------------------------

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
end)
