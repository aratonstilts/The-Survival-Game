print("Loading")

repeat wait()
until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Head") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid") 
local mouse = game.Players.LocalPlayer:GetMouse()
repeat wait() until mouse

function loadModule(url)
	return loadstring(game:HttpGet(url))()
end

local oreModule = loadModule("https://raw.githubusercontent.com/aratonstilts/The-Survival-Game/main/modules/ore-farming.lua")
local treeModule = loadModule("https://raw.githubusercontent.com/aratonstilts/The-Survival-Game/main/modules/choppable-farm.lua")
local farmModule = loadModule("https://raw.githubusercontent.com/aratonstilts/The-Survival-Game/main/modules/farming.lua")
local pickupRangeModule = loadModule("https://raw.githubusercontent.com/aratonstilts/The-Survival-Game/main/modules/increase-range.lua")

print("Finished loading")

local function stopAllModules()
    oreModule.stopFarmingOre()
    treeModule.stopFarmingChoppable()
    pickupRangeModule.regularPickupRange()
    farmModule.stopTillingUnderPlayer()
end

local Character = game.Players.LocalPlayer.Character
local Humanoid = Character.Humanoid

local noClip = false

local function NoclipLoop()
    if noClip == true then
        for _, child in pairs(Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                child.CanCollide = false
            end
    	end
    end
end

local function checkHealth()
    local healthBar = Player.PlayerGui.Main["status"].health.container.bar.stat.Text
    if healthBar:sub(0,1) == "0" then
        local spawnButton = Player.PlayerGui.Avatar.spawnButtons.spawn
        repeat wait() until spawnButton.Parent.Visible == true
        task.wait(2)
        
        
        repeat wait() until game.Players.LocalPlayer.Character
        Player = Players.LocalPlayer
        Character = Player.Character
        Humanoid = Character.Humanoid
        HR = Character.HumanoidRootPart
        
        hideGUIS()
        
        startFarmingChoppable(tree)
    end
end

local RUN = false
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if RUN then
        Humanoid.WalkSpeed = 30
    end
end)

local GUI = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local Scroll = Instance.new("ScrollingFrame")
local Close = Instance.new("TextButton")
local Minimum = Instance.new("TextButton")
local draggableName = Instance.new("TextButton")
local Grid = Instance.new("UIGridLayout")
local oreSelection = Instance.new("TextButton")
local treeSelection = Instance.new("TextButton")
local farmSelection = Instance.new("TextButton")
local fastWalkButton = Instance.new("TextButton")
local noClipButton = Instance.new("TextButton")
local increaseRangeButton = Instance.new("TextButton")



