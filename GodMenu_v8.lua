local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local gui = lp:WaitForChild("PlayerGui")

-- Полная очистка старых версий
if gui:FindFirstChild("SuperMenuUI_V9") then gui.SuperMenuUI_V9:Destroy() end
if workspace:FindFirstChild("GoldOrbit_" .. lp.Name) then workspace["GoldOrbit_" .. lp.Name]:Destroy() end
if workspace:FindFirstChild("MagnetRing_" .. lp.Name) then workspace["MagnetRing_" .. lp.Name]:Destroy() end
if workspace:FindFirstChild("PushRing_" .. lp.Name) then workspace["PushRing_" .. lp.Name]:Destroy() end
if workspace:FindFirstChild("AirWalk_" .. lp.Name) then workspace["AirWalk_" .. lp.Name]:Destroy() end
for _, toolName in ipairs({"Click TP", "BTools (Delete)", "BTools (Move)", "BTools (Create)", "BTools (Create Anchored)", "BTools (Create Physics)"}) do
    if lp.Backpack:FindFirstChild(toolName) then lp.Backpack[toolName]:Destroy() end
end

local s = Instance.new("ScreenGui")
s.Name = "SuperMenuUI_V9"
s.Parent = gui
s.ResetOnSpawn = false

-- Главный фрейм теперь фиксированного размера, так как внутри будет прокрутка
local f = Instance.new("Frame")
f.Size = UDim2.new(0, 160, 0, 450)
f.Position = UDim2.new(0, 20, 0.15, 0)
f.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
f.Active = true
f.Draggable = true
f.Parent = s

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 8)
fCorner.Parent = f

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "GOD MENU v9.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1
title.Parent = f

-- Создаем зону с прокруткой (ScrollingFrame)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -35)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 640) -- Внутренний размер для прокрутки (увеличивай, если добавишь еще кнопки)
scroll.Parent = f

-- UIListLayout автоматически выстраивает все элементы внутри scroll ровно вниз
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6) -- Расстояние между кнопками
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = scroll

-- Обновленная функция создания кнопок (больше не нужны координаты X и Y)
local function createButton(name, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = scroll
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    return btn
end

-- ================= СОЗДАНИЕ КНОПОК =================
local speedBtn = createButton("SPEED", Color3.fromRGB(0, 120, 200))
local jumpBtn = createButton("HIGH JUMP", Color3.fromRGB(160, 40, 160))
local goldBtn = createButton("GOLD INF JUMP", Color3.fromRGB(212, 175, 55))
local magnetBtn = createButton("MAGNET", Color3.fromRGB(0, 150, 90))
local pushBtn = createButton("PUSH AURA", Color3.fromRGB(200, 50, 50))
local flyBtn = createButton("FLY", Color3.fromRGB(130, 130, 30))
local tpBtn = createButton("CLICK TP", Color3.fromRGB(120, 30, 130))
local spinBtn = createButton("SPINBOT", Color3.fromRGB(200, 100, 0))    -- НОВАЯ
local airBtn = createButton("AIR WALK", Color3.fromRGB(0, 200, 200))    -- НОВАЯ
local xrayBtn = createButton("X-RAY", Color3.fromRGB(100, 100, 100))    -- НОВАЯ
local btoolsBtn = createButton("BTOOLS", Color3.fromRGB(180, 100, 30))

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(0.9, 0, 0, 40)
sizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
sizeInput.Text = "4"
sizeInput.PlaceholderText = "Размер"
sizeInput.TextColor3 = Color3.fromRGB(255, 215, 0)
sizeInput.TextSize = 14
sizeInput.Font = Enum.Font.SourceSansBold
sizeInput.ClearTextOnFocus = false
sizeInput.Parent = scroll
local sizeCorner = Instance.new("UICorner") sizeCorner.CornerRadius = UDim.new(0, 6) sizeCorner.Parent = sizeInput

local shapeBtn = createButton("SHAPE: CUBE", Color3.fromRGB(70, 70, 80))

-- ================= ЛОГИКА НОВЫХ ФУНКЦИЙ =================

-- 1. SPINBOT (Торнадо)
local spinEnabled, spinVelocity = false, nil
spinBtn.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not spinEnabled then
        spinBtn.Text = "SPINBOT" spinBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        if spinVelocity then spinVelocity:Destroy() spinVelocity = nil end
        return
    end
    if root then
        spinBtn.Text = "SPINBOT: ON" spinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        spinVelocity = Instance.new("BodyAngularVelocity")
        spinVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        -- Крутимся по оси Y (вокруг своей оси) с огромной скоростью 150
        spinVelocity.AngularVelocity = Vector3.new(0, 150, 0)
        spinVelocity.Parent = root
    end
end)

