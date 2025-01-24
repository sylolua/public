-- Dig It Neox Hub Open Source
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shovels = {}
local OriginalShovelNames = {}

local function AddComma(amount: number)
	local formatted = amount
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

for i,v in ReplicatedStorage.Settings.Items.Shovels:GetChildren() do
	local Success, ItemInfo = pcall(require, v)

	local BuyPrice = 0
	
	local NewName

	if Success and ItemInfo then
		if not ItemInfo.BuyPrice then
			continue
		end
		
		BuyPrice = ItemInfo.BuyPrice
		
		NewName = `{v.Name} (${AddComma(BuyPrice)})`
	else
		NewName = `{v.Name}`
	end
	
	table.insert(Shovels, NewName)
	OriginalShovelNames[NewName] = {
		Name = v.Name,
		BuyPrice = BuyPrice
	}
end




table.sort(Shovels, function(a,b)
	return OriginalShovelNames[a].BuyPrice < OriginalShovelNames[b].BuyPrice
end)




local CollectionService = game:GetService("CollectionService")

local Player = game:GetService("Players").LocalPlayer

local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")







local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/neoxlib')))()

local Window = OrionLib:MakeWindow({Name = "NEOX ⭐ HUB | Digit v1.2", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionTest"})

local homeTab = Window:MakeTab({
	Name = "| Home",
	Icon = "rbxassetid://7733960981",
	PremiumOnly = false
})

local mainTab = Window:MakeTab({
	Name = "| Main",
	Icon = "rbxassetid://7743869612",
	PremiumOnly = false
})

local itemsTab = Window:MakeTab({
	Name = "| Items",
	Icon = "rbxassetid://7734056878",
	PremiumOnly = false
})

local MiscTab = Window:MakeTab({
	Name = "| Misc",
	Icon = "rbxassetid://7733789088",
	PremiumOnly = false
})

local ShopTab = Window:MakeTab({
	Name = "| Shop",
	Icon = "rbxassetid://7734056747",
	PremiumOnly = false
})



local TeleportTab = Window:MakeTab({
	Name = "| Teleport",
	Icon = "rbxassetid://7733992789",
	PremiumOnly = false
})

local WeatherTab = Window:MakeTab({
	Name = "| Environment",
	Icon = "rbxassetid://7734068495",
	PremiumOnly = false
})

local ESPTab = Window:MakeTab({
	Name = "| Esp",
	Icon = "rbxassetid://7743876054",
	PremiumOnly = false
})








homeTab:AddButton({
	Name = "Join Our Discord!",
	Callback = function()
		setclipboard("https://discord.gg/99UuEwM9sX")
		
		OrionLib:MakeNotification({
			Name = "Discord Link Copied!",
			Content = "The Discord link has been copied to your clipboard.",
			Image = "rbxassetid://6031071056", 
			Time = 10
		})
	end
})


homeTab:AddParagraph("Join Now!!","Click on above button to copy discord invite")
homeTab:AddParagraph("Upcoming Update","new W update is coming soon with W features")





















local Section = TeleportTab:AddSection({
	Name = "Teleport to NPCS"
})



local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local mapFolder = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Islands")
if not mapFolder then
    warn("Map > Islands folder not found!")
    return
end

local teleportLocations = {}
local npcNames = {}
local selectedModel = nil 

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function processModels(islandFolder, modelNames)
    for _, modelName in ipairs(modelNames) do
        local model = islandFolder:FindFirstChild(modelName)
        if model and model:IsA("Model") then
            if model:FindFirstChild("HumanoidRootPart") then
                teleportLocations[modelName] = model.HumanoidRootPart.Position
                table.insert(npcNames, modelName) 
                print("Processed model: " .. modelName)
            else
                warn("Model '" .. modelName .. "' does not have a HumanoidRootPart!")
            end
        else
            warn("Model '" .. modelName .. "' not found in " .. islandFolder.Name)
        end
    end
end


local nookville = mapFolder:FindFirstChild("Nookville")
if nookville then
    print("Nookville folder found")
    processModels(nookville, {
        "Wizzy", "Agent", "Cooper", "Milton", "Balwin", "Margot",
        "ShipDealer", "Scrubbucket", "Hobo", "Crook Dude", "Patricia", "Timy",
        "Ronald", "Benson"  
    })
else
    print("Nookville folder not found!")
end

local piratesburg = mapFolder:FindFirstChild("Piratesburg")
if piratesburg then
    print("Piratesburg folder found")
    processModels(piratesburg, {
        "Old Man", "CargoDude", "Blackbeard", "Arthur", "Knight",
        "Booga", "Mr. Sandman" 
    })
else
    print("Piratesburg folder not found!")
end

local greekTemple = mapFolder:FindFirstChild("Greek Temple")
if greekTemple then
    print("Greek Temple folder found")
    processModels(greekTemple, {"Dominus Empyreus"})
else
    print("Greek Temple folder not found!")
end

local badlands = mapFolder:FindFirstChild("Badlands")
if badlands then
    print("Badlands folder found")
    processModels(badlands, {"Mia", "Baller", "Waldo", "Flapjack"}) 
else
    print("Badlands folder not found!")
end

local lunarNewYear = mapFolder:FindFirstChild("Lunar New Year")
if lunarNewYear then
    print("Lunar New Year folder found")
    processModels(lunarNewYear, {"Tai"}) 
else
    print("Lunar New Year folder not found!")
end

local permafrost = mapFolder:FindFirstChild("Permafrost")
if permafrost then
    print("Permafrost folder found")
    processModels(permafrost, {"WomenElf", "Hobo Santa", "ElfMerchant", "Ice King", "Frank", "Rick", "ShipElf"})
else
    print("Permafrost folder not found!")
end

TeleportTab:AddDropdown({
    Name = "Select NPC to Teleport",
    Default = "None",
    Options = npcNames,
    Callback = function(value)
        selectedModel = value
        print("Selected Model:", selectedModel)
    end
})

TeleportTab:AddButton({ 
    Name = "Teleport", 
    Callback = function()
        if selectedModel and selectedModel ~= "None" then
            local targetPosition = teleportLocations[selectedModel]
            if targetPosition then
                local character = getCharacter()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                    print("Teleported to " .. selectedModel)
                else
                    warn("HumanoidRootPart not found!")
                end
            else
                warn("No position data found for the selected model!")
            end
        else
            warn("No valid model selected!")
        end
    end
})

ESPTab:AddToggle({ 
    Name = "NPC Esp",
    Default = false,
    Callback = function(state)
        local function addESP(model)
            if model:IsA("Model") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = model
                highlight.Adornee = model
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                local headPart = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
                if headPart then
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Parent = headPart
                    billboardGui.Adornee = headPart
                    billboardGui.Size = UDim2.new(40, 0, 1, 0)
                    billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboardGui.AlwaysOnTop = true

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Parent = billboardGui
                    textLabel.Size = UDim2.new(1, 0, 2, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = model.Name
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) 
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextScaled = true 
                    textLabel.TextSize = 80 
                end
            end
        end

        local function removeESP(model)
            if model:IsA("Model") then
                local highlight = model:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end

                local headPart = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
                if headPart then
                    local billboardGui = headPart:FindFirstChildOfClass("BillboardGui")
                    if billboardGui then
                        billboardGui:Destroy()
                    end
                end
            end
        end

        local function processModels(folder, modelNames)
            if folder then
                for _, modelName in ipairs(modelNames) do
                    local model = folder:FindFirstChild(modelName)
                    if model then
                        print("Found model: " .. modelName)  
                        if state then addESP(model) else removeESP(model) end
                    else
                        print("Model not found: " .. modelName) 
                    end
                end
            else
                print("Folder not found!")
            end
        end

        local mapFolder = game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Islands")
        if not mapFolder then
            warn("Map > Islands folder not found!")
            return
        end

        print("Starting ESP for all models")

        local nookville = mapFolder:FindFirstChild("Nookville")
        if nookville then
            print("Nookville folder found")
            processModels(nookville, {
                "Wizzy", "Agent", "Cooper", "Milton", "Balwin", "Margot",
                "ShipDealer", "Scrubbucket", "Hobo", "Crook Dude", "Patricia", "Timy",
                "Ronald", "Benson" 
            })
        else
            print("Nookville folder not found!")
        end

        local piratesburg = mapFolder:FindFirstChild("Piratesburg")
        if piratesburg then
            print("Piratesburg folder found")
            processModels(piratesburg, {
                "Old Man", "CargoDude", "Blackbeard", "Arthur", "Knight",
                "Booga", "Mr. Sandman" 
            })
        else
            print("Piratesburg folder not found!")
        end

        local greekTemple = mapFolder:FindFirstChild("Greek Temple")
        if greekTemple then
            print("Greek Temple folder found")
            processModels(greekTemple, {"Dominus Empyreus"})
        else
            print("Greek Temple folder not found!")
        end

        local badlands = mapFolder:FindFirstChild("Badlands")
        if badlands then
            print("Badlands folder found")
            processModels(badlands, {"Mia", "Baller", "Waldo", "Flapjack"})  
        else
            print("Badlands folder not found!")
        end

        local lunarNewYear = mapFolder:FindFirstChild("Lunar New Year")
        if lunarNewYear then
            print("Lunar New Year folder found")
            processModels(lunarNewYear, {"Tai"}) 
        else
            print("Lunar New Year folder not found!")
        end

        local permafrost = mapFolder:FindFirstChild("Permafrost")
        if permafrost then
            print("Permafrost folder found")
            processModels(permafrost, {"WomenElf", "Hobo Santa", "ElfMerchant", "Ice King", "Ice King", "Frank", "Rick", "ShipElf"}) 
        else
            print("Permafrost folder not found!")
        end

        print(state and "ESP Enabled for all models" or "ESP Disabled for all models")
    end    
})




local RunService = game:GetService("RunService")

local DayOnlyLoop

WeatherTab:AddToggle({
    Name = "Only Day",
    Default = false,
    Callback = function(Value)
        if Value then
            DayOnlyLoop = RunService.Heartbeat:Connect(function()
                game:GetService("Lighting").TimeOfDay = "12:00:00"
            end)
        else
            if DayOnlyLoop then
                DayOnlyLoop:Disconnect()
                DayOnlyLoop = nil
            end
        end
    end    
})

local NightOnlyLoop

WeatherTab:AddToggle({
    Name = "Only Night",
    Default = false,
    Callback = function(Value)
        if Value then
            NightOnlyLoop = RunService.Heartbeat:Connect(function()
                game:GetService("Lighting").TimeOfDay = "22:00:00"
            end)
        else
            if NightOnlyLoop then
                NightOnlyLoop:Disconnect()
                NightOnlyLoop = nil
            end
        end
    end    
})





WeatherTab:AddToggle({
    Name = "Remove Fog",
    Default = false,
    Callback = function(Value)
        if Value then
            local sky = game:GetService("Lighting"):FindFirstChild("Sky")
            if sky then
                sky.Parent = game:GetService("Lighting").Bloom
            end
        else
            local skyInBloom = game:GetService("Lighting").Bloom:FindFirstChild("Sky")
            if skyInBloom then
                skyInBloom.Parent = game:GetService("Lighting")
            end
        end
    end    
})


itemsTab:AddButton({ 
    Name = "Redeem Known Codes",
    Callback = function()
        local Codes = {
            "PLSMOLE",
            "LUNARV2",
            "TWITTER_DIGITRBLX",
            "5MILLION",
            "SECRET",
            "300KLIKES",
            "12MVISITS",
            "ROYAL_SECRET",
        }

        for _, Code: string in Codes do
            local Result = RemoteFunctions.Codes:InvokeServer({
                Command = "Redeem",
                Code = Code
            })

            if Result.Status then
                continue
            elseif Result.AlreadyRedeemed then
                OrionLib:MakeNotification({
                    Name = "NEOX HUB",
                    Content = "The code '" .. Code .. "' has already been redeemed",
                    Image = "rbxassetid://7733911828",
                    Time = 5
                })
            elseif Result.NotValid then
                OrionLib:MakeNotification({
                    Name = "NEOX HUB",
                    Content = "The code '" .. Code .. "' is not valid anymore.",
                    Image = "rbxassetid://7733911828",
                    Time = 5
                })
            else
                OrionLib:MakeNotification({
                    Name = "NEOX HUB",
                    Content = "The code '" .. Code .. "' had an internal error while redeeming.",
                    Image = "rbxassetid://7733911828",
                    Time = 5
                })
            end
        end
    end    
})


local Treasures = ReplicatedStorage.Settings.Items.Treasures

local ContainerNames = {
	"Chest",
	"Loot Bag",
	"Crate",
	"Magnet Box",
	"Strange Vase",
	"Sparkle Flask",
	"Gift of Labor",
	"Gift of Voyage",
	"Gift of Elves",
	"Frozen Container",
	"Pinata Box",
	"Frozen Magnet Box",
	"Piggy Bank",
	"Benson's Present",
	"Benson's Royal Crate",
	"Benson's Safe",
	"Benson's Box",
	"Gift of Dragons",
	"Gift of Abundance",
	"Gift of Fortune",
}

Flags = Flags or {}
Flags.OpenContainers = false

local function OpenContainer(Tool: Tool)
	if not Flags.OpenContainers then
		return 
	end

	if not RemoteEvents or not RemoteEvents.Treasure then
		warn("RemoteEvents.Treasure is not defined!")
		return
	end

	local Module: ModuleScript? = Treasures:FindFirstChild(Tool.Name)
	if not Module and not table.find(ContainerNames, Tool.Name) then
		return 
	end

	task.wait(0.5)
	RemoteEvents.Treasure:FireServer({
		Command = "RedeemContainer",
		Container = Tool,
	})
end

itemsTab:AddToggle({
	Name = "Auto Open Containers",
	Default = false,
	Callback = function(Value)
		Flags.OpenContainers = Value

		if Value then
			for _, Tool: Tool in Player.Backpack:GetChildren() do
				OpenContainer(Tool)
			end

			Player.Backpack.ChildAdded:Connect(function(Tool)
				if Flags.OpenContainers then
					OpenContainer(Tool)
				end
			end)
		end
	end,
})



itemsTab:AddButton({
    Name = "Get Mole Count",
    Callback = function()
        local Moles = 0
        local RoyalMoles = 0

        for _, v: Tool in Player.Backpack:GetChildren() do
            if v.Name == "Mole" then
                Moles += 1
            elseif v.Name == "Royal Mole" then
                RoyalMoles += 1
            end
        end

        for _, v: ImageLabel in Player.PlayerGui.Main.Core.Inventory.Inventory.Slots:GetChildren() do
            if not v:IsA("ImageLabel") then
                continue
            end

            if v.Icon.Image == Icons.Mole then
                Moles += 1
            elseif v.Icon.Image == Icons.RoyalMole then
                RoyalMoles += 1
            end
        end

        OrionLib:MakeNotification({
            Name = "Total Moles", 
            Content = `You have {Moles} Moles and {RoyalMoles} Royal Moles`,
            Image = "rbxassetid://7734068321",
            Time = 5
        })
    end    
})



local Section = TeleportTab:AddSection({
	Name = "Teleport to Islands"
})


local Islands = {}

for i,v in workspace.Map.Islands:GetChildren() do
    table.insert(Islands, v.Name)
end

for i,v in ReplicatedStorage.Assets.Sounds.Soundtrack.Locations:GetChildren() do
    if v.Name == "Ocean" then
        continue
    end

    if not table.find(Islands, v.Name) then
        table.insert(Islands, v.Name)
    end
end

table.sort(Islands)

TeleportTab:AddDropdown({
    Name = "Teleport to Island",
    Default = nil,
    Options = Islands,
    Callback = function(CurrentOption)
        if CurrentOption == "" then
            return
        end
        
        local Island = workspace.Map.Islands:FindFirstChild(CurrentOption)

        if not Island then
            OrionLib:MakeNotification({
                Name = "Error", 
                Content = "That island doesn't currently exist", 
                Image = "rbxassetid://7734068321",
                Time = 5
            })
            return
        end

        if Island:FindFirstChild("LocationSpawn") then
            Player.Character:PivotTo(Island.LocationSpawn.CFrame)
        elseif Island:FindFirstChild("SpawnPoint") then
            Player.Character:PivotTo(Island.SpawnPoint.CFrame)
        elseif CurrentOption ~= "Badlands" then
            Player.Character:PivotTo(Island:GetAttribute("Pivot"))
        else
            Player.Character:PivotTo(Island:GetAttribute("Pivot") + Vector3.yAxis * Island:GetAttribute("Size") / 2)
        end
    end
})

itemsTab:AddButton({ 
    Name = "Quick Sell Inventory", 
    Callback = function()
        local Flags = {
            Sell = {
                CurrentValue = true 
            }
        }

        local function GetInventorySize()
            local Inventory: {[string]: {["Attributes"]: {["Weight"]: number}}} = RemoteFunctions.Player:InvokeServer({
                Command = "GetInventory"
            })

            local InventorySize = 0

            for ID, Object in Inventory do
                InventorySize += 1
            end

            return InventorySize
        end

        local function SellInventory()
            Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

            local Merchant: Model
            for _, v: TextLabel in workspace.Map.Islands:GetDescendants() do
                if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
                    continue
                end
                Merchant = v.Parent.Parent
                break
            end

            if not Merchant then
                warn("No merchant found in the map.")
                return
            end

            local SellEnabled = Flags.Sell.CurrentValue
            local PreviousPosition = Player.Character:GetPivot()
            local PreviousSize = GetInventorySize()

            local Teleported = false
            local StartTime = tick()

            repeat
                Player.Character:PivotTo(Merchant:GetPivot())

                RemoteEvents.Merchant:FireServer({
                    Command = "SellAllTreasures",
                    Merchant = Merchant
                })

                task.wait(0.1)
                Teleported = true
            until GetInventorySize() ~= PreviousSize or Flags.Sell.CurrentValue ~= SellEnabled or tick() - StartTime >= 3

            if Teleported then
                Player.Character:PivotTo(PreviousPosition)
            end
        end

        SellInventory()
    end    
})



local Flags = Flags or {}  
Flags.Sell = Flags.Sell or { CurrentValue = false }

itemsTab:AddToggle({
    Name = "Auto Sell Inventory (When Backpack Full)",
    Default = false,
    Callback = function(Value)
        Flags.Sell.CurrentValue = Value

        local function GetInventorySize()
            local Inventory: {[string]: {["Attributes"]: {["Weight"]: number}}} = RemoteFunctions.Player:InvokeServer({
                Command = "GetInventory"
            })

            local InventorySize = 0

            for ID, Object in Inventory do
                InventorySize += 1
            end

            return InventorySize
        end

        local function SellInventory()
            Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

            local Merchant: Model

            for _, v: TextLabel in workspace.Map.Islands:GetDescendants() do
                if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
                    continue
                end

                Merchant = v.Parent.Parent
                break
            end

            local SellEnabled = Flags.Sell.CurrentValue
            local PreviousPosition = Player.Character:GetPivot()
            local PreviousSize = GetInventorySize()

            local Teleported = false
            local StartTime = tick()

            repeat
                Player.Character:PivotTo(Merchant:GetPivot())

                RemoteEvents.Merchant:FireServer({
                    Command = "SellAllTreasures",
                    Merchant = Merchant
                })

                task.wait(0.1)
                Teleported = true
            until GetInventorySize() ~= PreviousSize or Flags.Sell.CurrentValue ~= SellEnabled or tick() - StartTime >= 3

            if Teleported then
                Player.Character:PivotTo(PreviousPosition)
            end
        end

        while Flags.Sell.CurrentValue and task.wait() do
            if GetInventorySize() < Player:GetAttribute("MaxInventorySize") + 9 then
                print("InventorySize:", GetInventorySize(), "Max:", Player:GetAttribute("MaxInventorySize") + 9)
                continue
            end

            SellInventory()
        end
    end
})


local Section = ShopTab:AddSection({
	Name = "Magnets"
})



local magnetBoxAmount = 1

ShopTab:AddSlider({
    Name = "Amount of Magnet Boxes",
    Min = 1,
    Max = 100,
    Default = magnetBoxAmount,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "boxes",
    Callback = function(value)
        magnetBoxAmount = value
    end
})

ShopTab:AddButton({
    Name = "Purchase Magnet Boxes",
    Callback = function()
        RemoteFunctions.Shop:InvokeServer({
            Command = "Buy",
            Type = "Item",
            Product = "Magnet Box",
            Amount = magnetBoxAmount
        })
    end
})

local Section = ShopTab:AddSection({
	Name = "Shovel"
})


ShopTab:AddDropdown({
    Name = "Purchase Shovel",
    Default = nil,
    Options = Shovels,
    Callback = function(CurrentOption)
        if not CurrentOption or CurrentOption == "" then
            return
        end

        RemoteFunctions.Shop:InvokeServer({
            Command = "Buy",
            Type = "Item",
            Product = OriginalShovelNames[CurrentOption].Name,
            Amount = 1
        })
    end    
})

itemsTab:AddButton({
    Name = "Quick Appraise Held Item",
    Callback = function()
        RemoteFunctions.LootPit:InvokeServer({
            Command = "AppraiseItem"
        })
    end
})


local CollectedRewards = {}

local Flags = {
    Salary = { CurrentValue = false }
}

itemsTab:AddToggle({ 
    Name = "Auto Collect Salary Rewards",
    Default = false,
    Callback = function(Value)
        Flags.Salary.CurrentValue = Value
        
        while Flags.Salary.CurrentValue and task.wait() do
            local TierTimers = RemoteFunctions.TimeRewards:InvokeServer({
                Command = "GetSessionTimers"
            })

            for Tier, Timer in TierTimers do
                if Timer ~= 0 then
                    CollectedRewards[Tier] = false
                    continue
                end

                if CollectedRewards[Tier] then
                    continue
                end

                RemoteFunctions.TimeRewards:InvokeServer({
                    Command = "RedeemTier",
                    Tier = Tier
                })

                CollectedRewards[Tier] = true
            end

            task.wait(5)
        end
    end    
})


local HideGui = false  

local Toggle = MiscTab:AddToggle({
    Name = "Hide/Show UIs",  
    Default = false,  
    Callback = function(newState)
        HideGui = newState  

        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.Enabled = not HideGui 
            end
        end
    end    
})

for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then
        gui.Enabled = not HideGui 
    end
end

MiscTab:AddToggle({
    Name = "Freeze Character",
    Default = false,
    Callback = function(state)
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if state then
                player.Character.HumanoidRootPart.Anchored = true
                print("bro saw baddie and bro got Shocked.")
            else
                player.Character.HumanoidRootPart.Anchored = false
                print("bro saw ugly ass and start moving.")
            end
        else
            warn("Player or HumanoidRootPart not found!")
        end
    end
})


MiscTab:AddButton({ 
	Name = "AntiAFK",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))();
  	end    
})

