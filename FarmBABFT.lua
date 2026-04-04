--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
   BABFT Farm 3.23v
   by @HackerFurry
]]

local player = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- ========== ПРИВЕТСТВЕННЫЙ ЭКРАН ==========
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "FarmSplash"
splashGui.ResetOnSpawn = false
splashGui.Parent = player:WaitForChild("PlayerGui")

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BackgroundTransparency = 0.5
blackFrame.BorderSizePixel = 0
blackFrame.ZIndex = 10
blackFrame.Parent = splashGui

local thanksText = Instance.new("TextLabel")
thanksText.Size = UDim2.new(1, 0, 0, 100)
thanksText.Position = UDim2.new(0, 0, 0.5, -50)
thanksText.BackgroundTransparency = 1
thanksText.Text = "Thanks for using BABFT Farm 3.23v\nby @HackerFurry"
thanksText.TextColor3 = Color3.new(1, 1, 1)
thanksText.TextScaled = true
thanksText.Font = Enum.Font.SourceSansBold
thanksText.ZIndex = 11
thanksText.Parent = blackFrame

task.wait(3)
splashGui:Destroy()

-- ========== ОСНОВНОЙ ГУИ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BABFTFarm"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 280)
frame.Position = UDim2.new(0.5, -140, 0.4, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "BABFT Farm 3.23v"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- ========== ПОЛЗУНОК СКОРОСТИ (100-500) ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 35)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Fly Speed: 300"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 14
speedLabel.Parent = frame

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -10, 0, 20)
sliderFrame.Position = UDim2.new(0, 5, 0, 55)
sliderFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sliderFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.5, 0, 1, 0)
fill.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
fill.BorderSizePixel = 0
fill.Parent = sliderFrame
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = fill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
sliderButton.BackgroundColor3 = Color3.new(0.4, 0.7, 1)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderFrame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = sliderButton

local speedValue = 300
local dragging = false

local function updateSpeed(value)
    speedValue = math.clamp(value, 100, 500)
    local percent = (speedValue - 100) / 400
    fill.Size = UDim2.new(percent, 0, 1, 0)
    sliderButton.Position = UDim2.new(percent, -10, 0, 0)
    speedLabel.Text = "Fly Speed: " .. math.floor(speedValue)
end

-- Мышь
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = input.Position.X - sliderFrame.AbsolutePosition.X
        local percent = math.clamp(pos / sliderFrame.AbsoluteSize.X, 0, 1)
        speedValue = 100 + percent * 400
        updateSpeed(speedValue)
    end
end)

-- Сенсорное управление для телефона
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position.X - sliderFrame.AbsolutePosition.X
        local percent = math.clamp(pos / sliderFrame.AbsoluteSize.X, 0, 1)
        speedValue = 100 + percent * 400
        updateSpeed(speedValue)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 85)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(1,1,0)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Parent = frame

-- Счётчик запусков
local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -10, 0, 20)
counterLabel.Position = UDim2.new(0, 5, 0, 105)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Farms Completed: 0"
counterLabel.TextColor3 = Color3.new(0.5, 0.8, 1)
counterLabel.Font = Enum.Font.SourceSans
counterLabel.TextSize = 12
counterLabel.Parent = frame

-- Кнопки в одну ширину
local goldButton = Instance.new("TextButton")
goldButton.Size = UDim2.new(1, -10, 0, 35)
goldButton.Position = UDim2.new(0, 5, 0, 130)
goldButton.Text = "Start Gold Farm"
goldButton.BackgroundColor3 = Color3.new(0.1, 0.6, 0.3)
goldButton.TextColor3 = Color3.new(1,1,1)
goldButton.Font = Enum.Font.SourceSansBold
goldButton.TextSize = 14
goldButton.Parent = frame
local goldCorner = Instance.new("UICorner")
goldCorner.CornerRadius = UDim.new(0, 4)
goldCorner.Parent = goldButton

local blockButton = Instance.new("TextButton")
blockButton.Size = UDim2.new(1, -10, 0, 35)
blockButton.Position = UDim2.new(0, 5, 0, 175)
blockButton.Text = "Start Block Farm"
blockButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.8)
blockButton.TextColor3 = Color3.new(1,1,1)
blockButton.Font = Enum.Font.SourceSansBold
blockButton.TextSize = 14
blockButton.Parent = frame
local blockCorner = Instance.new("UICorner")
blockCorner.CornerRadius = UDim.new(0, 4)
blockCorner.Parent = blockButton

-- Кнопка FPS Counter
local fpsButton = Instance.new("TextButton")
fpsButton.Size = UDim2.new(1, -10, 0, 35)
fpsButton.Position = UDim2.new(0, 5, 0, 220)
fpsButton.Text = "FPS Counter"
fpsButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
fpsButton.TextColor3 = Color3.new(1,1,1)
fpsButton.Font = Enum.Font.SourceSansBold
fpsButton.TextSize = 14
fpsButton.Parent = frame
local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 4)
fpsCorner.Parent = fpsButton

