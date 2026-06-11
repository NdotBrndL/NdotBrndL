local player = game.Players.LocalPlayer
local humanoid = player.Character or player.CharacterAdded:Wait()

humanoid = humanoid:WaitForChild("Humanoid")
humanoid.UseJumpPower = true
humanoid.JumpPower = 120
