local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local gui = lp:WaitForChild("PlayerGui")

if gui:FindFirstChild("SuperMenuUI_V10") then gui.SuperMenuUI_V10:Destroy() end
for _, v in ipairs(workspace:GetChildren()) do 
    if v.Name:match("^GoldOrbit_") or v.Name:match("^MagnetRing_") or v.Name:match("^PushRing_") or v.Name:match("^AirWalk_") then v:Destroy() end 
end
for _, t in ipairs({"Click TP", "BTools (Delete)", "BTools (Move)", "BTools (Create)", "BTools (Create Anchored)", "BTools (Create Physics)", "Click Fling"}) do
    if lp.Backpack:FindFirstChild(t) then lp.Backpack[t]:Destroy() end
end

local s = Instance.new("ScreenGui", gui) s.Name = "SuperMenuUI_V10" s.ResetOnSpawn = false
local f = Instance.new("Frame", s) f.Size = UDim2.new(0, 160, 0, 450) f.Position = UDim2.new(0, 20, 0.15, 0) f.BackgroundColor3 = Color3.fromRGB(25, 25, 30) f.Active = true f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", f) title.Size = UDim2.new(1, 0, 0, 30) title.Text = "GOD MENU v10.0" title.TextColor3 = Color3.fromRGB(255, 50, 50) title.TextSize = 14 title.Font = Enum.Font.SourceSansBold title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", f) scroll.Size = UDim2.new(1, 0, 1, -35) scroll.Position = UDim2.new(0, 0, 0, 35) scroll.BackgroundTransparency = 1 scroll.BorderSizePixel = 0 scroll.ScrollBarThickness = 4 scroll.CanvasSize = UDim2.new(0, 0, 0, 680)
local list = Instance.new("UIListLayout", scroll) list.Padding = UDim.new(0, 6) list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(name, color)
    local btn = Instance.new("TextButton", scroll) btn.Size = UDim2.new(0.9, 0, 0, 40) btn.BackgroundColor3 = color btn.Text = name btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.TextSize = 13 btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local speedBtn = createButton("SPEED", Color3.fromRGB(0, 120, 200))
local jumpBtn = createButton("HIGH JUMP", Color3.fromRGB(160, 40, 160))
local goldBtn = createButton("GOLD INF JUMP", Color3.fromRGB(212, 175, 55))
local magnetBtn = createButton("MAGNET", Color3.fromRGB(0, 150, 90))
local pushBtn = createButton("PUSH AURA", Color3.fromRGB(200, 50, 50))
local flyBtn = createButton("FLY", Color3.fromRGB(130, 130, 30))
local tpBtn = createButton("CLICK TP", Color3.fromRGB(120, 30, 130))
local spinBtn = createButton("SPINBOT", Color3.fromRGB(200, 100, 0))    
local clickFlingBtn = createButton("CLICK FLING", Color3.fromRGB(150, 0, 0))
local airBtn = createButton("AIR WALK", Color3.fromRGB(0, 200, 200))    
local xrayBtn = createButton("X-RAY", Color3.fromRGB(100, 100, 100))    
local btoolsBtn = createButton("BTOOLS", Color3.fromRGB(180, 100, 30))

local sizeInput = Instance.new("TextBox", scroll) sizeInput.Size = UDim2.new(0.9, 0, 0, 40) sizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45) sizeInput.Text = "4" sizeInput.TextColor3 = Color3.fromRGB(255, 215, 0) sizeInput.TextSize = 14 sizeInput.Font = Enum.Font.SourceSansBold sizeInput.ClearTextOnFocus = false
Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 6)
local shapeBtn = createButton("SHAPE: CUBE", Color3.fromRGB(70, 70, 80))

-- SPINBOT
local spinOn, spinV, spinC = false, nil, nil
spinBtn.MouseButton1Click:Connect(function()
    spinOn = not spinOn
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not spinOn then
        spinBtn.Text, spinBtn.BackgroundColor3 = "SPINBOT", Color3.fromRGB(200, 100, 0)
        if spinV then spinV:Destroy() spinV = nil end
        if spinC then spinC:Disconnect() spinC = nil end
        return
    end
    if root then
        spinBtn.Text, spinBtn.BackgroundColor3 = "SPINBOT: ON", Color3.fromRGB(0, 180, 100)
        spinV = Instance.new("BodyAngularVelocity", root) spinV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) spinV.AngularVelocity = Vector3.new(0, 5000, 0)
        spinC = RunService.RenderStepped:Connect(function() if root then root.Velocity = Vector3.new(root.Velocity.X, root.Velocity.Y + 0.01, root.Velocity.Z) end end)
    end
