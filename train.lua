--[[
═══════════════════════════════════════════════════════════
    TRAIN TO FIGHT - TRAINING MULTIPLIER
    Version: 3.0 (Fixed - Training Multiplier)
    
    Multiply HASIL TRAINING (bukan stats yang ada)
    Training +18 → dengan x40 jadi +720
═══════════════════════════════════════════════════════════
]]

repeat wait() until game:IsLoaded()
wait(1)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════
-- ⚙️ KONFIGURASI (EDIT DI SINI)
-- ═══════════════════════════════════════════════════════════

getgenv().Config = getgenv().Config or {
    -- TRAINING MULTIPLIER (hasil training dikali berapa)
    TrainMultiplier = 40,       -- Training +18 → +720 (18 x 40)
    
    -- AUTO TRAINING
    AutoTrain = true,           -- Auto training on/off
    TrainDelay = 0.1,           -- Delay antar training (seconds) - lebih cepat!
    TrainBodyParts = {          -- Body parts yang mau di-train
        "Arms",
        "Back", 
        "Legs",
        "Agility",
    },
    RotateTraining = true,      -- true = rotasi, false = train semua sekaligus
    
    -- CHARACTER BOOST
    WalkSpeed = 100,            -- Default: 16
    JumpPower = 100,            -- Default: 50
    AutoApplySpeed = true,      -- Auto apply speed setiap spawn
    
    -- ANTI-AFK
    AntiAFK = true,
    
    -- GUI SETTINGS
    ShowGUI = true,
    GUIPosition = UDim2.new(0.85, 0, 0.3, 0),
}

-- ═══════════════════════════════════════════════════════════
-- 📡 NOTIFIKASI SISTEM
-- ═══════════════════════════════════════════════════════════

local function Notify(title, text, duration)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🎮 " .. title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

Notify("Train to Fight", "Loading script...", 3)

-- ═══════════════════════════════════════════════════════════
-- 🔍 FIND TRAINING REMOTE (AUTO DETECT)
-- ═══════════════════════════════════════════════════════════

local TrainRemote = nil
local trainAttempts = 0

