-- 서비스 로드
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- 설정
local KEY_URL = "여기에_키_링크_넣으세요" 
local CORRECT_KEY = "DORS123" 

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Mobile_Pro"
ScreenGui.ResetOnSpawn = false

-- [드래그 함수]
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- [1] 키 시스템 UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame)
makeDraggable(KeyFrame)

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
MainFrame.Size = UDim2.new(0, 320, 0, 300)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
makeDraggable(MainFrame)

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
EspBtn.Size = UDim2.new(0, 240, 0, 45)
EspBtn.Position = UDim2.new(0.5, -120, 0.35, 0)
EspBtn.Text = "Activate MM2 ESP"
EspBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", EspBtn)

local GunTpToggleBtn = Instance.new("TextButton", MainFrame)
GunTpToggleBtn.Size = UDim2.new(0, 240, 0, 45)
GunTpToggleBtn.Position = UDim2.new(0.5, -120, 0.55, 0)
GunTpToggleBtn.Text = "Gun TP Button: OFF"
GunTpToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
GunTpToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", GunTpToggleBtn)

-- [3] 별도의 작은 TP 실행 버튼
local QuickTpBtn = Instance.new("TextButton", ScreenGui)
QuickTpBtn.Size = UDim2.new(0, 60, 0, 60)
QuickTpBtn.Position = UDim2.new(0.8, 0, 0.5, 0)
QuickTpBtn.Text = "GET\nGUN"
QuickTpBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
QuickTpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
QuickTpBtn.Visible = false
Instance.new("UICorner", QuickTpBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(QuickTpBtn)

--- 기능 구현 로직 ---

local espEnabled = false
local tpButtonActive = false
local isTeleporting = false

-- 키 체크
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

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_URL)
    GetKeyBtn.Text = "Link Copied!"
    task.wait(2)
    GetKeyBtn.Text = "Get Key"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ESP 로직
local function applyESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local backpack = v:FindFirstChild("Backpack")
            local color = Color3.fromRGB(0, 255, 0) 

            local knifeNames = {"Knife", "Slasher", "Saw", "Blade", "칼"}
            local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총"}
            local isMurder = false
            local isSheriff = false

            for _, name in pairs(knifeNames) do
                if char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then isMurder = true break end
            end
            for _, name in pairs(gunNames) do
                if char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) then isSheriff = true break end
            end

            if isMurder then color = Color3.fromRGB(255, 0, 0)
            elseif isSheriff then color = Color3.fromRGB(0, 150, 255) end

            local highlight = char:FindFirstChild("MM2_ESP") or Instance.new("Highlight", char)
            highlight.Name = "MM2_ESP"
            highlight.FillColor = color
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.4
            highlight.Enabled = true
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "Activate MM2 ESP"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(171, 60, 255)
    
    task.spawn(function()
        while espEnabled do
            applyESP()
            task.wait(0.5)
        end
        if not espEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("MM2_ESP") then
                    v.Character.MM2_ESP:Destroy()
                end
            end
        end
    end)
end)

-- 순간이동(TP) 로직
local function getDroppedGun()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "GunDrop" then
            return obj:IsA("BasePart") and obj or obj:FindFirstChild("Handle")
        end
    end
    return nil
end

local function teleportToGun()
    if isTeleporting then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local gun = getDroppedGun()
    
    if root and gun then
        isTeleporting = true
        local oldPos = root.CFrame
        root.CFrame = gun.CFrame + Vector3.new(0, 2, 0)
        
        -- 총 획득 대기 (인벤토리에 Gun이 생길 때까지 최대 1.5초)
        local t = 0
        while t < 30 do
            task.wait(0.05)
            t = t + 1
            if lp.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun") then break end
        end
        
        root.CFrame = oldPos -- 원래 자리로 복귀
        isTeleporting = false
    end
end

GunTpToggleBtn.MouseButton1Click:Connect(function()
    tpButtonActive = not tpButtonActive
    QuickTpBtn.Visible = tpButtonActive
    GunTpToggleBtn.Text = tpButtonActive and "Gun TP Button: ON" or "Gun TP Button: OFF"
    GunTpToggleBtn.BackgroundColor3 = tpButtonActive and Color3.fromRGB(60, 255, 100) or Color3.fromRGB(255, 80, 0)
end)

QuickTpBtn.MouseButton1Click:Connect(teleportToGun)