MiscTab:AddToggle({
    Name = "Disable Swimming",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game.Players.LocalPlayer
        local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        if LocalCharacter and LocalCharacter:FindFirstChild("Humanoid") then
            local Humanoid = LocalCharacter:FindFirstChild("Humanoid")
            if Humanoid then
                if state then
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                    print("bro why you stop swimming")
                else
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                    print("bro start swimming")
                end
            end
        else
            warn("Humanoid not found!")
        end
    end
})


local BlackGui = Instance.new("ScreenGui")
BlackGui.Name = "BlackGui"
BlackGui.ResetOnSpawn = false
local blackFrame = Instance.new("Frame")
blackFrame.Name = "BlackFrame"
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BackgroundTransparency = 1
blackFrame.Parent = BlackGui
BlackGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local WhiteGui = Instance.new("ScreenGui")
WhiteGui.Name = "WhiteGui"
WhiteGui.ResetOnSpawn = false
local whiteFrame = Instance.new("Frame")
whiteFrame.Name = "WhiteFrame"
whiteFrame.Size = UDim2.new(1, 0, 1, 0)
whiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
whiteFrame.BackgroundTransparency = 1
whiteFrame.Parent = WhiteGui
WhiteGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MiscTab:AddToggle({ 
    Name = "Black Screen", 
    Default = false, 
    Callback = function(toggleState)
        if toggleState then
            blackFrame.BackgroundTransparency = 0
        else
            blackFrame.BackgroundTransparency = 1
        end
    end    
})

