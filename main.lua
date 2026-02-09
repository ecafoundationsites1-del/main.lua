-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- UI 생성
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_V4_FINAL_RANK"
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

-- [최소화/복구 기능]
local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenButton.Text = "ECA"
OpenButton.TextColor3 = Color3.new(1, 1, 1)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Visible = false -- 처음엔 숨김
makeDraggable(OpenButton)

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.SourceSansBold

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-------------------------------------------------------
-- [사이드바 및 페이지]
-------------------------------------------------------
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

createPage("ESP")
createPage("Wallhole")
createPage("TP")
createPage("AutoFarm")
createPage("RankFarm")
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
-- [로직 적용]
-------------------------------------------------------
local espOn, wallOn, tpOn, coinOn, rankOn = false, false, false, false, false
local platform = nil

local function checkWeapon(plr, names)
    for _, n in pairs(names) do
        if plr.Character and plr.Character:FindFirstChild(n) then return true end
        if plr.Backpack:FindFirstChild(n) then return true end
    end
    return false
end

createToggle(Pages.ESP, "ESP", function(v) espOn = v end)
createToggle(Pages.Wallhole, "Wallhole", function(v) wallOn = v end)
createToggle(Pages.TP, "Gun TP", function(v) tpOn = v end)
createToggle(Pages.AutoFarm, "Coin Farm", function(v) coinOn = v if not v and platform then platform:Destroy() platform = nil end end)
createToggle(Pages.RankFarm, "Rank Farm", function(v) rankOn = v if not v and platform then platform:Destroy() platform = nil end end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if rankOn then
            local isM = checkWeapon(lp, {"Knife"})
            if isM then
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

RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H") or Instance.new("Highlight", v.Character)
            h.Name = "ECA_H"
            if checkWeapon(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0)
            elseif checkWeapon(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1)
            else h.FillColor = Color3.new(0,1,0) end
            h.Enabled = true
        end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    if wallOn and (obj.Name:find("Bullet") or obj.Name == "KnifeProjectile") then obj.CanCollide = false end
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait(0.05)
        lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
    end
end)