local function createOreBackground()
    
    local oldBackground = game.CoreGui["Survival GUI"].Background:GetChildren()
    for i,v in pairs(oldBackground) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    
    
    if oreSelection.Text == "Auto-farm Minable <" then
        oreSelection.Text = "Auto-farm Minable >"
        return
    end
    oreSelection.Text = "Auto-farm Minable <"
    treeSelection.Text = "Auto-farm Choppables >"
    
    local oreBackground = Instance.new("Frame")
    local Scroll2 = Instance.new("ScrollingFrame")
    
    oreBackground.Name = "Ore Background"
    oreBackground.Parent = Background
    oreBackground.BackgroundColor3 = Color3.fromRGB(0,0,0)
    oreBackground.BorderSizePixel = 0
    oreBackground.BackgroundTransparency = 0.5
    oreBackground.Position = UDim2.new(1, 0, 0, 0)
    oreBackground.AnchorPoint = Vector2.new(0,0)
    oreBackground.Size = UDim2.new(0, 200, 0, 275)
    oreBackground.Active = true

    Scroll2.Name = "Scroll Menu"
    Scroll2.Parent = oreBackground
    Scroll2.Active = true
    Scroll2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Scroll2.BackgroundTransparency = 1
    Scroll2.BorderSizePixel = 0
    Scroll2.AutomaticCanvasSize = "Y"
    Scroll2.Position = UDim2.new(0, 0, 0, 25)
    Scroll2.Size = UDim2.new(1,0,1,-25)
    Scroll2.ScrollBarThickness = 4

    local Grid2 = Instance.new("UIGridLayout")
    Grid2.CellSize = UDim2.new(1,0,0,25)
    Grid2.CellPadding = UDim2.new(0,1,0,5)
    Grid2.SortOrder = "LayoutOrder"
    Grid2.Parent = Scroll2
    
    local allOresButton = Instance.new("TextButton")
    allOresButton.Name = "allOresButton"
    allOresButton.Position = UDim2.new(0,1,0,341)
    allOresButton.Size = UDim2.new(0,100,0,20)
    allOresButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    allOresButton.BackgroundTransparency = 0.5
    allOresButton.BorderColor3 = Color3.new(1,1,1)
    allOresButton.ZIndex = 2
    allOresButton.Text = "All Minables"
    allOresButton.TextColor3 = Color3.fromRGB(250,250,250)
    allOresButton.TextScaled = true
    allOresButton.LayoutOrder = 10
    allOresButton.Parent = Scroll2
    allOresButton.MouseButton1Click:Connect(function()
        if allOresButton.Text == "All Choppables" then
            RUN = true
            Humanoid.WalkSpeed = 30
            allOresButton.Text = "Mining All"
            allOresButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
            stopAllModules()
            oreModule.startFarmingOre("all")
        else
            RUN = false
            allOresButton.Text = "All Choppables"
            allOresButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            treeModule.stopFarmingOre()
        end
    end)
    
    local oreList = {"Iron Ore", "Copper Ore", "Coal Ore", "Stone", "Boulder", "Bluesteel", "Gold Vein"}
    for i,v in pairs(oreList) do
        local goldOreButton = Instance.new("TextButton")
        goldOreButton.Name = v
        goldOreButton.Position = UDim2.new(0,1,0,341)
        goldOreButton.Size = UDim2.new(0,100,0,20)
        goldOreButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
        goldOreButton.BackgroundTransparency = 0.5
        goldOreButton.BorderColor3 = Color3.new(1,1,1)
        goldOreButton.ZIndex = 2
        goldOreButton.Text = v
        goldOreButton.TextColor3 = Color3.fromRGB(250,250,250)
        goldOreButton.TextScaled = true
        goldOreButton.LayoutOrder = 10
        goldOreButton.Parent = Scroll2
        goldOreButton.MouseButton1Click:Connect(function()
            if goldOreButton.Text == v then
                goldOreButton.Text = "Mining "..v
                goldOreButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
                stopAllModules()
                RUN = true
                Humanoid.WalkSpeed = 30
                oreModule.startFarmingOre(v)
            else
                RUN = false
                goldOreButton.Text = v
                goldOreButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
                oreModule.stopFarmingOre()
            end
        end)
    end
end

