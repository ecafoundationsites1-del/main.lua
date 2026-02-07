-- [서비스 로드]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [설정 및 데이터]
local CORRECT_KEY = "DORS123"
local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총", "권총", "데저트이글", "DroppedGun", "GunDrop", "Handle"}

-- [UI 생성 및 드래그 설정]
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Fixed_Final"
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

-- [UI 구성 요소]
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
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 240, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -120, 0.65, 0)
CheckBtn.Text = "Login"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
Instance.new("UICorner", CheckBtn)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
makeDraggable(MainFrame)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.1, 0)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EspBtn)

local GunTpToggleBtn = Instance.new("TextButton", MainFrame)
GunTpToggleBtn.Size = UDim2.new(0, 240, 0, 50)
GunTpToggleBtn.Position = UDim2.new(0.5, -120, 0.35, 0)
GunTpToggleBtn.Text = "Gun TP Button: OFF"
GunTpToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
GunTpToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GunTpToggleBtn)

-- ✅ 총알 관통 버튼 추가
local PenetrationBtn = Instance.new("TextButton", MainFrame)
PenetrationBtn.Size = UDim2.new(0, 240, 0, 50)
PenetrationBtn.Position = UDim2.new(0.5, -120, 0.6, 0)
PenetrationBtn.Text = "Bullet Penetration: OFF"
PenetrationBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
PenetrationBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", PenetrationBtn)

local QuickTpBtn = Instance.new("TextButton", ScreenGui)
QuickTpBtn.Size = UDim2.new(0, 65, 0, 65)
QuickTpBtn.Position = UDim2.new(0.85, 0, 0.5, 0)
QuickTpBtn.Text = "GET\nGUN"
QuickTpBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
QuickTpBtn.Visible = false
Instance.new("UICorner", QuickTpBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(QuickTpBtn)

--- [핵심 기능 로직] ---

local espEnabled = false
local isTeleporting = false
local espLoop = nil
local penetrationEnabled = false  -- ✅ 관통 활성화 플래그

-- 정밀 총 찾기 (로비 방지 및 주인 없는 총 검색)
local function getValidDroppedGun()
    local success, result = pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if not obj or not obj.Parent then continue end
            
            local isMatch = false
            for _, name in pairs(gunNames) do
                if obj.Name == name or (obj.Parent and obj.Parent.Name == name) then
                    isMatch = true
                    break
                end
            end

            if isMatch and obj:IsA("BasePart") then
                local model = obj:FindFirstAncestorOfClass("Model")
                local playerOwner = model and Players:GetPlayerFromCharacter(model)
                
                -- 좌표 검증: 로비(0,0,0) 제외 및 적절한 맵 높이 확인
                local pos = obj.Position
                local isValidPos = pos.Magnitude > 15 and pos.Y > -40 and pos.Y < 450
                
                if not playerOwner and isValidPos then
                    return obj
                end
            end
        end
        return nil
    end)
    
    if not success then
        warn("getValidDroppedGun 에러:", result)
        return nil
    end
    return result
end

-- ESP 로직 (살인마 중복 방지: 체력 및 도구 소유 확인)
local function updateESP()
    local success, err = pcall(function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character then
                local char = v.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if not hum then continue end
                
                local h = char:FindFirstChild("MM2_ESP")
                if not h then
                    h = Instance.new("Highlight", char)
                    h.Name = "MM2_ESP"
                end

                -- 플레이어가 죽었으면 ESP 끄기 (중복 표시 방지 핵심)
                if hum.Health <= 0 then
                    h.Enabled = false
                    continue
                end

                local isMurder = false
                local isSheriff = false

                local function scan(container)
                    if not container then return end
                    for _, item in pairs(container:GetChildren()) do
                        if item:IsA("Tool") then
                            if item.Name:find("Knife") or item.Name:find("칼") then 
                                isMurder = true 
                            end
                            for _, g in pairs(gunNames) do 
                                if item.Name == g then 
                                    isSheriff = true 
                                end 
                            end
                        end
                    end
                end

                scan(v.Backpack)
                scan(char)

                -- ✅ 색상 조건 개선
                if isMurder then
                    h.FillColor = Color3.new(1, 0, 0) -- 빨강 (살인마)
                elseif isSheriff then
                    h.FillColor = Color3.new(0, 0.5, 1) -- 파랑 (보안관)
                else
                    h.FillColor = Color3.new(0, 1, 0) -- 초록 (일반인)
                end
                
                h.Enabled = true
            end
        end
    end)
    
    if not success then
        warn("updateESP 에러:", err)
    end