MiscTab:AddToggle({ 
    Name = "White Screen", 
    Default = false, 
    Callback = function(toggleState)
        if toggleState then
            whiteFrame.BackgroundTransparency = 0
        else
            whiteFrame.BackgroundTransparency = 1
        end
    end    
})


MiscTab:AddButton({ 
	Name = "Infiniteyield Reborn",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RyXeleron/infiniteyield-reborn/refs/heads/scriptblox/source"))()
  	end    
})


local Section = MiscTab:AddSection({
	Name = "Character"
})

MiscTab:AddToggle({ 
    Name = "T + Left Click Teleport", 
    Default = false, 
    Callback = function(Value)
        if not hasUserToggled and not isTeleportEnabled then
            hasUserToggled = true
            isTeleportEnabled = Value
            return
        end

        isTeleportEnabled = Value
        if Value then
            if not connection then
                connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and isTeleportEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.T) then
                            local player = game:GetService("Players").LocalPlayer
                            local mouse = player:GetMouse()
                            player.Character:MoveTo(Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z))
                        end
                    end
                end)
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end    
})

MiscTab:AddToggle({ 
    Name = "Infinite Jumps", 
    Default = false, 
    Callback = function(Value)
        _G.infinjump = Value
    end    
})

if not _G.infinJumpStarted then
    _G.infinJumpStarted = true
    _G.infinjump = false

    local plr = game:GetService('Players').LocalPlayer
    local m = plr:GetMouse()

    m.KeyDown:Connect(function(key)
        if _G.infinjump then
            if key:byte() == 32 then
                local humanoid = plr.Character and plr.Character:FindFirstChildOfClass('Humanoid')
                if humanoid then
                    humanoid:ChangeState('Jumping')
                    wait()
                    humanoid:ChangeState('Seated')
                end
            end
        end
    end)
