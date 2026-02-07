-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- 설정
local CORRECT_KEY = "DORS123" 

-- UI 생성 (ScreenGui)
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Ultimate_Mobile"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 15)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.4, 0)
KeyInput.PlaceholderText = "Enter Key: DORS123"
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 240, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -120, 0.7, 0)
CheckBtn.Text = "Login"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)

-- [2] 메인 UI (합쳐진 버전)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AntiLua Premium Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

-- 버튼 생성 함수 (중복 코드 방지)
local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.Size = UDim2.new(0, 260, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    Instance.new("UICorner", btn)
    return btn
end

local GodBtn = createBtn("GodBtn", UDim2.new(0.5, -130, 0.25, 0), Color3.fromRGB(255, 100, 0))
GodBtn.Text = "God Mode: OFF"

local EspBtn = createBtn("EspBtn", UDim2.new(0.5, -130, 0.45, 0), Color3.fromRGB(171, 60, 255))
EspBtn.Text = "Murder ESP: OFF"

local CloseBtn = createBtn("CloseBtn", UDim2.new(0.5, -130, 0.75, 0), Color3.fromRGB(200, 50, 50))
CloseBtn.Text = "Close Script"
CloseBtn.Size = UDim2.new(0, 260, 0, 40)

--- 기능 구현 ---

-- 키 체크
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    end
end)

-- [기능 1] 갓모드 (God Mode)
local godEnabled = false
GodBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    GodBtn.Text = godEnabled and "God Mode: ON" or "God Mode: OFF"
    GodBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 100, 0)
    
    task.spawn(function()
        while godEnabled do
            pcall(function()
                local char = lp.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        if hum.Health > 0 and hum.Health < 100 then
                            hum.Health = 100
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- [기능 2] 강화된 ESP
local espEnabled = false
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    
    task.spawn(function()
        while espEnabled do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character then
                    local char = v.Character
                    local color = Color3.fromRGB(0, 255, 0) -- 시민

                    -- 역할 판별 (도구 이름 기반)
                    local isMurder = char:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") or char:FindFirstChild("칼")
                    local isSheriff = char:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver") or char:FindFirstChild("총")

                    if isMurder then color = Color3.fromRGB(255, 0, 0)
                    elseif isSheriff then color = Color3.fromRGB(0, 150, 255) end

                    local hl = char:FindFirstChild("MM2_HL") or Instance.new("Highlight", char)
                    hl.Name = "MM2_HL"
                    hl.FillColor = color
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.4
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                end
            end
            task.wait(0.5)
        end
        -- ESP 종료 시 제거
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("MM2_HL") then
                v.Character.MM2_HL:Destroy()
            end
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

