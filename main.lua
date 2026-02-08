-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_Universal_Hub_V4"
ScreenGui.ResetOnSpawn = false

-------------------------------------------------------
-- [드래그 함수]
-------------------------------------------------------
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-------------------------------------------------------
-- [최소화 및 메인 UI]
-------------------------------------------------------
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "ECA"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false 
makeDraggable(OpenBtn)

local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 450, 0, 260)
KeyFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.new(1, 1, 1)
makeDraggable(KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 320, 0, 50)
KeyInput.Position = UDim2.new(0.5, -160, 0.4, 0)
KeyInput.Text = "DORS123"

local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
CheckKeyBtn.Size = UDim2.new(0, 150, 0, 45)
CheckKeyBtn.Position = UDim2.new(0.5, -75, 0.75, 0)
CheckKeyBtn.Text = "확인"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.Visible = false
makeDraggable(MainFrame)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)
CheckKeyBtn.MouseButton1Click:Connect(function() if KeyInput.Text == "DORS123" then KeyFrame:Destroy() MainFrame.Visible = true end end)

-- 사이드바 및 페이지
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -82)
SideBar.Position = UDim2.new(0, 0, 0, 82)
SideBar.BackgroundColor3 = Color3.new(0, 0, 0)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -162, 1, -82)
PageContainer.Position = UDim2.new(0, 162, 0, 82)
PageContainer.BackgroundTransparency = 1

local Pages = {
    Player = Instance.new("Frame", PageContainer),
    ESP = Instance.new("Frame", PageContainer),
    Wallhole = Instance.new("Frame", PageContainer),
    TP = Instance.new("Frame", PageContainer),
    AutoFarm = Instance.new("Frame", PageContainer)
}
for _, p in pairs(Pages) do p.Size = UDim2.new(1, 0, 1, 0) p.Visible = false p.BackgroundTransparency = 1 end
Pages.Player.Visible = true

local function createMenuBtn(name, pos, page)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0.5, -70, 0, pos)
    btn.Text = name
    btn.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end page.Visible = true end)
end
createMenuBtn("☰ 플레이어", 10, Pages.Player)
createMenuBtn("👁 ESP", 50, Pages.ESP)
createMenuBtn("🧱 Wallhole", 90, Pages.Wallhole)
createMenuBtn("🚀 Gun TP", 130, Pages.TP)
createMenuBtn("🚜 Auto Farm", 170, Pages.AutoFarm)

-- 기능 버튼들
local EspToggle = Instance.new("TextButton", Pages.ESP)
EspToggle.Size = UDim2.new(0, 180, 0, 50)
EspToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
EspToggle.Text = "ESP: OFF"

local WallToggle = Instance.new("TextButton", Pages.Wallhole)
WallToggle.Size = UDim2.new(0, 180, 0, 50)
WallToggle.Position = UDim2.new(0.5, -90, 0.4, -25)
WallToggle.Text = "Wallhole: OFF"

local TpToggle = Instance.new("TextButton", Pages.TP)
TpToggle.Size = UDim2.new(0, 200, 0, 60)
TpToggle.Position = UDim2.new(0.5, -100, 0.4, -30)
TpToggle.Text = "AUTO TP GUN: OFF"

local CoinFarmBtn = Instance.new("TextButton", Pages.AutoFarm)
CoinFarmBtn.Size = UDim2.new(0, 200, 0, 60)
CoinFarmBtn.Position = UDim2.new(0.5, -100, 0.4, -30)
CoinFarmBtn.Text = "COIN FARM: OFF"

-------------------------------------------------------
-- [핵심 로직 시스템]
-------------------------------------------------------
local coinFarmActive = false
local tpActive = false
local wallholeEnabled = false
local espEnabled = false
local safetyDistance = 10 
local platform = nil

-- 살인자 찾기 함수
local function getMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife") then
                return v.Character.HumanoidRootPart
            end
        end
    end
    return nil
end

-- 스카이 스폰 및 발판
local function skySpawn()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0)
        if not platform or not platform.Parent then
            platform = Instance.new("Part")
            platform.Size = Vector3.new(20, 1, 20)
            platform.Position = Vector3.new(0, 495, 0)
            platform.Anchored = true
            platform.Transparency = 0.5
            platform.BrickColor = BrickColor.new("Bright blue")
            platform.Parent = workspace
        end
    end
end

-- [기능 1] ESP
task.spawn(function()
    while true do
        if espEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character then
                    local h = v.Character:FindFirstChild("ECA_H") or Instance.new("Highlight", v.Character)
                    h.Name = "ECA_H"
                    local isM = v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Knife")
                    h.FillColor = isM and Color3.new(1,0,0) or Color3.new(0,1,0)
                    h.Enabled = true
                end
            end
        else
            for _, v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("ECA_H") then v.Character.ECA_H.Enabled = false end end
        end
        task.wait(0.5)
    end
end)

-- [기능 2] Wallhole
workspace.DescendantAdded:Connect(function(obj)
    if wallholeEnabled and obj:IsA("BasePart") then
        if obj.Name:find("'s Bullet") or obj.Name == "KnifeProjectile" then
            obj.CanCollide = false
        end
    end
end)

-- [기능 3] Gun Teleport (복구됨)
workspace.DescendantAdded:Connect(function(obj)
    if tpActive and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent and obj.Parent.Name == "Gun")) then
        task.wait(0.1)
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
        end
    end
end)

-- [기능 4] Auto Farm + Sky System
task.spawn(function()
    while true do
        if coinFarmActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            local murdererRoot = getMurderer()
            local coins = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin" and v:IsA("BasePart") then table.insert(coins, v) end
            end

            if #coins > 0 then
                if platform then platform:Destroy() platform = nil end
                for _, coin in pairs(coins) do
                    if not coinFarmActive then break end
                    local safe = true
                    if murdererRoot then
                        if (coin.Position - murdererRoot.Position).Magnitude < safetyDistance then safe = false end
                    end
                    if safe then
                        root.CFrame = coin.CFrame
                        task.wait(0.15)
                    end
                end
            else
                skySpawn()
            end
        end
        task.wait(0.1)
    end
end)

-------------------------------------------------------
-- [버튼 이벤트 연결]
-------------------------------------------------------
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
end)

WallToggle.MouseButton1Click:Connect(function()
    wallholeEnabled = not wallholeEnabled
    WallToggle.Text = wallholeEnabled and "Wallhole: ON" or "Wallhole: OFF"
end)

TpToggle.MouseButton1Click:Connect(function()
    tpActive = not tpActive
    TpToggle.Text = tpActive and "AUTO TP GUN: ON" or "AUTO TP GUN: OFF"
end)

CoinFarmBtn.MouseButton1Click:Connect(function()
    coinFarmActive = not coinFarmActive
    CoinFarmBtn.Text = coinFarmActive and "COIN FARM: ON" or "COIN FARM: OFF"
    if not coinFarmActive and platform then platform:Destroy() platform = nil end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if coinFarmActive then skySpawn() end
end)

