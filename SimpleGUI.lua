local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

TextButton.Parent = Frame
TextButton.Size = UDim2.new(0,200,0,50)
TextButton.Position = UDim2.new(0.5,-100,0.5,-25)
TextButton.Text = "Klik Saya"

TextButton.MouseButton1Click:Connect(function()
    print("Tombol ditekan")
end)