end)

-- CLICK-FLING
local flingOn, flingT = false, nil
local function giveFling()
    flingT = Instance.new("Tool", lp.Backpack) flingT.Name = "Click Fling" flingT.RequiresHandle = false
    flingT.Activated:Connect(function()
        local tar = lp:GetMouse().Target
        local tChar = tar and tar.Parent and tar:FindFirstAncestorOfClass("Model")
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local mRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and mRoot and tChar ~= lp.Character then
            local oldCF = mRoot.CFrame
            local sp = Instance.new("BodyAngularVelocity", mRoot) sp.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) sp.AngularVelocity = Vector3.new(0, 50000, 0)
            local endT = tick() + 0.3
            local c; c = RunService.Heartbeat:Connect(function()
                if tick() < endT then mRoot.CFrame, mRoot.Velocity = tRoot.CFrame, Vector3.new(10000, 10000, 10000)
                else c:Disconnect() sp:Destroy() mRoot.Velocity = Vector3.new(0,0,0) mRoot.CFrame = oldCF end
            end)
        end
    end)
end
clickFlingBtn.MouseButton1Click:Connect(function()
    flingOn = not flingOn
    clickFlingBtn.Text, clickFlingBtn.BackgroundColor3 = flingOn and "FLING TOOL: ON" or "CLICK FLING", flingOn and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(150, 0, 0)
    if flingOn then giveFling() elseif flingT then flingT:Destroy() flingT = nil end
end)

-- AIR WALK
local airOn, airP, airC = false, nil, nil
airBtn.MouseButton1Click:Connect(function()
    airOn = not airOn
    if not airOn then
        airBtn.Text, airBtn.BackgroundColor3 = "AIR WALK", Color3.fromRGB(0, 200, 200)
        if airP then airP:Destroy() airP = nil end if airC then airC:Disconnect() airC = nil end return
    end
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if root then
        airBtn.Text, airBtn.BackgroundColor3 = "AIR WALK: ON", Color3.fromRGB(0, 180, 100)
        airP = Instance.new("Part", workspace) airP.Name = "AirWalk_" .. lp.Name airP.Size = Vector3.new(6, 1, 6) airP.Transparency = 0.5 airP.Color = Color3.fromRGB(0, 255, 255) airP.Material = Enum.Material.Neon airP.Anchored, airP.CanCollide = true, true
        local fY = root.Position.Y - 3.2
        airC = RunService.Heartbeat:Connect(function() local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if r and airP then airP.Position = Vector3.new(r.Position.X, fY, r.Position.Z) end end)
    end
end)

-- X-RAY
local xrayOn, origTrans = false, {}
xrayBtn.MouseButton1Click:Connect(function()
    xrayOn = not xrayOn
    xrayBtn.Text, xrayBtn.BackgroundColor3 = xrayOn and "X-RAY: ON" or "X-RAY", xrayOn and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(100, 100, 100)
    if not xrayOn then for p, t in pairs(origTrans) do if p and p.Parent then p.Transparency = t end end origTrans = {} return end
    for _, o in ipairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(lp.Character) then origTrans[o] = o.Transparency o.Transparency = 0.75 end end
end)

speedBtn.MouseButton1Click:Connect(function()
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = h.WalkSpeed == 16 and 100 or 16 speedBtn.Text, speedBtn.BackgroundColor3 = h.WalkSpeed == 100 and "SPEED: ON" or "SPEED", h.WalkSpeed == 100 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(0, 120, 200) end
end)

jumpBtn.MouseButton1Click:Connect(function()
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = h.JumpPower == 50 and 150 or 50 h.JumpHeight = h.JumpPower == 150 and 50 or 7 h.UseJumpPower = true jumpBtn.Text, jumpBtn.BackgroundColor3 = h.JumpPower == 150 and "H-JUMP: ON" or "HIGH JUMP", h.JumpPower == 150 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(160, 40, 160) end
end)

