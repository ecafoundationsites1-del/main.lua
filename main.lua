-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- 설정
local KEY_URL = "여기에_키_링크_넣으세요" 
local CORRECT_KEY = "DORS123" 

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Mobile_Ultimate"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0

local KeyCorner = Instance.new("UICorner", KeyFrame)
local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "AntiLua Ultimate"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.Ubuntu

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.4, 0)
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 115, 0, 40)
GetKeyBtn.Position = UDim2.new(0.5, -120, 0.7, 0)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 115, 0, 40)
CheckBtn.Position = UDim2.new(0.5, 5, 0.7, 0)
CheckBtn.Text = "Check Key"
CheckBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
CheckBtn.TextColor3 = Color3.new(0, 0, 0)

-- [2] 메인 UI
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner", MainFrame)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

local ProfileImg = Instance.new("ImageLabel", MainFrame)
ProfileImg.Size = UDim2.new(0, 60, 0, 60)
ProfileImg.Position = UDim2.new(0.5, -30, 0.05, 0)
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local ImgCorner = Instance.new("UICorner", ProfileImg)
ImgCorner.CornerRadius = UDim.new(1, 0)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.35, 0)
EspBtn.Text = "Activate MM2 ESP"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EspBtn)

local AimBtn = Instance.new("TextButton", MainFrame)
AimBtn.Size = UDim2.new(0, 240, 0, 50)
AimBtn.Position = UDim2.new(0.5, -120, 0.55, 0)
AimBtn.Text = "Silent Aim (Wallbang): OFF"
AimBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
AimBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AimBtn)

--- 기능 구현 ---

local espEnabled = false
local silentAimEnabled = false

-- 1. 키 시스템 로직
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_URL)
    GetKeyBtn.Text = "Link Copied!"
    task.wait(2)
    GetKeyBtn.Text = "Get Key"
end)

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
        task.wait(1)
        KeyInput.PlaceholderText = "Enter Key Here..."
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 2. 향상된 ESP 로직 (노란색 영웅 추가)
local function applyESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local backpack = v:FindFirstChild("Backpack")
            local color = Color3.fromRGB(0, 255, 0) -- 기본 시민 (초록)

            local knifeNames = {"Knife", "Slasher", "Saw", "Blade", "칼"}
            local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총"}

            local hasKnife = false
            local hasGun = false

            -- 무기 소지 검사
            for _, name in pairs(knifeNames) do
                if char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then
                    hasKnife = true break
                end
            end
            for _, name in pairs(gunNames) do
                if char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then
                    hasGun = true break
                end
            end

            -- 색상 결정 우선순위
            if hasKnife then
                color = Color3.fromRGB(255, 0, 0) -- 살인자 (빨강)
            elseif hasGun then
                -- 보안관(Sheriff)인지 총을 주운 영웅(Hero)인지 구분
                -- 여기서는 총을 들고 있으면 노란색, 보안관이면 파란색으로 표시 (간단한 구분)
                if v:FindFirstChild("Backpack") and v.Backpack:FindFirstChild("Gun") then
                    color = Color3.fromRGB(255, 255, 0) -- 총 든 시민/영웅 (노랑)
                else
                    color = Color3.fromRGB(0, 150, 255) -- 보안관 (파랑)
                end
            end

            local highlight = char:FindFirstChild("MM2_ESP")
            if not highlight then
                highlight = Instance.new("Highlight", char)
                highlight.Name = "MM2_ESP"
            end
            highlight.FillColor = color
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.4
            highlight.Enabled = true
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    
    if espEnabled then
        task.spawn(function()
            while espEnabled do
                applyESP()
                task.wait(0.3)
            end
        end)
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("MM2_ESP") then
                v.Character.MM2_ESP:Destroy()
            end
        end
    end
end)

-- 3. 벽 관통 및 안전 사일런트 에임
local function getMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("MM2_ESP") then
            -- ESP가 빨간색인 대상만 정확히 타겟팅
            if v.Character.MM2_ESP.FillColor == Color3.fromRGB(255, 0, 0) then
                return v.Character:FindFirstChild("HumanoidRootPart")
            end
        end
    end
    return nil
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if silentAimEnabled and (method == "Raycast" or method == "FindPartOnRay") then
        local target = getMurderer()
        if target then
            -- 벽 관통 유도
            return target.Position
        else
            -- 살인자 없으면 맵 밖으로 쏴서 자살 방지
            return Vector3.new(0, -1000, 0)
        end
    end
    return oldNamecall(self, ...)
end)

AimBtn.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    AimBtn.Text = silentAimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    AimBtn.BackgroundColor3 = silentAimEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)
