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
        [1] = 5, -- probably the hotbar number for shovel
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
        [1] = 4, -- hotbar slot for axe
        [2] = v
        }

        game:GetService("ReplicatedStorage"):WaitForChild("remoteInterface"):WaitForChild("interactions"):WaitForChild("harvest"):FireServer(unpack(args))
    end
end

return {
  plantOnTilled(), -- "carrot" "wheat"
  harvestFarmland()
}
