local Players = game:GetService("Players")
local PlayerUserID = Players.LocalPlayer.UserId

local ServerScriptSercive = game:GetService("ServerScriptService")
local PlayerData = require(ServerScriptSercive.Server.PlayerData)

local function UpdateGUI()
	local InvPlayer = PlayerData.data[PlayerUserID].Inv
end
