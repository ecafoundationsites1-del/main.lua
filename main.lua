-- [[ 서비스 선언 ]]
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService") -- [수정] 누락되었던 서비스 추가

-- [[ 설정 ]]
local CONFIG = {
    KEY = "DORS123",
    LINK = "https://github.com/YourName/YourRepo",
    TITLE = "PREMIUM EXPLOIT V2"
}

-- [[ 상태 변수 ]]
local aimEnabled = false
local wallHackEnabled = false
local dragging = false
local dragInput, dragStart, startPos

-- [[ UI 생성 ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OptimizedGui"
local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = Player.PlayerGui end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 10)

-- 상단 타이틀 바 (드래그 핸들)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = CONFIG.TITLE
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- [드래그 로직 개선: 모바일 최적화]
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- [ 섹션 컨테이너 ]
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1

-- 1. 로그인 섹션
local LoginSection = Instance.new("Frame", Container)
LoginSection.Size = UDim2.new(1, 0, 1, 0)
LoginSection.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", LoginSection)
KeyInput.Size = UDim2.new(1, 0, 0, 40)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local LoginBtn = Instance.new("TextButton", LoginSection)
LoginBtn.Size = UDim2.new(1, 0, 0, 40)
LoginBtn.Position = UDim2.new(0, 0, 0, 50)
LoginBtn.Text = "LOGIN"
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
LoginBtn.TextColor3 = Color3.new(1, 1, 1)

-- 2. 기능 섹션 (숨김 상태)
local FeatureSection = Instance.new("Frame", Container)
FeatureSection.Size = UDim2.new(1, 0, 1, 0)
FeatureSection.BackgroundTransparency = 1
FeatureSection.Visible = false

local function createToggleButton(text, pos, callback)
    local btn = Instance.new("TextButton", FeatureSection)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = pos
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- [[ 기능 로직 수정 ]]

local function getClosest()
    local maxDist = 1000
    local target = nil
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = v.Character.HumanoidRootPart.Position
            local mag = (pos - Player.Character.HumanoidRootPart.Position).Magnitude
            if mag < maxDist then
                maxDist = mag
                target = v.Character
            end
        end
    end
    return target
end

-- 에임 보정 (RenderStepped 적용)
RunService.RenderStepped:Connect(function()
    if aimEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosest()
        if target then
            -- 캐릭터가 타겟을 부드럽게 바라보게 함
            local lookAt = CFrame.lookAt(Player.Character.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame:Lerp(lookAt, 0.1)
        end
    end
end)

-- [[ 이벤트 연결 ]]

LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CONFIG.KEY then
        LoginSection.Visible = false
        FeatureSection.Visible = true
        Title.Text = "WELCOME, " .. Player.Name:upper()
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "INVALID KEY!"
    end
end)

createToggleButton("Aimbot Lock", UDim2.new(0,0,0,0), function(btn)
    aimEnabled = not aimEnabled
    btn.Text = "Aimbot Lock: " .. (aimEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = aimEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(180, 50, 50)
end)

createToggleButton("Wall Visuals", UDim2.new(0,0,0,55), function(btn)
    wallHackEnabled = not wallHackEnabled
    btn.Text = "Wall Visuals: " .. (wallHackEnabled and "ON" or "OFF")
    btn.BackgroundColor3 = wallHackEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(180, 50, 50)
end)

-- 시각적 효과 (개선)
UserInputService.InputBegan:Connect(function(input, proc)
    if not proc and wallHackEnabled and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local t = getClosest()
        if t then
            local beam = Instance.new("Part", workspace)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Material = Enum.Material.Neon
            beam.Color = Color3.fromRGB(255, 0, 0)
            beam.Size = Vector3.new(0.2, 0.2, (Player.Character.Head.Position - t.HumanoidRootPart.Position).Magnitude)
            beam.CFrame = CFrame.lookAt(Player.Character.Head.Position, t.HumanoidRootPart.Position) * CFrame.new(0, 0, -beam.Size.Z/2)
            
            task.delay(0.1, function() beam:Destroy() end)
        end
    end
end)

