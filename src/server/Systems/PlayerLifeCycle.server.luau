local ServerScriptService = game:GetService("ServerScriptService")
local PlayerData = require(ServerScriptService.Server.PlayerData)
local Players = game:GetService("Players")

local function characterSpawing(character)
	local Humanoid = character:WaitForChild("Humanoid")
	--Faire les modif pour pouvoir courrir dans le jeux
	Humanoid.WalkSpeed = 20
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(characterSpawing)
	--Load la sauvegarde quand le joeur rejoint
	PlayerData.func.playerInit(player)
end

local function onPlayerRemoving(player)
	--Ajouter le la sauvegarde lorsque le joeur quitte
	PlayerData.func.playerLeft(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
