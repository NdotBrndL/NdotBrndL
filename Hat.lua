--==================================================
-- GLOBAL HAT ADMIN SYSTEM
-- Owner UserId: 10857881986
--==================================================

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local InsertService = game:GetService("InsertService")

--==================================================
-- CONFIG
--==================================================

local OWNER_USER_ID = 10857881986

local TOPIC = "GLOBAL_HAT_SYSTEM_V2"

-- Anti spam publish
local PUBLISH_COOLDOWN = 1

local lastPublish = {}

--==================================================
-- ADMIN CHECK
--==================================================

local ADMINS = {
	[OWNER_USER_ID] = true,
}

local function isAdmin(player)
	return ADMINS[player.UserId] == true
end

--==================================================
-- FIND PLAYER
--==================================================

local function findPlayer(name)
	if not name then
		return nil
	end

	name = string.lower(name)

	-- Exact username
	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == name then
			return player
		end
	end

	-- DisplayName
	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.DisplayName) == name then
			return player
		end
	end

	-- Partial username
	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(player.Name), 1, #name) == name then
			return player
		end
	end

	return nil
end

--==================================================
-- REMOVE HATS
--==================================================

local function removeHats(player)
	if not player.Character then
		return
	end

	for _, object in ipairs(player.Character:GetChildren()) do

		if object:IsA("Accessory") then

			if object.AccessoryType == Enum.AccessoryType.Hat
				or object.AccessoryType == Enum.AccessoryType.Hair
				or object.AccessoryType == Enum.AccessoryType.Face then

				object:Destroy()
			end
		end
	end
end

--==================================================
-- GIVE HAT
--==================================================

local function giveHat(player, assetId)

	if not player then
		return false, "Player tidak ditemukan."
	end

	if not player.Character then
		return false, "Character belum tersedia."
	end

	assetId = tonumber(assetId)

	if not assetId then
		return false, "Asset ID tidak valid."
	end

	local success, asset = pcall(function()
		return InsertService:LoadAsset(assetId)
	end)

	if not success or not asset then
		return false, "Gagal memuat asset " .. tostring(assetId)
	end

	local accessory

	for _, object in ipairs(asset:GetDescendants()) do

		if object:IsA("Accessory") then
			accessory = object
			break
		end

	end

	if not accessory then
		asset:Destroy()
		return false, "Asset tersebut bukan Accessory."
	end

	local clonedAccessory = accessory:Clone()

	asset:Destroy()

	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		clonedAccessory:Destroy()
		return false, "Humanoid tidak ditemukan."
	end

	clonedAccessory.Parent = player.Character

	return true, "Hat berhasil dipasang."
end

--==================================================
-- GLOBAL PUBLISH
--==================================================

local function publish(data)

	local now = os.clock()

	if lastPublish[data.Command] then

		if now - lastPublish[data.Command] < PUBLISH_COOLDOWN then
			return false, "Tunggu sebentar."
		end

	end

	lastPublish[data.Command] = now

	local success, errorMessage = pcall(function()

		MessagingService:PublishAsync(
			TOPIC,
			data
		)

	end)

	if not success then
		warn("[GLOBAL HAT] Publish Error:", errorMessage)
		return false, errorMessage
	end

	return true
end

--==================================================
-- EXECUTE GLOBAL COMMAND
--==================================================

local function executeGlobal(data)

	if typeof(data) ~= "table" then
		return
	end

	local command = data.Command

	--==============================================
	-- HAT
	--==============================================

	if command == "HAT" then

		local userId = tonumber(data.UserId)
		local assetId = tonumber(data.AssetId)

		if not userId or not assetId then
			return
		end

		local player = Players:GetPlayerByUserId(userId)

		if player then

			local success, message = giveHat(
				player,
				assetId
			)

			if not success then
				warn("[GLOBAL HAT]", message)
			end

		end

	--==============================================
	-- UNHAT
	--==============================================

	elseif command == "UNHAT" then

		local userId = tonumber(data.UserId)

		if not userId then
			return
		end

		local player = Players:GetPlayerByUserId(userId)

		if player then
			removeHats(player)
		end

	--==============================================
	-- HAT ALL
	--==============================================

	elseif command == "HATALL" then

		local assetId = tonumber(data.AssetId)

		if not assetId then
			return
		end

		for _, player in ipairs(Players:GetPlayers()) do

			giveHat(
				player,
				assetId
			)

		end

	--==============================================
	-- UNHAT ALL
	--==============================================

	elseif command == "UNHATALL" then

		for _, player in ipairs(Players:GetPlayers()) do
			removeHats(player)
		end

	end
