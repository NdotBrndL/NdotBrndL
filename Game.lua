local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-------------------------------------------------
-- SETTINGS
-------------------------------------------------

local NORMAL_SPEED = 16
local BOOST_SPEED = 50

local NORMAL_JUMP = 50
local BOOST_JUMP = 120

local godEnabled = false
local speedEnabled = false
local jumpEnabled = false
local tpEnabled = false
local aimEnabled = false
local damageEnabled = false

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "TestingGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0,240,0,340)
main.Position = UDim2.new(0.05,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "TESTING GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = main

-------------------------------------------------
-- BUTTON FUNCTION
-------------------------------------------------

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,200,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 16
	btn.Text = text
	btn.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,8)
	c.Parent = btn

	return btn
end

-------------------------------------------------
-- GOD MODE
-------------------------------------------------

local godBtn = createButton("GOD : OFF")

godBtn.MouseButton1Click:Connect(function()
	godEnabled = not godEnabled

	if godEnabled then
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge
		godBtn.Text = "GOD : ON"
	else
		humanoid.MaxHealth = 100
		humanoid.Health = 100
		godBtn.Text = "GOD : OFF"
	end
end)

-------------------------------------------------
-- DAMAGE BOOST
-------------------------------------------------

local damageBtn = createButton("Damage++ : OFF")

damageBtn.MouseButton1Click:Connect(function()
	damageEnabled = not damageEnabled

	if damageEnabled then
		damageBtn.Text = "Damage++ : ON"
		print("Damage boost enabled")
	else
		damageBtn.Text = "Damage++ : OFF"
	end
end)

-------------------------------------------------
-- TELEPORT
-------------------------------------------------

local tpBtn = createButton("Teleport : OFF")

tpBtn.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled

	if tpEnabled then
		tpBtn.Text = "Teleport : ON"
		hrp.CFrame = hrp.CFrame + Vector3.new(0,0,-50)
	else
		tpBtn.Text = "Teleport : OFF"
	end
end)

-------------------------------------------------
-- AUTO AIM
-------------------------------------------------

local aimBtn = createButton("Auto AIM : OFF")

local aimConnection

local function getClosestPlayer()
	local closest
	local distance = math.huge

	for _,v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local mag = (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

			if mag < distance then
				distance = mag
				closest = v
			end
		end
	end

	return closest
end

aimBtn.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled

	if aimEnabled then
		aimBtn.Text = "Auto AIM : ON"

		aimConnection = RunService.RenderStepped:Connect(function()
			local target = getClosestPlayer()

			if target and target.Character then
				local enemyHRP = target.Character:FindFirstChild("HumanoidRootPart")

				if enemyHRP then
					workspace.CurrentCamera.CFrame = CFrame.new(
						workspace.CurrentCamera.CFrame.Position,
						enemyHRP.Position
					)
				end
			end
		end)
	else
		aimBtn.Text = "Auto AIM : OFF"

		if aimConnection then
			aimConnection:Disconnect()
		end
	end
end)

-------------------------------------------------
-- JUMP POWER
-------------------------------------------------

local jumpBtn = createButton("JumpPower : OFF")

jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled

	if jumpEnabled then
		humanoid.JumpPower = BOOST_JUMP
		jumpBtn.Text = "JumpPower : ON"
	else
		humanoid.JumpPower = NORMAL_JUMP
		jumpBtn.Text = "JumpPower : OFF"
	end
end)

-------------------------------------------------
-- WALKSPEED
-------------------------------------------------

local speedBtn = createButton("WalkSpeed : OFF")

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	if speedEnabled then
		humanoid.WalkSpeed = BOOST_SPEED
		speedBtn.Text = "WalkSpeed : ON"
	else
		humanoid.WalkSpeed = NORMAL_SPEED
		speedBtn.Text = "WalkSpeed : OFF"
	end
end)

-------------------------------------------------
-- OPEN / CLOSE
-------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,60,0,35)
toggle.Position = UDim2.new(0,10,0.1,0)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Text = "OPEN"
toggle.Parent = gui

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0,8)
tc.Parent = toggle

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible

	if main.Visible then
		toggle.Text = "CLOSE"
	else
		toggle.Text = "OPEN"
	end
end)
