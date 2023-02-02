local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local HR = Character.HumanoidRootPart
local VirtualInputManager = game:GetService("VirtualInputManager")
local autoJumpDebounce = false
local autoJumping = false
local checkHealth
local checkFood

local minerals = game:GetService("Workspace").worldResources.mineable

local function setOreFarming(value)
    Player:SetAttribute("farmingOre", value)
end

local function getOre(oreName)
    local ores = {}
    
    
    if oreName == "all" then
        for i,v in pairs(minerals:GetDescendants()) do
            if v:FindFirstChildWhichIsA("MeshPart") and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
                table.insert(ores, v)
            end
        end
    else
        for i,v in pairs(minerals:GetDescendants()) do
            if v.Name == oreName and v:FindFirstChildWhichIsA("MeshPart") and v.PrimaryPart and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
                table.insert(ores, v)
            end
        end
    end
    
    table.sort(ores, function(t1, t2) 
		return Player:DistanceFromCharacter(t1.PrimaryPart.Position) < Player:DistanceFromCharacter(t2.PrimaryPart.Position) end)
	return ores
        
end

local function walkTo(pos)
    Humanoid:MoveTo(pos)
end

local function autoJump()
    autoJumping = true
    while autoJumping do
        if autoJumpDebounce == false then
            autoJumpDebounce = true
            local check1 = workspace:FindPartOnRay(Ray.new(Humanoid.RootPart.Position-Vector3.new(0,1.5,0), Humanoid.RootPart.CFrame.lookVector*3), Humanoid.Parent)
            local check2 = workspace:FindPartOnRay(Ray.new(Humanoid.RootPart.Position+Vector3.new(0,1.5,0), Humanoid.RootPart.CFrame.lookVector*3), Humanoid.Parent)
            if (check1 or check2) and Player:GetAttribute("farmingOre") == true then
                HR.CFrame = CFrame.new(HR.Position + Vector3.new(0,140,0))
            end
            task.wait(0.7)
            autoJumpDebounce = false
        end
        task.wait()
    end
    return
end

local function findTool(tool)
    local toolToEquip
    
    for i,v in pairs(Player.Backpack:GetChildren()) do
        if v:FindFirstChild("toolModel") and v.toolModel:FindFirstChildWhichIsA("MeshPart").Name:find(tool) then
            toolToEquip = v
        end
    end
    
    return toolToEquip
end

local function equipTool(tool)
    local mesh = Character:FindFirstChildWhichIsA("Tool")
    if mesh and mesh:FindFirstChild("toolModel") and mesh.toolModel:FindFirstChildWhichIsA("MeshPart") and mesh.toolModel:FindFirstChildWhichIsA("MeshPart").Name:find(tool) then
        return
    else
        if mesh then
            mesh.Parent = Player.Backpack
        end
        local toolToEquip = findTool(tool) or Character:FindFirstChildWhichIsA("Tool")
        toolToEquip.Parent = Character
    end
end

local function clickScreen()
    equipTool("Pickaxe")
    VirtualInputManager:SendMouseButtonEvent(0, 500, 0, true, game, 1)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 500, 0, false, game, 1)
end

local function collectDrops(position)
    local drops = game.Workspace.droppedItems:GetChildren()
    for i,v in pairs(drops) do
        if (v.Position - position).Magnitude < 30 then
            HR.CFrame = v.CFrame
            task.wait(0.1)
        end
    end
end

local function moveToOre(ore)
    local X,Y,Z = HR.Position.X, HR.Position.Y, HR.Position.Z
    local X2,Y2,Z2 = ore.PrimaryPart.Position.X, ore.PrimaryPart.Position.Y, ore.PrimaryPart.Position.Z
    if X2 >= X-7 and X2 <= X+7 and Z2 >= Z-7 and Z2 <= Z+7 then
        autoJumping = false
        HR.CFrame = CFrame.new(ore.PrimaryPart.Position)
        task.wait()
        repeat
            clickScreen() 
            HR.CFrame = CFrame.new(ore.PrimaryPart.Position) 
        until ore.PrimaryPart.Transparency == 1 or Player:GetAttribute("farmingOre") == false
    end
    
    collectDrops(ore.PrimaryPart.Position)
    
    task.spawn(autoJump)
end

local function stopFarmingOre()
    setOreFarming(false)
    autoJumpDebounce = false
    autoJumping = false
end

local function startFarmingOre(ore) -- Iron Ore, Gold Vein
    setOreFarming(true)
    task.spawn(autoJump)
    while Player:GetAttribute("farmingOre") and wait() do
        
        checkHealth(ore)
        checkFood()
        
        local ores = getOre(ore)
        for i,v in pairs(ores) do
            moveToOre(v)
            
            walkTo(v.PrimaryPart.Position)
        break
        end
    end
    return
end

local function clickSpawnButton()
    local spawnButton = Player.PlayerGui.Avatar.spawnButtons.spawn
    repeat wait() until spawnButton.Parent.Visible == true
    task.wait(1)
    firesignal(spawnButton.Activated)
end

local function hideGUIS()
    for i,v in pairs(Player.PlayerGui.Avatar:GetChildren()) do
        if (v:IsA("Frame") or v:IsA("ImageLabel")) and v.Visible == true then
            v.Visible = false
        end
    end
end

function checkHealth(ore)
    local healthBar = Player.PlayerGui.Main["status"].health.container.bar.stat.Text
    
    if healthBar:sub(0,1) == "0" then
        stopFarmingOre()
        
        clickSpawnButton()
    
        hideGUIS()
        
        repeat wait() until game.Players.LocalPlayer.Character
        Player = Players.LocalPlayer
        Character = Player.Character
        Humanoid = Character.Humanoid
        HR = Character.HumanoidRootPart
        
        startFarmingOre(ore)
    end
end

local function findFoodInBackpack()
    local backpack = Player.PlayerGui.Inventory.nonHotbar.menuContainer.inventory.frame.content.backpack
    
    for i,v in pairs(backpack:GetChildren()) do
        if v:IsA("ImageButton") and v:FindFirstChild("viewport") and v.viewport:FindFirstChild("stats") and v.viewport.stats:FindFirstChild("food") then
           return v.Name
        end 
    end
end

local function eatFood()
    local foodNumber = findFoodInBackpack()
    local args = {
    [1] = tonumber(foodNumber)
    }

    game:GetService("ReplicatedStorage"):WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("eat"):FireServer(unpack(args))
end

function checkFood()
    local foodBar = Player.PlayerGui.Main.status.hunger.container.bar.stat.Text
    if foodBar:sub(0,1) == "9" then
        for i = 1,2 do
            eatFood()
            task.wait(1)
        end
    end
end

return {
    startFarmingOre = startFarmingOre,
    stopFarmingOre = stopFarmingOre
}
