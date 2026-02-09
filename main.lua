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
-- [1. 모바일 & PC 공용 드래그 함수]
-------------------------------------------------------
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
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
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Visible = false
makeDraggable(MainFrame)

-- 상단 바
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "ECA HUB V4 UNIVERSAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Right

-- 사이드바
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 150, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.BorderSizePixel = 0

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
-- [3. UI 컴포넌트 생성 함수]
-------------------------------------------------------
local function createMenuBtn(name, pos, page)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

local function createToggle(parent, text, pos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 360, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and " : ON" or " : OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(35, 35, 35)
        callback(enabled)
    end)
end

-------------------------------------------------------
-- [4. 기능 연결 및 버튼 배치]
-------------------------------------------------------
local wallholeEnabled = false
local coinFarmActive = false

createMenuBtn("☰ PLAYER", 15, Pages.Player)
createMenuBtn("👁 ESP", 55, Pages.ESP)
createMenuBtn("🧱 WALLHOLE", 95, Pages.Wallhole)
createMenuBtn("🚀 GUN TP", 135, Pages.TP)
createMenuBtn("🚜 AUTO FARM", 175, Pages.AutoFarm)

createToggle(Pages.Player, "Speed Hack (100)", 10, function(state)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = state and 100 or 16
    end
end)

createToggle(Pages.ESP, "Player ESP (Visual)", 10, function(state)
    print("ESP 기능: " .. tostring(state))
end)

createToggle(Pages.Wallhole, "Bullet Wallhole", 10, function(state)
    wallholeEnabled = state
end)

createToggle(Pages.AutoFarm, "Coin Auto Farm", 10, function(state)
    coinFarmActive = state
end)

-------------------------------------------------------
-- [5. 핵심 로직 루프]
-------------------------------------------------------
workspace.DescendantAdded:Connect(function(obj)
    if wallholeEnabled and obj:IsA("BasePart") then
        local n = obj.Name
        if n:find("Bullet") or n:find("Projectile") or n == "KnifeProjectile" then
            obj.CanCollide = false
        end
    end
end)

task.spawn(function()
    while true do
        if coinFarmActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local root = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if not coinFarmActive then break end
                if v.Name == "Coin" and v:IsA("BasePart") then
                    root.CFrame = v.CFrame
                    task.wait(0.15)
                end
            end
        end
        task.wait(0.5)
    end
end)

-------------------------------------------------------
-- [6. 키 시스템 (모바일 드래그 지원)]
-------------------------------------------------------
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 400, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.new(1, 1, 1)
makeDraggable(KeyFrame) -- 키 입력창도 드래그 가능하게 수정

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0.35, 0)
KeyInput.Text = "DORS123"
KeyInput.TextColor3 = Color3.new(0, 0, 0)
KeyInput.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
KeyInput.ClearTextOnFocus = false -- 모바일 편의성 위해 추가

local LoginBtn = Instance.new("TextButton", KeyFrame)
LoginBtn.Size = UDim2.new(0, 120, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -60, 0.7, 0)
LoginBtn.Text = "LOGIN"
LoginBtn.BackgroundColor3 = Color3.new(0, 0.8, 0)
LoginBtn.TextColor3 = Color3.new(1, 1, 1)

LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "DORS123" then
        KeyFrame:Destroy()
        MainFrame.Visible = true
    end
end)