end

-- ✅ 총알 관통 활성화 함수
local function enableBulletPenetration()
    while penetrationEnabled do
        local success, err = pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                -- 총알 감지 (Name이 Bullet, 탄환 등)
                if obj:IsA("BasePart") and (obj.Name == "Bullet" or obj.Name:find("bullet") or obj.Name == "탄환") then
                    -- 살인자의 캐릭터 파츠를 CanCollide = false로 설정
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= lp and player.Character then
                            local char = player.Character
                            local isMurder = false
                            
                            -- 살인마 판별
                            for _, item in pairs(char:GetDescendants()) do
                                if item:IsA("Tool") and (item.Name:find("Knife") or item.Name:find("칼")) then
                                    isMurder = true
                                    break
                                end
                            end
                            
                            -- 살인마의 모든 파츠를 관통 가능하게 설정
                            if isMurder then
                                for _, part in pairs(char:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        if not success then
            warn("Bullet Penetration 에러:", err)
        end
        
        task.wait(0.05)
    end
end

-- ✅ 플레이어 접속 처리
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        task.wait(0.5) -- 캐릭터 로드 대기
        if player.Character then
            updateESP()
        end
    end
end)

-- ✅ 플레이어 퇴장 처리
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        local espHighlight = player.Character:FindFirstChild("MM2_ESP")
        if espHighlight then
            espHighlight:Destroy()
        end
    end
end)

-- [이벤트 연결]
CheckBtn.MouseButton1Click:Connect(function()
    -- ✅ 키 검증 개선 (공백 제거, 대소문자 무��)
    local inputKey = KeyInput.Text:gsub(" ", ""):upper()
    if inputKey == CORRECT_KEY then 
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "❌ 잘못된 키"
        task.wait(1)
        KeyInput.PlaceholderText = "Key: DORS123"
    end
end)

-- ✅ ESP 토글 버그 수정 (단일 루프 관리)
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    
    if espEnabled then
        if espLoop then
            return -- 이미 실행 중이면 무시
        end
        
        espLoop = task.spawn(function()
            while espEnabled do
                updateESP()
                task.wait(0.5)
            end
            
            -- ESP 종료 시 모든 하이라이트 제거
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character then
                    local espHighlight = v.Character:FindFirstChild("MM2_ESP")
                    if espHighlight then
                        espHighlight.Enabled = false
                    end
                end
            end
            espLoop = nil
        end)
    else
        espLoop = nil
    end
end)

GunTpToggleBtn.MouseButton1Click:Connect(function()
    QuickTpBtn.Visible = not QuickTpBtn.Visible
    GunTpToggleBtn.Text = QuickTpBtn.Visible and "Gun TP Button: ON" or "Gun TP Button: OFF"
    GunTpToggleBtn.BackgroundColor3 = QuickTpBtn.Visible and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)

-- ✅ 총알 관통 토글 버튼
PenetrationBtn.MouseButton1Click:Connect(function()
    penetrationEnabled = not penetrationEnabled
    PenetrationBtn.Text = penetrationEnabled and "Bullet Penetration: ON" or "Bullet Penetration: OFF"
    PenetrationBtn.BackgroundColor3 = penetrationEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 200, 255)
    
    if penetrationEnabled then
        task.spawn(enableBulletPenetration)
    end
end)

-- ✅ TP 기능 에러 처리 강화
QuickTpBtn.MouseButton1Click:Connect(function()
    if isTeleporting then return end
    
    local success, err = pcall(function()
        local gun = getValidDroppedGun()
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        
        if not gun or not root then
            QuickTpBtn.Text = "없음"
            task.wait(0.5)
            QuickTpBtn.Text = "GET\nGUN"
            return
        end
        
        isTeleporting = true
        local oldPos = root.CFrame
        
        -- 총 획득을 위해 짧게 고정 후 복귀
        local t = tick()
        while tick() - t < 0.25 and root and root.Parent do
            root.CFrame = gun.CFrame + Vector3.new(0, 1.5, 0)
            RunService.Heartbeat:Wait()
        end
        
        task.wait(0.1)
        if root and root.Parent then
            root.CFrame = oldPos
        end
        isTeleporting = false
    end)
    
    if not success then
        warn("TP 에러:", err)
        isTeleporting = false
    end
end)

-- ✅ 스크립트 정리 (옵션)
game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
    if espLoop then
        espLoop = nil
    end
    penetrationEnabled = false
end)
