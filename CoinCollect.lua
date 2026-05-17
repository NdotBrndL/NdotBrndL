local coin = script.Parent

coin.Touched:Connect(function(hit)
    local player = game.Players:GetPlayerFromCharacter(hit.Parent)

    if player then
        local stats = player:FindFirstChild("leaderstats")

        if stats then
            stats.Coins.Value = stats.Coins.Value + 1
        end

        coin:Destroy()
    end
end)