end

local Noclip = nil
local Clip = true

function noclip()
    Clip = false
    local function Nocl()
        if Clip == false and game.Players.LocalPlayer.Character ~= nil then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21)
    end
    Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

function clip()
    if Noclip then 
        Noclip:Disconnect()
    end
    Clip = true
    if game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA('BasePart') and v.CanCollide == false then
                v.CanCollide = true
            end
        end
    end
end

MiscTab:AddToggle({ 
    Name = "Noclip", 
    Default = false, 
    Callback = function(state)
        if state then
            noclip()
        else
            clip()
        end
    end    
})

MiscTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "WalkSpeed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MiscTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "JumpPower",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local runService = game:GetService("RunService")
local event

MiscTab:AddSlider({
    Name = "Gravity",
    Min = 0,
    Max = 500,
    Default = 196,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "Gravity",
    Callback = function(Value)
        print("Gravity slider changed to:", Value)
        if event then
            event:Disconnect()
        end
        event = runService.RenderStepped:Connect(function()
            workspace.Gravity = Value
        end)
    end
})

MiscTab:AddSlider({
    Name = "HipHeight",
    Min = 0,
    Max = 500,
    Default = 0,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 1,
    ValueName = "HipHeight",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = Value
    end
})

MiscTab:AddTextbox({
    Name = "Change FOV",
    Default = "70",
    TextDisappear = true,
    Callback = function(Value)
        local fov = tonumber(Value)
        if fov then
            game.Workspace.Camera.FieldOfView = fov
            print("FOV set to:", fov)
        else
            warn("Invalid FOV value entered")
        end
    end
})