-- 2. AIR WALK (Невидимый мост)
local airWalkEnabled, airPart, airConnection = false, nil, nil
airBtn.MouseButton1Click:Connect(function()
    airWalkEnabled = not airWalkEnabled
    if not airWalkEnabled then
        airBtn.Text = "AIR WALK" airBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
        if airPart then airPart:Destroy() airPart = nil end
        if airConnection then airConnection:Disconnect() airConnection = nil end
        return
    end
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        airBtn.Text = "AIR WALK: ON" airBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        
        airPart = Instance.new("Part")
        airPart.Name = "AirWalk_" .. lp.Name
        airPart.Size = Vector3.new(6, 1, 6)
        airPart.Transparency = 0.5 -- Слегка видно, как стеклянный пол
        airPart.Color = Color3.fromRGB(0, 255, 255)
        airPart.Material = Enum.Material.Neon
        airPart.Anchored = true
        airPart.CanCollide = true
        airPart.Parent = workspace
        
        -- Фиксируем высоту в момент включения скрипта (-3.2 это чуть ниже ног)
        local fixedY = root.Position.Y - 3.2
        
        airConnection = RunService.Heartbeat:Connect(function()
            local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if r and airPart then
                -- Пол двигается за игроком по осям X и Z, но высота (Y) заморожена!
                airPart.Position = Vector3.new(r.Position.X, fixedY, r.Position.Z)
            end
        end)
    end
end)

-- 3. X-RAY (Просмотр сквозь стены)
local xrayEnabled = false
local originalTransparencies = {} -- Сюда будем сохранять оригинальную прозрачность блоков
xrayBtn.MouseButton1Click:Connect(function()
    xrayEnabled = not xrayEnabled
    if not xrayEnabled then
        xrayBtn.Text = "X-RAY" xrayBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        -- Возвращаем всё как было
        for part, origTrans in pairs(originalTransparencies) do
            if part and part.Parent then part.Transparency = origTrans end
        end
        originalTransparencies = {} -- Очищаем память
        return
    end
    
    xrayBtn.Text = "X-RAY: ON" xrayBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    -- Сканируем весь мир
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Проверяем, что это физический блок и он НЕ является частью нашего персонажа
        if obj:IsA("BasePart") and not obj:IsDescendantOf(lp.Character) then
            originalTransparencies[obj] = obj.Transparency -- Запоминаем
            obj.Transparency = 0.75 -- Делаем полупрозрачным
        end
    end
end)

-- ================= ЛОГИКА СТАРЫХ ФУНКЦИЙ =================
-- (Она осталась без изменений, чтобы всё работало как часы)

speedBtn.MouseButton1Click:Connect(function()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.WalkSpeed == 16 then hum.WalkSpeed = 100 speedBtn.Text = "SPEED: ON" speedBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        else hum.WalkSpeed = 16 speedBtn.Text = "SPEED" speedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200) end
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.JumpPower == 50 or hum.JumpHeight == 7 then hum.JumpPower = 150 hum.JumpHeight = 50 hum.UseJumpPower = true jumpBtn.Text = "H-JUMP: ON" jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        else hum.JumpPower = 50 hum.JumpHeight = 7 jumpBtn.Text = "HIGH JUMP" jumpBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 160) end
    end
