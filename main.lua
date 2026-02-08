-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECAhack_Hub_V3_Final"

-------------------------------------------------------
-- [1. 키 시스템 프레임]
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

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 320, 0, 50)
KeyInput.Position = UDim2.new(0.5, -160, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
KeyInput.Text = "키입력"
KeyInput.TextColor3 = Color3.new(0, 0, 0)
KeyInput.TextSize = 24
KeyInput.Font = Enum.Font.SourceSansBold

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 150, 0, 45)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 255)
GetKeyBtn.Text = "키받기"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.TextSize = 20
GetKeyBtn.Font = Enum.Font.SourceSansBold

local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
CheckKeyBtn.Size = UDim2.new(0, 150, 0, 45)
CheckKeyBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CheckKeyBtn.Text = "확인"
CheckKeyBtn.TextColor3 = Color3.new(1, 1, 1)
CheckKeyBtn.TextSize = 20
CheckKeyBtn.Font = Enum.Font.SourceSansBold

-------------------------------------------------------
-- [2. 메인 프레임]
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Visible = false

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

local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -82)
SideBar.Position = UDim2.new(0, 0, 0, 82)
SideBar.BackgroundColor3 = Color3.new(0, 0, 0)

local SideLine = Instance.new("Frame", SideBar)
SideLine.Size = UDim2.new(0, 2, 1, 0)
SideLine.Position = UDim2.new(1, 0, 0, 0)
SideLine.BackgroundColor3 = Color3.new(1, 1, 1)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -162, 1, -82)
PageContainer.Position = UDim2.new(0, 162, 0, 82)
PageContainer.BackgroundTransparency = 1

-- 페이지들 생성
local PagePlayer = Instance.new("Frame", PageContainer)
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = true

local PageESP = Instance.new("Frame", PageContainer)
PageESP.Size = UDim2.new(1, 0, 1, 0)
PageESP.BackgroundTransparency = 1
PageESP.Visible = false

local PageWallhole = Instance.new("Frame", PageContainer)
PageWallhole.Size = UDim2.new(1, 0, 1, 0)
PageWallhole.BackgroundTransparency = 1
PageWallhole.Visible = false

local PageTP = Instance.new("Frame", PageContainer) -- 텔레포트 전용 페이지
PageTP.Size = UDim2.new(1, 0, 1, 0)
PageTP.BackgroundTransparency = 1
PageTP.Visible = false

-------------------------------------------------------
-- [기능용 UI 요소들]
-------------------------------------------------------

-- ESP 버튼
local EspToggle = Instance.new("TextButton", PageESP)
EspToggle.Size = UDim2.new(0, 180, 0, 50)
EspToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
EspToggle.BackgroundColor3 = Color3.new(0, 0, 0)
EspToggle.BorderColor3 = Color3.new(1, 1, 1)
EspToggle.Text = "ESP: OFF"
EspToggle.TextColor3 = Color3.new(1, 1, 1)
EspToggle.Font = Enum.Font.SourceSansBold
EspToggle.TextSize = 22

-- 관통 버튼
local WallToggle = Instance.new("TextButton", PageWallhole)
WallToggle.Size = UDim2.new(0, 180, 0, 50)
WallToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
WallToggle.BackgroundColor3 = Color3.new(0, 0, 0)
WallToggle.BorderColor3 = Color3.new(1, 1, 1)
WallToggle.Text = "Wallhole: OFF"
WallToggle.TextColor3 = Color3.new(1, 1, 1)
WallToggle.Font = Enum.Font.SourceSansBold
WallToggle.TextSize = 22

-- 텔레포트 버튼
local TpToggle = Instance.new("TextButton", PageTP)
TpToggle.Size = UDim2.new(0, 220, 0, 60)
TpToggle.Position = UDim2.new(0.5, -110, 0.4, -30)
TpToggle.BackgroundColor3 = Color3.new(0, 0, 0)
TpToggle.BorderColor3 = Color3.fromRGB(255, 0, 0)
TpToggle.Text = "AUTO TP GUN: OFF"
TpToggle.TextColor3 = Color3.new(1, 1, 1)
TpToggle.Font = Enum.Font.SourceSansBold
TpToggle.TextSize = 20

-------------------------------------------------------
-- [3. 로직 및 이벤트]
-------------------------------------------------------

-- 드래그 기능
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

-- 페이지 전환
local function showPage(page)
    PagePlayer.Visible = false
    PageESP.Visible = false
    PageWallhole.Visible = false
    PageTP.Visible = false
    page.Visible = true
end

-- 사이드바 메뉴 버튼 생성
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
end

createMenuBtn("☰ 플레이어 정보", 15, PagePlayer)
createMenuBtn("👁 ESP(TEAMS)", 60, PageESP)
createMenuBtn("🧱 Wallhole Gun", 105, PageWallhole)
createMenuBtn("🚀 Gun Teleport", 150, PageTP) -- 텔레포트 메뉴 추가

-- 키 시스템
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "DORS123" then KeyFrame:Destroy() MainFrame.Visible = true
    else KeyInput.Text = "틀렸습니다!" task.wait(1) KeyInput.Text = "" end
end)

-- [기능1] ESP 로직 (보안관 정밀 감지 포함)
local espEnabled = false
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local char = v.Character
            local high = char:FindFirstChild("ECA_Highlight") or Instance.new("Highlight", char)
            high.Name = "ECA_Highlight"
            
            local isM = char:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife")
            local isS = char:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver") or v.Backpack:FindFirstChild("Revolver")
            
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
    task.spawn(function() while espEnabled do updateESP() task.wait(0.5) end end)
end)

-- [기능2] Wallhole (관통)
local wallholeEnabled = false
local function applyWallhole(obj)
    if obj:IsA("BasePart") and (obj.Name:find("Handle") or obj.Name:find("Projectile") or obj.Name:find("Bullet")) then
        obj.CanCollide = false
    end
end
WallToggle.MouseButton1Click:Connect(function()
    wallholeEnabled = not wallholeEnabled
    WallToggle.Text = wallholeEnabled and "Wallhole: ON" or "Wallhole: OFF"
    WallToggle.BackgroundColor3 = wallholeEnabled and Color3.new(1,1,1) or Color3.new(0,0,0)
    WallToggle.TextColor3 = wallholeEnabled and Color3.new(0,0,0) or Color3.new(1,1,1)
end)
workspace.DescendantAdded:Connect(function(obj) if wallholeEnabled then applyWallhole(obj) end end)

-- [기능3] Auto TP Gun (자동 텔레포트)
local autoTpEnabled = false
local function checkAndTp(obj)
    if not autoTpEnabled then return end
    -- MM2 등에서 떨어진 총의 일반적인 이름들
    if obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent:IsA("Model") and obj.Parent.Name == "Gun") then
        task.wait(0.1)
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = obj:IsA("Model") and obj:GetModelCFrame() or obj.CFrame
        end
    end
end
TpToggle.MouseButton1Click:Connect(function()
    autoTpEnabled = not autoTpEnabled
    TpToggle.Text = autoTpEnabled and "AUTO TP GUN: ON" or "AUTO TP GUN: OFF"
    TpToggle.BackgroundColor3 = autoTpEnabled and Color3.new(1,0,0) or Color3.new(0,0,0)
    TpToggle.TextColor3 = Color3.new(1,1,1)
end)
workspace.DescendantAdded:Connect(checkAndTp)