local Section = mainTab:AddSection({
	Name = "Teleport to position"
})


local selectedPosition = nil
local teleporting = false

mainTab:AddButton({
    Name = "Select Position",
    Callback = function()
        local player = game.Players.LocalPlayer
        if not player then
            print("No player found.")
            return
        end

        local character = player.Character or player.CharacterAdded:Wait()
        if not character then
            print("No character found.")
            return
        end

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        if not humanoidRootPart then
            print("HumanoidRootPart not found.")
            return
        end

        print("Player position: " .. tostring(humanoidRootPart.Position))

        local position = humanoidRootPart.Position
        selectedPosition = CFrame.new(position) * humanoidRootPart.CFrame.Rotation
    end
})

mainTab:AddToggle({
    Name = "Teleport to selected location",
    Default = false,
    Callback = function(state)
        if state then
            print("Toggle On")
            teleporting = true
            while teleporting do
                local player = game.Players.LocalPlayer
                if player and selectedPosition then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = selectedPosition
                    end
                end
                task.wait()
            end
        else
            print("Toggle Off")
            teleporting = false
        end
    end
})

local Section = mainTab:AddSection({
	Name = "Digging"
})


local Flags = Flags or {}

Flags.CreatePiles = Flags.CreatePiles or { CurrentValue = false }
Flags.LegitPiles = Flags.LegitPiles or { CurrentValue = false }
Flags.LegitDig = Flags.LegitDig or { CurrentValue = false }

