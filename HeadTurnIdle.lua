-- Character components
local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")
local head = char:WaitForChild("Head")
local hrp = char:WaitForChild("HumanoidRootPart")
local torso = char:WaitForChild("Torso")

-- Idle animation
local idleAnim = humanoid:LoadAnimation(script:WaitForChild("idle"))
idleAnim.Looped = true
idleAnim:Play()

-- Makes sure that the head is connected to the torso
local neck = head:FindFirstChild("Neck") or Instance.new("Motor6D", torso)
neck.Name = "Neck"
neck.Part0 = torso
neck.Part1 = head
neck.C0 = CFrame.new(0, 0.5, 0)

-- Original neck position offsets
local xOffSet, yOffSet, zOffSet = neck.C0.X, neck.C0.Y, neck.C0.Z

-- Gets the closest player
local function getClosestPlayerHrp(maxDist)
	local closestHrp, closestDist = nil, maxDist

	for _, player in pairs(game.Players:GetPlayers()) do
		local character = player.Character
		local tmpHrp = character and character:FindFirstChild("HumanoidRootPart")

		if tmpHrp then
			local distance = (tmpHrp.Position - hrp.Position).Magnitude
			if distance < closestDist then
				closestHrp, closestDist = tmpHrp, distance
			end
		end
	end

	return closestHrp
end

-- Neck rotation
while wait() do
	local targetHrp = getClosestPlayerHrp(50)
	if targetHrp then
		local direction = (targetHrp.Position - hrp.Position).Unit
		local ht = hrp.Position.Y - targetHrp.Position.Y
		local dist = (targetHrp.Position - hrp.Position).Magnitude
		local upAngle = math.atan(ht / dist)

		local vecA = Vector2.new(hrp.CFrame.LookVector.X, hrp.CFrame.LookVector.Z)
		local vecB = Vector2.new(direction.X, direction.Z)
		local angle = math.atan2(vecA:Cross(vecB), vecA:Dot(vecB))
		angle = math.clamp(angle, -math.pi / 3, math.pi / 3)

		neck.C0 = CFrame.new(xOffSet, yOffSet + 1, zOffSet) * CFrame.Angles(0, -angle, 0) * CFrame.Angles(-upAngle, 0, 0)
	end
end