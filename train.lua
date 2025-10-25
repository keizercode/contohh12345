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
    AgilityMultiplier = 10,     -- Multiply Agility
    
    -- AUTO TRAINING
    AutoTrain = true,           -- Auto training on/off
    TrainDelay = 0.3,          -- Delay antar training (seconds)
    TrainBodyParts = {         -- Body parts yang mau di-train
        "Arms",
        "Back", 
        "Legs",
        "Agility",
    },
    
    -- CHARACTER BOOST
    WalkSpeed = 300,            -- Default: 16
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
-- 💪 MULTIPLY STATS FUNCTION (FIXED)
-- ═══════════════════════════════════════════════════════════

local function MultiplyStats()
    local success, errorMsg = pcall(function()
        wait(0.5) -- Delay untuk ensure stats loaded
        
        -- Cari di berbagai lokasi possible
        local statsFolder = Player:FindFirstChild("leaderstats") 
            or Player:FindFirstChild("Stats")
            or Player:FindFirstChild("PlayerStats")
            or Player.Character and Player.Character:FindFirstChild("Stats")
        
        if not statsFolder then
            -- Cari di PlayerGui atau PlayerScripts
            for _, location in pairs({Player.PlayerGui, Player.PlayerScripts, Player.Backpack}) do
                local found = location:FindFirstChild("leaderstats") or location:FindFirstChild("Stats")
                if found then
                    statsFolder = found
                    break
                end
            end
        end
        
        if not statsFolder then
            Notify("Debug", "Searching in all Player children...", 2)
            -- Debug: Print semua children
            for _, child in pairs(Player:GetChildren()) do
                print("Player child:", child.Name, child.ClassName)
            end
            
            Notify("Error", "Stats folder not found!\nCheck console (F9) for debug info", 5)
            return
        end
        
        print("✓ Stats folder found:", statsFolder:GetFullName())
        
        local multiplied = {}
        -- Stats yang ada di Train to Fight
        local statsList = {
            {name = "Arms", multiplier = getgenv().Config.ArmsMultiplier},
            {name = "Back", multiplier = getgenv().Config.BackMultiplier},
            {name = "Legs", multiplier = getgenv().Config.LegsMultiplier},
            {name = "Agility", multiplier = getgenv().Config.AgilityMultiplier},
        }
        
        -- Loop through semua stats
        for _, statInfo in ipairs(statsList) do
            local stat = statsFolder:FindFirstChild(statInfo.name)
            
            if stat then
                print("✓ Found stat:", statInfo.name, "Type:", stat.ClassName, "Value:", stat.Value)
                
                -- Check if it's a value object
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    local oldValue = tonumber(stat.Value) or 0
                    
                    if oldValue >= 0 then -- Allow 0 value
                        local newValue = oldValue * statInfo.multiplier
                        
                        -- Update value
                        stat.Value = newValue
                        
                        table.insert(multiplied, string.format("%s: %d → %d", 
                            statInfo.name, oldValue, newValue))
                        print(string.format("✓ Multiplied %s: %d → %d (x%d)", 
                            statInfo.name, oldValue, newValue, statInfo.multiplier))
                    end
                elseif stat:IsA("StringValue") then
                    -- Jika stats disimpan sebagai string
                    local oldValue = tonumber(stat.Value) or 0
                    if oldValue >= 0 then
                        local newValue = oldValue * statInfo.multiplier
                        stat.Value = tostring(newValue)
                        table.insert(multiplied, string.format("%s: %d → %d", 
                            statInfo.name, oldValue, newValue))
                    end
                end
            else
                print("⚠️ Stat not found:", statInfo.name)
            end
        end
        
        if #multiplied > 0 then
            Notify("Stats Multiplied! ✓", table.concat(multiplied, "\n"), 6)
        else
            -- Debug info
            Notify("Warning", "No valid stats found to multiply!", 4)
            print("Available children in stats folder:")
            for _, child in pairs(statsFolder:GetChildren()) do
                print(" -", child.Name, child.ClassName, 
                    child:IsA("ValueBase") and ("Value: " .. tostring(child.Value)) or "")
            end
        end
    end)
    
    if not success then
        Notify("Error", "Multiply failed!\n" .. tostring(errorMsg), 5)
        warn("Multiply Stats Error:", errorMsg)
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