end)

local infJumpEnabled, goldFolder, goldConnection, jumpConnection = false, nil, nil, nil
goldBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if not infJumpEnabled then
        goldBtn.Text = "GOLD INF JUMP" goldBtn.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
        if goldFolder then goldFolder:Destroy() goldFolder = nil end
        if goldConnection then goldConnection:Disconnect() goldConnection = nil end
        if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
        return
    end
    goldBtn.Text = "GOLD JUMP: ON" goldBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    goldFolder = Instance.new("Folder") goldFolder.Name = "GoldOrbit_" .. lp.Name goldFolder.Parent = workspace
    local parts = {}
    for i = 1, 7 do
        local p = Instance.new("Part") p.Shape = Enum.PartType.Ball p.Size = Vector3.new(1.8, 1.8, 1.8) p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.fromRGB(255, 215, 0) p.Parent = goldFolder table.insert(parts, p)
    end
    goldConnection = RunService.Heartbeat:Connect(function()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root or not goldFolder or not goldFolder.Parent then if goldConnection then goldConnection:Disconnect() end return end
        local currentTime = tick() * 2.5
        for i, p in ipairs(parts) do
            local angle = currentTime + (i * (math.pi * 2 / 7))
            p.Position = Vector3.new(root.Position.X + math.cos(angle) * 7.5, root.Position.Y, root.Position.Z + math.sin(angle) * 7.5)
        end
    end)
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root and infJumpEnabled then root.Velocity = Vector3.new(root.Velocity.X, 60, root.Velocity.Z) end
    end)
end)

local magnetEnabled, magnetConnection, magnetRing = false, nil, nil
magnetBtn.MouseButton1Click:Connect(function()
    magnetEnabled = not magnetEnabled
    if not magnetEnabled then
        magnetBtn.Text = "MAGNET" magnetBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
        if magnetConnection then magnetConnection:Disconnect() magnetConnection = nil end
        if magnetRing then magnetRing:Destroy() magnetRing = nil end
        return
    end
    magnetBtn.Text = "MAGNET: ON" magnetBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    magnetRing = Instance.new("Part") magnetRing.Name = "MagnetRing_" .. lp.Name magnetRing.Shape = Enum.PartType.Cylinder magnetRing.Size = Vector3.new(0.2, 60, 60) magnetRing.Orientation = Vector3.new(0, 0, 90) magnetRing.Color = Color3.fromRGB(0, 255, 150) magnetRing.Material = Enum.Material.Neon magnetRing.Transparency = 0.9 magnetRing.Anchored = true magnetRing.CanCollide = false magnetRing.Parent = workspace
    magnetConnection = RunService.Heartbeat:Connect(function()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root or not magnetRing then return end
        magnetRing.Position = root.Position - Vector3.new(0, 2.5, 0)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= lp.Character and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                local distance = (root.Position - obj.Position).Magnitude
                if distance <= 30 then obj.Velocity = (root.Position - obj.Position).Unit * 40 end
            end
        end
    end)
end)

