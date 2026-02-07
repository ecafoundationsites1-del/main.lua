-- 서비스 로드
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECAhack_Hub_V3"

-- [메인 프레임]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)

-- [상단 헤더 영역]
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundColor3 = Color3.new(0, 0, 0)
Header.BorderSizePixel = 0

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.Size = UDim2.new(1, 0, 0, 2)
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.BackgroundColor3 = Color3.new(1, 1, 1)

-- 상단 프로필 (이미지 일치)
local ProfileImgTop = Instance.new("ImageLabel", Header)
ProfileImgTop.Size = UDim2.new(0, 60, 0, 60)
ProfileImgTop.Position = UDim2.new(0, 15, 0.5, -30)
ProfileImgTop.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
Instance.new("UICorner", ProfileImgTop).CornerRadius = UDim.new(1, 0)

-- 상단 정보 (닉네임 괄호 및 날짜)
local TopInfo = Instance.new("TextLabel", Header)
TopInfo.Size = UDim2.new(0, 250, 1, 0)
TopInfo.Position = UDim2.new(0, 85, 0, 0)
TopInfo.BackgroundTransparency = 1
TopInfo.Text = "Nickname: (" .. lp.Name .. ")\n계정생성일자: (" .. lp.AccountAge .. "일)"
TopInfo.TextColor3 = Color3.new(1, 1, 1)
TopInfo.TextXAlignment = Enum.TextXAlignment.Left
TopInfo.Font = Enum.Font.SourceSansBold
TopInfo.TextSize = 17

-- 허브 제목
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(1, -210, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ECAhack hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 28
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Right

-- [사이드바 영역]
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -82)
SideBar.Position = UDim2.new(0, 0, 0, 82)
SideBar.BackgroundColor3 = Color3.new(0, 0, 0)

local SideLine = Instance.new("Frame", SideBar)
SideLine.Size = UDim2.new(0, 2, 1, 0)
SideLine.Position = UDim2.new(1, 0, 0, 0)
SideLine.BackgroundColor3 = Color3.new(1, 1, 1)

-- [우측 컨텐츠 영역 (페이지 전환용 컨테이너)]
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -162, 1, -82)
PageContainer.Position = UDim2.new(0, 162, 0, 82)
PageContainer.BackgroundTransparency = 1

-------------------------------------------------------
-- 페이지 1: 플레이어 정보 (디자인 반영)
local PagePlayer = Instance.new("Frame", PageContainer)
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = true -- 기본 페이지

local LargeProfile = Instance.new("ImageLabel", PagePlayer)
LargeProfile.Size = UDim2.new(0, 120, 0, 120)
LargeProfile.Position = UDim2.new(0.5, -60, 0.1, 0)
LargeProfile.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
LargeProfile.BackgroundColor3 = Color3.new(0, 0, 0)
LargeProfile.BorderColor3 = Color3.new(1, 1, 1)
LargeProfile.BorderSizePixel = 2

local PlayerDetails = Instance.new("TextLabel", PagePlayer)
PlayerDetails.Size = UDim2.new(1, 0, 0, 60)
PlayerDetails.Position = UDim2.new(0, 0, 0.65, 0)
PlayerDetails.BackgroundTransparency = 1
PlayerDetails.Text = "DISPLAY: " .. lp.DisplayName .. "\nUSER ID: " .. lp.UserId
PlayerDetails.TextColor3 = Color3.new(1, 1, 1)
PlayerDetails.Font = Enum.Font.SourceSansBold
PlayerDetails.TextSize = 20

-- 페이지 2: ESP 설정 창
local PageESP = Instance.new("Frame", PageContainer)
PageESP.Size = UDim2.new(1, 0, 1, 0)
PageESP.BackgroundTransparency = 1
PageESP.Visible = false

local EspToggle = Instance.new("TextButton", PageESP)
EspToggle.Size = UDim2.new(0, 180, 0, 50)
EspToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
EspToggle.BackgroundColor3 = Color3.new(0, 0, 0)
EspToggle.BorderColor3 = Color3.new(1, 1, 1)
EspToggle.Text = "ESP: OFF"
EspToggle.TextColor3 = Color3.new(1, 1, 1)
EspToggle.Font = Enum.Font.SourceSansBold
EspToggle.TextSize = 22

-- 페이지 3: 미구현 안내 창
local PageNotDev = Instance.new("Frame", PageContainer)
PageNotDev.Size = UDim2.new(1, 0, 1, 0)
PageNotDev.BackgroundTransparency = 1
PageNotDev.Visible = false

local NotDevMsg = Instance.new("TextLabel", PageNotDev)
NotDevMsg.Size = UDim2.new(1, 0, 1, 0)
NotDevMsg.BackgroundTransparency = 1
NotDevMsg.Text = "It has not been\ndeveloped! :("
NotDevMsg.TextColor3 = Color3.new(1, 1, 1)
NotDevMsg.TextSize = 45
NotDevMsg.Font = Enum.Font.SourceSansBold
-------------------------------------------------------

-- 사이드바 버튼 생성
local function createMenuBtn(name, pos)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0.5, -70, 0, pos)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.new(1, 1, 1)
    return btn
end

local BtnInfo = createMenuBtn("☰ 플레이어 정보", 15)
local BtnEsp = createMenuBtn("👁 ESP(TEAMS)", 60)
local BtnWall = createMenuBtn("🧱 wall hgole gun", 105)

-- 사이드바 하단 안내 텍스트
local Footer = Instance.new("TextLabel", SideBar)
Footer.Size = UDim2.new(1, 0, 0, 80)
Footer.Position = UDim2.new(0, 0, 1, -80)
Footer.BackgroundTransparency = 1
Footer.Text = "The button has\nnot been\ndeveloped.\n:("
Footer.TextColor3 = Color3.new(1, 1, 1)
Footer.TextSize = 13

-- [페이지 전환 함수]
local function showPage(page)
    PagePlayer.Visible = false
    PageESP.Visible = false
    PageNotDev.Visible = false
    page.Visible = true
end

BtnInfo.MouseButton1Click:Connect(function() showPage(PagePlayer) end)
BtnEsp.MouseButton1Click:Connect(function() showPage(PageESP) end)
BtnWall.MouseButton1Click:Connect(function() showPage(PageNotDev) end)

-- [ESP 기능 구현]
local espEnabled = false
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local char = v.Character
            local high = char:FindFirstChild("ECA_Highlight") or Instance.new("Highlight", char)
            high.Name = "ECA_Highlight"
            
            -- MM2 역할 감지
            local isM = char:FindFirstChild("Knife") or (v.Backpack:FindFirstChild("Knife"))
            local isS = char:FindFirstChild("Gun") or (v.Backpack:FindFirstChild("Gun"))
            
            high.FillColor = isM and Color3.new(1,0,0) or (isS and Color3.new(0,0.5,1) or Color3.new(0,1,0))
            high.Enabled = espEnabled
        end
    end
end

EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    EspToggle.BackgroundColor3 = espEnabled and Color3.new(1,1,1) or Color3.new(0,0,0)
    EspToggle.TextColor3 = espEnabled and Color3.new(0,0,0) or Color3.new(1,1,1)
    
    task.spawn(function()
        while espEnabled do updateESP() task.wait(0.5) end
    end)
end)

-- 드래그 기능 (모바일/PC)
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = MainFrame.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function() dragging = false end)

