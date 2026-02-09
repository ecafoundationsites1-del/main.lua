-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- 이전 UI 삭제 (중복 방지)
local uiName = "ECA_V4_Final_Fixed"
local oldGui = gethui():FindFirstChild(uiName) or game:GetService("CoreGui"):FindFirstChild(uiName)
if oldGui then oldGui:Destroy() end

-- UI 컨테이너 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = uiName
ScreenGui.ResetOnSpawn = false

-------------------------------------------------------
-- [1. 드래그(이동) 기능 함수]
-------------------------------------------------------
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-------------------------------------------------------
-- [2. 메인 프레임 설정]
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Visible = false -- 로그인 전까지 숨김
MainFrame.ZIndex = 1
makeDraggable(MainFrame) -- 이동 기능 적용

-- 상단 바 (헤더)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "ECA HUB V4 UNIVERSAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Right

-- 사이드바 (목록바)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 150, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 2

-- 페이지 컨테이너
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -160, 1, -50)
PageContainer.Position = UDim2.new(0, 160, 0, 50)
PageContainer.BackgroundTransparency = 1

local Pages = {
    Player = Instance.new("Frame", PageContainer),
    ESP = Instance.new("Frame", PageContainer),
    Wallhole = Instance.new("Frame", PageContainer),
    TP = Instance.new("Frame", PageContainer),
    AutoFarm = Instance.new("Frame", PageContainer)
}

for _, p in pairs(Pages) do
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
end
Pages.Player.Visible = true

-------------------------------------------------------
-- [3. 사이드바 버튼 생성 (실종 방지용)]
-------------------------------------------------------
local function createMenuBtn(name, pos, page)
    local btn = Instance.new("TextButton", SideBar)
    btn.Name = name .. "_Btn"
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    btn.ZIndex = 3

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- 버튼 리스트 (정확하게 순서대로 배치)
createMenuBtn("☰ PLAYER", 15, Pages.Player)
createMenuBtn("👁 ESP", 55, Pages.ESP)
createMenuBtn("🧱 WALLHOLE", 95, Pages.Wallhole)
createMenuBtn("🚀 GUN TP", 135, Pages.TP)
createMenuBtn("🚜 AUTO FARM", 175, Pages.AutoFarm)

-------------------------------------------------------
-- [4. 핵심 기능 로직]
-------------------------------------------------------

-- 1. [관통] KnifeProjectile + 's Bullet
local wallholeEnabled = false
workspace.DescendantAdded:Connect(function(obj)
    if wallholeEnabled and obj:IsA("BasePart") then
        local n = obj.Name
        if n:find("'s Bullet") or n:find("Bullet") or n:find("Projectile") or n == "KnifeProjectile" then
            obj.CanCollide = false
            obj:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if wallholeEnabled then obj.CanCollide = false end
            end)
        end
    end
end)

-- 2. [오토팜] Coin 고속 TP
local coinFarmActive = false
task.spawn(function()
    while true do
        if coinFarmActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if coinFarmActive and v.Name == "Coin" and v:IsA("BasePart") then
                    root.CFrame = v.CFrame
                    task.wait(0.15)
                end
            end
        end
        task.wait(0.5)
    end
end)

-------------------------------------------------------
-- [5. 키 시스템 및 로그인 처리]
-------------------------------------------------------
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 400, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.new(1, 1, 1)
makeDraggable(KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0.35, 0)
KeyInput.Text = "DORS123"
KeyInput.TextColor3 = Color3.new(0, 0, 0)
KeyInput.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

local LoginBtn = Instance.new("TextButton", KeyFrame)
LoginBtn.Size = UDim2.new(0, 120, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -60, 0.7, 0)
LoginBtn.Text = "LOGIN"
LoginBtn.BackgroundColor3 = Color3.new(0, 0.8, 0)

LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "DORS123" then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    end
end)
