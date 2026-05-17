local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "NDOT HUB",
    LoadingTitle = "NDOT HUB",
    LoadingSubtitle = "Universal Roblox Script",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NDOTHUB",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

-- SPEED
Tab:CreateToggle({
    Name = "Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if Value then
            humanoid.WalkSpeed = 50
        else
            humanoid.WalkSpeed = 16
        end
    end,
})

-- HIGH JUMP
Tab:CreateToggle({
    Name = "High Jump",
    CurrentValue = false,
    Flag = "JumpToggle",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if Value then
            humanoid.JumpPower = 120
        else
            humanoid.JumpPower = 50
        end
    end,
})

-- INFINITE JUMP
local InfiniteJumpEnabled = false

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local player = game.Players.LocalPlayer
        local character = player.Character

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end,
})

-- FLY
local bodyVelocity

Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        if Value then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
            bodyVelocity.Velocity = Vector3.new(0,50,0)
            bodyVelocity.Parent = hrp
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end,
})

-- ESP PLAYER
local espObjects = {}

Tab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)

        if Value then
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local h = Instance.new("Highlight")
                    h.Parent = plr.Character
                    table.insert(espObjects, h)
                end
            end
        else
            for _,v in pairs(espObjects) do
                v:Destroy()
            end

            espObjects = {}
        end
    end,
})

-- CLONE AVATAR
Tab:CreateButton({
    Name = "Clone Avatar",
    Callback = function()

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local clone = character:Clone()
        clone.Parent = workspace

        clone:SetPrimaryPartCFrame(
            character.PrimaryPart.CFrame * CFrame.new(5,0,0)
        )

    end,
})

-- NOTIFICATION
Rayfield:Notify({
    Title = "NDOT HUB",
    Content = "Script berhasil dimuat",
    Duration = 5,
    Image = 4483362458,
})