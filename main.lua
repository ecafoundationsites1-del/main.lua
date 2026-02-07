-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECAhack_Hub_V3"

-------------------------------------------------------
-- [1. 키 시스템 프레임] (첨부 이미지 디자인)
-------------------------------------------------------
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 450, 0, 260)
KeyFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.new(1, 1, 1)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, -10, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "ECAhack hub"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.TextSize = 28
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextXAlignment = Enum.TextXAlignment.Right

-- 회색 키 입력창
local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 320, 0, 50)
KeyInput.Position = UDim2.new(0.5, -160, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
KeyInput.Text = "키입력"
KeyInput.TextColor3 = Color3.new(0, 0, 0)
KeyInput.TextSize = 24
KeyInput.Font = Enum.Font.SourceSansBold

-- 보라색 키받기 버튼
local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 150, 0, 45)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 255)
GetKeyBtn.Text = "키받기"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.TextSize = 20
GetKeyBtn.Font = Enum.Font.SourceSansBold
GetKeyBtn.BorderSizePixel = 0

-- 연두색 확인 버튼
local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
CheckKeyBtn.Size = UDim2.new(0, 150, 0, 45)
CheckKeyBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CheckKeyBtn.Text = "확인"
CheckKeyBtn.TextColor3 = Color3.new(1, 1, 1)
CheckKeyBtn.TextSize = 20
CheckKeyBtn.Font = Enum.Font.SourceSansBold
CheckKeyBtn.BorderSizePixel = 0

-------------------------------------------------------
-- [2. 메인 프레임] (초기 비활성)
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Visible = false

-- [상단 헤더 영역]
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundColor3 = Color3.new(0, 0, 0)
Header.BorderSizePixel = 0

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.Size = UDim2.new(1, 0, 0, 2)
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.BackgroundColor3 = Color3.new(1, 1, 1)

local ProfileImgTop = Instance.new("ImageLabel", Header)
ProfileImgTop.Size = UDim2.new(0, 60, 0, 60)
ProfileImgTop.Position = UDim2.new(0, 15, 0.5, -30)
ProfileImgTop.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
Instance.new("UICorner", ProfileImgTop).CornerRadius = UDim.new(1, 0)

local TopInfo = Instance.new("TextLabel", Header)
TopInfo.Size = UDim2.new(0, 250, 1, 0)
TopInfo.Position = UDim2.new(0, 85, 0, 0)
TopInfo.BackgroundTransparency = 1
TopInfo.Text = "Nickname: (" .. lp.Name .. ")\n계정생성일자: (" .. lp.AccountAge .. "일)"
TopInfo.TextColor3 = Color3.new(1, 1, 1)
TopInfo.TextXAlignment = Enum.TextXAlignment.Left
TopInfo.Font = Enum.Font.SourceSansBold
TopInfo.TextSize = 17

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

-- [페이지 컨테이너]
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -162, 1, -82)
PageContainer.Position = UDim2.new(0, 162, 0, 82)
PageContainer.BackgroundTransparency = 1

-- 페이지 1: 플레이어 정보
local PagePlayer = Instance.new("Frame", PageContainer)
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = true

local LargeProfile = Instance.new("ImageLabel", PagePlayer)
LargeProfile.Size = UDim2.new(0, 120, 0, 120)
LargeProfile.Position = UDim2.new(0.5, -60, 0.1, 0)
LargeProfile.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
LargeProfile.BorderSizePixel = 2
LargeProfile.BorderColor3 = Color3.new(1, 1, 1)

local PlayerDetails = Instance.new("TextLabel", PagePlayer)
PlayerDetails.Size = UDim2.new(1, 0, 0, 60)
PlayerDetails.Position = UDim2.new(0, 0, 0.65, 0)
PlayerDetails.BackgroundTransparency = 1
PlayerDetails.Text = "DISPLAY: " .. lp.DisplayName .. "\nUSER ID: " .. lp.UserId
PlayerDetails.TextColor3 = Color3.new(1, 1, 1)
PlayerDetails.Font = Enum.Font.SourceSansBold
PlayerDetails.TextSize = 20

-- 페이지 2: ESP
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

-- 페이지 3: 미구현
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
-- [3. 로직 및 이벤트]
-------------------------------------------------------

-- 드래그 함수
local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = i.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

makeDraggable(KeyFrame)
makeDraggable(MainFrame)

-- 키 시스템 로직
GetKeyBtn.MouseButton1Click:Connect(function()
    local link = "https://link-target.net/3356742/3g1CM5ipo8co"
    if setclipboard then
        setclipboard(link)
        GetKeyBtn.Text = "복사 완료!"
        task.wait(2)
        GetKeyBtn.Text = "키받기"
    else
        KeyInput.Text = "클립보드 지원불가"
    end
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "DORS123" then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = "틀렸습니다!"
        task.wait(1)
        KeyInput.Text = ""
    end
end)

-- 페이지 전환
local function showPage(page)
    PagePlayer.Visible = false
    PageESP.Visible = false
    PageNotDev.Visible = false
    page.Visible = true
end

-- 사이드바 버튼
local function createMenuBtn(name, pos, page)
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
    btn.MouseButton1Click:Connect(function() showPage(page) end)
    return btn
end

createMenuBtn("☰ 플레이어 정보", 15, PagePlayer)
createMenuBtn("👁 ESP(TEAMS)", 60, PageESP)
createMenuBtn("🧱 wall hgole gun", 105, PageNotDev)

-- ESP 기능
local espEnabled = false
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local char = v.Character
            local high = char:FindFirstChild("ECA_Highlight") or Instance.new("Highlight", char)
            high.Name = "ECA_Highlight"
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

