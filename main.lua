-- 서비스 로드
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- UI 및 드래그 (생략 없이 통합)
local ScreenGui = Instance.new("ScreenGui", gethui() or game:GetService("CoreGui"))
ScreenGui.Name = "ECA_V4_FINAL"
ScreenGui.ResetOnSpawn = false

local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- 메인 프레임
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
makeDraggable(MainFrame)

-- 사이드바 및 버튼 구성
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 160, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -160, 1, -40)
PageContainer.Position = UDim2.new(0, 160, 0, 40)
PageContainer.BackgroundTransparency = 1

local Pages = {
    Main = Instance.new("Frame", PageContainer)
}
Pages.Main.Size = UDim2.new(1,0,1,0)
Pages.Main.BackgroundTransparency = 1

local function createToggle(name, pos, defaultText)
    local btn = Instance.new("TextButton", Pages.Main)
    btn.Size = UDim2.new(0, 170, 0, 40)
    btn.Position = pos
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    return btn
end

local EspToggle = createToggle("👁 ESP", UDim2.new(0, 10, 0, 10))
local WallToggle = createToggle("🧱 Wallhole", UDim2.new(0, 10, 0, 60))
local TpToggle = createToggle("🚀 Gun TP", UDim2.new(0, 10, 0, 110))
local CoinToggle = createToggle("🚜 코인 팜", UDim2.new(0, 190, 0, 10))
local RankToggle = createToggle("⭐ 랭크 팜", UDim2.new(0, 190, 0, 60))

-------------------------------------------------------
-- [개선된 코인 탐지 시스템]
-------------------------------------------------------
local coinList = {}
local function updateCoinList()
    table.clear(coinList)
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Coin" and v:IsA("BasePart") then
            table.insert(coinList, v)
        end
    end
end

-- 새로운 코인이 생성될 때 즉시 리스트에 추가 (속도 향상의 핵심)
workspace.DescendantAdded:Connect(function(v)
    if v.Name == "Coin" then table.insert(coinList, v) end
end)

-------------------------------------------------------
-- [통합 로직]
-------------------------------------------------------
local espOn, wallOn, tpOn, coinOn, rankOn = false, false, false, false, false
local platform = nil
local safetyDist = 12

local function checkInv(plr, names)
    for _, n in pairs(names) do
        if plr.Character and plr.Character:FindFirstChild(n) then return true end
        if plr.Backpack:FindFirstChild(n) then return true end
    end
    return false
end

-- [ESP]
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local h = v.Character:FindFirstChild("ECA_H") or Instance.new("Highlight", v.Character)
            h.Name = "ECA_H"
            if checkInv(v, {"Knife"}) then h.FillColor = Color3.new(1,0,0)
            elseif checkInv(v, {"Gun", "Revolver"}) then h.FillColor = Color3.new(0,0,1)
            else h.FillColor = Color3.new(0,1,0) end
            h.Enabled = true
        end
    end
end)

-- [Wallhole & Gun TP]
workspace.DescendantAdded:Connect(function(obj)
    if wallOn and (obj.Name:find("Bullet") or obj.Name == "KnifeProjectile") then
        obj.CanCollide = false
    end
    if tpOn and (obj.Name == "GunDrop" or (obj.Name == "Handle" and obj.Parent.Name == "Gun")) then
        task.wait()
        lp.Character.HumanoidRootPart.CFrame = obj:IsA("BasePart") and obj.CFrame or obj:GetModelCFrame()
    end
end)

-- [핵심 오토 루프: 코인팜/랭크팜]
task.spawn(function()
    while true do
        task.wait(0.01) -- 엔진 부하 방지 최소 대기
        
        if rankOn then
            local isM = checkInv(lp, {"Knife"})
            if isM then
                local k = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                k.Parent = lp.Character
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
                        task.wait(0.05) k:Activate() task.wait(0.1)
                    end
                end
            else
                -- 보안관/시민이면 하늘 대기
                if not platform then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 800, 0)
                    platform = Instance.new("Part", workspace)
                    platform.Size, platform.Position, platform.Anchored = Vector3.new(30,1,30), Vector3.new(0, 795, 0), true
                end
            end
            
        elseif coinOn then
            if #coinList > 0 then
                if platform then platform:Destroy() platform = nil end
                
                -- 살인자 위치 파악
                local mRoot = nil
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lp and checkInv(v, {"Knife"}) and v.Character then mRoot = v.Character:FindFirstChild("HumanoidRootPart") break end
                end

                for i, c in ipairs(coinList) do
                    if not coinOn or rankOn then break end
                    if c and c.Parent then
                        -- 안전 거리 확인
                        if not mRoot or (c.Position - mRoot.Position).Magnitude > safetyDist then
                            lp.Character.HumanoidRootPart.CFrame = c.CFrame
                            task.wait(0.15) -- 0.15초 수집 딜레이
                        end
                    else
                        table.remove(coinList, i) -- 먹은 코인 제거
                    end
                end
            else
                -- 코인 없을 때 하늘 대기
                if not platform then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 700, 0)
                    platform = Instance.new("Part", workspace)
                    platform.Size, platform.Position, platform.Anchored = Vector3.new(30,1,30), Vector3.new(0, 695, 0), true
                    updateCoinList() -- 리스트 갱신 시도
                end
                task.wait(0.5)
            end
        end
    end
end)

-------------------------------------------------------
-- [버튼 연결]
-------------------------------------------------------
EspToggle.MouseButton1Click:Connect(function() espOn = not espOn EspToggle.Text = "ESP: "..(espOn and "ON" or "OFF") end)
WallToggle.MouseButton1Click:Connect(function() wallOn = not wallOn WallToggle.Text = "Wallhole: "..(wallOn and "ON" or "OFF") end)
TpToggle.MouseButton1Click:Connect(function() tpOn = not tpOn TpToggle.Text = "Gun TP: "..(tpOn and "ON" or "OFF") end)

CoinToggle.MouseButton1Click:Connect(function() 
    coinOn = not coinOn rankOn = false
    if not coinOn and platform then platform:Destroy() platform = nil end
    updateCoinList()
    CoinToggle.Text = "코인 팜: "..(coinOn and "ON" or "OFF")
    RankToggle.Text = "랭크 팜: OFF"
end)

RankToggle.MouseButton1Click:Connect(function()
    rankOn = not rankOn coinOn = false
    if not rankOn and platform then platform:Destroy() platform = nil end
    RankToggle.Text = "랭크 팜: "..(rankOn and "ON" or "OFF")
    CoinToggle.Text = "코인 팜: OFF"
end)

