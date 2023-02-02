local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function setRangeIncrease(value)
    Player:SetAttribute("increaseRange", value)
end

local function pickUpItem(part)
    game:GetService("ReplicatedStorage").remoteInterface.inventory.pickupItem:FireServer(part)
end

local function getDrops()
    local dropsFolder = game:GetService("Workspace").droppedItems
    for i,v in pairs(dropsFolder:GetChildren()) do
        pickUpItem(v)
    end
end

local function increasePickupRange()
    setRangeIncrease(true)
    
    while Player:GetAttribute("increaseRange") and wait(0.2) do
        getDrops()
    end
end

local function regularPickupRange()
    setRangeIncrease(false)
end

return {
    increasePickupRange = increasePickupRange, 
    regularPickupRange = regularPickupRange
}
