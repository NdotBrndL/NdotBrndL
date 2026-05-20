-- SIMPLE UNIVERSAL MENU
-- Jump Power + Anti AFK + God Mode

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.Text = "Simple Universal Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(45,45,45)
title.TextScaled = true

--------------------------------------------------
-- TOGGLE BUTTON OPEN/CLOSE
--------------------------------------------------

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = gui
toggleButton.Size = UDim2.new(0,50,0,50)
toggleButton.Position = UDim2.new(0,10,0.5,-25)
toggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextScaled = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1,0)
toggleCorner.Parent = toggleButton

local menuOpen = true

toggleButton.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	frame.Visible = menuOpen
end)

--------------------------------------------------
-- Jump Power
--------------------------------------------------

local jpEnabled = false

local jpButton = Instance.new("TextButton")
jpButton.Parent = frame
jpButton.Size = UDim2.new(0,180,0,35)
jpButton.Position = UDim2.new(0,20,0,45)
jpButton.Text = "Jump Power OFF"

local jpCorner = Instance.new("UICorner")
jpCorner.Parent = jpButton

jpButton.MouseButton1Click:Connect(function()
	jpEnabled = not jpEnabled

	if jpEnabled then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 100
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

local afkCorner = Instance.new("UICorner")
afkCorner.Parent = afkButton

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

local godCorner = Instance.new("UICorner")
godCorner.Parent = godButton

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
-- Noclip
--------------------------------------------------

local noclipEnabled = false

local noclipButton = Instance.new("TextButton")
noclipButton.Parent = frame
noclipButton.Size = UDim2.new(0,180,0,35)
noclipButton.Position = UDim2.new(0,20,0,180)
noclipButton.Text = "Noclip OFF"

local noclipCorner = Instance.new("UICorner")
noclipCorner.Parent = noclipButton

-- Perbesar frame supaya tombol terlihat
frame.Size = UDim2.new(0,220,0,230)

game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled

	if noclipEnabled then
		noclipButton.Text = "Noclip ON"
	else
		noclipButton.Text = "Noclip OFF"

		-- Balikin collide normal
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

--------------------------------------------------
-- RESET CHARACTER
--------------------------------------------------

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
end)
