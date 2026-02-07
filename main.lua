-- [서비스 로드]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [설정 및 데이터]
local CORRECT_KEY = "DORS123"
local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총", "권총", "데저트이글", "DroppedGun", "GunDrop", "Handle", "Model"}

-- [UI 생성 및 드래그 설정]
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_KR_Pro_Final"
ScreenGui.ResetOnSpawn = false

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", KeyFrame)
makeDraggable(KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.3, 0)
KeyInput.PlaceholderText = "Key: DORS123"
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 240, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -120, 0.65, 0)
CheckBtn.Text = "Login"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
Instance.new("UICorner", CheckBtn)

-- [2] 메인 UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 330)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
makeDraggable(MainFrame)

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 260, 0, 45)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Ubuntu
    Instance.new("UICorner", btn)
    return btn
end

local EspBtn = createBtn("ESP: OFF", UDim2.new(0.5, -130, 0.1, 0), Color3.fromRGB(171, 60, 255))
local GunTpToggleBtn = createBtn("Gun TP Button: OFF", UDim2.new(0.5, -130, 0.35, 0), Color3.fromRGB(255, 80, 0))
local WallBtn = createBtn("Wall Penetration: OFF", UDim2.new(0.5, -130, 0.6, 0), Color3.fromRGB(0, 200, 255))
local CloseBtn = createBtn("Close Script", UDim2.new(0.5, -130, 0.85, 0), Color3.fromRGB(150, 0, 0))

-- [3] GET GUN 실행 버튼
local QuickTpBtn = Instance.new("TextButton", ScreenGui)
QuickTpBtn.Size = UDim2.new(0, 65, 0, 65)
QuickTpBtn.Position = UDim2.new(0.85, 0, 0.5, 0)
QuickTpBtn.Text = "GET\nGUN"
QuickTpBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
QuickTpBtn.Visible = false
Instance.new("UICorner", QuickTpBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(QuickTpBtn)

--- [핵심 기능 로직] ---

local espEnabled, wallEnabled, isTeleporting = false, false, false

-- 1. 살인마 중복 수정된 정밀 ESP
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local char = v.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local highlight = char:FindFirstChild("MM2_ESP") or Instance.new("Highlight", char)
            highlight.Name = "MM2_ESP"

            -- 죽은 사람은 끄기 (살인마 중복 방지)
            if not hum or hum.Health <= 0 then
                highlight.Enabled = false
                continue
            end

            local isMurder, isSheriff = false, false
            local function scan(container)
                for _, item in pairs(container:GetChildren()) do
                    if item:IsA("Tool") then
                        if item.Name:lower():find("knife") or item.Name:find("칼") then isMurder = true end
                        for _, gn in pairs(gunNames) do if item.Name == gn then isSheriff = true end end
                    end
                end
            end
            scan(v.Backpack); scan(char)

            highlight.FillColor = isMurder and Color3.new(1,0,0) or (isSheriff and Color3.new(0,0.5,1) or Color3.new(0,1,0))
            highlight.Enabled = true
        end
    end
end

-- 2. 한국 머더 전용 총 찾기 (로비 방지)
local function getDroppedGun()
    for _, obj in pairs(workspace:GetDescendants()) do
        local isGun = false
        for _, name in pairs(gunNames) do
            if obj.Name == name or (obj.Parent and obj.Parent.Name == name) then
                isGun = true; break
            end
        end
        if isGun and obj:IsA("BasePart") then
            local model = obj:FindFirstAncestorOfClass("Model")
            if not model or not Players:GetPlayerFromCharacter(model) then
                if obj.Position.Magnitude > 20 and obj.Position.Y > -30 then return obj end
            end
        end
    end
    return nil
end

-- 3. 벽 뚫기 관통 (Bullet Penetration)
local function doPenetration()
    while wallEnabled do
        pcall(function()
            -- 레이캐스트 무시를 위해 캐릭터 충돌 그룹 혹은 CanCollide 조절
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "Wall" or obj.Name == "Part") then
                    if (lp.Character.HumanoidRootPart.Position - obj.Position).Magnitude < 10 then
                        obj.CanCollide = false
                    else
                        obj.CanCollide = true
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end

-- [이벤트 연결]
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text:upper() == CORRECT_KEY then KeyFrame:Destroy(); MainFrame.Visible = true end
end)

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    task.spawn(function()
        while espEnabled do updateESP(); task.wait(1) end
        for _, v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("MM2_ESP") then v.Character.MM2_ESP.Enabled = false end end
    end)
end)

GunTpToggleBtn.MouseButton1Click:Connect(function()
    QuickTpBtn.Visible = not QuickTpBtn.Visible
    GunTpToggleBtn.Text = "Gun TP Button: " .. (QuickTpBtn.Visible and "ON" or "OFF")
    GunTpToggleBtn.BackgroundColor3 = QuickTpBtn.Visible and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)

WallBtn.MouseButton1Click:Connect(function()
    wallEnabled = not wallEnabled
    WallBtn.Text = "Wall Penetration: " .. (wallEnabled and "ON" or "OFF")
    WallBtn.BackgroundColor3 = wallEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(0, 200, 255)
    if wallEnabled then task.spawn(doPenetration) end
end)

QuickTpBtn.MouseButton1Click:Connect(function()
    if isTeleporting then return end
    local gun = getDroppedGun()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if gun and root then
        isTeleporting = true
        local oldPos = root.CFrame
        local start = tick()
        while tick() - start < 0.3 do
            root.CFrame = gun.CFrame + Vector3.new(0, 2, 0)
            RunService.Heartbeat:Wait()
        end
        task.wait(0.1); root.CFrame = oldPos
        isTeleporting = false
    else
        QuickTpBtn.Text = "없음"; task.wait(0.5); QuickTpBtn.Text = "GET\nGUN"
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

