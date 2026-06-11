local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDOT_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,320,0,260)
Main.Position = UDim2.new(0.5,-160,0.5,-130)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(60,60,60)

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "NDOT HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(180,40,40)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close)

local Minimize = Instance.new("TextButton")
Minimize.Parent = Main
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-70,0,5)
Minimize.Text = "-"
Minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
Minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Minimize)

local function CreateButton(text,y)
	local Btn = Instance.new("TextButton")
	Btn.Parent = Main
	Btn.Size = UDim2.new(0.85,0,0,40)
	Btn.Position = UDim2.new(0.075,0,0,y)
	Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Btn.TextColor3 = Color3.new(1,1,1)
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 14
	Btn.Text = text
	Instance.new("UICorner", Btn)
	return Btn
end

local JumpBtn = CreateButton("Jump Power: OFF",60)
local AntiAfkBtn = CreateButton("Anti AFK: OFF",110)

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Parent = Main
FPSLabel.Size = UDim2.new(0.85,0,0,35)
FPSLabel.Position = UDim2.new(0.075,0,0,170)
FPSLabel.BackgroundColor3 = Color3.fromRGB(40,40,40)
FPSLabel.TextColor3 = Color3.new(1,1,1)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 14
FPSLabel.Text = "FPS: 0"
Instance.new("UICorner", FPSLabel)

local jumpEnabled = false
local antiAfkEnabled = false

JumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled

	local Char = Player.Character
	if Char and Char:FindFirstChild("Humanoid") then
		Char.Humanoid.JumpPower = jumpEnabled and 100 or 50
	end

	JumpBtn.Text = jumpEnabled and "Jump Power: ON" or "Jump Power: OFF"
end)

AntiAfkBtn.MouseButton1Click:Connect(function()
	antiAfkEnabled = not antiAfkEnabled
	AntiAfkBtn.Text = antiAfkEnabled and "Anti AFK: ON" or "Anti AFK: OFF"
end)

Player.Idled:Connect(function()
	if antiAfkEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

local Frames = 0
local Last = tick()

RunService.RenderStepped:Connect(function()
	Frames += 1

	if tick() - Last >= 1 then
		FPSLabel.Text = "FPS: "..Frames
		Frames = 0
		Last = tick()
	end
end)

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	for _,v in ipairs(Main:GetChildren()) do
		if v ~= Title and v ~= Close and v ~= Minimize then
			v.Visible = not Minimized
		end
	end

	Main.Size = Minimized
		and UDim2.new(0,320,0,45)
		or UDim2.new(0,320,0,260)
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local Dragging = false
local DragStart
local StartPos

Title.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
	or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPos = Main.Position
	end
end)

Title.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
	or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Dragging and (
		Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch
	) then

		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + Delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + Delta.Y
		)
	end
end)