mainTab:AddToggle({
    Name = "Auto Create Piles on Any Terrain",
    Default = false,
    Callback = function(Value)    
        Flags.CreatePiles.CurrentValue = Value 
        while Flags.CreatePiles.CurrentValue and task.wait() do    
            if Player:GetAttribute("PileCount") ~= 0 then
                continue
            end
            
            local PileInfo: {["PileIndex"]: number, ["Success"]: boolean} = RemoteFunctions.Digging:InvokeServer({
                Command = "CreatePile"
            })
            
            if PileInfo.Success then
                RemoteEvents.Digging:FireServer({
                    Command = "DigIntoSandSound"
                })
            end
        end
    end
})

mainTab:AddToggle({
    Name = "Auto Legit Create Piles (Works with Legit Dig)",
    Default = false,
    Callback = function(Value)    
        Flags.LegitPiles.CurrentValue = Value 
        while Flags.LegitPiles.CurrentValue and task.wait() do
            local Tool = Player.Character:FindFirstChildOfClass("Tool")
            
            if not Tool or Tool:GetAttribute("Type") ~= "Shovel" then
                continue
            end
            
            local PileAdornee: Model? = Player.Character.Shovel.Highlight.Adornee

            if PileAdornee and PileAdornee:GetAttribute("Blacklisted") then
                continue
            end
            
            Tool:Activate()
        end
    end
})







