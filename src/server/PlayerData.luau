local PlayerData = {}
PlayerData.data = {}
PlayerData.loadOk = {}
--Récupération des prix des items grace a Config.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
--Récupération de la variable pour l'enregistrement des données
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("PlayerData", "v1")

local function playerInit(player)
	local playerUserID = player.UserId

	PlayerData.loadOk[playerUserID] = false

	local function setLoad() --Load des donné joeur
		return DataStore:GetAsync(tostring(playerUserID))
	end

	local succes, snapshot = pcall(setLoad)

	if succes then
		PlayerData.loadOk[playerUserID] = true
		if snapshot ~= nil then --Vérification que la sauvegarde existe
			PlayerData.data[playerUserID] = snapshot
			return
		end
	else
		local retry = 0
		while not succes and retry < 2 do
			succes, snapshot = pcall(setLoad)
			retry = retry + 1
			task.wait(1)
			if succes then
				PlayerData.loadOk[playerUserID] = true
				if snapshot ~= nil then --Vérification que la sauvegarde existe
					PlayerData.data[playerUserID] = snapshot
					return
				end
			end
		end
		warn("Information loading failed please try realoading the game")
	end

	if PlayerData.data[playerUserID] == nil then
		PlayerData.data[playerUserID] = {
			coin = 0,
			Inv = {},
		}
	end
end

--Quand un joueur réucpère un item
local function addItems(player, itemsName)
	local playerUserID = player.UserId
	if PlayerData.data[playerUserID].Inv[itemsName] == nil then
		PlayerData.data[playerUserID].Inv[itemsName] = 0
	end
	PlayerData.data[playerUserID].Inv[itemsName] = PlayerData.data[playerUserID].Inv[itemsName] + 1
end

--Quand un joueur vend un item
local function sellItems(player, itemsName)
	local playerUserID = player.UserId
	if not Config.itemsPrice[itemsName] then
		warn("Unknow items", itemsName)
		return
	elseif PlayerData.data[playerUserID].Inv[itemsName] == nil or PlayerData.data[playerUserID].Inv[itemsName] == 0 then
		return "The Player does not have enough items to sell"
	end
	PlayerData.data[playerUserID].Inv[itemsName] = PlayerData.data[playerUserID].Inv[itemsName] - 1
	PlayerData.data[playerUserID].coin = PlayerData.data[playerUserID].coin + Config.itemsPrice[itemsName]
	return "Item sold successfully"
end

--Table et Fonctrion de sauvegarde lorsque le joueur quitte le jeux
local function playerLeft(player)
	local playerUserID = player.UserId
	if PlayerData.data[playerUserID] == nil or not PlayerData.loadOk[playerUserID] then
		return
	end --Vérification que l'inventaire du joueur existe

	local function setSave() --Save des données joueur
		return DataStore:SetAsync(tostring(playerUserID), PlayerData.data[playerUserID])
	end

	local succes, _ = pcall(setSave)

	if succes then
		PlayerData.loadOk[playerUserID] = nil
		PlayerData.data[playerUserID] = nil --Netoyagge des tables enregistrer
	else
		local retry = 0
		while not succes and retry < 2 do
			succes, _ = pcall(setSave)
			retry = retry + 1
			task.wait(1)
			if succes then
				PlayerData.data[playerUserID] = nil
				PlayerData.loadOk[playerUserID] = nil
			end
		end
		warn("Save failed")
	end
end

--Ajout des fonctions a la table PlayerData pour utilisation externe
PlayerData.func = {}
PlayerData.func.playerInit = playerInit
PlayerData.func.addItems = addItems
PlayerData.func.sellItems = sellItems
PlayerData.func.playerLeft = playerLeft

return PlayerData