local pushEnabled, pushConnection, pushRing = false, nil, nil
pushBtn.MouseButton1Click:Connect(function()
    pushEnabled = not pushEnabled
    if not pushEnabled then
        pushBtn.Text = "PUSH AURA" pushBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if pushConnection then pushConnection:Disconnect() pushConnection = nil end
        if pushRing then pushRing:Destroy() pushRing = nil end
        return
    end
    pushBtn.Text = "PUSH: ON" pushBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    pushRing = Instance.new("Part") pushRing.Name = "PushRing_" .. lp.Name pushRing.Shape = Enum.PartType.Cylinder pushRing.Size = Vector3.new(0.2, 50, 50) pushRing.Orientation = Vector3.new(0, 0, 90) pushRing.Color = Color3.fromRGB(255, 50, 50) pushRing.Material = Enum.Material.Neon pushRing.Transparency = 0.88 pushRing.Anchored = true pushRing.CanCollide = false pushRing.Parent = workspace
    pushConnection = RunService.Heartbeat:Connect(function()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root or not pushRing then return end
        pushRing.Position = root.Position - Vector3.new(0, 2.5, 0)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= lp.Character and not obj.Parent:FindFirstChildOfClass("Humanoid") then
                local distance = (root.Position - obj.Position).Magnitude
                if distance <= 25 then obj.Velocity = (obj.Position - root.Position).Unit * 70 + Vector3.new(0, 20, 0) end
            end
        end
    end)
end)

local flyEnabled, flyConnection, bv, bg = false, nil, nil, nil
flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if not flyEnabled then
        flyBtn.Text = "FLY" flyBtn.BackgroundColor3 = Color3.fromRGB(130, 130, 30)
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        return
    end
    flyBtn.Text = "FLY: ON" flyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if root and hum then
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) bv.Velocity = Vector3.new(0, 0, 0) bv.Parent = root
        bg = Instance.new("BodyGyro") bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.CFrame = root.CFrame bg.Parent = root
        flyConnection = RunService.RenderStepped:Connect(function()
            local currentSubRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local currentSubHum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if not currentSubRoot or not currentSubHum or not bv or not bg then return end
            local camCFrame = workspace.CurrentCamera.CFrame
            bg.CFrame = camCFrame
            local moveDir = currentSubHum.MoveDirection
            if moveDir.Magnitude > 0 then
                local localMove = camCFrame:VectorToObjectSpace(moveDir)
                bv.Velocity = (camCFrame.LookVector * -localMove.Z + camCFrame.RightVector * localMove.X) * 60
            else bv.Velocity = Vector3.new(0, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bv.Velocity = bv.Velocity + Vector3.new(0, 60, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then bv.Velocity = bv.Velocity + Vector3.new(0, -60, 0) end
        end)
    end
end)

local tpEnabled, tpTool = false, nil
local function giveTpTool()
    tpTool = Instance.new("Tool") tpTool.Name = "Click TP" tpTool.RequiresHandle = false tpTool.Parent = lp.Backpack
    tpTool.Activated:Connect(function()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local mouse = lp:GetMouse()
        if root and mouse and mouse.Hit then root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end)
end
tpBtn.MouseButton1Click:Connect(function()
    tpEnabled = not tpEnabled
    if not tpEnabled then tpBtn.Text = "CLICK TP" tpBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 130) if tpTool then tpTool:Destroy() tpTool = nil end return end
    tpBtn.Text = "TP TOOL: ON" tpBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100) giveTpTool()
end)

-- BTOOLS (Форма и размер)
local shapes = {Enum.PartType.Block, Enum.PartType.Ball, Enum.PartType.Cylinder}
local shapeNames = {"CUBE", "BALL", "CYLINDER"}
local currentShapeIndex = 1

shapeBtn.MouseButton1Click:Connect(function()
    currentShapeIndex = currentShapeIndex + 1
    if currentShapeIndex > #shapes then currentShapeIndex = 1 end
    shapeBtn.Text = "SHAPE: " .. shapeNames[currentShapeIndex]
end)

local function getBlockSize()
    local val = tonumber(sizeInput.Text)
    if val and val > 0.1 then return val end
    return 4
end

