local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local jumpin
local HR = Character.HumanoidRootPart
local VirtualInputManager = game:GetService("VirtualInputManager")

local minerals = game:GetService("Workspace").worldResources.mineable

local function setOreFarming(value)
    Player:SetAttribute("farmingOre", value)
end

local function getOre(oreName)
    local ores = {}
    
    for i,v in pairs(minerals:GetDescendants()) do
        if v.Name == oreName and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
            table.insert(ores, v)
        end
    end
    
    
    table.sort(ores, function(t1, t2) 
		return Player:DistanceFromCharacter(t1.PrimaryPart.Position) < Player:DistanceFromCharacter(t2.PrimaryPart.Position) end)
	return ores
        
end

local function walkTo(pos)
    Humanoid:MoveTo(pos)
    Humanoid.MoveToFinished:wait()
end

local function autoJump()
	    local check1 = workspace:FindPartOnRay(Ray.new(Humanoid.RootPart.Position-Vector3.new(0,1.5,0), Humanoid.RootPart.CFrame.lookVector*3), Humanoid.Parent)
	    local check2 = workspace:FindPartOnRay(Ray.new(Humanoid.RootPart.Position+Vector3.new(0,1.5,0), Humanoid.RootPart.CFrame.lookVector*3), Humanoid.Parent)
	    if (check1 or check2) and Player:GetAttribute("farmingOre") == true then
	    	HR.CFrame = CFrame.new(HR.Position + Vector3.new(0,140,0))
	    end
end

local function clickScreen()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function moveToOre(ore)
    local X,Y,Z = HR.Position.X, HR.Position.Y, HR.Position.Z
    local X2,Y2,Z2 = ore.PrimaryPart.Position.X, ore.PrimaryPart.Position.Y, ore.PrimaryPart.Position.Z
    if X2 >= X-7 and X2 <= X+7 and Z2 >= Z-7 and Z2 <= Z+7 then
        jumpin:Disconnect()
        HR.CFrame = CFrame.new(ore.PrimaryPart.Position)
        task.wait()
        repeat clickScreen() HR.CFrame = CFrame.new(ore.PrimaryPart.Position) until ore.PrimaryPart.Transparency == 1 or Player:GetAttribute("farmingOre") == false
    end
    jumpin = game:GetService('RunService').Stepped:Connect(autoJump)
end

local function startFarmingOre(ore) -- Iron Ore, Gold Vein
    setOreFarming(true)
    jumpin = game:GetService('RunService').Stepped:Connect(autoJump)
    while Player:GetAttribute("farmingOre") and wait() do
        local ores = getOre(ore)
        for i,v in pairs(ores) do
            moveToOre(v)
            
            walkTo(v.PrimaryPart.Position)
        
        break
        end
    end
end

local function stopFarmingOre() -- some reason this isnt working
    setOreFarming(false)
    if jumpin then
        jumpin:Disconnect()
    end
end

return {
    startFarmingOre = startFarmingOre,
    stopFarmingOre = stopFarmingOre
}