local function createTreeBackground()
    
    local oldBackground = game.CoreGui["Survival GUI"].Background:GetChildren()
    for i,v in pairs(oldBackground) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    
    if treeSelection.Text == "Auto-farm Choppables <" then
        treeSelection.Text = "Auto-farm Choppables >"
        return
    end
    oreSelection.Text = "Auto-farm Minable >"
    treeSelection.Text = "Auto-farm Choppables <"
    
    local treeBackground = Instance.new("Frame")
    local Scroll2 = Instance.new("ScrollingFrame")
    
    treeBackground.Name = "tree Background"
    treeBackground.Parent = Background
    treeBackground.BackgroundColor3 = Color3.fromRGB(0,0,0)
    treeBackground.BorderSizePixel = 0
    treeBackground.BackgroundTransparency = 0.5
    treeBackground.Position = UDim2.new(1, 0, 0, 0)
    treeBackground.AnchorPoint = Vector2.new(0,0)
    treeBackground.Size = UDim2.new(0, 200, 0, 275)
    treeBackground.Active = true

    Scroll2.Name = "Scroll Menu"
    Scroll2.Parent = treeBackground
    Scroll2.Active = true
    Scroll2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Scroll2.BackgroundTransparency = 1
    Scroll2.BorderSizePixel = 0
    Scroll2.AutomaticCanvasSize = "Y"
    Scroll2.Position = UDim2.new(0, 0, 0, 25)
    Scroll2.Size = UDim2.new(1,0,1,-25)
    Scroll2.ScrollBarThickness = 4

    local Grid2 = Instance.new("UIGridLayout")
    Grid2.CellSize = UDim2.new(1,0,0,25)
    Grid2.CellPadding = UDim2.new(0,1,0,5)
    Grid2.SortOrder = "LayoutOrder"
    Grid2.Parent = Scroll2
    
    local allWoodsButton = Instance.new("TextButton")
    allWoodsButton.Name = "all Woods"
    allWoodsButton.Position = UDim2.new(0,1,0,341)
    allWoodsButton.Size = UDim2.new(0,100,0,20)
    allWoodsButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    allWoodsButton.BackgroundTransparency = 0.5
    allWoodsButton.BorderColor3 = Color3.new(1,1,1)
    allWoodsButton.ZIndex = 2
    allWoodsButton.Text = "All Choppables"
    allWoodsButton.TextColor3 = Color3.fromRGB(250,250,250)
    allWoodsButton.TextScaled = true
    allWoodsButton.LayoutOrder = 10
    allWoodsButton.Parent = Scroll2
    allWoodsButton.MouseButton1Click:Connect(function()
        if allWoodsButton.Text == "All Choppables" then
            RUN = true
            Humanoid.WalkSpeed = 30
            allWoodsButton.Text = "Chopping All"
            allWoodsButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
            stopAllModules()
            treeModule.startFarmingChoppable("all")
        else
            RUN = false
            allWoodsButton.Text = "All Choppables"
            allWoodsButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            treeModule.stopFarmingChoppable()
        end
    end)
    
    local allFoodsButton = Instance.new("TextButton")
    allFoodsButton.Name = "all Woods"
    allFoodsButton.Position = UDim2.new(0,1,0,341)
    allFoodsButton.Size = UDim2.new(0,100,0,20)
    allFoodsButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    allFoodsButton.BackgroundTransparency = 0.5
    allFoodsButton.BorderColor3 = Color3.new(1,1,1)
    allFoodsButton.ZIndex = 2
    allFoodsButton.Text = "Foods"
    allFoodsButton.TextColor3 = Color3.fromRGB(250,250,250)
    allFoodsButton.TextScaled = true
    allFoodsButton.LayoutOrder = 10
    allFoodsButton.Parent = Scroll2
    allFoodsButton.MouseButton1Click:Connect(function()
        if allFoodsButton.Text == "Foods" then
            allFoodsButton.Text = "Chopping all Foods"
            allFoodsButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
            stopAllModules()
            RUN = true
            Humanoid.WalkSpeed = 30
            treeModule.startFarmingChoppable("foods")
        else
            RUN = false
            allFoodsButton.Text = "Foods"
            allFoodsButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            treeModule.stopFarmingChoppable()
        end
    end)
    
    local chopList = {"Big Oak Tree", "Pine Tree", "Oak Tree", "Big Pine Tree", "Berry Bush", "Bush", "Mushroom", "Carrot", "Wheat", "Palm Tree", "Big Palm Tree", "Jungle Tree", "Big Jungle Tree", "Jungle Vine"}
    for i,v in pairs(chopList) do
        local chopButton = Instance.new("TextButton")
        chopButton.Name = v
        chopButton.Position = UDim2.new(0,1,0,341)
        chopButton.Size = UDim2.new(0,100,0,20)
        chopButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
        chopButton.BackgroundTransparency = 0.5
        chopButton.BorderColor3 = Color3.new(1,1,1)
        chopButton.ZIndex = 2
        chopButton.Text = v
        chopButton.TextColor3 = Color3.fromRGB(250,250,250)
        chopButton.TextScaled = true
        chopButton.LayoutOrder = 10
        chopButton.Parent = Scroll2
        chopButton.MouseButton1Click:Connect(function()
            if chopButton.Text == v then
                chopButton.Text = "Chopping "..v
                chopButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
                stopAllModules()
                RUN = true
                Humanoid.WalkSpeed = 30
                treeModule.startFarmingChoppable(v)
            else
                RUN = false
                chopButton.Text = v
                chopButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
                treeModule.stopFarmingChoppable()
            end
        end)
    end
