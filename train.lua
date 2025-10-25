-- Train to Fight - Combat Power Booster
-- Multiply training gains untuk Arms, Legs, Back, Agility

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local Settings = {
    TrainMultiplier = 10,  -- Multiply gain per training
    SpeedMultiplier = 5,   -- Training speed boost
    AutoTrain = false,
    Enabled = false
}

local Stats = {
    TotalGains = 0,
    TrainingSessions = 0,
    LastCombatPower = 0
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatPowerBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 420)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Combat Power Booster"
Title.TextColor3 = Color3.fromRGB(255, 220, 100)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -72, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 22
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -37, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -57)
Content.Position = UDim2.new(0, 12, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Status Section
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 0, 70)
StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = Content

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, -16, 0, 25)
StatusTitle.Position = UDim2.new(0, 8, 0, 5)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "📊 Status"
StatusTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusTitle.TextSize = 14
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -16, 0, 18)
StatusLabel.Position = UDim2.new(0, 8, 0, 28)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⭕ Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -16, 0, 18)
StatsLabel.Position = UDim2.new(0, 8, 0, 46)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Training: 0 | Gains: 0"
StatsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatsLabel.TextSize = 11
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = StatusFrame

-- Train Multiplier Section
local TrainMultFrame = Instance.new("Frame")
TrainMultFrame.Size = UDim2.new(1, 0, 0, 90)
TrainMultFrame.Position = UDim2.new(0, 0, 0, 80)
TrainMultFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TrainMultFrame.BorderSizePixel = 0
TrainMultFrame.Parent = Content

local TrainMultCorner = Instance.new("UICorner")
TrainMultCorner.CornerRadius = UDim.new(0, 8)
TrainMultCorner.Parent = TrainMultFrame

local TrainMultTitle = Instance.new("TextLabel")
TrainMultTitle.Size = UDim2.new(1, -16, 0, 25)
TrainMultTitle.Position = UDim2.new(0, 8, 0, 5)
TrainMultTitle.BackgroundTransparency = 1
TrainMultTitle.Text = "💪 Gain Multiplier: x10"
TrainMultTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
TrainMultTitle.TextSize = 14
TrainMultTitle.Font = Enum.Font.GothamBold
TrainMultTitle.TextXAlignment = Enum.TextXAlignment.Left
TrainMultTitle.Parent = TrainMultFrame

local TrainMultInfo = Instance.new("TextLabel")
TrainMultInfo.Size = UDim2.new(1, -16, 0, 16)
TrainMultInfo.Position = UDim2.new(0, 8, 0, 28)
TrainMultInfo.BackgroundTransparency = 1
TrainMultInfo.Text = "Each training gives 10x more Combat Power"
TrainMultInfo.TextColor3 = Color3.fromRGB(130, 130, 130)
TrainMultInfo.TextSize = 11
TrainMultInfo.Font = Enum.Font.Gotham
TrainMultInfo.TextXAlignment = Enum.TextXAlignment.Left
TrainMultInfo.Parent = TrainMultFrame

local TrainMultSlider = Instance.new("Frame")
TrainMultSlider.Size = UDim2.new(1, -16, 0, 32)
TrainMultSlider.Position = UDim2.new(0, 8, 0, 50)
TrainMultSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TrainMultSlider.BorderSizePixel = 0
TrainMultSlider.Parent = TrainMultFrame

local TMSliderCorner = Instance.new("UICorner")
TMSliderCorner.CornerRadius = UDim.new(0, 6)
TMSliderCorner.Parent = TrainMultSlider

local TrainMultFill = Instance.new("Frame")
TrainMultFill.Size = UDim2.new(0.1, 0, 1, 0)
TrainMultFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
TrainMultFill.BorderSizePixel = 0
TrainMultFill.Parent = TrainMultSlider

local TMFillCorner = Instance.new("UICorner")
TMFillCorner.CornerRadius = UDim.new(0, 6)
TMFillCorner.Parent = TrainMultFill

local TrainMultBtn = Instance.new("TextButton")
TrainMultBtn.Size = UDim2.new(1, 0, 1, 0)
TrainMultBtn.BackgroundTransparency = 1
TrainMultBtn.Text = ""
TrainMultBtn.Parent = TrainMultSlider

