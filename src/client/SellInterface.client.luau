local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local SellPlace = Workspace:WaitForChild("SellPlace")

local function Interface(Player) end

ProximityPromptService.Triggered:Connect(Interface)
