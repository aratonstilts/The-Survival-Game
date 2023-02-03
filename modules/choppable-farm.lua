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

local choppables = game:GetService("Workspace").worldResources.choppable
local animals = game.Workspace.animals

local function setTreeFarming(value)
    Player:SetAttribute("farmingChoppable", value)
end

local function getTree(treeName)
    local trees = {}
    
    if treeName == "all" then
        for i,v in pairs(choppables:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
                table.insert(trees, v)
            end
        end
        
    elseif treeName == "foods" then
        local listOfFoods = {"Berry Bush", "Bush", "Mushroom", "Carrot", "Wheat", "Cabbages", "Peppers"}
        for i,v in pairs(choppables:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
                for i2,v2 in pairs(listOfFoods) do
                    if v.Name == v2 then
                        table.insert(trees, v)
                    end
                end
            end
        end
        for i,v in pairs(animals:GetChildren()) do
            if v:IsA("Model") then
                table.insert(trees, v)
            end
        end
        
    else
        for i,v in pairs(choppables:GetDescendants()) do
            if v:IsA("Model") and v.Name == treeName and v:FindFirstChildWhichIsA("MeshPart").Transparency == 0 then
                table.insert(trees, v)
            end
        end
    
    end
    
    
    table.sort(trees, function(t1, t2) 
		return Player:DistanceFromCharacter(t1.PrimaryPart.Position) < Player:DistanceFromCharacter(t2.PrimaryPart.Position) end)
	return trees
        
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
            if (check1 or check2) and Player:GetAttribute("farmingChoppable") == true then
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
        local toolToEquip = findTool(tool)
        toolToEquip.Parent = Character
    end
end

local function clickScreen()
    equipTool("Axe")
    VirtualInputManager:SendMouseButtonEvent(0, 500, 0, true, game, 1)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(0, 500, 0, false, game, 1)
end

local function collectDrops(position)
    local drops = game.Workspace.droppedItems:GetChildren()
    for i,v in pairs(drops) do
        if (v.Position - position).Magnitude < 50 then
            HR.CFrame = v.CFrame
            task.wait()
        end
    end
end

local function moveToTree(tree)
    local X,Y,Z = HR.Position.X, HR.Position.Y, HR.Position.Z
    local X2,Y2,Z2 = tree.PrimaryPart.Position.X, tree.PrimaryPart.Position.Y, tree.PrimaryPart.Position.Z
    if X2 >= X-7 and X2 <= X+7 and Z2 >= Z-7 and Z2 <= Z+7 then
        autoJumping = false
        HR.CFrame = CFrame.new(tree.PrimaryPart.Position)
        task.wait()
        repeat
            clickScreen() 
            HR.CFrame = CFrame.new(tree.PrimaryPart.Position + Vector3.new(0,0,4)) 
        until tree.PrimaryPart.Transparency == 1 or Player:GetAttribute("farmingChoppable") == false
    end
    
    task.wait(0.2)
    collectDrops(tree.PrimaryPart.Position)
    
    task.spawn(autoJump)
end

local function stopFarmingChoppable()
    setTreeFarming(false)
    autoJumpDebounce = false
    autoJumping = false
end

local function startFarmingChoppable(tree)
    setTreeFarming(true)
    task.spawn(autoJump)
    while Player:GetAttribute("farmingChoppable") and wait() do
        
        checkHealth(tree)
        checkFood(tree)
        
        local trees = getTree(tree)
        for i,v in pairs(trees) do
            moveToTree(v)
            
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

function checkHealth(tree)
    local healthBar = Player.PlayerGui.Main["status"].health.container.bar.stat.Text
    
    if healthBar:sub(0,1) == "0" then
        stopFarmingChoppable()
        
        clickSpawnButton()
        
        repeat wait() until game.Players.LocalPlayer.Character
        Player = Players.LocalPlayer
        Character = Player.Character
        Humanoid = Character.Humanoid
        HR = Character.HumanoidRootPart
        
        hideGUIS()
        
        startFarmingChoppable(tree)
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
    startFarmingChoppable = startFarmingChoppable,
    stopFarmingChoppable = stopFarmingChoppable
}