end

local function createFarmBackground()
    
    local oldBackground = game.CoreGui["Survival GUI"].Background:GetChildren()
    for i,v in pairs(oldBackground) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    
    
    if farmSelection.Text == "Farm Stuff <" then
        farmSelection.Text = "Farm Stuff >"
        return
    end
    farmSelection.Text = "Farm Stuff <"
    oreSelection.Text = "Auto-farm Minable >"
    treeSelection.Text = "Auto-farm Choppables >"
    
    local farmBackground = Instance.new("Frame")
    local Scroll2 = Instance.new("ScrollingFrame")
    
    farmBackground.Name = "Farm Background"
    farmBackground.Parent = Background
    farmBackground.BackgroundColor3 = Color3.fromRGB(0,0,0)
    farmBackground.BorderSizePixel = 0
    farmBackground.BackgroundTransparency = 0.5
    farmBackground.Position = UDim2.new(1, 0, 0, 0)
    farmBackground.AnchorPoint = Vector2.new(0,0)
    farmBackground.Size = UDim2.new(0, 200, 0, 275)
    farmBackground.Active = true

    Scroll2.Name = "Scroll Menu"
    Scroll2.Parent = farmBackground
    Scroll2.Active = true
    Scroll2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Scroll2.BackgroundTransparency = 1
    Scroll2.BorderSizePixel = 0
    Scroll2.AutomaticCanvasSize = "Y"
    Scroll2.Position = UDim2.new(0, 0, 0, 0)
    Scroll2.Size = UDim2.new(1,0,1,0)
    Scroll2.ScrollBarThickness = 4

    local Grid2 = Instance.new("UIGridLayout")
    Grid2.CellSize = UDim2.new(1,0,0,25)
    Grid2.CellPadding = UDim2.new(0,1,0,5)
    Grid2.SortOrder = "LayoutOrder"
    Grid2.Parent = Scroll2
    
    local titleForPlants = Instance.new("TextLabel")
    titleForPlants.Name = "Click to plant"
    titleForPlants.Parent = Scroll2
    titleForPlants.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    titleForPlants.BackgroundTransparency = 1
    titleForPlants.BorderSizePixel = 0
    titleForPlants.Size = UDim2.new(0, 120, 0, 15)
    titleForPlants.Font = Enum.Font.GothamBlack
    titleForPlants.Text = "Click to plant"
    titleForPlants.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleForPlants.TextScaled = true
    titleForPlants.TextSize = 14.000
    titleForPlants.TextWrapped = true
    
    local farmingList = {"carrot", "wheat"}
    for i,v in pairs(farmingList) do
        local plantPlantButton = Instance.new("TextButton")
        plantPlantButton.Name = v
        plantPlantButton.Position = UDim2.new(0,1,0,341)
        plantPlantButton.Size = UDim2.new(0,100,0,20)
        plantPlantButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
        plantPlantButton.BackgroundTransparency = 0.5
        plantPlantButton.BorderColor3 = Color3.new(1,1,1)
        plantPlantButton.ZIndex = 2
        plantPlantButton.Text = v
        plantPlantButton.TextColor3 = Color3.fromRGB(250,250,250)
        plantPlantButton.TextScaled = true
        plantPlantButton.LayoutOrder = 10
        plantPlantButton.Parent = Scroll2
        plantPlantButton.MouseButton1Click:Connect(function()
            farmModule.plantOnTilled(v)
        end)
    end
    
    local harvestFarmButton = Instance.new("TextButton")
    harvestFarmButton.Name = "harvest farmland"
    harvestFarmButton.Position = UDim2.new(0,1,0,341)
    harvestFarmButton.Size = UDim2.new(0,100,0,20)
    harvestFarmButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    harvestFarmButton.BackgroundTransparency = 0.5
    harvestFarmButton.BorderColor3 = Color3.new(1,1,1)
    harvestFarmButton.ZIndex = 2
    harvestFarmButton.Text = "Harvest nearby farmland"
    harvestFarmButton.TextColor3 = Color3.fromRGB(250,250,250)
    harvestFarmButton.TextScaled = true
    harvestFarmButton.LayoutOrder = 10
    harvestFarmButton.Parent = Scroll2
    harvestFarmButton.MouseButton1Click:Connect(function()
        farmModule.harvestFarmland()
    end)
    
    local autoTillButton = Instance.new("TextButton")
    autoTillButton.Name = "autoTillButton"
    autoTillButton.Position = UDim2.new(0,1,0,341)
    autoTillButton.Size = UDim2.new(0,100,0,20)
    autoTillButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    autoTillButton.BackgroundTransparency = 0.5
    autoTillButton.BorderColor3 = Color3.new(1,1,1)
    autoTillButton.ZIndex = 2
    autoTillButton.Text = "Till Under Player"
    autoTillButton.TextColor3 = Color3.fromRGB(250,250,250)
    autoTillButton.TextScaled = true
    autoTillButton.LayoutOrder = 10
    autoTillButton.Parent = Scroll2
    autoTillButton.MouseButton1Click:Connect(function()
        if autoTillButton.Text == "Till Under Player" then
            autoTillButton.BackgroundColor3 = Color3.fromRGB(0,0,250)
            autoTillButton.Text = "Tilling Under Player"
            farmModule.startTillingUnderPlayer()
        else
            autoTillButton.Text = "Till Under Player"
            autoTillButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            farmModule.stopTillingUnderPlayer()
        end
    end)
    
