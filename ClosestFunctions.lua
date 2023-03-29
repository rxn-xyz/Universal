-- Functions
local Functions = {}
-- Player Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
-- Character Variables
local HRP = Character.HumanoidRootPart or Character:WaitForChild("HumanoidRootPart")
-- Get Player Closest To Mouse
function Functions.PlayerClosestToMouse()
	print("WIP")
end
-- Get Player Closest To Character
function Functions.PlayerClosestToCharacter(MaxDistance)
	local Closest; local Magnitude; local Distance = MaxDistance
	for _, Player in Players:GetPlayers() do if Player == LocalPlayer then continue end
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
			Magnitude = (HRP.Position - Player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if Distance > Magnitude then Distance = Magnitude; Closest = Player.Character end
		end
	end
	return Closest
end
-- Return
return Functions