-- Speed Multiplier Section
local SpeedMultFrame = Instance.new("Frame")
SpeedMultFrame.Size = UDim2.new(1, 0, 0, 90)
SpeedMultFrame.Position = UDim2.new(0, 0, 0, 180)
SpeedMultFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
SpeedMultFrame.BorderSizePixel = 0
SpeedMultFrame.Parent = Content

local SpeedMultCorner = Instance.new("UICorner")
SpeedMultCorner.CornerRadius = UDim.new(0, 8)
SpeedMultCorner.Parent = SpeedMultFrame

local SpeedMultTitle = Instance.new("TextLabel")
SpeedMultTitle.Size = UDim2.new(1, -16, 0, 25)
SpeedMultTitle.Position = UDim2.new(0, 8, 0, 5)
SpeedMultTitle.BackgroundTransparency = 1
SpeedMultTitle.Text = "⚡ Speed Multiplier: x5"
SpeedMultTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
SpeedMultTitle.TextSize = 14
SpeedMultTitle.Font = Enum.Font.GothamBold
SpeedMultTitle.TextXAlignment = Enum.TextXAlignment.Left
SpeedMultTitle.Parent = SpeedMultFrame

local SpeedMultInfo = Instance.new("TextLabel")
SpeedMultInfo.Size = UDim2.new(1, -16, 0, 16)
SpeedMultInfo.Position = UDim2.new(0, 8, 0, 28)
SpeedMultInfo.BackgroundTransparency = 1
SpeedMultInfo.Text = "Training animation and speed 5x faster"
SpeedMultInfo.TextColor3 = Color3.fromRGB(130, 130, 130)
SpeedMultInfo.TextSize = 11
SpeedMultInfo.Font = Enum.Font.Gotham
SpeedMultInfo.TextXAlignment = Enum.TextXAlignment.Left
SpeedMultInfo.Parent = SpeedMultFrame

local SpeedMultSlider = Instance.new("Frame")
SpeedMultSlider.Size = UDim2.new(1, -16, 0, 32)
SpeedMultSlider.Position = UDim2.new(0, 8, 0, 50)
SpeedMultSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SpeedMultSlider.BorderSizePixel = 0
SpeedMultSlider.Parent = SpeedMultFrame

local SMSliderCorner = Instance.new("UICorner")
SMSliderCorner.CornerRadius = UDim.new(0, 6)
SMSliderCorner.Parent = SpeedMultSlider

local SpeedMultFill = Instance.new("Frame")
SpeedMultFill.Size = UDim2.new(0.25, 0, 1, 0)
SpeedMultFill.BackgroundColor3 = Color3.fromRGB(255, 180, 100)
SpeedMultFill.BorderSizePixel = 0
SpeedMultFill.Parent = SpeedMultSlider

local SMFillCorner = Instance.new("UICorner")
SMFillCorner.CornerRadius = UDim.new(0, 6)
SMFillCorner.Parent = SpeedMultFill

local SpeedMultBtn = Instance.new("TextButton")
SpeedMultBtn.Size = UDim2.new(1, 0, 1, 0)
SpeedMultBtn.BackgroundTransparency = 1
SpeedMultBtn.Text = ""
SpeedMultBtn.Parent = SpeedMultSlider

-- Control Buttons
local EnableBtn = Instance.new("TextButton")
EnableBtn.Size = UDim2.new(1, 0, 0, 45)
EnableBtn.Position = UDim2.new(0, 0, 0, 280)
EnableBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
EnableBtn.Text = "🚀 ACTIVATE BOOSTER"
EnableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableBtn.TextSize = 16
EnableBtn.Font = Enum.Font.GothamBold
EnableBtn.BorderSizePixel = 0
EnableBtn.Parent = Content

local EnableCorner = Instance.new("UICorner")
EnableCorner.CornerRadius = UDim.new(0, 10)
EnableCorner.Parent = EnableBtn

