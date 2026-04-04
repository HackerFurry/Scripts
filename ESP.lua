--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
   ESP HF 1.0v
   by @HackerFurry
]]

local player = game:GetService("Players").LocalPlayer
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- ========== ПРИВЕТСТВЕННЫЙ ЭКРАН ==========
local splashGui = Instance.new("ScreenGui")
splashGui.Name = "ESPSplash"
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
thanksText.Text = "ESP HF 1.0v\nby @HackerFurry"
thanksText.TextColor3 = Color3.new(1, 1, 1)
thanksText.TextScaled = true
thanksText.Font = Enum.Font.SourceSansBold
thanksText.ZIndex = 11
thanksText.Parent = blackFrame

task.wait(3)
splashGui:Destroy()

-- ========== ОСНОВНОЙ ГУИ ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPHF"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 210)
frame.Position = UDim2.new(0.5, -110, 0.4, 0)
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
title.Text = "ESP HF 1.0v"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -10, 1, -70)
container.Position = UDim2.new(0, 5, 0, 35)
container.BackgroundTransparency = 1
container.Parent = frame

local y = 0

local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.Text = text .. " OFF"
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = container
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 4)
    cornerBtn.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.new(0.3, 0.5, 0.3)
            btn.Text = text .. " ON"
        else
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            btn.Text = text .. " OFF"
        end
        callback(state)
    end)
    y = y + 40
    return btn
end

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

-- ========== НАСТРОЙКИ ==========
local espEnabled = false
local rainbowEnabled = false
local showNames = true
local teamColorEnabled = true  -- новая функция: цвет по команде

local espObjects = {}
local rainbowIndex = 1
local rainbowColors = {
    Color3.new(1,0,0), Color3.new(1,0.5,0), Color3.new(1,1,0),
    Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(0.5,0,1),
    Color3.new(1,0,1)
}

-- Получение цвета команды
local function getTeamColor(plr)
    if not teamColorEnabled then return Color3.new(1, 0.3, 0.3) end
    local team = plr.Team
    if team then
        if team.Name:lower():find("red") or team.Name:lower():find("красн") then
            return Color3.new(1, 0.2, 0.2)
        elseif team.Name:lower():find("blue") or team.Name:lower():find("син") then
            return Color3.new(0.2, 0.4, 1)
        elseif team.Name:lower():find("green") or team.Name:lower():find("зелен") then
            return Color3.new(0.2, 0.8, 0.2)
        elseif team.Name:lower():find("yellow") or team.Name:lower():find("желт") then
            return Color3.new(1, 0.8, 0)
        end
    end
    -- По цвету одежды (упрощённо)
    local char = plr.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("Shirt") or part:IsA("Pants") then
                local color = part.Color
                if color.r > 0.7 and color.g < 0.3 and color.b < 0.3 then
                    return Color3.new(1, 0.2, 0.2)
                elseif color.b > 0.7 and color.r < 0.3 and color.g < 0.3 then
                    return Color3.new(0.2, 0.4, 1)
                end
            end
        end
    end
    return Color3.new(1, 0.3, 0.3)
end

local function getDefaultColor(plr)
    if rainbowEnabled then
        return rainbowColors[rainbowIndex]
    end
    return getTeamColor(plr)
end

local function createHighlight(char, color)
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.new(1,1,1)
    h.Parent = char
    return h
end

local function createNameTag(plr, char)
    if not showNames then return nil end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return nil end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = plr.Name
    text.TextColor3 = Color3.new(1,1,1)
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 14
    text.Parent = frame
    return billboard
end

local function removeESPForPlayer(plr)
    local objs = espObjects[plr]
    if objs then
        if objs.highlight then objs.highlight:Destroy() end
        if objs.nameTag then objs.nameTag:Destroy() end
        espObjects[plr] = nil
    end
end

local function applyESPForPlayer(plr)
    if plr == player then return end
    if not plr.Character then return end
    removeESPForPlayer(plr)
    
    local color = getDefaultColor(plr)
    local highlight = createHighlight(plr.Character, color)
    local nameTag = createNameTag(plr, plr.Character)
    espObjects[plr] = { highlight = highlight, nameTag = nameTag }
end

local function updateRainbowColors()
    if not rainbowEnabled then return end
    rainbowIndex = rainbowIndex % #rainbowColors + 1
    local color = rainbowColors[rainbowIndex]
    for plr, objs in pairs(espObjects) do
        if objs.highlight then
            objs.highlight.FillColor = color
        end
    end
end

local function updateTeamColors()
    if rainbowEnabled or not teamColorEnabled then return end
    for plr, objs in pairs(espObjects) do
        if objs.highlight then
            objs.highlight.FillColor = getTeamColor(plr)
        end
    end
end

local function updateESP()
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= player then
            if espEnabled then
                if not espObjects[plr] then
                    applyESPForPlayer(plr)
                else
                    if not rainbowEnabled and teamColorEnabled then
                        espObjects[plr].highlight.FillColor = getTeamColor(plr)
                    end
                end
            else
                if espObjects[plr] then
                    removeESPForPlayer(plr)
                end
            end
        end
    end
end

local function updateNames()
    for plr, objs in pairs(espObjects) do
        if objs.nameTag then
            objs.nameTag:Destroy()
            objs.nameTag = nil
        end
        if showNames and espEnabled and plr.Character then
            objs.nameTag = createNameTag(plr, plr.Character)
        end
    end
end

-- Подписки на события
players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            applyESPForPlayer(plr)
        end)
        plr.CharacterRemoving:Connect(function()
            removeESPForPlayer(plr)
        end)
        if plr.Character then
            task.wait(0.5)
            applyESPForPlayer(plr)
        end
    end
end)

players.PlayerRemoving:Connect(function(plr)
    removeESPForPlayer(plr)
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    updateESP()
end)

-- Обновление цветов команд при смене команды
players.PlayerAdded:Connect(function(plr)
    plr:GetPropertyChangedSignal("Team"):Connect(function()
        if espEnabled and espObjects[plr] and espObjects[plr].highlight then
            espObjects[plr].highlight.FillColor = getTeamColor(plr)
        end
    end)
end)

-- Радужный цикл
task.spawn(function()
    while true do
        if rainbowEnabled and espEnabled then
            updateRainbowColors()
        end
        task.wait(0.2)
    end
end)

-- Обновление цветов команд
task.spawn(function()
    while true do
        if teamColorEnabled and espEnabled and not rainbowEnabled then
            updateTeamColors()
        end
        task.wait(0.5)
    end
end)

-- Обновление ESP
task.spawn(function()
    while true do
        updateESP()
        task.wait(1)
    end
end)

-- ========== КНОПКИ ==========
addToggle("ESP", function(state)
    espEnabled = state
    updateESP()
end)

addToggle("Team Color", function(state)
    teamColorEnabled = state
    if not rainbowEnabled then
        updateESP()
    end
end)

addToggle("Rainbow ESP", function(state)
    rainbowEnabled = state
    if state then
        updateRainbowColors()
    else
        updateESP()
    end
end)

addToggle("Nickname", function(state)
    showNames = state
    updateNames()
end)

-- Горячая клавиша Insert
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

updateESP()
