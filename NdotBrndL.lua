local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "👑₦đø₮฿ɽ₦đⱠ👑"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,100)
frame.Position = UDim2.new(0.5,-150,0.5,-50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "👑₦đø₮฿ɽ₦đⱠ👑"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.9,0,0,20)
barBg.Position = UDim2.new(0.05,0,0.65,0)
barBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
barBg.Parent = frame

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.Parent = barBg

for i = 1,100 do
	bar.Size = UDim2.new(i/100,0,1,0)
	task.wait(0.02)
end

frame:Destroy()

local main = Instance.new("Frame")
main.Size = UDim2.new(0,220,0,120)
main.Position = UDim2.new(0.5,-110,0.5,-60)
main.BackgroundColor3 = Color3.fromRGB(35,35,35)
main.Parent = gui

local UIS = game:GetService("UserInputService")

local speed = 1

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0,25)
label.Position = UDim2.new(0,0,0.15,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.Text = "AnimSpeed : 1.0x"
label.Parent = main

local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(0.8,0,0,8)
sliderBG.Position = UDim2.new(0.1,0,0.55,0)
sliderBG.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBG.Parent = main

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.125,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
fill.Parent = sliderBG

local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0,18,0,18)
knob.Position = UDim2.new(0.125,-9,0.5,-9)
knob.Text = ""
knob.Parent = sliderBG

local function ApplySpeed()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    for _,track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(speed)
    end
end

local dragging = false

knob.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)

    if dragging then

        local percent = math.clamp(
            (input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X,
            0,
            1
        )

        knob.Position = UDim2.new(percent,-9,0.5,-9)
        fill.Size = UDim2.new(percent,0,1,0)

        speed = math.floor((0.5 + percent * 4.5) * 10) / 10

        label.Text = "AnimSpeed : "..speed.."x"

        ApplySpeed()
    end
end)

-- Terapkan juga ke animasi yang baru dimainkan
local function HookCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    hum.AnimationPlayed:Connect(function(track)
        task.wait()
        track:AdjustSpeed(speed)
    end)
end

if player.Character then
    HookCharacter(player.Character)
end

player.CharacterAdded:Connect(HookCharacter)


---------------------------------------------------
-- OPEN / CLOSE BUTTON
---------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,50,0,50)
toggle.Position = UDim2.new(0,20,0.5,-25)
toggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextScaled = true
toggle.Text = "☰"
toggle.Parent = gui

local opened = true

toggle.MouseButton1Click:Connect(function()

	opened = not opened

	main.Visible = opened

	if opened then
		toggle.Text = "☰"
	else
		toggle.Text = "▶"
	end
end)

local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

toggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = toggle.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then

		local delta = input.Position - dragStart

		toggle.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