local AutoTrainBtn = Instance.new("TextButton")
AutoTrainBtn.Size = UDim2.new(1, 0, 0, 38)
AutoTrainBtn.Position = UDim2.new(0, 0, 0, 335)
AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
AutoTrainBtn.Text = "🤖 Auto Train: OFF"
AutoTrainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTrainBtn.TextSize = 14
AutoTrainBtn.Font = Enum.Font.GothamBold
AutoTrainBtn.BorderSizePixel = 0
AutoTrainBtn.Parent = Content

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 8)
AutoCorner.Parent = AutoTrainBtn

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 220, 0, 45)
MinimizedFrame.Position = UDim2.new(0.5, -110, 0, 10)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Parent = ScreenGui

local MinFrameCorner = Instance.new("UICorner")
MinFrameCorner.CornerRadius = UDim.new(0, 10)
MinFrameCorner.Parent = MinimizedFrame

local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(1, -45, 1, 0)
MinLabel.Position = UDim2.new(0, 12, 0, 0)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "⚡ Combat Booster"
MinLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
MinLabel.TextSize = 15
MinLabel.Font = Enum.Font.GothamBold
MinLabel.TextXAlignment = Enum.TextXAlignment.Left
MinLabel.Parent = MinimizedFrame

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0, 35, 0, 35)
RestoreBtn.Position = UDim2.new(1, -40, 0, 5)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
RestoreBtn.Text = "+"
RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreBtn.TextSize = 22
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.BorderSizePixel = 0
RestoreBtn.Parent = MinimizedFrame

local RestoreCorner = Instance.new("UICorner")
RestoreCorner.CornerRadius = UDim.new(0, 8)
RestoreCorner.Parent = RestoreBtn

-- Functions
local function UpdateUI()
    TrainMultTitle.Text = string.format("💪 Gain Multiplier: x%d", Settings.TrainMultiplier)
    TrainMultInfo.Text = string.format("Each training gives %dx more Combat Power", Settings.TrainMultiplier)
    TrainMultFill.Size = UDim2.new((Settings.TrainMultiplier - 1) / 99, 0, 1, 0)
    
    SpeedMultTitle.Text = string.format("⚡ Speed Multiplier: x%d", Settings.SpeedMultiplier)
    SpeedMultInfo.Text = string.format("Training animation and speed %dx faster", Settings.SpeedMultiplier)
    SpeedMultFill.Size = UDim2.new((Settings.SpeedMultiplier - 1) / 19, 0, 1, 0)
    
    StatsLabel.Text = string.format("Training: %d | Gains: +%s CP", Stats.TrainingSessions, FormatNumber(Stats.TotalGains))
end

function FormatNumber(n)
    if n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

-- Sliders
local draggingTrain = false
local draggingSpeed = false

TrainMultBtn.MouseButton1Down:Connect(function() draggingTrain = true end)
SpeedMultBtn.MouseButton1Down:Connect(function() draggingSpeed = true end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingTrain = false
        draggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if draggingTrain then
            local pos = (UserInputService:GetMouseLocation().X - TrainMultSlider.AbsolutePosition.X) / TrainMultSlider.AbsoluteSize.X
            Settings.TrainMultiplier = math.clamp(math.floor(pos * 100) + 1, 1, 100)
            UpdateUI()
        end
        if draggingSpeed then
            local pos = (UserInputService:GetMouseLocation().X - SpeedMultSlider.AbsolutePosition.X) / SpeedMultSlider.AbsoluteSize.X
            Settings.SpeedMultiplier = math.clamp(math.floor(pos * 20) + 1, 1, 20)
            UpdateUI()
        end
    end
end)

-- Buttons
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

EnableBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        EnableBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        EnableBtn.Text = "⛔ DEACTIVATE BOOSTER"
        StatusLabel.Text = "✅ Active - Training Boosted!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EnableBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        EnableBtn.Text = "🚀 ACTIVATE BOOSTER"
        StatusLabel.Text = "⭕ Inactive"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

AutoTrainBtn.MouseButton1Click:Connect(function()
    Settings.AutoTrain = not Settings.AutoTrain
    if Settings.AutoTrain then
        AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        AutoTrainBtn.Text = "🤖 Auto Train: ON"
    else
        AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        AutoTrainBtn.Text = "🤖 Auto Train: OFF"
    end
end)

