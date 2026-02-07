-- [서비스 로드]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [설정 및 데이터]
local CORRECT_KEY = "DORS123"
local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총", "권총", "데저트이글", "DroppedGun", "GunDrop", "Handle"}

-- [UI 및 드래그 설정]
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Final"
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
MainFrame.Size = UDim2.new(0, 320, 0, 250)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
makeDraggable(MainFrame)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.2, 0)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
Instance.new("UICorner", EspBtn)

local GunTpToggleBtn = Instance.new("TextButton", MainFrame)
GunTpToggleBtn.Size = UDim2.new(0, 240, 0, 50)
GunTpToggleBtn.Position = UDim2.new(0.5, -120, 0.5, 0)
GunTpToggleBtn.Text = "Gun TP Button: OFF"
GunTpToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
Instance.new("UICorner", GunTpToggleBtn)

-- [3] GET GUN 실행 버튼
local QuickTpBtn = Instance.new("TextButton", ScreenGui)
QuickTpBtn.Size = UDim2.new(0, 65, 0, 65)
QuickTpBtn.Position = UDim2.new(0.85, 0, 0.5, 0)
QuickTpBtn.Text = "GET\nGUN"
QuickTpBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
QuickTpBtn.Visible = false
Instance.new("UICorner", QuickTpBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(QuickTpBtn)

--- [핵심 로직] ---

local espEnabled = false
local isTeleporting = false

-- 정밀 총 찾기 함수
local function getValidDroppedGun()
    for _, obj in pairs(workspace:GetDescendants()) do
        local isMatch = false
        for _, name in pairs(gunNames) do
            if obj.Name == name or (obj.Parent and obj.Parent.Name == name) then
                isMatch = true; break
            end
        end

        if isMatch and obj:IsA("BasePart") then
            -- 1. 플레이어가 들고 있는지 확인
            local model = obj:FindFirstAncestorOfClass("Model")
            local isPlayer = model and Players:GetPlayerFromCharacter(model)
            
            -- 2. 좌표 유효성 검사 (로비 텔포 방지용)
            -- 좌표가 0,0,0이 아니고, 너무 높거나 낮지 않은지 확인
            local pos = obj.Position
            local isRealMapPos = pos.Magnitude > 15 and pos.Y > -40 and pos.Y < 400
            
            if not isPlayer and isRealMapPos then
                return obj
            end
        end
    end
    return nil
end

-- ESP 및 순간이동 버튼 로직
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then KeyFrame:Destroy(); MainFrame.Visible = true end
end)

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    task.spawn(function()
        while espEnabled do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character then
                    local char = v.Character
                    local isMurder = false
                    local isSheriff = false
                    -- 인벤토리 및 손 체크
                    for _, item in pairs(v.Backpack:GetChildren()) do
                        if item.Name:find("Knife") or item.Name:find("칼") then isMurder = true end
                        for _, g in pairs(gunNames) do if item.Name == g then isSheriff = true end end
                    end
                    for _, item in pairs(char:GetChildren()) do
                        if item.Name:find("Knife") or item.Name:find("칼") then isMurder = true end
                        for _, g in pairs(gunNames) do if item.Name == g then isSheriff = true end end
                    end
                    local color = isMurder and Color3.new(1,0,0) or (isSheriff and Color3.new(0,0.5,1) or Color3.new(0,1,0))
                    local h = char:FindFirstChild("MM2_ESP") or Instance.new("Highlight", char)
                    h.Name = "MM2_ESP"; h.FillColor = color; h.Enabled = true
                end
            end
            task.wait(1)
        end
    end)
end)

GunTpToggleBtn.MouseButton1Click:Connect(function()
    QuickTpBtn.Visible = not QuickTpBtn.Visible
    GunTpToggleBtn.Text = QuickTpBtn.Visible and "Gun TP Button: ON" or "Gun TP Button: OFF"
    GunTpToggleBtn.BackgroundColor3 = QuickTpBtn.Visible and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)

QuickTpBtn.MouseButton1Click:Connect(function()
    if isTeleporting then return end
    local gun = getValidDroppedGun()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    
    if gun and root then
        isTeleporting = true
        local oldPos = root.CFrame
        
        -- 정확한 획득을 위해 0.2초간 강제 고정
        local t = tick()
        while tick() - t < 0.25 do
            root.CFrame = gun.CFrame + Vector3.new(0, 1.5, 0)
            RunService.Heartbeat:Wait()
        end
        
        task.wait(0.1)
        root.CFrame = oldPos -- 획득 후 즉시 복귀
        isTeleporting = false
    else
        QuickTpBtn.Text = "없음"
        task.wait(0.5); QuickTpBtn.Text = "GET\nGUN"
    end
end)
