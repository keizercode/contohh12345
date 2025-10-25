--[[
═══════════════════════════════════════════════════════════
    TRAIN TO FIGHT - STATS MULTIPLIER SCRIPT
    Version: 2.0 (GitHub Compatible)
    
    CARA PAKAI:
    1. Copy script ini
    2. Upload ke GitHub (atau Pastebin)
    3. Gunakan: loadstring(game:HttpGet("URL_KAMU"))()
    
    ATAU langsung execute di Delta!
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
    -- MULTIPLIER STATS
    ArmsMultiplier = 10,        -- Multiply Arms
    BackMultiplier = 10,        -- Multiply Back
    LegsMultiplier = 10,        -- Multiply Legs
    ChestMultiplier = 10,       -- Multiply Chest (jika ada)
    
    -- AUTO TRAINING
    AutoTrain = true,           -- Auto training on/off
    TrainDelay = 0.3,          -- Delay antar training (seconds)
    TrainBodyParts = {         -- Body parts yang mau di-train
        "Arms",
        "Back", 
        "Legs",
        -- "Chest", -- Uncomment jika ada
    },
    
    -- CHARACTER BOOST
    WalkSpeed = 100,            -- Default: 16
    JumpPower = 100,            -- Default: 50
    AutoApplySpeed = true,      -- Auto apply speed setiap spawn
    
    -- ANTI-AFK
    AntiAFK = true,
    
    -- AUTO COLLECT (jika ada gems/coins)
    AutoCollect = false,
    
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
            Icon = "rbxassetid://7733992358"
        })
    end)
end

Notify("Train to Fight", "Loading script...", 3)

-- ═══════════════════════════════════════════════════════════
-- 🔍 FIND REMOTES (AUTO DETECT)
-- ═══════════════════════════════════════════════════════════

local TrainRemote = nil
local StatsRemote = nil

local function FindRemotes()
    -- Cari di ReplicatedStorage
    for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            
            -- Detect Training Remote
            if name:find("train") or name:find("workout") or name:find("exercise") then
                TrainRemote = descendant
                print("✓ Found Train Remote:", descendant:GetFullName())
            end
            
            -- Detect Stats Remote
            if name:find("stat") or name:find("point") or name:find("upgrade") then
                StatsRemote = descendant
                print("✓ Found Stats Remote:", descendant:GetFullName())
            end
        end
    end
    
    if not TrainRemote then
        warn("⚠️ Train Remote not found! Using fallback method...")
    end
end

FindRemotes()

-- ═══════════════════════════════════════════════════════════
-- 💪 MULTIPLY STATS FUNCTION
-- ═══════════════════════════════════════════════════════════

local function MultiplyStats()
    local success = pcall(function()
        local leaderstats = Player:FindFirstChild("leaderstats") or Player:FindFirstChild("Stats")
        
        if not leaderstats then
            Notify("Error", "Leaderstats not found!", 3)
            return
        end
        
        local multiplied = {}
        
        -- Arms
        local Arms = leaderstats:FindFirstChild("Arms") or leaderstats:FindFirstChild("Arm")
        if Arms and Arms:IsA("IntValue") or Arms:IsA("NumberValue") then
            local old = Arms.Value
            Arms.Value = old * getgenv().Config.ArmsMultiplier
            table.insert(multiplied, string.format("Arms: %d → %d", old, Arms.Value))
        end
        
        -- Back
        local Back = leaderstats:FindFirstChild("Back")
        if Back and Back:IsA("IntValue") or Back:IsA("NumberValue") then
            local old = Back.Value
            Back.Value = old * getgenv().Config.BackMultiplier
            table.insert(multiplied, string.format("Back: %d → %d", old, Back.Value))
        end
        
        -- Legs
        local Legs = leaderstats:FindFirstChild("Legs") or leaderstats:FindFirstChild("Leg")
        if Legs and Legs:IsA("IntValue") or Legs:IsA("NumberValue") then
            local old = Legs.Value
            Legs.Value = old * getgenv().Config.LegsMultiplier
            table.insert(multiplied, string.format("Legs: %d → %d", old, Legs.Value))
        end
        
        -- Chest (optional)
        local Chest = leaderstats:FindFirstChild("Chest")
        if Chest and Chest:IsA("IntValue") or Chest:IsA("NumberValue") then
            local old = Chest.Value
            Chest.Value = old * getgenv().Config.ChestMultiplier
            table.insert(multiplied, string.format("Chest: %d → %d", old, Chest.Value))
        end
        
        if #multiplied > 0 then
            Notify("Stats Multiplied!", table.concat(multiplied, "\n"), 5)
        else
            Notify("Warning", "No stats found to multiply!", 3)
        end
    end)
    
    if not success then
        Notify("Error", "Failed to multiply stats!", 3)
    end
end

-- ═══════════════════════════════════════════════════════════
-- 🏋️ AUTO TRAINING
-- ═══════════════════════════════════════════════════════════

local AutoTrainRunning = false

local function AutoTrain()
    if AutoTrainRunning then return end
    AutoTrainRunning = true
    
    spawn(function()
        local index = 1
        while getgenv().Config.AutoTrain and AutoTrainRunning do
            pcall(function()
                local bodyPart = getgenv().Config.TrainBodyParts[index]
                
                if TrainRemote then
                    -- Method 1: FireServer dengan body part
                    if TrainRemote:IsA("RemoteEvent") then
                        TrainRemote:FireServer(bodyPart)
                    else
                        TrainRemote:InvokeServer(bodyPart)
                    end
                else
                    -- Method 2: Fallback - cari semua remote yang possible
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and remote.Name:lower():find("train") then
                            remote:FireServer(bodyPart)
                            break
                        end
                    end
                end
                
                -- Rotasi body part
                index = index % #getgenv().Config.TrainBodyParts + 1
            end)
            
            wait(getgenv().Config.TrainDelay)
        end
        AutoTrainRunning = false
    end)
    
    Notify("Auto Train", "Started!", 2)
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
-- 🎨 SIMPLE GUI
-- ═══════════════════════════════════════════════════════════

if getgenv().Config.ShowGUI then
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Container = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    
    ScreenGui.Name = "TrainToFightGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = getgenv().Config.GUIPosition
    MainFrame.Size = UDim2.new(0, 220, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🎮 Train to Fight"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title
    
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 55)
    Container.Size = UDim2.new(1, -20, 1, -65)
    
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
    
    -- Buttons
    local MultiplyBtn = CreateButton("💪 Multiply Stats", Color3.fromRGB(0, 180, 0), MultiplyStats)
    
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
    
    local SpeedBtn = CreateButton("⚡ Apply Speed", Color3.fromRGB(0, 120, 215), ApplyCharacterBoost)
    
    local CloseBtn = CreateButton("❌ Close", Color3.fromRGB(180, 0, 0), function()
        ScreenGui:Destroy()
        getgenv().Config.AutoTrain = false
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

Notify("Train to Fight", "Script loaded! ✓", 5)

print([[
═══════════════════════════════════════════════════════════
    TRAIN TO FIGHT MOD - LOADED
    
    • Multiply Stats: Click button atau panggil MultiplyStats()
    • Auto Train: Toggle di GUI
    • Speed Boost: Applied automatically
    
    Edit Config di baris 21-48 untuk customize!
═══════════════════════════════════════════════════════════
]])
