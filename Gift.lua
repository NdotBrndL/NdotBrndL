--==================================================
-- NDOT HAT SYSTEM
-- Owner: 10857881986
-- SERVER-SIDE VERSION
--==================================================

local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")

local OWNER_USER_ID = 10857881986

local ADMINS = {
	[OWNER_USER_ID] = true,
}

----------------------------------------------------
-- ADMIN CHECK
----------------------------------------------------

local function isAdmin(player)
	return ADMINS[player.UserId] == true
end

----------------------------------------------------
-- FIND PLAYER
----------------------------------------------------

local function findPlayer(text)
	if not text then
		return nil
	end

	text = string.lower(text)

	-- Username exact
	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == text then
			return player
		end
	end

	-- DisplayName exact
	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.DisplayName) == text then
			return player
		end
	end

	-- Username partial
	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(player.Name), 1, #text) == text then
			return player
		end
	end

	return nil
end

----------------------------------------------------
-- REMOVE HAT
----------------------------------------------------

local function removeHats(player)
	if not player.Character then
		return
	end

	for _, item in ipairs(player.Character:GetChildren()) do
		if item:IsA("Accessory") then
			if item.AccessoryType == Enum.AccessoryType.Hat then
				item:Destroy()
			end
		end
	end
end

----------------------------------------------------
-- GIVE HAT
----------------------------------------------------

local function giveHat(player, assetId)

	if not player.Character then
		return false, "Character belum siap."
	end

	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return false, "Humanoid tidak ditemukan."
	end

	assetId = tonumber(assetId)

	if not assetId then
		return false, "Asset ID tidak valid."
	end

	local success, model = pcall(function()
		return InsertService:LoadAsset(assetId)
	end)

	if not success or not model then
		return false, "Tidak bisa memuat asset."
	end

	local accessory

	for _, item in ipairs(model:GetDescendants()) do
		if item:IsA("Accessory") then
			accessory = item
			break
		end
	end

	if not accessory then
		model:Destroy()
		return false, "Asset bukan Accessory."
	end

	local newAccessory = accessory:Clone()

	model:Destroy()

	local successAdd, errorMessage = pcall(function()
		humanoid:AddAccessory(newAccessory)
	end)

	if not successAdd then
		newAccessory:Destroy()
		return false, errorMessage
	end

	return true, "Hat berhasil dipasang."
end

----------------------------------------------------
-- COMMAND HANDLER
----------------------------------------------------

local function handleCommand(player, message)

	if not isAdmin(player) then
		return
	end

	local args = string.split(message, " ")
	local command = string.lower(args[1] or "")

	------------------------------------------------
	-- /hat PLAYER ASSETID
	------------------------------------------------

	if command == "/hat" then

		local targetName = args[2]
		local assetId = args[3]

		if not targetName or not assetId then
			warn("Format: /hat PlayerName AssetID")
			return
		end

		local target = findPlayer(targetName)

		if not target then
			warn("Player tidak ditemukan:", targetName)
			return
		end

		local success, result = giveHat(
			target,
			assetId
		)

		if success then
			print(
				"[HAT] Berhasil:",
				target.Name,
				assetId
			)
		else
			warn(
				"[HAT] Gagal:",
				result
			)
		end

	------------------------------------------------
	-- /unhat PLAYER
	------------------------------------------------

	elseif command == "/unhat" then

		local targetName = args[2]

		if not targetName then
			warn("Format: /unhat PlayerName")
			return
		end

		local target = findPlayer(targetName)

		if not target then
			warn("Player tidak ditemukan.")
			return
		end

		removeHats(target)

		print(
			"[HAT] Hat dihapus:",
			target.Name
		)

	------------------------------------------------
	-- /hatall ASSETID
	------------------------------------------------

	elseif command == "/hatall" then

		local assetId = args[2]

		if not assetId then
			warn("Format: /hatall AssetID")
			return
		end

		for _, target in ipairs(Players:GetPlayers()) do
			giveHat(target, assetId)
		end

		print(
			"[HAT] Hat diberikan ke semua pemain:",
			assetId
		)

	------------------------------------------------
	-- /unhatall
	------------------------------------------------

	elseif command == "/unhatall" then

		for _, target in ipairs(Players:GetPlayers()) do
			removeHats(target)
		end

		print("[HAT] Semua hat dihapus.")

	------------------------------------------------
	-- /hathelp
	------------------------------------------------

	elseif command == "/hathelp" then

		print("================================")
		print("       NDOT HAT ADMIN")
		print("================================")
		print("/hat PlayerName AssetID")
		print("/unhat PlayerName")
		print("/hatall AssetID")
		print("/unhatall")
		print("/hathelp")
		print("================================")

	end
end

----------------------------------------------------
-- PLAYER SETUP
----------------------------------------------------

local function setupPlayer(player)

	player.Chatted:Connect(function(message)
		handleCommand(player, message)
	end)

end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

print("================================")
print("NDOT HAT SYSTEM AKTIF")
print("OWNER:", OWNER_USER_ID)
print("================================")
