local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

--Permet de récup le dossier Pickups
local pickupsFolder = workspace:WaitForChild("Pickups")

--Permet de récupérer la liste d'objet dans Pickups
local pickups = pickupsFolder:GetChildren()

--Récupération des objet récupérable
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

--Récupération des fonction de gestion d'inventaire
local ServerScritpService = game:GetService("ServerScriptService")
local PlayerData = require(ServerScritpService.Server.PlayerData)

--fonction qui permet de connecter tous les parts de Pickups avec .Touched
local function TouchObject(pickupPart)
	pickupPart.Touched:Connect(function(hitPart)
		local character = hitPart.Parent
		if not character then
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end

		local player = players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		local itemsPrice = Config.itemsPrice[pickupPart.Name]

		if not itemsPrice then
			warn("La part est incconue de Config", pickupPart.Name)
			return
		end

		print("Le Joeur a ramasser", pickupPart.Name, "valant", itemsPrice)
		PlayerData.func.addItems(player, pickupPart.Name)
		pickupPart:Destroy()
	end)
end

--Vérification si ce qui est dans Pickups est bien un élément du BasePart
for _, pickupPart in ipairs(pickups) do
	if pickupPart:IsA("BasePart") then
		TouchObject(pickupPart)
	end
end
