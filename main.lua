-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_V4_FINAL_WALL_BREAKER"
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

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 1, -40)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "OPEN GUI"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 150, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -150, 1, 0)
PageContainer.Position = UDim2.new(0, 150, 0, 0)
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

createPage("ESP"); createPage("Wallhole"); createPage("TP"); createPage("AutoFarm"); createPage("RankFarm")
Pages.ESP.Visible = true

local function createMenuBtn(name, displayName, pos)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
createMenuBtn("TP", "🚀 Gun TP", 110)
createMenuBtn("AutoFarm", "🚜 Coin Farm", 160)
createMenuBtn("RankFarm", "⭐ Rank Farm", 210)

local function createToggle(parent, title, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 220, 0, 60)
    btn.Position = UDim2.new(0.5, -110, 0.4, -30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = title .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = title .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

-------------------------------------------------------
-- [기능 로직]
-------------------------------------------------------
local espOn, wallOn, tpOn, coinOn, rankOn = false, false, false, false, false
local wallParts = {} -- 벽 복구용 테이블

local function checkWeapon(plr, names)
    if not plr or not plr.Character then return false end
    for _, n in pairs(names) do
        if plr.Character:FindFirstChild(n) or plr.Backpack:FindFirstChild(n) then return true end
    end
    return false
end

-- 벽 제거 로직
local function toggleWalls(v)
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Name:lower():find("floor") and not obj.Name:lower():find("baseplate") then
                if not wallParts[obj] then
                    wallParts[obj] = {Transparency = obj.Transparency, CanCollide = obj.CanCollide}
                end
                obj.Transparency = 0.6
                obj.CanCollide = false
            end
        end
    else
        for obj, data in pairs(wallParts) do
            if obj and obj.Parent then
                obj.Transparency = data.Transparency
                obj.CanCollide = data.CanCollide
            end
        end
        wallParts = {}
    end
end

createToggle(Pages.ESP, "ESP", function(v) espOn = v end)
createToggle(Pages.Wallhole, "Wall Destroyer", function(v) wallOn = v toggleWalls(v) end)
createToggle(Pages.TP, "Gun TP", function(v) tpOn = v end)
createToggle(Pages.AutoFarm, "Snap Coin Farm", function(v) coinOn = v end)
createToggle(Pages.RankFarm, "Pro Rank Farm", function(v) rankOn = v end)

-- 공용 플랫폼 (Y=900)
local safePlatform = Instance.new("Part")
safePlatform.Name = "ECA_SafePlatform"
safePlatform.Size = Vector3.new(30, 1, 30)
safePlatform.Anchored = true
safePlatform.Transparency = 1
safePlatform.Parent = workspace

task.spawn(function()
    while true do
        task.wait(0.15)
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        if coinOn then
            -- 히트박스 스냅 방식: 몸은 공중, 판정만 코인으로
            local coin = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if (v.Name == "Coin" or v.Name == "GoldCoin" or v.Name == "CandyCorn") and v:IsA("BasePart") then
                    coin = v break
                end
            end
            if coin then
                local oldCFrame = CFrame.new(0, 903, 0)
                safePlatform.Position = Vector3.new(0, 900, 0)
                root.Velocity = Vector3.new(0,0,0)
                root.CFrame = coin.CFrame -- 스냅
                task.wait(0.02)
                root.CFrame = oldCFrame -- 복귀
            else
                safePlatform.Position = Vector3.new(0, 900, 0)
                root.CFrame = CFrame.new(0, 903, 0)
            end

        elseif rankOn then
            local isM = checkWeapon(lp, {"Knife"})
            if isM then
                local target = nil
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        target = v break
                    end
                end
                if target then
                    safePlatform.Position = Vector3.new(0, -500, 0)
                    root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.7)
                    local k = char:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    if k then k.Parent = char k:Activate() end
                else
                    task.wait(5) -- 전원 처치 시 5초 대기 (무승부 방지)
                    safePlatform.Position = Vector3.new(0, 997, 0)
                    root.CFrame = CFrame.new(0, 1000, 0)
                end
            else
                safePlatform.Position = Vector3.new(0, 997, 0)
                root.CFrame = CFrame.new(0, 1000, 0)
            end
        else
            safePlatform.Position = Vector3.new(0, -500, 0)
        end
    end
end)

-- ESP 로직
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H")
            if not espOn then if h then h.Enabled = false end continue end
            if not h then h = Instance.new("Highlight", v.Character) h.Name = "ECA_H" end
            h.Enabled = true
            if checkWeapon(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0)
            elseif checkWeapon(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1)
            else h.FillColor = Color3.new(0,1,0) end
        end
    end
end)

-- 총기 드랍 자동 획득
workspace.DescendantAdded:Connect(function(obj)
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait(0.1)
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
        end
    end
end)

