-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECAhack_Hub_V3_Final_Universal"

-------------------------------------------------------
-- [1. 키 시스템]
-------------------------------------------------------
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 450, 0, 260)
KeyFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.new(1, 1, 1)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 320, 0, 50)
KeyInput.Position = UDim2.new(0.5, -160, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
KeyInput.Text = "DORS123"
KeyInput.TextColor3 = Color3.new(0, 0, 0)
KeyInput.TextSize = 24
KeyInput.Font = Enum.Font.SourceSansBold

local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
CheckKeyBtn.Size = UDim2.new(0, 150, 0, 45)
CheckKeyBtn.Position = UDim2.new(0.5, -75, 0.75, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
CheckKeyBtn.Text = "확인"
CheckKeyBtn.TextColor3 = Color3.new(1, 1, 1)
CheckKeyBtn.TextSize = 20
CheckKeyBtn.Font = Enum.Font.SourceSansBold

-------------------------------------------------------
-- [2. 메인 프레임 및 사이드바]
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Visible = false

local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -82)
SideBar.Position = UDim2.new(0, 0, 0, 82)
SideBar.BackgroundColor3 = Color3.new(0, 0, 0)
SideBar.BorderSizePixel = 0

local SideLine = Instance.new("Frame", SideBar)
SideLine.Size = UDim2.new(0, 2, 1, 0)
SideLine.Position = UDim2.new(1, 0, 0, 0)
SideLine.BackgroundColor3 = Color3.new(1, 1, 1)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -162, 1, -82)
PageContainer.Position = UDim2.new(0, 162, 0, 82)
PageContainer.BackgroundTransparency = 1

-- 페이지 설정
local Pages = {
    Player = Instance.new("Frame", PageContainer),
    ESP = Instance.new("Frame", PageContainer),
    Wallhole = Instance.new("Frame", PageContainer),
    TP = Instance.new("Frame", PageContainer)
}

for _, p in pairs(Pages) do
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
end
Pages.Player.Visible = true

-------------------------------------------------------
-- [3. 기능 버튼 및 메뉴 생성]
-------------------------------------------------------
local function createMenuBtn(name, pos, page)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0.5, -70, 0, pos)
    btn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

createMenuBtn("☰ 플레이어 정보", 15, Pages.Player)
createMenuBtn("👁 ESP(TEAMS)", 60, Pages.ESP)
createMenuBtn("🧱 Wallhole Gun", 105, Pages.Wallhole)
createMenuBtn("🚀 Gun Teleport", 150, Pages.TP)

-- 각 페이지별 버튼들
local EspToggle = Instance.new("TextButton", Pages.ESP)
EspToggle.Size = UDim2.new(0, 180, 0, 50)
EspToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
EspToggle.Text = "ESP: OFF"
EspToggle.BackgroundColor3 = Color3.new(0,0,0)
EspToggle.TextColor3 = Color3.new(1,1,1)
EspToggle.BorderColor3 = Color3.new(1,1,1)

local WallToggle = Instance.new("TextButton", Pages.Wallhole)
WallToggle.Size = UDim2.new(0, 180, 0, 50)
WallToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
WallToggle.Text = "Wallhole: OFF"
WallToggle.BackgroundColor3 = Color3.new(0,0,0)
WallToggle.TextColor3 = Color3.new(1,1,1)
WallToggle.BorderColor3 = Color3.new(1,1,1)

local TpToggle = Instance.new("TextButton", Pages.TP)
TpToggle.Size = UDim2.new(0, 200, 0, 60)
TpToggle.Position = UDim2.new(0.5, -100, 0.4, -30)
TpToggle.Text = "AUTO TP GUN: OFF"
TpToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
TpToggle.TextColor3 = Color3.new(1,1,1)
TpToggle.BorderColor3 = Color3.new(1,1,1)

-------------------------------------------------------
-- [4. 핵심 작동 로직]
-------------------------------------------------------

-- 드래그
local function drag(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = obj.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end
drag(KeyFrame) drag(MainFrame)

-- 키 확인
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "DORS123" then KeyFrame:Destroy() MainFrame.Visible = true end
end)

-- [기능 1: 범용 관통 로직]
local wallholeEnabled = false
local function applyWallhole(obj)
    if not wallholeEnabled then return end
    if obj:IsA("BasePart") then
        -- 's Bullet 패턴이나 Bullet, Projectile 이름을 포함하면 관통 처리
        if obj.Name:find("'s Bullet") or obj.Name:find("Bullet") or obj.Name:find("Projectile") then
            obj.CanCollide = false
            obj:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if wallholeEnabled then obj.CanCollide = false end
            end)
        end
    end
end

WallToggle.MouseButton1Click:Connect(function()
    wallholeEnabled = not wallholeEnabled
    WallToggle.Text = wallholeEnabled and "Wallhole: ON" or "Wallhole: OFF"
    WallToggle.BackgroundColor3 = wallholeEnabled and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    WallToggle.TextColor3 = wallholeEnabled and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    if wallholeEnabled then
        for _, v in pairs(workspace:GetDescendants()) do applyWallhole(v) end
    end
end)
workspace.DescendantAdded:Connect(applyWallhole)

-- [기능 2: 자동 텔레포트]
local tpActive = false
TpToggle.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    TpToggle.Text = tpActive and "AUTO TP GUN: ON" or "AUTO TP GUN: OFF"
    TpToggle.BackgroundColor3 = tpActive and Color3.new(0, 0.6, 0) or Color3.fromRGB(50, 0, 0)
end)

workspace.DescendantAdded:Connect(function(obj)
    if tpActive and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait(0.1)
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
        end
    end
end)

-- [기능 3: ESP]
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

