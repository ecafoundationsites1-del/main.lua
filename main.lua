-- 서비스 로드
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- UI 생성 (ScreenGui)
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECAhack_Hub_Final"

-- [메인 프레임]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)

-- [상단 바]
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 80)
Header.BackgroundColor3 = Color3.new(0, 0, 0)
Header.BorderSizePixel = 0

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.Size = UDim2.new(1, 0, 0, 2)
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.BackgroundColor3 = Color3.new(1, 1, 1)

-- 프로필 이미지 (원형)
local ProfileImg = Instance.new("ImageLabel", Header)
ProfileImg.Size = UDim2.new(0, 60, 0, 60)
ProfileImg.Position = UDim2.new(0, 15, 0.5, -30)
ProfileImg.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
local ProfileCorner = Instance.new("UICorner", ProfileImg)
ProfileCorner.CornerRadius = UDim.new(1, 0)

-- 플레이어 정보 텍스트
local PlayerInfoTxt = Instance.new("TextLabel", Header)
PlayerInfoTxt.Size = UDim2.new(0, 250, 1, 0)
PlayerInfoTxt.Position = UDim2.new(0, 85, 0, 0)
PlayerInfoTxt.BackgroundTransparency = 1
PlayerInfoTxt.Text = "Nickname: (" .. lp.Name .. ")\n계정생성일자: (" .. lp.AccountAge .. " days)"
PlayerInfoTxt.TextColor3 = Color3.new(1, 1, 1)
PlayerInfoTxt.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfoTxt.Font = Enum.Font.SourceSansBold
PlayerInfoTxt.TextSize = 17

-- 허브 타이틀
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(1, -210, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ECAhack hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 28
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Right

-- [사이드바]
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -82)
SideBar.Position = UDim2.new(0, 0, 0, 82)
SideBar.BackgroundColor3 = Color3.new(0, 0, 0)
SideBar.BorderSizePixel = 0

local SideLine = Instance.new("Frame", SideBar)
SideLine.Size = UDim2.new(0, 2, 1, 0)
SideLine.Position = UDim2.new(1, 0, 0, 0)
SideLine.BackgroundColor3 = Color3.new(1, 1, 1)

-- [우측 메인 컨텐츠 영역]
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -162, 1, -82)
ContentFrame.Position = UDim2.new(0, 162, 0, 82)
ContentFrame.BackgroundTransparency = 1

local CenterMsg = Instance.new("TextLabel", ContentFrame)
CenterMsg.Size = UDim2.new(1, 0, 1, 0)
CenterMsg.BackgroundTransparency = 1
CenterMsg.Text = "It has not been\ndeveloped! :("
CenterMsg.TextColor3 = Color3.new(1, 1, 1)
CenterMsg.TextSize = 45
CenterMsg.Font = Enum.Font.SourceSansBold
CenterMsg.Visible = false

--- 버튼 생성 함수 ---
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

local PlayerInfoBtn = createMenuBtn("☰ 플레이어 정보", 15)
local EspBtn = createMenuBtn("👁 ESP(TEAMS)", 60)
local WallBtn = createMenuBtn("🧱 wall hgole gun", 105)

-- 하단 고정 텍스트
local FooterTxt = Instance.new("TextLabel", SideBar)
FooterTxt.Size = UDim2.new(1, 0, 0, 80)
FooterTxt.Position = UDim2.new(0, 0, 1, -80)
FooterTxt.BackgroundTransparency = 1
FooterTxt.Text = "The button has\nnot been\ndeveloped.\n:("
FooterTxt.TextColor3 = Color3.new(1, 1, 1)
FooterTxt.TextSize = 14
FooterTxt.Font = Enum.Font.SourceSans

--- 기능 구현부 ---

local espActive = false

-- 1. MM2 ESP 로직
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local backpack = v:FindFirstChild("Backpack")
            local color = Color3.fromRGB(0, 255, 0) -- 기본 시민 (초록)

            local knifeNames = {"Knife", "Slasher", "Saw", "Blade", "칼"}
            local gunNames = {"Gun", "Revolver", "Luger", "Sheriff", "총"}

            local hasKnife = false
            local hasGun = false

            for _, n in pairs(knifeNames) do if char:FindFirstChild(n) or (backpack and backpack:FindFirstChild(n)) then hasKnife = true break end end
            for _, n in pairs(gunNames) do if char:FindFirstChild(n) or (backpack and backpack:FindFirstChild(n)) then hasGun = true break end end

            if hasKnife then color = Color3.fromRGB(255, 0, 0) -- 머더
            elseif hasGun then color = Color3.fromRGB(0, 150, 255) -- 보안관
            end

            local high = char:FindFirstChild("ECA_ESP")
            if not high then
                high = Instance.new("Highlight")
                high.Name = "ECA_ESP"
                high.Parent = char
            end
            high.FillColor = color
            high.OutlineColor = Color3.new(1, 1, 1)
            high.Enabled = espActive
        end
    end
end

-- 2. 버튼 클릭 이벤트
EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    CenterMsg.Visible = false
    if espActive then
        EspBtn.BackgroundColor3 = Color3.new(1, 1, 1)
        EspBtn.TextColor3 = Color3.new(0, 0, 0)
        task.spawn(function()
            while espActive do
                updateESP()
                task.wait(0.5)
            end
        end)
    else
        EspBtn.BackgroundColor3 = Color3.new(0, 0, 0)
        EspBtn.TextColor3 = Color3.new(1, 1, 1)
        -- ESP 끄기
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ECA_ESP") then
                p.Character.ECA_ESP.Enabled = false
            end
        end
    end
end)

WallBtn.MouseButton1Click:Connect(function()
    CenterMsg.Visible = true
end)

PlayerInfoBtn.MouseButton1Click:Connect(function()
    CenterMsg.Visible = true
end)

-- 3. 드래그 기능 (모바일 대응)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