-- GOLD JUMP / MAGNET / PUSH
local gjOn, gFold, gC, jC = false, nil, nil, nil
goldBtn.MouseButton1Click:Connect(function()
    gjOn = not gjOn
    if not gjOn then
        goldBtn.Text, goldBtn.BackgroundColor3 = "GOLD INF JUMP", Color3.fromRGB(212, 175, 55)
        if gFold then gFold:Destroy() gFold = nil end if gC then gC:Disconnect() gC = nil end if jC then jC:Disconnect() jC = nil end return
    end
    goldBtn.Text, goldBtn.BackgroundColor3 = "GOLD JUMP: ON", Color3.fromRGB(0, 180, 100)
    gFold = Instance.new("Folder", workspace) gFold.Name = "GoldOrbit_" .. lp.Name
    local parts = {} for i = 1, 7 do local p = Instance.new("Part", gFold) p.Shape, p.Size, p.Anchored, p.CanCollide, p.Material, p.Color = Enum.PartType.Ball, Vector3.new(1.8,1.8,1.8), true, false, Enum.Material.Neon, Color3.fromRGB(255,215,0) table.insert(parts, p) end
    gC = RunService.Heartbeat:Connect(function()
        local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if not r then return end
        for i, p in ipairs(parts) do local a = (tick()*2.5) + (i*(math.pi*2/7)) p.Position = Vector3.new(r.Position.X + math.cos(a)*7.5, r.Position.Y, r.Position.Z + math.sin(a)*7.5) end
    end)
    jC = UserInputService.JumpRequest:Connect(function() local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if r and gjOn then r.Velocity = Vector3.new(r.Velocity.X, 60, r.Velocity.Z) end end)
end)

local function makeAura(name, color, size, isPush)
    local on, ring, conn = false, nil, nil
    return function(btn)
        on = not on
        btn.Text, btn.BackgroundColor3 = on and (name..": ON") or name, on and Color3.fromRGB(0, 180, 100) or color
        if not on then if ring then ring:Destroy() ring = nil end if conn then conn:Disconnect() conn = nil end return end
        ring = Instance.new("Part", workspace) ring.Name = name.."Ring_"..lp.Name ring.Shape, ring.Size, ring.Orientation, ring.Color, ring.Material, ring.Transparency, ring.Anchored, ring.CanCollide = Enum.PartType.Cylinder, size, Vector3.new(0,0,90), color, Enum.Material.Neon, isPush and 0.88 or 0.9, true, false
        conn = RunService.Heartbeat:Connect(function()
            local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") if not r or not ring then return end
            ring.Position = r.Position - Vector3.new(0, 2.5, 0)
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") and not o.Anchored and o.Parent ~= lp.Character and not o.Parent:FindFirstChildOfClass("Humanoid") then
                    local d = (r.Position - o.Position).Magnitude
                    if d <= size.Y/2 then o.Velocity = isPush and ((o.Position - r.Position).Unit * 70 + Vector3.new(0, 20, 0)) or ((r.Position - o.Position).Unit * 40) end
                end
            end
        end)
    end
end
magnetBtn.MouseButton1Click:Connect(function() makeAura("MAGNET", Color3.fromRGB(0, 150, 90), Vector3.new(0.2, 60, 60), false)(magnetBtn) end)
pushBtn.MouseButton1Click:Connect(function() makeAura("PUSH", Color3.fromRGB(200, 50, 50), Vector3.new(0.2, 50, 50), true)(pushBtn) end)

