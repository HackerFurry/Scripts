--[[
  BABFT Farm
  by @HackerFurry
]]

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()
local farmWindow = library:Window("BABFT Farm")
local optWindow = library:Window("Optimization")

local plr = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local credits = "by @HackerFurry | t.me/HackerCoffee"

-- ========== ПЕРЕМЕННЫЕ ==========
local farmActive = false
local farmType = nil
local farmCounter = 0
local farmSpeed = 300
local autoRestart = true

-- СТАТИСТИКА (ТОЧНЫЕ ЗНАЧЕНИЯ)
local goldCollected = 0
local blocksCollected = 0
local goldPerCycle = 122  -- 122 золота за 1 цикл фарма
local blocksPerCycle = 200  -- блоков за цикл (если нужно, измени)
local sessionStartTime = nil
local goldPerHour = 0
local blocksPerHour = 0

-- ========== ФУНКЦИИ ФАРМА ==========
local function flyTo(targetPos, speed)
    local char = plr.Character
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

local function goldFarmCycle(speed)
    local char = plr.Character
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

local function blockFarmCycle(speed)
    local char = plr.Character
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

local function updateStats(cycleType)
    local now = os.time()
    if not sessionStartTime then
        sessionStartTime = now
    end
    
    if cycleType == "gold" then
        goldCollected = goldCollected + goldPerCycle
    elseif cycleType == "block" then
        blocksCollected = blocksCollected + blocksPerCycle
    end
    
    local elapsedHours = (now - sessionStartTime) / 3600
    if elapsedHours > 0 then
        goldPerHour = math.floor(goldCollected / elapsedHours)
        blocksPerHour = math.floor(blocksCollected / elapsedHours)
    end
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function runFarm()
    while farmActive do
        local speed = farmSpeed
        if farmType == "gold" then
            goldFarmCycle(speed)
            updateStats("gold")
        elseif farmType == "block" then
            blockFarmCycle(speed)
            updateStats("block")
        end
        farmCounter = farmCounter + 1
        task.wait(2)
    end
end

local function startFarm(type)
    if farmActive then return end
    farmActive = true
    farmType = type
    if not sessionStartTime then
        sessionStartTime = os.time()
    end
    task.spawn(runFarm)
end

local function stopFarm()
    farmActive = false
end

-- АВТО-РЕСТАРТ ПОСЛЕ СМЕРТИ
plr.CharacterAdded:Connect(function()
    if autoRestart and farmType then
        task.wait(3)
        if farmType == "gold" then
            startFarm("gold")
        elseif farmType == "block" then
            startFarm("block")
        end
    end
end)

-- ========== НАСТРОЙКИ ==========
-- FullBright
local fullbrightActive = false
local originalBrightness = lighting.Brightness
local originalAmbient = lighting.Ambient
local originalOutdoorAmbient = lighting.OutdoorAmbient

local function setFullBright(enable)
    if enable then
        lighting.Brightness = 2
        lighting.Ambient = Color3.new(1, 1, 1)
        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        lighting.ClockTime = 12
    else
        lighting.Brightness = originalBrightness
        lighting.Ambient = originalAmbient
        lighting.OutdoorAmbient = originalOutdoorAmbient
    end
end

-- Буст FPS
local boostFPSActive = false

local function setBoostFPS(enable)
    if enable then
        lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end
        if workspace:FindFirstChild("Terrain") then
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterRefraction = 0
        end
    else
        lighting.GlobalShadows = true
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = true
            end
            if v:IsA("Decal") then
                v.Transparency = 0
            end
        end
        if workspace:FindFirstChild("Terrain") then
            workspace.Terrain.WaterWaveSize = 0.5
            workspace.Terrain.WaterReflectance = 0.5
            workspace.Terrain.WaterRefraction = 0.5
        end
    end
end

-- Анти-АФК
local antiAFKActive = false
local afkConnection = nil
local vu = game:GetService("VirtualUser")

local function setupAntiAFK()
    if afkConnection then afkConnection:Disconnect() end
    afkConnection = plr.Idled:Connect(function()
        if antiAFKActive and vu then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end

local function toggleAntiAFK(value)
    antiAFKActive = value
    if value then
        setupAntiAFK()
    end
end

-- FPS Counter
local function loadFPS()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FPS-Counter-V1dot6dot1-115754"))()
end

-- ========== FARM WINDOW ==========
farmWindow:Label("=== FARM CONTROL ===")

farmWindow:Button("▶️ Start Gold Farm", function()
    if farmActive then stopFarm(); task.wait(0.5) end
    startFarm("gold")
end)

farmWindow:Button("🧱 Start Block Farm", function()
    if farmActive then stopFarm(); task.wait(0.5) end
    startFarm("block")
end)

farmWindow:Button("⏹️ Stop Farm", function()
    stopFarm()
end)

farmWindow:Slider("Fly Speed", 100, 500, farmSpeed, function(value)
    farmSpeed = value
end)

farmWindow:Toggle("🔄 Auto Restart after death", true, function(value)
    autoRestart = value
end)

farmWindow:Label("=== STATISTICS ===")

local goldLabel = farmWindow:Label("💰 Gold: 0")
local goldPerHourLabel = farmWindow:Label("📈 Gold/h: 0")
local cyclesLabel = farmWindow:Label("🔄 Cycles: 0")
local timerLabel = farmWindow:Label("⏱️ Time: 00:00:00")

farmWindow:Label(credits, Color3.fromRGB(127, 143, 166))

-- ========== OPTIMIZATION WINDOW ==========
optWindow:Label("=== OPTIMIZATION ===")

optWindow:Toggle("🚀 Boost FPS", false, function(value)
    setBoostFPS(value)
end)

optWindow:Toggle("☀️ FullBright", false, function(value)
    setFullBright(value)
end)

optWindow:Toggle("🛡️ Anti-AFK", false, function(value)
    toggleAntiAFK(value)
end)

optWindow:Button("📊 FPS Counter", function()
    loadFPS()
end)

optWindow:Label(credits, Color3.fromRGB(127, 143, 166))

-- Обновление статистики
task.spawn(function()
    while true do
        local elapsed = 0
        if sessionStartTime then
            elapsed = os.time() - sessionStartTime
        end
        timerLabel.Text = "⏱️ Time: " .. formatTime(elapsed)
        
        goldLabel.Text = "💰 Gold: " .. goldCollected
        goldPerHourLabel.Text = "📈 Gold/h: " .. goldPerHour
        cyclesLabel.Text = "🔄 Cycles: " .. farmCounter
        
        task.wait(1)
    end
end)

-- Горячая клавиша для скрытия UI (LeftControl)
local uis = game:GetService("UserInputService")
local uiVisible = true
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        if uiVisible then
            library:Show()
        else
            library:Hide()
        end
    end
end)

print("BABFT Farm loaded. Press LeftControl to hide UI.")
