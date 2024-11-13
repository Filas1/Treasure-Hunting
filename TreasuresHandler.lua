-- BASIC VARIABLES
local player = game.Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")

-- TREASURE VARIABLES
local TreasuresFolder = workspace["Main Map"].WaterModels.Treasures

-- TREASURE VALUES
local TreasureValues = {
	AtlantidaGem = 7000,
	EmeraldGem = 10000,
	GoldenCoin = 250,
	GoldenRing = 500,
	HistoricalArtefact = 15000,
	OldAgeChronicle = 20000,
	OldAgeCompass = 3500,
	PearlNecklace = 2000,
	TreasureChest = 5000,
	Trophy = 1000
}

-- TREASURE LIST (Only Proximity Prompts)
local TreasurePrompts = {
	AtlantidaGem = TreasuresFolder:FindFirstChild("AtlantidaGem").Mesh.ProximityPrompt,
	EmeraldGem = TreasuresFolder:FindFirstChild("EmeraldGem").Mesh.ProximityPrompt,
	GoldenCoin = TreasuresFolder:FindFirstChild("GoldenCoin").Money.ProximityPrompt,
	GoldenRing = TreasuresFolder:FindFirstChild("GoldenRing")["Meshes/Ring1"].ProximityPrompt,
	HistoricalArtefact = TreasuresFolder:FindFirstChild("HistoricalArtefact").Mesh.ProximityPrompt,
	OldAgeChronicle = TreasuresFolder:FindFirstChild("OldAgeChronicle").MeshPart1.ProximityPrompt,
	OldAgeCompass = TreasuresFolder:FindFirstChild("OldAgeCompass").Part.ProximityPrompt,
	PearlNecklace = TreasuresFolder:FindFirstChild("PearlNecklace").Mesh.ProximityPrompt,
	TreasureChest = TreasuresFolder:FindFirstChild("TreasureChest").Union1.ProximityPrompt,
	Trophy = TreasuresFolder:FindFirstChild("Trophy").MeshPart.ProximityPrompt
}

-- Function to add money to the player's leaderstats
local function addMoneyToPlayer(player, amount)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local money = leaderstats:FindFirstChild("Money")
		if money then
			money.Value = money.Value + amount
			print("Added", amount, "to player's money. New balance:", money.Value)
		end
	end
end

-- Function to handle treasure interaction
local function setupTreasurePrompt(prompt, treasureName)
	prompt.Triggered:Connect(function(player)
		print("Prompt triggered for treasure:", treasureName, "by player:", player.Name)

		-- Find the value of the treasure
		local treasureValue = TreasureValues[treasureName]
		if treasureValue then
			print("Adding treasure value", treasureValue, "to player")
			addMoneyToPlayer(player, treasureValue)
			print("Treasure value", treasureValue, "added to player")

			-- Immediate removal of the prompt
			prompt.Enabled = false
			print("Prompt disabled for treasure:", treasureName)

			-- Gradual transparency effect on the treasure model
			local treasureModel = prompt.Parent.Parent -- Assuming ProximityPrompt is nested within the treasure model structure
			print("Starting fade-out for treasure:", treasureName)
			for transparency = 0, 1, 0.1 do
				for _, part in ipairs(treasureModel:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Transparency = transparency
					end
				end
				wait(0.3)
			end

			-- Finally, destroy the prompt and the treasure after fading out
			prompt:Destroy()
			print("Prompt destroyed for treasure:", treasureName)
			treasureModel:Destroy()
			print("Treasure destroyed:", treasureName)
		else
			print("Treasure value not found for", treasureName)
		end
	end)
end

-- Set up each treasure prompt
for treasureName, prompt in pairs(TreasurePrompts) do
	print("Setting up prompt for treasure:", treasureName)
	setupTreasurePrompt(prompt, treasureName)
end
