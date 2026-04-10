--[[
  BABFT Farm
  by @HackerFurry
]]

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()
local w = library:Window("BABFT Farm")

local plr = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")
local credits = "by @HackerFurry | t.me/HackerCoffee"

-- ========== ПЕРЕМЕННЫЕ ==========
local farmActive = false
local farmType = nil
local farmCounter = 0
local farmSpeed = 300

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

local function runFarm()
    while farmActive do
        local speed = farmSpeed
        if farmType == "gold" then
            goldFarmCycle(speed)
        elseif farmType == "block" then
            blockFarmCycle(speed)
        end
        farmCounter = farmCounter + 1
        task.wait(2)
    end
end

local function startFarm(type)
    if farmActive then return end
    farmActive = true
    farmType = type
    task.spawn(runFarm)
end

-- ========== FPS COUNTER ==========
local function loadFPS()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FPS-Counter-V1dot6dot1-115754"))()
end

-- ========== GUI ==========
w:Label("=== FARM CONTROL ===")

w:Button("▶️ Start Gold Farm", function()
    if farmActive then farmActive = false; task.wait(0.5) end
    startFarm("gold")
end)

w:Button("🧱 Start Block Farm", function()
    if farmActive then farmActive = false; task.wait(0.5) end
    startFarm("block")
end)

w:Slider("Fly Speed", 100, 500, farmSpeed, function(value)
    farmSpeed = value
end)

w:Label("Farms Completed: " .. farmCounter)

w:Label("=== OTHER ===")

w:Button("📊 FPS Counter", function()
    loadFPS()
end)

w:Label(credits, Color3.fromRGB(127, 143, 166))

-- Обновление счётчика
task.spawn(function()
    while true do
        for _, child in pairs(w:GetChildren()) do
            if child:IsA("Label") and child.Text:match("Farms Completed") then
                child.Text = "Farms Completed: " .. farmCounter
            end
        end
        task.wait(1)
    end
end)

print("BABFT Farm loaded.")
