--// NDOT PROFILE COVER GUI
--// Android Executor Support
--// Drag + Open Close + Change Cover

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-------------------------------------------------
-- REMOVE OLD GUI
-------------------------------------------------

pcall(function()
    game.CoreGui:FindFirstChild("NDOTProfileGUI"):Destroy()
end)

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "NDOTProfileGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-------------------------------------------------
-- MAIN FRAME
-------------------------------------------------

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,320,0,420)
frame.Position = UDim2.new(0.5,-160,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.1

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,20)

local stroke = Instance.new("UIStroke")
stroke.Parent = frame
stroke.Color = Color3.fromRGB(80,80,80)
stroke.Thickness = 1.5

-------------------------------------------------
-- COVER IMAGE
-------------------------------------------------

local image = Instance.new("ImageLabel")
image.Parent = frame
image.Size = UDim2.new(1,0,0.75,0)
image.BackgroundTransparency = 1
image.ScaleType = Enum.ScaleType.Crop

Instance.new("UICorner",image).CornerRadius = UDim.new(0,20)

-------------------------------------------------
-- REMOVE OLD COVER
-------------------------------------------------

image.Image = ""
task.wait(0.1)

-------------------------------------------------
-- SET NEW COVER
-------------------------------------------------

local COVER_ID = "83696075180663"

image.Image = "rbxassetid://"..COVER_ID

-------------------------------------------------
-- DARK EFFECT
-------------------------------------------------

local dark = Instance.new("Frame")
dark.Parent = image
dark.Size = UDim2.new(1,0,1,0)
dark.BackgroundTransparency = 1

local grad = Instance.new("UIGradient")
grad.Parent = dark
grad.Rotation = 90
grad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(1,0.2)
}

-------------------------------------------------
-- DISPLAY NAME
-------------------------------------------------

local display = Instance.new("TextLabel")
display.Parent = frame
display.BackgroundTransparency = 1
display.Position = UDim2.new(0,20,0.78,0)
display.Size = UDim2.new(1,-40,0,40)
display.Font = Enum.Font.GothamBold
display.Text = player.DisplayName
display.TextColor3 = Color3.new(1,1,1)
display.TextSize = 30
display.TextXAlignment = Enum.TextXAlignment.Left

-------------------------------------------------
-- USERNAME
-------------------------------------------------

local username = Instance.new("TextLabel")
username.Parent = frame
username.BackgroundTransparency = 1
username.Position = UDim2.new(0,20,0.87,0)
username.Size = UDim2.new(1,-40,0,30)
username.Font = Enum.Font.Gotham
username.Text = "@ "..player.Name
username.TextColor3 = Color3.fromRGB(180,180,180)
username.TextSize = 22
username.TextXAlignment = Enum.TextXAlignment.Left

-------------------------------------------------
-- CLOSE BUTTON
-------------------------------------------------

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-45,0,10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 22
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(40,40,40)

Instance.new("UICorner",close).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-------------------------------------------------
-- OPEN BUTTON
-------------------------------------------------

local open = Instance.new("TextButton")
open.Parent = gui
open.Size = UDim2.new(0,50,0,50)
open.Position = UDim2.new(0,20,0.5,-25)
open.Text = "☰"
open.Font = Enum.Font.GothamBold
open.TextSize = 28
open.TextColor3 = Color3.new(1,1,1)
open.BackgroundColor3 = Color3.fromRGB(30,30,30)

Instance.new("UICorner",open).CornerRadius = UDim.new(1,0)

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-------------------------------------------------
-- DRAG SYSTEM MOBILE
-------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart

    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-------------------------------------------------
-- NOTIFICATION
-------------------------------------------------

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "NDOT PROFILE",
    Text = "Cover Loaded Successfully",
    Duration = 5
})
