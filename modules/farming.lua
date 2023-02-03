local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local HR = Character.HumanoidRootPart

local function findTool(tool)
    local toolToEquip
    
    if Character:FindFirstChildWhichIsA("Tool") and Character:FindFirstChildWhichIsA("Tool").toolModel:FindFirstChildWhichIsA("MeshPart") and Character:FindFirstChildWhichIsA("Tool").toolModel:FindFirstChildWhichIsA("MeshPart").Name:find(tool) then
        return Character:FindFirstChildWhichIsA("Tool")
    end
    
    for i,v in pairs(Player.Backpack:GetChildren()) do
        if v:FindFirstChild("toolModel") and v.toolModel:FindFirstChildWhichIsA("MeshPart").Name:find(tool) then
            toolToEquip = v
        end
    end
    
    return tonumber(toolToEquip.Name)
end

local function setAutoTilling(value)
    Player:SetAttribute("autoTilling", value)
end

local function tillUnderPlayer()
    local args = {
    [1] = findTool("Shovel"),
    [2] = HR.Position - Vector3.new(0,3,0),
    [3] = 0
    }

    game:GetService("ReplicatedStorage").remoteInterface.interactions.createFarmland:FireServer(unpack(args))
end

local function getTilledLand()
    local tilledDirt = {}
    
    for i,v in pairs(game.Workspace.farmland:GetChildren()) do
        table.insert(tilledDirt, v)
    end
    
    return tilledDirt
end

local function plantOnTilled(plant)
    local tilledDirt = getTilledLand()
    
    local plantNumber
    if plant == "wheat" then
        plantNumber = 107
    elseif plant == "carrot" then
        plantNumber = 95
    elseif plant == "berry" then
        plantNumber = 113
    elseif plant == "cabbage" then
        plantNumber = 210
    elseif plant == "pepper" then
        plantNumber = 211
    end
    
    for i,v in pairs(tilledDirt) do
        local args = {
        [1] = findTool("Shovel"),
        [2] = plantNumber,
        [3] = v
        }
        game:GetService("ReplicatedStorage"):WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("plant"):FireServer(unpack(args))
    end
end

local function harvestFarmland()
    local tilledDirt = getTilledLand()
    for i,v in pairs(tilledDirt) do
        local args = {
        [1] = findTool("Axe"),
        [2] = v
        }

        game:GetService("ReplicatedStorage"):WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("harvest"):FireServer(unpack(args))
    end
end

local function startTillingUnderPlayer()
    setAutoTilling(true)
    while Player:GetAttribute("autoTilling") and wait() do
        tillUnderPlayer()
    end
end

local function stopTillingUnderPlayer()
    setAutoTilling(false)
end

return {
  plantOnTilled = plantOnTilled, -- "carrot" "wheat"
  harvestFarmland = harvestFarmland,
  startTillingUnderPlayer = startTillingUnderPlayer,
  stopTillingUnderPlayer = stopTillingUnderPlayer
}
