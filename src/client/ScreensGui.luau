local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--Ajouts des packets React Lua pour création UI
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local function InvotoryUI()
    Player = Players.LocalPlayer
    PlayerGui = Player.WaitForChild("PlayerGui")
    local container = Instance.new("ScreenGui")
    container.Name = "Inventaire"
    container.
end