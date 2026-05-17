local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

UserInputService.JumpRequest:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)