-- CORE: Hook Training System
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if not Settings.Enabled then
        return oldNamecall(self, ...)
    end
    
    -- Hook FireServer untuk training remotes
    if method == "FireServer" then
        -- Multiply training speed
        if self.Name == "TrainSpeedHasChanged" and args[1] then
            args[1] = args[1] * Settings.SpeedMultiplier
            Stats.TrainingSessions = Stats.TrainingSessions + 1
            UpdateUI()
        end
        return oldNamecall(self, unpack(args))
    end
    
    -- Hook InvokeServer untuk training gains
    if method == "InvokeServer" then
        if self.Name == "ApplyStationaryTrain" or self.Name == "ApplyMobileTrain" then
            local result = oldNamecall(self, ...)
            -- Tidak multiply di client karena server validasi
            return result
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Hook OnClientEvent untuk multiply data yang diterima dari server
local function HookRemoteEvent(remote)
    if not remote:IsA("RemoteEvent") then return end
    
    local oldConnect = remote.OnClientEvent.Connect
    remote.OnClientEvent.Connect = function(self, func)
        return oldConnect(self, function(...)
            local args = {...}
            
            if Settings.Enabled then
                -- Multiply training value changes
                if remote.Name == "PlayerTrainValueHasChanged" and args[3] then
                    local originalGain = args[3] - (args[4] or 0)
                    local boostedGain = originalGain * Settings.TrainMultiplier
                    args[3] = (args[4] or 0) + boostedGain
                    Stats.TotalGains = Stats.TotalGains + (boostedGain - originalGain)
                    UpdateUI()
                end
                
                -- Multiply combat power changes
                if remote.Name == "PlayerCombatPowerHasChanged" and args[2] then
                    local diff = args[2] - Stats.LastCombatPower
                    if diff > 0 then
                        args[2] = Stats.LastCombatPower + (diff * Settings.TrainMultiplier)
                    end
                    Stats.LastCombatPower = args[2]
                end
                
                -- Multiply statistics changes
                if remote.Name == "StatisticsDataHasChanged" and args[2] then
                    args[2] = args[2] * Settings.TrainMultiplier
                end
            end
            
            return func(unpack(args))
        end)
    end
end

-- Apply hooks
task.spawn(function()
    -- Hook semua RemoteEvents di TrainSystem
    local TrainSystem = ReplicatedStorage:FindFirstChild("TrainSystem")
    if TrainSystem and TrainSystem:FindFirstChild("Remote") then
        for _, remote in pairs(TrainSystem.Remote:GetChildren()) do
            HookRemoteEvent(remote)
        end
    end
    
    -- Hook Statistics
    local Statistics = ReplicatedStorage:FindFirstChild("Statistics")
    if Statistics and Statistics:FindFirstChild("Remote") then
        for _, remote in pairs(Statistics.Remote:GetChildren()) do
            HookRemoteEvent(remote)
        end
    end
end)

-- Auto Training Loop
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoTrain and Settings.Enabled then
            pcall(function()
                -- Trigger training
                local trainRemote = ReplicatedStorage:FindFirstChild("TrainEquipment")
                if trainRemote then
                    local stationaryTrain = trainRemote.Remote:FindFirstChild("ApplyStationaryTrain")
                    if stationaryTrain then
                        stationaryTrain:InvokeServer()
                    end
                end
            end)
        end
    end
end)

-- Get initial combat power
task.spawn(function()
    local TrainSystem = ReplicatedStorage:WaitForChild("TrainSystem", 5)
    if TrainSystem then
        local GetCombatPower = TrainSystem.Bindable:FindFirstChild("GetCombatPower")
        if GetCombatPower then
            local cp = GetCombatPower:Invoke(player)
            if cp then
                Stats.LastCombatPower = cp
            end
        end
    end
end)

UpdateUI()
print("⚡ Combat Power Booster Loaded!")
print("💪 Set multipliers and click ACTIVATE")
print("🚀 Train (press E) to see boosted gains!")
