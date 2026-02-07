-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- 설정
local KEY_URL = "여기에_키_링크_넣으세요" -- 키 받는 링크
local CORRECT_KEY = "DORS123" -- 정답 키

-- UI 생성 (모바일 최적화)
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Mobile"

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0

local KeyCorner = Instance.new("UICorner", KeyFrame)
KeyCorner.CornerRadius = UDim.new(0, 15)

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

-- [2] 메인 기능 UI (처음엔 숨김)
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

-- 프로필 사진 (동그란 화면)
local ProfileImg = Instance.new("ImageLabel", MainFrame)
ProfileImg.Size = UDim2.new(0, 70, 0, 70)
ProfileImg.Position = UDim2.new(0.5, -35, 0.1, 0)
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local ImgCorner = Instance.new("UICorner", ProfileImg)
ImgCorner.CornerRadius = UDim.new(1, 0)

-- ESP 버튼
local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 50)
EspBtn.Position = UDim2.new(0.5, -120, 0.6, 0)
EspBtn.Text = "Activate Murder ESP"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)

--- 기능 구현 ---

-- 1. 키 시스템 로직
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_URL) -- 링크 복사
    GetKeyBtn.Text = "Link Copied!"
    wait(2)
    GetKeyBtn.Text = "Get Key"
end)

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
        wait(1)
        KeyInput.PlaceholderText = "Enter Key Here..."
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 2. 한국 머더 전용 ESP 로직
local espEnabled = false
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    
    if espEnabled then
        local function applyESP()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local char = v.Character
                    local color = Color3.new(1, 1, 1) -- 시민 (기본 흰색/초록)
                    
                    -- 한국 머더 역할 감지 (도구 이름 기반)
                    if char:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") then
                        color = Color3.fromRGB(255, 0, 0) -- 살인자 (빨강)
                    elseif char:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun") then
                        color = Color3.fromRGB(0, 0, 255) -- 보안관 (파랑)
                    else
                        color = Color3.fromRGB(0, 255, 0) -- 시민 (초록)
                    end
                    
                    local highlight = char:FindFirstChild("MM2_ESP") or Instance.new("Highlight", char)
                    highlight.Name = "MM2_ESP"
                    highlight.FillColor = color
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                end
            end
        end
        
        -- 주기적으로 갱신 (역할이 바뀔 수 있으므로)
        task.spawn(function()
            while espEnabled do
                applyESP()
                task.wait(1)
            end
        end)
    else
        -- ESP 끄기
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("MM2_ESP") then
                v.Character.MM2_ESP:Destroy()
            end
        end
    end
end)

