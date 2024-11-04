-- BASIC VARIABLES
local player = game.Players.LocalPlayer
local character
local humanoid
local DetectPart = workspace.Scripts.UnderWater.Basic.Breathing.DetectPart -- Part that detects if a player is underwater
local YdetectPart = DetectPart.Position.Y -- Position of detect part

-- SETTING BASIC STATES
local airTime = 30 -- default time that player can spend in the water
local currentAirTime = airTime -- actual time of air
local isUnderwater = false -- if player is underwater

-- GUI
local WaterBreathGui
local FrontRoundFrame

-- Function to update references after respawn
local function initializeCharacterReferences()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")

	local playerGui = player:WaitForChild("PlayerGui")
	WaterBreathGui = playerGui:WaitForChild("WaterBreathGui")
	FrontRoundFrame = WaterBreathGui:WaitForChild("FrontroundFrame")
end

-- Function to update the air bar in the GUI
local function UpdateAirBar()
	local maxHeight = 209 -- full height of the bar in pixels
	local scale = currentAirTime / airTime
	local height = math.floor(scale * maxHeight)

	-- Set the size to decrease from top to bottom
	if typeof(FrontRoundFrame) == "Instance" and FrontRoundFrame:IsA("Frame") then
		FrontRoundFrame.Size = UDim2.new(0, 44, 0, height)
		FrontRoundFrame.Position = UDim2.new(0.953, 0, 0.229, maxHeight - height)
		print("Updated Air Bar Height:", height, "Frame Size:", FrontRoundFrame.Size)
	else
		warn("FrontRoundFrame not found or is not a Frame! Check your GUI setup.")
	end
end

-- Function to set the "CurrentAirTime"
function setAirTime(newAirTime)
	airTime = newAirTime
	currentAirTime = airTime
	UpdateAirBar()
end

-- Function to start player "breathing underwater" when they enter the water
local function startBreathing()
	isUnderwater = true
	currentAirTime = airTime -- reset air time
	print("Starting to breathe underwater")

	while isUnderwater and currentAirTime > 0 do
		wait(1)
		currentAirTime = currentAirTime - 1
		UpdateAirBar()
	end

	if currentAirTime <= 0 then
		humanoid.Health = 0 -- player will drown
	end
end

-- Function to stop player "breathing underwater" when they leave the water
local function stopBreathing()
	isUnderwater = false
	currentAirTime = airTime -- reset air time completely
	UpdateAirBar() -- reset GUI bar to full
	print("Stopped breathing underwater")
end

-- Check if player is underwater
game:GetService("RunService").RenderStepped:Connect(function()
	if character and character:FindFirstChild("HumanoidRootPart") then
		if character.HumanoidRootPart.Position.Y < YdetectPart then
			if not isUnderwater then
				startBreathing() -- start breathing underwater if player is underwater
			end
		else
			if isUnderwater then
				stopBreathing() -- stop breathing underwater if player is not underwater
			end
		end
	end
end)

-- Re-initialize on respawn
player.CharacterAdded:Connect(function()
	initializeCharacterReferences()
end)

-- Initial setup
initializeCharacterReferences()
