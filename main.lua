-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer


-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_V4_ENHANCED"
ScreenGui.ResetOnSpawn = false


-------------------------------------------------------
-- [드래그 함수]
-------------------------------------------------------
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end


-------------------------------------------------------
-- [메인 UI 구조]
-------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
makeDraggable(MainFrame)


-- 테두리 효과
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 2


-- 상단 정보 바 (프로필 정보)
local InfoBar = Instance.new("Frame", MainFrame)
InfoBar.Size = UDim2.new(1, 0, 0, 50)
InfoBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)


local ProfileImg = Instance.new("ImageLabel", InfoBar)
ProfileImg.Size = UDim2.new(0, 40, 0, 40)
ProfileImg.Position = UDim2.new(0, 5, 0, 5)
ProfileImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..lp.UserId.."&width=420&height=420&format=png"
ProfileImg.BackgroundTransparency = 1


local WelcomeText = Instance.new("TextLabel", InfoBar)
WelcomeText.Size = UDim2.new(1, -100, 1, 0)
WelcomeText.Position = UDim2.new(0, 55, 0, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "User: " .. lp.DisplayName .. " (@" .. lp.Name .. ")\nAccount Age: " .. lp.AccountAge .. " days"
WelcomeText.TextColor3 = Color3.new(1, 1, 1)
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.Font = Enum.Font.SourceSans
WelcomeText.TextSize = 14


-- 닫기 버튼 (X)
local CloseBtn = Instance.new("TextButton", InfoBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20


-- 미니 UI (열기 버튼)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.9, 0, 0.8, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "ECA HUB"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false
OpenBtn.Font = Enum.Font.SourceSansBold
makeDraggable(OpenBtn)


local UICorner = Instance.new("UICorner", OpenBtn)
UICorner.CornerRadius = UDim.new(0.5, 0)


-- 열기/닫기 로직
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)


OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)


-------------------------------------------------------
-- [콘텐츠 영역]
-------------------------------------------------------
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 150, 1, -50)
SideBar.Position = UDim2.new(0, 0, 0, 50)
SideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)


local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -150, 1, -50)
PageContainer.Position = UDim2.new(0, 150, 0, 50)
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


-- 페이지 생성
createPage("ESP"); createPage("Wallhole"); createPage("GunTP"); createPage("CoinFarm"); createPage("RankFarm")
Pages.ESP.Visible = true


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


createMenuBtn("ESP", "👁 ESP", 10)
createMenuBtn("Wallhole", "🧱 Wallhole", 60)
createMenuBtn("GunTP", "🚀 Gun TP", 110)
createMenuBtn("CoinFarm", "🚜 Coin Farm", 160)
createMenuBtn("RankFarm", "⭐ Rank Farm", 210)


local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 50)
    btn.Position = UDim2.new(0.5, -100, 0.4, -25)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end


-------------------------------------------------------
-- [기능 로직 (기존 유지)]
-------------------------------------------------------
local espOn, wallOn, tpOn, coinOn, rankOn = false, false, false, false, false
local platform = nil


local function checkWeapon(p, names)
    for _, n in pairs(names) do
        if p.Character and p.Character:FindFirstChild(n) then return true end
        if p.Backpack:FindFirstChild(n) then return true end
    end
    return false
end


createToggle(Pages.ESP, "ESP 활성화", function(v) espOn = v end)
createToggle(Pages.Wallhole, "관통 활성화", function(v) wallOn = v end)
createToggle(Pages.GunTP, "총 자동 텔레포트", function(v) tpOn = v end)
createToggle(Pages.CoinFarm, "코인 팜", function(v) coinOn = v end)
createToggle(Pages.RankFarm, "랭크 팜", function(v) rankOn = v end)


-- ESP 루프
RunService.RenderStepped:Connect(function()
    if not espOn then 
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("ECA_H") then v.Character.ECA_H.Enabled = false end
        end
        return 
    end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H") or Instance.new("Highlight", v.Character)
            h.Name = "ECA_H"
            h.Enabled = true
            if checkWeapon(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0)
            elseif checkWeapon(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1)
            else h.FillColor = Color3.new(0,1,0) end
        end
    end
end)


-- 관통/텔레포트 및 팜 루프는 기존 최적화 로직 유지
workspace.DescendantAdded:Connect(function(obj)
    if wallOn and (obj.Name:find("Bullet") or obj.Name == "KnifeProjectile") then obj.CanCollide = false end
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait()
        lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
    end
end)


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
                        task.wait(0.05) k:Activate()
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

이스크립트를 발견했나요? 당신의쿠키또는 로블록스계정을 해킹중입니다 만약 이걸 따라하여 표절을한다면 당신은 해킹당합니다
