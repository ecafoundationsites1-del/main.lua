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
ScreenGui.Name = "AntiLua_Mobile_Pro"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0

local KeyCorner = Instance.new("UICorner", KeyFrame)
local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "AntiLua Key System"
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
MainFrame.Size = UDim2.new(0, 320, 0, 250)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
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
ProfileImg.Size = UDim2.new(0, 70, 0, 70)
ProfileImg.Position = UDim2.new(0.5, -35, 0.1, 0)
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local ImgCorner = Instance.new("UICorner", ProfileImg)
ImgCorner.CornerRadius = UDim.new(1, 0)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.6, 0)
EspBtn.Text = "Activate Murder ESP"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)

--- 기능 구현 ---

-- 1. 키 시스템
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

-- 2. 고성능 ESP 로직 (보안관 감지 강화)
local espEnabled = false

local function applyESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local color = Color3.fromRGB(0, 255, 0) -- 기본: 시민 (초록)

            -- [살인자 체크]
            local knifeNames = {"Knife", "칼", "Slasher"}
            local isMurder = false
            for _, name in pairs(knifeNames) do
                if char:FindFirstChild(name) or v.Backpack:FindFirstChild(name) then
                    isMurder = true
                    break
                end
            end

            -- [보안관 체크] (더 많은 이름 추가)
            local gunNames = {"Gun", "Revolver", "총", "Luger", "Sheriff"}
            local isSheriff = false
            for _, name in pairs(gunNames) do
                if char:FindFirstChild(name) or v.Backpack:FindFirstChild(name) then
                    isSheriff = true
                    break
                end
            end

            -- 우선순위: 살인자 > 보안관 > 시민
            if isMurder then
                color = Color3.fromRGB(255, 0, 0) -- 빨강
            elseif isSheriff then
                color = Color3.fromRGB(0, 150, 255) -- 파랑
            end

            -- Highlight 적용
            local highlight = char:FindFirstChild("MM2_ESP")
            if not highlight then
                highlight = Instance.new("Highlight", char)
                highlight.Name = "MM2_ESP"
            end
            
            highlight.FillColor = color
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- 벽 너머에서도 보임
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
                task.wait(0.5) -- 0.5초마다 갱신 (반응 속도 향상)
            end
        end)
    else
        -- ESP 제거
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("MM2_ESP") then
                v.Character.MM2_ESP:Destroy()
            end
        end
    end
end)

