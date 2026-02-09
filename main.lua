-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_V4_FINAL_PERFECT"
ScreenGui.ResetOnSpawn = false

-------------------------------------------------------
-- [드래그 함수]
-------------------------------------------------------
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-------------------------------------------------------
-- [메인 UI 구조]
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
makeDraggable(MainFrame)

-- 상단 제목
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = " ECA UNIVERSAL HUB V4 "
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- 사이드바
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 150, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- 페이지 컨테이너
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -150, 1, -40)
PageContainer.Position = UDim2.new(0, 150, 0, 40)
PageContainer.BackgroundTransparency = 1

local Pages = {}
local function createPage(name)
    local p = Instance.new("Frame", PageContainer)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    Pages[name] = p
    return p
end

-- 페이지들 생성
createPage("ESP")
createPage("Wallhole")
createPage("GunTP")
createPage("CoinFarm")
createPage("RankFarm")
Pages.ESP.Visible = true -- 기본 페이지

-- 사이드바 버튼 생성 함수
local function createMenuBtn(name, displayName, pos)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = displayName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end

createMenuBtn("ESP", "👁 ESP 설정", 10)
createMenuBtn("Wallhole", "🧱 관통 설정", 60)
createMenuBtn("GunTP", "🚀 총 텔레포트", 110)
createMenuBtn("CoinFarm", "🚜 코인 팜", 160)
createMenuBtn("RankFarm", "⭐ 랭크 팜", 210)

-- 활성화 버튼 생성 함수 (페이지 안에 들어갈 버튼)
local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 250, 0, 60)
    btn.Position = UDim2.new(0.5, -125, 0.4, -30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-------------------------------------------------------
-- [기능 변수 및 로직]
-------------------------------------------------------
local espOn, wallOn, tpOn, coinOn, rankOn = false, false, false, false, false
local platform = nil
local coinList = {}

local function checkWeapon(p, names)
    for _, n in pairs(names) do
        if p.Character and p.Character:FindFirstChild(n) then return true end
        if p.Backpack:FindFirstChild(n) then return true end
    end
    return false
end

-- 1. ESP
createToggle(Pages.ESP, "ESP 활성화", function(v) espOn = v end)
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H") or Instance.new("Highlight", v.Character)
            h.Name = "ECA_H"
            if checkWeapon(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0) -- 살인자
            elseif checkWeapon(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1) -- 보안관
            else h.FillColor = Color3.new(0,1,0) end
            h.Enabled = true
        end
    end
end)

-- 2. Wallhole
createToggle(Pages.Wallhole, "총/칼 관통", function(v) wallOn = v end)
workspace.DescendantAdded:Connect(function(obj)
    if wallOn and (obj.Name:find("Bullet") or obj.Name == "KnifeProjectile") then obj.CanCollide = false end
end)

-- 3. Gun TP
createToggle(Pages.GunTP, "총 자동 텔레포트", function(v) tpOn = v end)
workspace.DescendantAdded:Connect(function(obj)
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait()
        lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
    end
end)

-- 4. Coin Farm (0.15초 광속 수집)
createToggle(Pages.CoinFarm, "코인 팜 시작", function(v) 
    coinOn = v 
    if not v and platform then platform:Destroy() platform = nil end
end)

-- 5. Rank Farm
createToggle(Pages.RankFarm, "랭크 팜 시작", function(v) 
    rankOn = v 
    if not v and platform then platform:Destroy() platform = nil end
end)

-- 공용 루프 (코인팜/랭크팜)
task.spawn(function()
    while true do
        task.wait(0.01)
        if rankOn then
            if checkWeapon(lp, {"Knife"}) then
                if platform then platform:Destroy() platform = nil end
                local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                k.Parent = lp.Character
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                        task.wait(0.05) k:Activate() task.wait(0.1)
                    end
                end
            else
                if not platform then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 800, 0)
                    platform = Instance.new("Part", workspace)
                    platform.Size, platform.Position, platform.Anchored = Vector3.new(30,1,30), Vector3.new(0, 795, 0), true
                end
            end
        elseif coinOn then
            local coins = {}
            for _, v in pairs(workspace:GetDescendants()) do if v.Name == "Coin" then table.insert(coins, v) end end
            if #coins > 0 then
                if platform then platform:Destroy() platform = nil end
                for _, c in pairs(coins) do
                    if not coinOn or rankOn then break end
                    lp.Character.HumanoidRootPart.CFrame = c.CFrame
                    task.wait(0.15)
                end
            else
                if not platform then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 700, 0)
                    platform = Instance.new("Part", workspace)
                    platform.Size, platform.Position, platform.Anchored = Vector3.new(30,1,30), Vector3.new(0, 695, 0), true
                end
            end
        end
    end
end)