end

--==================================================
-- MESSAGING SERVICE
--==================================================

local subscribeSuccess, subscribeResult = pcall(function()

	return MessagingService:SubscribeAsync(
		TOPIC,
		function(message)

			executeGlobal(message.Data)

		end
	)

end)

if not subscribeSuccess then

	warn(
		"[GLOBAL HAT] Subscribe gagal:",
		subscribeResult
	)

end

--==================================================
-- COMMAND HELP
--==================================================

local function showHelp(player)

	print("======================================")
	print(" GLOBAL HAT ADMIN")
	print("======================================")
	print("/hat PLAYER ASSETID")
	print("/unhat PLAYER")
	print("/hatall ASSETID")
	print("/unhatall")
	print("/hathelp")
	print("======================================")

end

--==================================================
-- CHAT COMMAND
--==================================================

local function setupPlayer(player)

	player.Chatted:Connect(function(message)

		if not isAdmin(player) then
			return
		end

		local args = string.split(
			message,
			" "
		)

		local command = string.lower(
			args[1] or ""
		)

		--==========================================
		-- HELP
		--==========================================

		if command == "/hathelp" then

			showHelp(player)

		--==========================================
		-- HAT
		--==========================================

		elseif command == "/hat" then

			local targetName = args[2]
			local assetId = tonumber(args[3])

			if not targetName or not assetId then

				warn(
					"Gunakan: /hat PlayerName AssetID"
				)

				return
			end

			local targetPlayer = findPlayer(
				targetName
			)

			if not targetPlayer then

				warn(
					"Player tidak ditemukan."
				)

				return
			end

			-- Server saat ini
			giveHat(
				targetPlayer,
				assetId
			)

			-- Semua server/place
			publish({

				Command = "HAT",

				UserId = targetPlayer.UserId,

				AssetId = assetId,

			})

		--==========================================
		-- UNHAT
		--==========================================

		elseif command == "/unhat" then

			local targetName = args[2]

			if not targetName then
				return
			end

			local targetPlayer = findPlayer(
				targetName
			)

			if not targetPlayer then

				warn(
					"Player tidak ditemukan."
				)

				return
			end

			removeHats(
				targetPlayer
			)

			publish({

				Command = "UNHAT",

				UserId = targetPlayer.UserId,

			})

		--==========================================
		-- HAT ALL
		--==========================================

		elseif command == "/hatall" then

			local assetId = tonumber(args[2])

			if not assetId then

				warn(
					"Gunakan: /hatall AssetID"
				)

				return
			end

			for _, targetPlayer in ipairs(
				Players:GetPlayers()
			) do

				giveHat(
					targetPlayer,
					assetId
				)

			end

			publish({

				Command = "HATALL",

				AssetId = assetId,

			})

		--==========================================
		-- UNHAT ALL
		--==========================================

		elseif command == "/unhatall" then

			for _, targetPlayer in ipairs(
				Players:GetPlayers()
			) do

				removeHats(
					targetPlayer
				)

			end

			publish({

				Command = "UNHATALL",

			})

		end

	end)

end

--==================================================
-- PLAYER ADDED
--==================================================

Players.PlayerAdded:Connect(
	setupPlayer
)

for _, player in ipairs(
	Players:GetPlayers()
) do

	setupPlayer(player)

end

print(
	"[GLOBAL HAT] System aktif. Owner:",
	OWNER_USER_ID
)