local btoolsEnabled, btoolsDeleteTool, btoolsMoveTool, btoolsAnchoredTool, btoolsPhysicsTool, selectedPart = false, nil, nil, nil, nil, nil
local function giveBTools()
    btoolsDeleteTool = Instance.new("Tool") btoolsDeleteTool.Name = "BTools (Delete)" btoolsDeleteTool.RequiresHandle = false btoolsDeleteTool.Parent = lp.Backpack
    btoolsDeleteTool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if mouse and mouse.Target and mouse.Target.Name ~= "Baseplate" and not mouse.Target:IsA("Terrain") then
            if not (mouse.Target:FindFirstAncestorOfClass("Model") and mouse.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")) then mouse.Target:Destroy() end
        end
    end)
    btoolsMoveTool = Instance.new("Tool") btoolsMoveTool.Name = "BTools (Move)" btoolsMoveTool.RequiresHandle = false btoolsMoveTool.Parent = lp.Backpack
    btoolsMoveTool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if not mouse then return end
        if selectedPart then
            if selectedPart.Parent then selectedPart.Position = mouse.Hit.Position + Vector3.new(0, selectedPart.Size.Y / 2, 0) end
            selectedPart = nil btoolsMoveTool.Name = "BTools (Move)"
        elseif mouse.Target and mouse.Target.Name ~= "Baseplate" and not mouse.Target:IsA("Terrain") then
            if not (mouse.Target:FindFirstAncestorOfClass("Model") and mouse.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")) then
                selectedPart = mouse.Target btoolsMoveTool.Name = "[ КЛИКНИ КУДА ПЕРЕНЕСТИ ]"
            end
        end
    end)
    btoolsMoveTool.Unequipped:Connect(function() selectedPart = nil btoolsMoveTool.Name = "BTools (Move)" end)

    btoolsAnchoredTool = Instance.new("Tool") btoolsAnchoredTool.Name = "BTools (Create Anchored)" btoolsAnchoredTool.RequiresHandle = false btoolsAnchoredTool.Parent = lp.Backpack
    btoolsAnchoredTool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if mouse and mouse.Hit then
            local size = getBlockSize()
            local newPart = Instance.new("Part") newPart.Shape = shapes[currentShapeIndex] newPart.Size = Vector3.new(size, size, size)
            newPart.Position = mouse.Hit.Position + Vector3.new(0, size / 2, 0) newPart.Anchored = true newPart.Material = Enum.Material.SmoothPlastic newPart.Color = Color3.fromRGB(0, 150, 255) newPart.Parent = workspace
        end
    end)

    btoolsPhysicsTool = Instance.new("Tool") btoolsPhysicsTool.Name = "BTools (Create Physics)" btoolsPhysicsTool.RequiresHandle = false btoolsPhysicsTool.Parent = lp.Backpack
    btoolsPhysicsTool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if mouse and mouse.Hit then
            local size = getBlockSize()
            local newPart = Instance.new("Part") newPart.Shape = shapes[currentShapeIndex] newPart.Size = Vector3.new(size, size, size)
            newPart.Position = mouse.Hit.Position + Vector3.new(0, size / 2, 0) newPart.Anchored = false newPart.Material = Enum.Material.SmoothPlastic newPart.Color = Color3.fromRGB(255, 130, 0) newPart.Parent = workspace
        end
    end)
end

btoolsBtn.MouseButton1Click:Connect(function()
    btoolsEnabled = not btoolsEnabled
    if not btoolsEnabled then
        btoolsBtn.Text = "BTOOLS" btoolsBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 30)
        if btoolsDeleteTool then btoolsDeleteTool:Destroy() btoolsDeleteTool = nil end
        if btoolsMoveTool then btoolsMoveTool:Destroy() btoolsMoveTool = nil end
        if btoolsAnchoredTool then btoolsAnchoredTool:Destroy() btoolsAnchoredTool = nil end
        if btoolsPhysicsTool then btoolsPhysicsTool:Destroy() btoolsPhysicsTool = nil end
        selectedPart = nil
        return
    end
    btoolsBtn.Text = "BTOOLS: ON" btoolsBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    giveBTools()
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if tpEnabled then giveTpTool() end
    if btoolsEnabled then giveBTools() end
end)