end


local function createGUI()
    if game:GetService("CoreGui"):FindFirstChild("Survival GUI") then
        game.CoreGui["Survival GUI"]:Destroy()
    end

    GUI.Name = "Survival GUI"
    GUI.Parent = game:GetService("CoreGui")


    Background.Name = "Background"
    Background.Parent = GUI
    Background.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Background.BorderSizePixel = 0
    Background.BackgroundTransparency = 0.5
    Background.Position = UDim2.new(0.06, 0, 0.50, 0)
    Background.AnchorPoint = Vector2.new(0,0.5)
    Background.Size = UDim2.new(0, 200, 0, 275)
    Background.Active = true
    
    draggableName.Name = "CmdName"
    draggableName.AutoButtonColor = false
    draggableName.Parent = Background
    draggableName.BackgroundColor3 = Color3.fromRGB(0,0,150)
    draggableName.BorderSizePixel = 0
    draggableName.Size = UDim2.new(1, 0, 0, 20)
    draggableName.Font = Enum.Font.GothamBlack
    draggableName.Text = "Survival GUI"
    draggableName.TextColor3 = Color3.fromRGB(255, 255, 255)
    draggableName.TextScaled = true
    draggableName.TextSize = 14.000
    draggableName.TextWrapped = true
    Dragg = false
    draggableName.MouseButton1Down:Connect(function()Dragg = true while Dragg do game.TweenService:Create(Background, TweenInfo.new(.06), {Position = UDim2.new(0,mouse.X-100,0,mouse.Y+ (275/2) - 5)}):Play()wait()end end)
    draggableName.MouseButton1Up:Connect(function()Dragg = false end)
    
    Close.Name = "Close"
    Close.Parent = Background
    Close.BackgroundColor3 = Color3.fromRGB(155, 0, 0)
    Close.BorderSizePixel = 0
    Close.Position = UDim2.new(1, 0, 0, 0)
    Close.AnchorPoint = Vector2.new(1,0)
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Font = Enum.Font.SourceSans
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 14.000
    Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
    stopAllModules()
    end)
    
    Minimum.Name = "Minimum"
    Minimum.Parent = Background
    Minimum.BackgroundColor3 = Color3.fromRGB(0, 155, 155)
    Minimum.BorderSizePixel = 0
    Minimum.Position = UDim2.new(1, -20, 0, 0)
    Minimum.AnchorPoint = Vector2.new(1,0)
    Minimum.Size = UDim2.new(0, 20, 0, 20)
    Minimum.Font = Enum.Font.SourceSans
    Minimum.Text = "-"
    Minimum.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimum.TextSize = 14.000
    Minimum.MouseButton1Click:Connect(function()
    	if Background.BackgroundTransparency == 0.5 then
    		Background.BackgroundTransparency = 1
    		for i,v in pairs(Background:GetChildren()) do
    		    if v:IsA("ScrollingFrame") or v:IsA("Frame") then
    		        v.Visible = false
    		    end
            end
    	elseif Background.BackgroundTransparency == 1 then
    		Background.BackgroundTransparency = 0.5
    		for i,v in pairs(Background:GetChildren()) do
    		    if v:IsA("ScrollingFrame") or v:IsA("Frame") then
    		        v.Visible = true
    		    end
            end
    	end
    end)
    
    Scroll.Name = "Scroll Menu"
    Scroll.Parent = Background
    Scroll.Active = true
    Scroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.AutomaticCanvasSize = "Y"
    Scroll.Position = UDim2.new(0, 0, 0, 25)
    Scroll.Size = UDim2.new(1,0,1,-25)
    Scroll.ScrollBarThickness = 4
    
    Grid.CellSize = UDim2.new(1,0,0,25)
    Grid.CellPadding = UDim2.new(0,1,0,5)
    Grid.SortOrder = "LayoutOrder"
    Grid.Parent = Scroll
    
    oreSelection.Name = "Auto-farm Ore"
    oreSelection.Position = UDim2.new(0,1,0,341)
    oreSelection.Size = UDim2.new(0,100,0,20)
    oreSelection.BackgroundColor3 = Color3.fromRGB(0,0,50)
    oreSelection.BackgroundTransparency = 0.5
    oreSelection.BorderColor3 = Color3.new(1,1,1)
    oreSelection.ZIndex = 2
    oreSelection.Text = "Auto-farm Minable >"
    oreSelection.TextColor3 = Color3.fromRGB(250,250,250)
    oreSelection.TextScaled = true
    oreSelection.LayoutOrder = 10
    oreSelection.Parent = Scroll
    oreSelection.MouseButton1Click:Connect(createOreBackground)
    
    treeSelection.Name = "Auto-farm Choppables"
    treeSelection.Position = UDim2.new(0,1,0,341)
    treeSelection.Size = UDim2.new(0,100,0,20)
    treeSelection.BackgroundColor3 = Color3.fromRGB(0,0,50)
    treeSelection.BackgroundTransparency = 0.5
    treeSelection.BorderColor3 = Color3.new(1,1,1)
    treeSelection.ZIndex = 2
    treeSelection.Text = "Auto-farm Choppables >"
    treeSelection.TextColor3 = Color3.fromRGB(250,250,250)
    treeSelection.TextScaled = true
    treeSelection.LayoutOrder = 10
    treeSelection.Parent = Scroll
    treeSelection.MouseButton1Click:Connect(createTreeBackground)
    
    farmSelection.Name = "Farm Stuff"
    farmSelection.Position = UDim2.new(0,1,0,341)
    farmSelection.Size = UDim2.new(0,100,0,20)
    farmSelection.BackgroundColor3 = Color3.fromRGB(0,0,50)
    farmSelection.BackgroundTransparency = 0.5
    farmSelection.BorderColor3 = Color3.new(1,1,1)
    farmSelection.ZIndex = 2
    farmSelection.Text = "Farm Stuff >"
    farmSelection.TextColor3 = Color3.fromRGB(250,250,250)
    farmSelection.TextScaled = true
    farmSelection.LayoutOrder = 10
    farmSelection.Parent = Scroll
    farmSelection.MouseButton1Click:Connect(createFarmBackground)
    
    fastWalkButton.Name = "Fast Walk"
    fastWalkButton.Position = UDim2.new(0,1,0,341)
    fastWalkButton.Size = UDim2.new(0,100,0,20)
    fastWalkButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    fastWalkButton.BackgroundTransparency = 0.5
    fastWalkButton.BorderColor3 = Color3.new(1,1,1)
    fastWalkButton.ZIndex = 2
    fastWalkButton.Text = "Fast Walk"
    fastWalkButton.TextColor3 = Color3.fromRGB(250,250,250)
    fastWalkButton.TextScaled = true
    fastWalkButton.LayoutOrder = 10
    fastWalkButton.Parent = Scroll
    fastWalkButton.MouseButton1Click:Connect(function()
        if RUN == false then
            RUN = true
            Humanoid.WalkSpeed = 30
            fastWalkButton.Text = "Walking Fast"
            fastWalkButton.BackgroundColor3 = Color3.fromRGB(100,0,0)
        else
            RUN = false
            fastWalkButton.Text = "Fast Walk"
            fastWalkButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
        end
    end)
    
    noClipButton.Name = "No Clip"
    noClipButton.Position = UDim2.new(0,1,0,341)
    noClipButton.Size = UDim2.new(0,100,0,20)
    noClipButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    noClipButton.BackgroundTransparency = 0.5
    noClipButton.BorderColor3 = Color3.new(1,1,1)
    noClipButton.ZIndex = 2
    noClipButton.Text = "No Clip"
    noClipButton.TextColor3 = Color3.fromRGB(250,250,250)
    noClipButton.TextScaled = true
    noClipButton.LayoutOrder = 10
    noClipButton.Parent = Scroll
    noClipButton.MouseButton1Click:Connect(function()
        if noClipButton.Text == "No Clip" then
            noClipButton.Text = "No Clipping"
            noClipButton.BackgroundColor3 = Color3.fromRGB(0,0,250)
            NoClipping = game:GetService('RunService').Stepped:Connect(NoclipLoop) 
            noClip = true
        else
            noClipButton.Text = "No Clip"
            noClipButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            NoClipping:Disconnect()
            noClip = false
        end
    end)
    
    increaseRangeButton.Name = "Increase Pickup Range"
    increaseRangeButton.Position = UDim2.new(0,1,0,341)
    increaseRangeButton.Size = UDim2.new(0,100,0,20)
    increaseRangeButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
    increaseRangeButton.BackgroundTransparency = 0.5
    increaseRangeButton.BorderColor3 = Color3.new(1,1,1)
    increaseRangeButton.ZIndex = 2
    increaseRangeButton.Text = "Increase Pickup Range"
    increaseRangeButton.TextColor3 = Color3.fromRGB(250,250,250)
    increaseRangeButton.TextScaled = true
    increaseRangeButton.LayoutOrder = 10
    increaseRangeButton.Parent = Scroll
    increaseRangeButton.MouseButton1Click:Connect(function()
        if increaseRangeButton.Text == "Increase Pickup Range" then
            increaseRangeButton.Text = "Increased Range"
            increaseRangeButton.BackgroundColor3 = Color3.fromRGB(0,0,250)
            pickupRangeModule.increasePickupRange()
        else
            increaseRangeButton.Text = "Increase Pickup Range"
            increaseRangeButton.BackgroundColor3 = Color3.fromRGB(0,0,50)
            pickupRangeModule.regularPickupRange()
        end
    end)
end

createGUI()
