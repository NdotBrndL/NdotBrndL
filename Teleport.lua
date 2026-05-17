local pad = script.Parent
local tujuan = workspace.Tujuan

pad.Touched:Connect(function(hit)
    local character = hit.Parent
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart then
        humanoidRootPart.CFrame = tujuan.CFrame + Vector3.new(0,5,0)
    end
end)