mainTab:AddToggle({
    Name = "Auto Fast Dig",
    Default = false,
    Callback = function(Value)
        while Value and task.wait() do
            if not Player.Character:FindFirstChildOfClass("Tool") then
                continue
            end

            local Adornee: Model? = Player.Character.Shovel.Highlight.Adornee

            if not Adornee or Adornee.Parent ~= workspace.Map.TreasurePiles or Adornee:GetAttribute("Blacklisted") then
                continue
            end

            RemoteFunctions.Digging:InvokeServer({
                Command = "DigPile",
                TargetPileIndex = Adornee:GetAttribute("PileIndex")
            })
        end
    end
})

local function LegitDig()
    if not Flags.LegitDig.CurrentValue then
        return
    end

    local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

    if not DigMinigame then
        return
    end

    local Connection: RBXScriptConnection
    Connection = game:GetService("RunService").Heartbeat:Connect(function()
        local DigMinigame = Player.PlayerGui.Main:FindFirstChild("DigMinigame")

        if not DigMinigame or not Flags.LegitDig.CurrentValue then
            return Connection:Disconnect()
        end

        DigMinigame.Cursor.Position = DigMinigame.Area.Position
    end)

    HandleConnection(Connection, "LegitDigHeartbeat")
end

mainTab:AddToggle({
    Name = "Auto Legit Dig",
    Default = false,
    Callback = function(Value)
        Flags.LegitDig.CurrentValue = Value  
        if Value then
            LegitDig()
        end
    end
})

HandleConnection(Player.PlayerGui.Main.ChildAdded:Connect(LegitDig), "LegitDig")