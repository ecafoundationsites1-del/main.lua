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

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 1, -40)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "OPEN GUI"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.SourceSansBold
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

-- 무기 소지 확인 함수
local function checkWeapon(plr, names)
    if not plr or not plr.Character then return false end
    for _, n in pairs(names) do
        if plr.Character:FindFirstChild(n) then return true end
        if plr.Backpack:FindFirstChild(n) then return true end
    end
    return false
end

createToggle(Pages.ESP, "ESP", function(v) espOn = v end)
createToggle(Pages.Wallhole, "Wallhole", function(v) wallOn = v end)
createToggle(Pages.TP, "Gun TP", function(v) tpOn = v end)
createToggle(Pages.AutoFarm, "Coin Farm", function(v) coinOn = v end)
createToggle(Pages.RankFarm, "Rank Farm", function(v) rankOn = v end)

-- 공용 안전 플랫폼 (한 번만 생성)
local safePlatform = Instance.new("Part")
safePlatform.Name = "ECA_UniversalPlatform"
safePlatform.Size = Vector3.new(50, 1, 50)
safePlatform.Anchored = true
safePlatform.CanCollide = true
safePlatform.Position = Vector3.new(0, -500, 0) 
safePlatform.Parent = workspace

task.spawn(function()
    while true do
        task.wait(0.1)
        
        -- 캐릭터 확인
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        -- 기능 꺼져있으면 플랫폼 숨기기
        if not (rankOn or coinOn) then
            safePlatform.Position = Vector3.new(0, -500, 0)
            continue
        end

        if rankOn then
            local isMurderer = checkWeapon(lp, {"Knife"})
            
            if isMurderer then
                -- 살인마인 경우 타겟 추적
                local target = nil
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        target = v
                        break
                    end
                end

                if target and target.Character:FindFirstChild("HumanoidRootPart") then
                    safePlatform.Position = Vector3.new(0, -500, 0) -- 추적 시 플랫폼 치우기
                    local k = char:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                    if k then 
                        k.Parent = char
                        root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        task.wait(0.05)
                        k:Activate()
                    end
                else
                    -- 타겟 없으면 공허 대기
                    safePlatform.Position = Vector3.new(0, 800, 0)
                    root.CFrame = CFrame.new(0, 805, 0)
                end
            else
                -- 시민/보안관이면 공허 대기
                safePlatform.Position = Vector3.new(0, 800, 0)
                root.CFrame = CFrame.new(0, 805, 0)
            end

        elseif coinOn then
            -- 코인 팜 로직
            local coin = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin" or v.Name == "GoldCoin" then coin = v break end
            end

            if coin and coin:IsA("BasePart") then
                safePlatform.Position = Vector3.new(0, -500, 0)
                root.CFrame = coin.CFrame
            else
                -- 코인 없으면 공허 대기
                safePlatform.Position = Vector3.new(0, 700, 0)
                root.CFrame = CFrame.new(0, 705, 0)
            end
        end
    end
end)

-- ESP 로직
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H")
            if not espOn then
                if h then h.Enabled = false end
                continue
            end
            
            if not h then
                h = Instance.new("Highlight", v.Character)
                h.Name = "ECA_H"
            end
            
            h.Enabled = true
            if checkWeapon(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0)
            elseif checkWeapon(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1)
            else h.FillColor = Color3.new(0,1,0) end
        end
    end
end)

-- 총기/투사체 감지
workspace.DescendantAdded:Connect(function(obj)
    if wallOn and (obj.Name:find("Bullet") or obj.Name == "KnifeProjectile") then obj.CanCollide = false end
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait(0.1)
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
        end
    end
end)

