-- Train to Fight - Training Multiplier GUI
-- Simple GUI dengan minimize dan smooth operation

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local Settings = {
    Multiplier = 40,
    AutoTrain = false,
    TrainSpeed = 4,
    Enabled = false
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainMultiplierGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner for MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Train Multiplier"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TopBar

local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(0, 6)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ContentFrame

-- Multiplier Section
local MultiplierLabel = Instance.new("TextLabel")
MultiplierLabel.Size = UDim2.new(1, 0, 0, 20)
MultiplierLabel.Position = UDim2.new(0, 0, 0, 35)
MultiplierLabel.BackgroundTransparency = 1
MultiplierLabel.Text = "Multiplier: 40x"
MultiplierLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
MultiplierLabel.TextSize = 13
MultiplierLabel.Font = Enum.Font.GothamMedium
MultiplierLabel.TextXAlignment = Enum.TextXAlignment.Left
MultiplierLabel.Parent = ContentFrame

local MultiplierSlider = Instance.new("Frame")
MultiplierSlider.Size = UDim2.new(1, 0, 0, 30)
MultiplierSlider.Position = UDim2.new(0, 0, 0, 58)
MultiplierSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MultiplierSlider.BorderSizePixel = 0
MultiplierSlider.Parent = ContentFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = MultiplierSlider

local SliderFill = Instance.new("Frame")
SliderFill.Name = "Fill"
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = MultiplierSlider

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 6)
SliderFillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.BackgroundTransparency = 1
SliderButton.Text = ""
SliderButton.Parent = MultiplierSlider

-- Points Info
local PointsLabel = Instance.new("TextLabel")
PointsLabel.Size = UDim2.new(1, 0, 0, 20)
PointsLabel.Position = UDim2.new(0, 0, 0, 93)
PointsLabel.BackgroundTransparency = 1
PointsLabel.Text = "Expected Points: 1.44K"
PointsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PointsLabel.TextSize = 12
PointsLabel.Font = Enum.Font.Gotham
PointsLabel.TextXAlignment = Enum.TextXAlignment.Left
PointsLabel.Parent = ContentFrame

-- Enable Button
local EnableBtn = Instance.new("TextButton")
EnableBtn.Name = "EnableBtn"
EnableBtn.Size = UDim2.new(1, 0, 0, 40)
EnableBtn.Position = UDim2.new(0, 0, 0, 120)
EnableBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
EnableBtn.Text = "🚀 Enable Multiplier"
EnableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableBtn.TextSize = 15
EnableBtn.Font = Enum.Font.GothamBold
EnableBtn.BorderSizePixel = 0
EnableBtn.Parent = ContentFrame

local EnableBtnCorner = Instance.new("UICorner")
EnableBtnCorner.CornerRadius = UDim.new(0, 8)
EnableBtnCorner.Parent = EnableBtn

-- Auto Train Toggle
local AutoTrainBtn = Instance.new("TextButton")
AutoTrainBtn.Name = "AutoTrainBtn"
AutoTrainBtn.Size = UDim2.new(1, 0, 0, 35)
AutoTrainBtn.Position = UDim2.new(0, 0, 0, 170)
AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
AutoTrainBtn.Text = "Auto Train: OFF"
AutoTrainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTrainBtn.TextSize = 14
AutoTrainBtn.Font = Enum.Font.GothamMedium
AutoTrainBtn.BorderSizePixel = 0
AutoTrainBtn.Parent = ContentFrame

local AutoTrainBtnCorner = Instance.new("UICorner")
AutoTrainBtnCorner.CornerRadius = UDim.new(0, 8)
AutoTrainBtnCorner.Parent = AutoTrainBtn

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 200, 0, 40)
MinimizedFrame.Position = UDim2.new(0.5, -100, 0, 10)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 8)
MinimizedCorner.Parent = MinimizedFrame

local MinimizedLabel = Instance.new("TextLabel")
MinimizedLabel.Size = UDim2.new(1, -40, 1, 0)
MinimizedLabel.Position = UDim2.new(0, 10, 0, 0)
MinimizedLabel.BackgroundTransparency = 1
MinimizedLabel.Text = "🎮 Train Multiplier"
MinimizedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedLabel.TextSize = 14
MinimizedLabel.Font = Enum.Font.GothamBold
MinimizedLabel.TextXAlignment = Enum.TextXAlignment.Left
MinimizedLabel.Parent = MinimizedFrame

local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Size = UDim2.new(0, 30, 0, 30)
RestoreBtn.Position = UDim2.new(1, -35, 0, 5)
RestoreBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
RestoreBtn.Text = "+"
RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RestoreBtn.TextSize = 20
RestoreBtn.Font = Enum.Font.GothamBold
RestoreBtn.BorderSizePixel = 0
RestoreBtn.Parent = MinimizedFrame

local RestoreBtnCorner = Instance.new("UICorner")
RestoreBtnCorner.CornerRadius = UDim.new(0, 6)
RestoreBtnCorner.Parent = RestoreBtn

-- Functions
local function UpdateSlider(value)
    local percent = (value - 40) / 960 -- 40 to 1000 range
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    MultiplierLabel.Text = string.format("Multiplier: %dx", value)
    local expectedPoints = 1.44 * (value / 40)
    PointsLabel.Text = string.format("Expected Points: %.2fK", expectedPoints)
end

local function ToggleMinimize()
    if MainFrame.Visible then
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    else
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
    end
end

-- Slider Logic
local dragging = false
SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = MultiplierSlider.AbsolutePosition.X
        local sliderSize = MultiplierSlider.AbsoluteSize.X
        local relative = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        Settings.Multiplier = math.floor(40 + (relative * 960)) -- 40 to 1000
        UpdateSlider(Settings.Multiplier)
    end
end)

-- Button Events
MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
RestoreBtn.MouseButton1Click:Connect(ToggleMinimize)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

EnableBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        EnableBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        EnableBtn.Text = "⛔ Disable Multiplier"
        StatusLabel.Text = "Status: Active ✓"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        EnableBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
        EnableBtn.Text = "🚀 Enable Multiplier"
        StatusLabel.Text = "Status: Inactive"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

AutoTrainBtn.MouseButton1Click:Connect(function()
    Settings.AutoTrain = not Settings.AutoTrain
    if Settings.AutoTrain then
        AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        AutoTrainBtn.Text = "Auto Train: ON"
    else
        AutoTrainBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        AutoTrainBtn.Text = "Auto Train: OFF"
    end
end)

-- Core Functions
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not Settings.Enabled then return oldNamecall(self, ...) end
    
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and self.Name == "TrainSpeedHasChanged" then
        if args[1] then
            args[1] = args[1] * (Settings.Multiplier / 40)
        end
        return oldNamecall(self, unpack(args))
    end
    
    if method == "Fire" and (self.Name == "StatisticsDataHasChanged" or self.Name == "PlayerCombatPowerHasChanged") then
        if args[2] then
            args[2] = args[2] * (Settings.Multiplier / 40)
        end
        return oldNamecall(self, unpack(args))
    end
    
    return oldNamecall(self, ...)
end)

-- Auto Train Loop
spawn(function()
    while wait(0.5) do
        if Settings.AutoTrain and Settings.Enabled then
            pcall(function()
                local ApplyStationaryTrain = ReplicatedStorage.TrainEquipment.Remote:FindFirstChild("ApplyStationaryTrain")
                if ApplyStationaryTrain then
                    ApplyStationaryTrain:InvokeServer()
                end
            end)
        end
    end
end)

-- Initialize
UpdateSlider(Settings.Multiplier)
print("[Train Multiplier GUI] Loaded successfully!")