local function FindTrainingRemote()
    print("🔍 Searching for training remote...")
    
    -- Possible remote names untuk Train to Fight
    local possibleNames = {
        "Train",
        "TrainEvent", 
        "Training",
        "Workout",
        "Exercise",
        "AddStats",
        "UpdateStats",
        "IncreaseStats"
    }
    
    -- Search di ReplicatedStorage
    for _, name in ipairs(possibleNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            TrainRemote = remote
            print("✓ Found training remote:", remote:GetFullName())
            Notify("Remote Found", remote.Name, 2)
            return true
        end
    end
    
    -- Search in descendants
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            if name:find("train") or name:find("workout") or name:find("stat") then
                TrainRemote = descendant
                print("✓ Found training remote:", descendant:GetFullName())
                Notify("Remote Found", descendant.Name, 2)
                return true
            end
        end
    end
    
    warn("⚠️ Training remote not found!")
    return false
end

FindTrainingRemote()

-- ═══════════════════════════════════════════════════════════
-- 💪 TRAINING DENGAN MULTIPLIER
-- ═══════════════════════════════════════════════════════════

local function TrainWithMultiplier(bodyPart)
    if not TrainRemote then
        if trainAttempts < 3 then
            trainAttempts = trainAttempts + 1
            FindTrainingRemote()
        end
        return false
    end
    
    local success = pcall(function()
        -- Method 1: FireServer multiple times untuk simulate multiplier
        for i = 1, getgenv().Config.TrainMultiplier do
            if TrainRemote:IsA("RemoteEvent") then
                TrainRemote:FireServer(bodyPart)
            else
                TrainRemote:InvokeServer(bodyPart)
            end
            
            -- Micro delay untuk prevent spam detection
            if i % 10 == 0 then
                wait(0.01)
            end
        end
        
        return true
    end)
    
    if not success then
        -- Fallback: Try tanpa body part argument
        pcall(function()
            for i = 1, getgenv().Config.TrainMultiplier do
                TrainRemote:FireServer()
            end
        end)
    end
    
    return success
end

-- ═══════════════════════════════════════════════════════════
-- 🏋️ AUTO TRAINING LOOP
-- ═══════════════════════════════════════════════════════════

local AutoTrainRunning = false
local trainingStats = {
    Arms = 0,
    Back = 0,
    Legs = 0,
    Agility = 0
}

local function AutoTrain()
    if AutoTrainRunning then return end
    AutoTrainRunning = true
    
    Notify("Auto Train", "Started with x" .. getgenv().Config.TrainMultiplier .. " multiplier!", 3)
    
    spawn(function()
        local currentIndex = 1
        local cycleCount = 0
        
        while getgenv().Config.AutoTrain and AutoTrainRunning do
            local bodyPart = getgenv().Config.TrainBodyParts[currentIndex]
            
            -- Train with multiplier
            local success = TrainWithMultiplier(bodyPart)
            
            if success then
                trainingStats[bodyPart] = trainingStats[bodyPart] + 1
                
                -- Show progress every 10 cycles
                if cycleCount % 10 == 0 then
                    print(string.format("✓ Training %s (x%d) - Cycle: %d", 
                        bodyPart, getgenv().Config.TrainMultiplier, trainingStats[bodyPart]))
                end
            end
            
            -- Rotate or train all
            if getgenv().Config.RotateTraining then
                currentIndex = currentIndex % #getgenv().Config.TrainBodyParts + 1
            else
                -- Train all parts in sequence
                currentIndex = currentIndex + 1
                if currentIndex > #getgenv().Config.TrainBodyParts then
                    currentIndex = 1
                    cycleCount = cycleCount + 1
                end
            end
            
            wait(getgenv().Config.TrainDelay)
        end
        
        AutoTrainRunning = false
        Notify("Auto Train", "Stopped", 2)
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🎯 MANUAL TRAIN (untuk button)
-- ═══════════════════════════════════════════════════════════

local function ManualTrain(bodyPart)
    Notify("Training", bodyPart .. " x" .. getgenv().Config.TrainMultiplier, 2)
    
    spawn(function()
        TrainWithMultiplier(bodyPart)
    end)
end

-- ═══════════════════════════════════════════════════════════
-- ⚡ CHARACTER BOOST
-- ═══════════════════════════════════════════════════════════

local function ApplyCharacterBoost()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = getgenv().Config.WalkSpeed
        humanoid.JumpPower = getgenv().Config.JumpPower
        
        -- Keep speed constant
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= getgenv().Config.WalkSpeed then
                humanoid.WalkSpeed = getgenv().Config.WalkSpeed
            end
        end)
        
        Notify("Speed Boost", string.format("Speed: %d | Jump: %d", 
            getgenv().Config.WalkSpeed, getgenv().Config.JumpPower), 2)
    end
end

-- ═══════════════════════════════════════════════════════════
-- 🛡️ ANTI-AFK
-- ═══════════════════════════════════════════════════════════

if getgenv().Config.AntiAFK then
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🎨 GUI
-- ═══════════════════════════════════════════════════════════

if getgenv().Config.ShowGUI then
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local MultiplierLabel = Instance.new("TextLabel")
    local Container = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    
    ScreenGui.Name = "TrainToFightGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = getgenv().Config.GUIPosition
    MainFrame.Size = UDim2.new(0, 240, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🏋️ Train to Fight"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = Title
    
    MultiplierLabel.Parent = MainFrame
    MultiplierLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    MultiplierLabel.BorderSizePixel = 0
    MultiplierLabel.Position = UDim2.new(0, 10, 0, 55)
    MultiplierLabel.Size = UDim2.new(1, -20, 0, 35)
    MultiplierLabel.Font = Enum.Font.GothamBold
    MultiplierLabel.Text = "💪 Multiplier: x" .. getgenv().Config.TrainMultiplier
    MultiplierLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MultiplierLabel.TextSize = 14
    
    local MultCorner = Instance.new("UICorner")
    MultCorner.CornerRadius = UDim.new(0, 8)
    MultCorner.Parent = MultiplierLabel
    
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 100)
    Container.Size = UDim2.new(1, -20, 1, -110)
    Container.ScrollBarThickness = 4
    Container.BorderSizePixel = 0
    
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    
    local function CreateButton(text, color, callback)
        local Button = Instance.new("TextButton")
        local BtnCorner = Instance.new("UICorner")
        
        Button.Parent = Container
        Button.BackgroundColor3 = color
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 13
        Button.MouseButton1Click:Connect(callback)
        
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = Button
        
        return Button
    end
    
    -- Manual Training Buttons
    CreateButton("💪 Train Arms", Color3.fromRGB(220, 50, 50), function()
        ManualTrain("Arms")
    end)
    
    CreateButton("🦵 Train Legs", Color3.fromRGB(50, 150, 220), function()
        ManualTrain("Legs")
    end)
    
    CreateButton("🔥 Train Back", Color3.fromRGB(220, 150, 50), function()
        ManualTrain("Back")
    end)
    
    CreateButton("⚡ Train Agility", Color3.fromRGB(150, 50, 220), function()
        ManualTrain("Agility")
    end)
    
    -- Auto Train Toggle
    local AutoTrainBtn = CreateButton(
        "🏋️ Auto Train: " .. (getgenv().Config.AutoTrain and "ON" or "OFF"),
        getgenv().Config.AutoTrain and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0),
        function()
            getgenv().Config.AutoTrain = not getgenv().Config.AutoTrain
            AutoTrainBtn.Text = "🏋️ Auto Train: " .. (getgenv().Config.AutoTrain and "ON" or "OFF")
            AutoTrainBtn.BackgroundColor3 = getgenv().Config.AutoTrain and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
            
            if getgenv().Config.AutoTrain then
                AutoTrain()
            else
                AutoTrainRunning = false
            end
        end
    )
    
    CreateButton("⚡ Apply Speed", Color3.fromRGB(0, 120, 215), ApplyCharacterBoost)
    
    CreateButton("❌ Close", Color3.fromRGB(180, 0, 0), function()
        ScreenGui:Destroy()
        getgenv().Config.AutoTrain = false
        AutoTrainRunning = false
        Notify("GUI", "Closed", 2)
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🚀 AUTO INITIALIZATION
-- ═══════════════════════════════════════════════════════════

wait(1)

-- Apply speed on spawn
if getgenv().Config.AutoApplySpeed then
    ApplyCharacterBoost()
    Player.CharacterAdded:Connect(function()
        wait(1)
        ApplyCharacterBoost()
    end)
end

-- Start auto train
if getgenv().Config.AutoTrain then
    AutoTrain()
end

Notify("Train to Fight", "Loaded! Multiplier: x" .. getgenv().Config.TrainMultiplier, 5)

print([[
═══════════════════════════════════════════════════════════
    TRAIN TO FIGHT - TRAINING MULTIPLIER
    
    Training multiplier: x]] .. getgenv().Config.TrainMultiplier .. [[
    
    Normal: +18 per train
    With script: +]] .. (18 * getgenv().Config.TrainMultiplier) .. [[ per train!
    
    • Manual train: Click buttons untuk train sekali
    • Auto train: Toggle untuk train otomatis
    • Multiplier: Edit di Config baris 18
═══════════════════════════════════════════════════════════
]])