-- FLY
local flyOn, flyC, fV, fG = false, nil, nil, nil
flyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    flyBtn.Text, flyBtn.BackgroundColor3 = flyOn and "FLY: ON" or "FLY", flyOn and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(130, 130, 30)
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not flyOn then if flyC then flyC:Disconnect() flyC = nil end if fV then fV:Destroy() fV = nil end if fG then fG:Destroy() fG = nil end if h then h.PlatformStand = false end return end
    if r and h then
        h.PlatformStand = true
        fV = Instance.new("BodyVelocity", r) fV.MaxForce = Vector3.new(9e9, 9e9, 9e9) fV.Velocity = Vector3.new(0,0,0)
        fG = Instance.new("BodyGyro", r) fG.MaxTorque = Vector3.new(9e9, 9e9, 9e9) fG.CFrame = r.CFrame
        flyC = RunService.RenderStepped:Connect(function()
            local camCF = workspace.CurrentCamera.CFrame fG.CFrame = camCF
            if h.MoveDirection.Magnitude > 0 then local lM = camCF:VectorToObjectSpace(h.MoveDirection) fV.Velocity = (camCF.LookVector * -lM.Z + camCF.RightVector * lM.X) * 60 else fV.Velocity = Vector3.new(0,0,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then fV.Velocity = fV.Velocity + Vector3.new(0, 60, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then fV.Velocity = fV.Velocity + Vector3.new(0, -60, 0) end
        end)
    end
end)

-- CLICK TP
local tpOn, tpT = false, nil
local function giveTp() tpT = Instance.new("Tool", lp.Backpack) tpT.Name = "Click TP" tpT.RequiresHandle = false tpT.Activated:Connect(function() local r = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") local m = lp:GetMouse() if r and m.Hit then r.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0)) end end) end
tpBtn.MouseButton1Click:Connect(function() tpOn = not tpOn tpBtn.Text, tpBtn.BackgroundColor3 = tpOn and "TP TOOL: ON" or "CLICK TP", tpOn and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(120, 30, 130) if tpOn then giveTp() elseif tpT then tpT:Destroy() tpT = nil end end)

-- BTOOLS
local shapes, shapeNames, cSI = {Enum.PartType.Block, Enum.PartType.Ball, Enum.PartType.Cylinder}, {"CUBE", "BALL", "CYLINDER"}, 1
shapeBtn.MouseButton1Click:Connect(function() cSI = cSI + 1 if cSI > #shapes then cSI = 1 end shapeBtn.Text = "SHAPE: " .. shapeNames[cSI] end)
local btOn, btD, btM, btA, btP, selP = false, nil, nil, nil, nil, nil
local function giveBT()
    btD = Instance.new("Tool", lp.Backpack) btD.Name = "BTools (Delete)" btD.RequiresHandle = false btD.Activated:Connect(function() local m = lp:GetMouse() if m.Target and m.Target.Name ~= "Baseplate" and not m.Target:IsA("Terrain") and not (m.Target:FindFirstAncestorOfClass("Model") and m.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")) then m.Target:Destroy() end end)
    btM = Instance.new("Tool", lp.Backpack) btM.Name = "BTools (Move)" btM.RequiresHandle = false btM.Activated:Connect(function() local m = lp:GetMouse() if selP then if selP.Parent then selP.Position = m.Hit.Position + Vector3.new(0, selP.Size.Y / 2, 0) end selP = nil btM.Name = "BTools (Move)" elseif m.Target and m.Target.Name ~= "Baseplate" and not m.Target:IsA("Terrain") and not (m.Target:FindFirstAncestorOfClass("Model") and m.Target:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")) then selP = m.Target btM.Name = "[ КЛИКНИ КУДА ]" end end)
    local function createPart(anc, col) local m = lp:GetMouse() if m.Hit then local s = tonumber(sizeInput.Text) or 4 local p = Instance.new("Part", workspace) p.Shape, p.Size, p.Position, p.Anchored, p.Material, p.Color = shapes[cSI], Vector3.new(s,s,s), m.Hit.Position + Vector3.new(0, s/2, 0), anc, Enum.Material.SmoothPlastic, col end end
    btA = Instance.new("Tool", lp.Backpack) btA.Name = "BTools (Create Anchored)" btA.RequiresHandle = false btA.Activated:Connect(function() createPart(true, Color3.fromRGB(0, 150, 255)) end)
    btP = Instance.new("Tool", lp.Backpack) btP.Name = "BTools (Create Physics)" btP.RequiresHandle = false btP.Activated:Connect(function() createPart(false, Color3.fromRGB(255, 130, 0)) end)
end
btoolsBtn.MouseButton1Click:Connect(function()
    btOn = not btOn btoolsBtn.Text, btoolsBtn.BackgroundColor3 = btOn and "BTOOLS: ON" or "BTOOLS", btOn and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 100, 30)
    if not btOn then for _, t in ipairs({btD, btM, btA, btP}) do if t then t:Destroy() end end selP = nil else giveBT() end
end)

lp.CharacterAdded:Connect(function() task.wait(0.5) if tpOn then giveTp() end if btOn then giveBT() end if flingOn then giveFling() end end)