-- Надпись By @HackerFurry
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 25)
creditLabel.Position = UDim2.new(0, 0, 1, -30)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "By @HackerFurry"
creditLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
creditLabel.Font = Enum.Font.SourceSans
creditLabel.TextSize = 12
creditLabel.Parent = frame

-- ========== FPS COUNTER ==========
fpsButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FPS-Counter-V1dot6dot1-115754"))()
    fpsButton.Text = "FPS Loaded ✅"
    fpsButton.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
    fpsButton.Active = false
    task.wait(2)
    fpsButton.Text = "FPS Counter"
    fpsButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    fpsButton.Active = true
end)

-- ========== ФУНКЦИИ ФАРМА ==========
local farmCounter = 0

local function flyTo(targetPos, speed)
    local char = player.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local direction = (targetPos - root.Position).Unit
    local distance = (targetPos - root.Position).Magnitude
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = direction * speed
    bv.MaxForce = Vector3.new(4000, 4000, 4000)
    bv.Parent = root
    local time = distance / speed
    task.wait(time)
    bv:Destroy()
    return true
end

-- Gold Farm
local function goldFarmCycle(speed)
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return false end

    root.CFrame = CFrame.new(-59, 66, 755)
    task.wait(0.5)
    flyTo(Vector3.new(-74, 66, 7595), speed)
    root.CFrame = CFrame.new(-267, 51, 7633)
    task.wait(1)
    root.CFrame = CFrame.new(-56, -355, 9492)
    task.wait(2)
    root.CFrame = CFrame.new(-57, -355, 9495)
    task.wait(2)
    humanoid.Health = 0
    return true
end

-- Block Farm
local function blockFarmCycle(speed)
    local char = player.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return false end

    root.CFrame = CFrame.new(-63, 65, 1306)
    task.wait(0.5)
    flyTo(Vector3.new(-59, 65, 1495), speed)
    root.CFrame = CFrame.new(-52, -352, 9496)
    task.wait(3)
    root.CFrame = CFrame.new(-52, -352, 9496)
    task.wait(1)
    return true
end

-- Управление фармом
local activeFarm = false
local farmType = nil
local autoRepeat = false

local function updateCounter()
    counterLabel.Text = "Farms Completed: " .. farmCounter
end

local function runFarm()
    while activeFarm and autoRepeat do
        local success = false
        if farmType == "gold" then
            success = goldFarmCycle(speedValue)
        elseif farmType == "block" then
            success = blockFarmCycle(speedValue)
        end
        if success then
            farmCounter = farmCounter + 1
            updateCounter()
        end
        task.wait(2)
    end
end

local function startFarm(type)
    if activeFarm then return end
    activeFarm = true
    farmType = type
    autoRepeat = true
    
    if type == "gold" then
        statusLabel.Text = "Status: Gold Farm..."
        goldButton.Text = "Farming..."
        goldButton.BackgroundColor3 = Color3.new(0.8,0.2,0.2)
        blockButton.Active = false
    elseif type == "block" then
        statusLabel.Text = "Status: Block Farm..."
        blockButton.Text = "Farming..."
        blockButton.BackgroundColor3 = Color3.new(0.8,0.2,0.2)
        goldButton.Active = false
    end
    goldButton.Active = false
    blockButton.Active = false
    
    task.spawn(runFarm)
end

local function stopFarm()
    activeFarm = false
    autoRepeat = false
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.new(1,1,0)
    goldButton.Text = "Start Gold Farm"
    goldButton.BackgroundColor3 = Color3.new(0.1,0.6,0.3)
    blockButton.Text = "Start Block Farm"
    blockButton.BackgroundColor3 = Color3.new(0.1,0.5,0.8)
    goldButton.Active = true
    blockButton.Active = true
end

goldButton.MouseButton1Click:Connect(function()
    if not activeFarm then startFarm("gold") else stopFarm() end
end)

blockButton.MouseButton1Click:Connect(function()
    if not activeFarm then startFarm("block") else stopFarm() end
end)

player.CharacterAdded:Connect(function()
    if autoRepeat then
        task.wait(2)
        if autoRepeat and not activeFarm then
            activeFarm = true
            task.spawn(runFarm)
        end
    end
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.new(1,1,0)
    goldButton.Text = "Start Gold Farm"
    goldButton.BackgroundColor3 = Color3.new(0.1,0.6,0.3)
    blockButton.Text = "Start Block Farm"
    blockButton.BackgroundColor3 = Color3.new(0.1,0.5,0.8)
    goldButton.Active = true
    blockButton.Active = true
end)

-- Горячая клавиша Insert для скрытия/показа
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

updateSpeed(300)
print("BABFT Farm 3.23v loaded. Press Insert to hide/show.")
