local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function findTool(tool)
    local toolToEquip
    
    for i,v in pairs(Player.Backpack:GetChildren()) do
        if v:FindFirstChild("toolModel") and v.toolModel:FindFirstChildWhichIsA("MeshPart").Name:find(tool) then
            toolToEquip = v
        end
    end
    
    return toolToEquip
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

return {
  plantOnTilled = plantOnTilled, -- "carrot" "wheat"
  harvestFarmland = harvestFarmland
}
