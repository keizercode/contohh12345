-- Train to Fight - Stats Multiply Mod
-- Modified training script with customizable multipliers

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    Multipliers = {
        Arms = 40,      -- Multiply untuk Arms training
        Legs = 40,      -- Multiply untuk Legs training
        Back = 40,      -- Multiply untuk Back training
        Agility = 40    -- Multiply untuk Agility training
    },
    AutoTrain = {
        Arms = false,
        Legs = false,
        Back = false,
        Agility = false
    },
    TrainDelay = 0.1  -- Delay antar training (detik)
}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainMultiplyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "Train Multiply Mod"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Function untuk membuat section
local function CreateSection(name, yPos)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(0.9, 0, 0, 70)
    Section.Position = UDim2.new(0.05, 0, 0, yPos)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Section.BorderSizePixel = 0
    Section.Parent = MainFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 0, 30)
    Label.Position = UDim2.new(0.05, 0, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Section
    
    local MultiplierBox = Instance.new("TextBox")
    MultiplierBox.Size = UDim2.new(0.25, 0, 0, 25)
    MultiplierBox.Position = UDim2.new(0.05, 0, 0.5, 0)
    MultiplierBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    MultiplierBox.Text = tostring(Config.Multipliers[name])
    MultiplierBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    MultiplierBox.TextSize = 12
    MultiplierBox.Font = Enum.Font.Gotham
    MultiplierBox.PlaceholderText = "x40"
    MultiplierBox.Parent = Section
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = MultiplierBox
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.35, 0, 0, 25)
    ToggleButton.Position = UDim2.new(0.35, 0, 0.5, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = Section
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = ToggleButton
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.2, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0.75, 0, 0.5, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "0"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Parent = Section
    
    -- Update multiplier saat text berubah
    MultiplierBox.FocusLost:Connect(function()
        local value = tonumber(MultiplierBox.Text)
        if value and value > 0 then
            Config.Multipliers[name] = value
        else
            MultiplierBox.Text = tostring(Config.Multipliers[name])
        end
    end)
    
    -- Toggle button
    ToggleButton.MouseButton1Click:Connect(function()
        Config.AutoTrain[name] = not Config.AutoTrain[name]
        if Config.AutoTrain[name] then
            ToggleButton.Text = "ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        else
            ToggleButton.Text = "OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        end
    end)
    
    return StatusLabel
end

-- Buat sections untuk setiap stat
local StatusLabels = {
    Arms = CreateSection("Arms", 50),
    Legs = CreateSection("Legs", 130),
    Back = CreateSection("Back", 210),
    Agility = CreateSection("Agility", 290)
}

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.9, 0, 0, 35)
CloseButton.Position = UDim2.new(0.05, 0, 0, 405)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "Close GUI"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Training functions
local TrainCounts = {Arms = 0, Legs = 0, Back = 0, Agility = 0}

local function TrainStat(statName)
    local multiplier = Config.Multipliers[statName]
    
    -- Cari remote event yang sesuai berdasarkan screenshot
    local success, err = pcall(function()
        for i = 1, multiplier do
            -- Sesuaikan dengan remote yang ada di game
            -- Contoh remote calls berdasarkan pola di screenshot
            if statName == "Arms" then
                ReplicatedStorage.TrainEquipment.Remote.ApplyMobileTrain:FireServer("Arms")
            elseif statName == "Legs" then
                ReplicatedStorage.TrainEquipment.Remote.ApplyMobileTrain:FireServer("Legs")
            elseif statName == "Back" then
                ReplicatedStorage.TrainEquipment.Remote.ApplyMobileTrain:FireServer("Back")
            elseif statName == "Agility" then
                ReplicatedStorage.TrainEquipment.Remote.ApplyMobileTrain:FireServer("Agility")
            end
            
            TrainCounts[statName] = TrainCounts[statName] + 1
            StatusLabels[statName].Text = tostring(TrainCounts[statName])
            
            wait(0.01) -- Small delay antar request
        end
    end)
    
    if not success then
        warn("Training error:", err)
    end
end

-- Main training loop
spawn(function()
    while wait(Config.TrainDelay) do
        for statName, enabled in pairs(Config.AutoTrain) do
            if enabled then
                TrainStat(statName)
            end
        end
    end
end)

-- Info
print("Train Multiply Mod loaded!")
print("Multiply: Arms x" .. Config.Multipliers.Arms)
print("Contoh: Train +18 dengan multiply x40 = 720 per klik")
