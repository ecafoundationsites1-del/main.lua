local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [설정 변수]
local CORRECT_KEY = "DORS123"
local KEY_URL = "https://link-center.net/your_link_here" -- 실제 링크로 수정 가능

-- [UI 생성]
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Final"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
local KeyCorner = Instance.new("UICorner", KeyFrame)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "AntiLua HUB"
KeyTitle.TextColor3 = Color3.fromRGB(171, 60, 255)
KeyTitle.TextSize = 20
KeyTitle.Font = Enum.Font.UbuntuBold
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.35, 0)
KeyInput.PlaceholderText = "키를 입력하세요..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 115, 0, 40)
GetKeyBtn.Position = UDim2.new(0.5, -120, 0.65, 0)
GetKeyBtn.Text = "키 받기"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GetKeyBtn)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 115, 0, 40)
CheckBtn.Position = UDim2.new(0.5, 5, 0.65, 0)
CheckBtn.Text = "확인"
CheckBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
CheckBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CheckBtn)

-- [2] 메인 기능 UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local ProfileImg = Instance.new("ImageLabel", MainFrame)
ProfileImg.Size = UDim2.new(0, 80, 0, 80)
ProfileImg.Position = UDim2.new(0.5, -40, 0.08, 0)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local ImgCorner = Instance.new("UICorner", ProfileImg)
ImgCorner.CornerRadius = UDim.new(1, 0)

-- [버튼들]
local function CreateButton(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 260, 0, 55)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.UbuntuMedium
    Instance.new("UICorner", btn)
    return btn
end

local EspBtn = CreateButton("ESP (팀 구별): OFF", UDim2.new(0.5, -130, 0.35, 0), Color3.fromRGB(171, 60, 255))
local GodBtn = CreateButton("갓모드: OFF", UDim2.new(0.5, -130, 0.55, 0), Color3.fromRGB(255, 100, 0))

-----------------------------------------------------------
-- 기능 구현 섹션
-----------------------------------------------------------

-- 1. 키 시스템
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_URL)
    GetKeyBtn.Text = "링크 복사됨!"
    task.wait(2)
    GetKeyBtn.Text = "키 받기"
end)

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "잘못된 키입니다!"
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 2. ESP 기능 (한국 머더 최적화)
local espEnabled = false
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP (팀 구별): ON" or "ESP (팀 구별): OFF"
    
    task.spawn(function()
        while espEnabled do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character then
                    local char = v.Character
                    local color = Color3.fromRGB(0, 255, 0) -- 시민 (초록)
                    
                    local hasKnife = char:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife")
                    local hasGun = char:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver") or v.Backpack:FindFirstChild("Revolver")
                    
                    if hasKnife then
                        color = Color3.fromRGB(255, 0, 0) -- 살인자 (빨강)
                    elseif hasGun then
                        if v.Team and (v.Team.Name == "Sheriff" or v.Team.Name == "보안관") then
                            color = Color3.fromRGB(0, 0, 255) -- 보안관 (파랑)
                        else
                            color = Color3.fromRGB(255, 255, 0) -- 영웅 (노랑)
                        end
                    end
                    
                    local hl = char:FindFirstChild("AntiLuaHL") or Instance.new("Highlight", char)
                    hl.Name = "AntiLuaHL"
                    hl.FillColor = color
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
            task.wait(1)
        end
        -- 종료 시 제거
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("AntiLuaHL") then
                v.Character.AntiLuaHL:Destroy()
            end
        end
    end)
end)

-- 3. 갓모드 기능
local godEnabled = false
GodBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    GodBtn.Text = godEnabled and "갓모드: ON" or "갓모드: OFF"
    
    task.spawn(function()
        while godEnabled do
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.Health = lp.Character.Humanoid.MaxHealth
            end
            task.wait(0.1)
        end
    end)
end)
