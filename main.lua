-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- 설정
local CORRECT_KEY = "DORS123" 

-- UI 생성 (기존 코드 유지)
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Mobile_Pro"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
local KeyCorner = Instance.new("UICorner", KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.4, 0)
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 115, 0, 40)
CheckBtn.Position = UDim2.new(0.5, 5, 0.7, 0)
CheckBtn.Text = "Check Key"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)

-- [2] 메인 UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 300)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner", MainFrame)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 45)
EspBtn.Position = UDim2.new(0.5, -120, 0.35, 0)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EspBtn)

-- 수정된 부분: 에임핵 버튼 대신 순간이동 버튼
local TeleportBtn = Instance.new("TextButton", MainFrame)
TeleportBtn.Size = UDim2.new(0, 240, 0, 45)
TeleportBtn.Position = UDim2.new(0.5, -120, 0.55, 0)
TeleportBtn.Text = "TP to Murderer"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
TeleportBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TeleportBtn)

--- 기능 구현 ---

-- 1. 키 체크 로직
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    end
end)

-- 2. ESP 로직 (기존 유지)
local function applyESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local isMurder = false
            -- 살인자 판별 로직... (중략)
            if char:FindFirstChild("Knife") or (v:FindFirstChild("Backpack") and v.Backpack:FindFirstChild("Knife")) then
                isMurder = true
            end

            local highlight = char:FindFirstChild("MM2_ESP") or Instance.new("Highlight", char)
            highlight.Name = "MM2_ESP"
            highlight.FillColor = isMurder and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
            highlight.Enabled = true
        end
    end
end

-- 3. 순간이동 로직 (새로 추가)
local function teleportToMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- 캐릭터가 칼을 들고 있는지 확인
            local hasKnife = v.Character:FindFirstChild("Knife") or (v:FindFirstChild("Backpack") and v.Backpack:FindFirstChild("Knife"))
            
            if hasKnife then
                local targetPos = v.Character.HumanoidRootPart.Position
                -- 살인자 머리 위 5스터드 위치로 순간이동 (안전빵)
                lp.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                return
            end
        end
    end
    TeleportBtn.Text = "Murderer Not Found!"
    task.wait(1)
    TeleportBtn.Text = "TP to Murderer"
end

TeleportBtn.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        teleportToMurderer()
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    -- ESP 활성화/비활성화 로직
    applyESP()
end)

