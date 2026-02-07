-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- 설정
local CORRECT_KEY = "DORS123" 
local espEnabled = false
local silentAimEnabled = false

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_KR_Murder_Pro"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
local KeyCorner = Instance.new("UICorner", KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.35, 0)
KeyInput.PlaceholderText = "키를 입력하세요 (DORS123)"
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 240, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -120, 0.65, 0)
CheckBtn.Text = "인증하기"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
CheckBtn.TextColor3 = Color3.new(0, 0, 0)

-- [2] 메인 UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "한국머더 전용 메뉴"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.25, 0)
EspBtn.Text = "ESP: 꺼짐"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EspBtn)

local AimBtn = Instance.new("TextButton", MainFrame)
AimBtn.Size = UDim2.new(0, 240, 0, 50)
AimBtn.Position = UDim2.new(0.5, -120, 0.55, 0)
AimBtn.Text = "벽뚫 자동사격: 꺼짐"
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
AimBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AimBtn)

--- 핵심 기능 로직 ---

-- 살인자 찾기 (한국머더 한글 아이템 대응)
local function getMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local backpack = v:FindFirstChild("Backpack")
            local char = v.Character
            -- '칼' 또는 'Knife'를 가진 유저 확인
            if char:FindFirstChild("칼") or char:FindFirstChild("Knife") or (backpack and (backpack:FindFirstChild("칼") or backpack:FindFirstChild("Knife"))) then
                return v.Character
            end
        end
    end
    return nil
end

-- ESP 루프
task.spawn(function()
    while true do
        if espEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local char = v.Character
                    local isMurder = char:FindFirstChild("칼") or char:FindFirstChild("Knife") or (v:FindFirstChild("Backpack") and (v.Backpack:FindFirstChild("칼") or v.Backpack:FindFirstChild("Knife")))
                    
                    local hl = char:FindFirstChild("KR_ESP") or Instance.new("Highlight", char)
                    hl.Name = "KR_ESP"
                    hl.FillColor = isMurder and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.5
                    hl.Enabled = true
                end
            end
        else
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("KR_ESP") then
                    v.Character.KR_ESP:Destroy()
                end
            end
        end
        task.wait(0.5)
    end
end)

-- 자동 발사 (벽 무시) 루프
task.spawn(function()
    while true do
        if silentAimEnabled then
            local targetChar = getMurderer()
            local gun = lp.Character and (lp.Character:FindFirstChild("총") or lp.Character:FindFirstChild("Gun"))

            if targetChar and gun and targetChar:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetChar.HumanoidRootPart.Position
                
                -- 1. 살인자 강제 조준
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPos)
                
                -- 2. 자동 발사 및 리모트 호출 (벽 무시 시도)
                gun:Activate()
                local remote = gun:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    remote:FireServer(targetPos)
                end
            end
        end
        task.wait(0.05)
    end
end)

--- 버튼 이벤트 ---

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "잘못된 키입니다!"
    end
end)

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: 켜짐" or "ESP: 꺼짐"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
end)

AimBtn.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    AimBtn.Text = silentAimEnabled and "벽뚫 자동사격: 켜짐" or "벽뚫 자동사격: 꺼짐"
    AimBtn.BackgroundColor3 = silentAimEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)

