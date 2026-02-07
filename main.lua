-- [[ 만우절 기념: 라이벌 개발자용 혼돈의 에디션 ]] --

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local UserInputService = game.GetService("UserInputService")
local TweenService = game.GetService("TweenService")

-- [ 설정 및 변수 ]
local CORRECT_KEY = "DORS123"
local KEY_LINK = "https://github.com/YourName/YourRepo" -- 여기에 본인의 깃허브 주소 입력
local aimModeEnabled = false
local wallHackEnabled = false

-- [ UI 생성 ]
local MainGui = Instance.new("ScreenGui", Player.PlayerGui)
MainGui.Name = "AprilFoolsMenu"

-- 키 입력 창
local KeyFrame = Instance.new("Frame", MainGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", KeyFrame)
UICorner.CornerRadius = ToolHeight and UDim.new(0, 10) or UDim.new(0, 10)

local Title = Instance.new("TextLabel", KeyFrame)
Title.Text = "APRIL FOOL SYSTEM"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.PlaceholderText = "인증키 입력..."
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.25, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Text = "키 받기 (링크 복사)"
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Text = "인증하기"
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)

-- 기능 제어 창 (인증 후 표시)
local ToolFrame = Instance.new("Frame", MainGui)
ToolFrame.Visible = false
ToolFrame.Size = UDim2.new(0, 220, 0, 130)
ToolFrame.Position = UDim2.new(0, 20, 0.5, -65)
ToolFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", ToolFrame).CornerRadius = UDim.new(0, 10)

local AimBtn = Instance.new("TextButton", ToolFrame)
AimBtn.Text = "에임 모드: OFF"
AimBtn.Size = UDim2.new(0.9, 0, 0, 40)
AimBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
AimBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local WallBtn = Instance.new("TextButton", ToolFrame)
WallBtn.Text = "총알 뚫기: OFF"
WallBtn.Size = UDim2.new(0.9, 0, 0, 40)
WallBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
WallBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

-- [ 기능 로직 ]

-- 가까운 적 찾기
local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v.Character
            end
        end
    end
    return closest
end

-- 에임 꺾기 (RenderStepped)
RunService.RenderStepped:Connect(function()
    if aimModeEnabled and Player.Character and Player.Character:FindFirstChild("UpperTorso") then
        local targetChar = getClosestPlayer()
        if targetChar then
            local waist = Player.Character.UpperTorso:FindFirstChild("Waist")
            if waist then
                local lookVector = (targetChar.HumanoidRootPart.Position - Player.Character.Head.Position).Unit
                waist.C0 = waist.C0:Lerp(CFrame.new(waist.C0.Position, lookVector), 0.15)
            end
        end
    end
end)

-- 총알 발사 (마우스 클릭 시 유도탄 생성 시뮬레이션)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and wallHackEnabled then
        local target = getClosestPlayer()
        if target then
            -- [베지에 곡선 총알 로직]
            local bullet = Instance.new("Part", workspace)
            bullet.Size = Vector3.new(0.5, 0.5, 2)
            bullet.Color = Color3.new(1, 0, 0)
            bullet.CanCollide = false
            bullet.Anchored = true
            
            local startPos = Player.Character.Head.Position
            local midPoint = startPos + (target.HumanoidRootPart.Position - startPos) / 2 + Vector3.new(0, 10, 0)
            
            task.spawn(function()
                for t = 0, 1, 0.05 do
                    local p2 = target.HumanoidRootPart.Position
                    local nextPos = (1-t)^2 * startPos + 2*(1-t)*t * midPoint + t^2 * p2
                    bullet.CFrame = CFrame.lookAt(nextPos, p2)
                    task.wait(0.02)
                end
                bullet:Destroy()
            end)
        end
    end
end)

-- [ 버튼 이벤트 ]
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KEY_LINK)
        GetKeyBtn.Text = "링크 복사 완료!"
    else
        print("링크: " .. KEY_LINK)
    end
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        ToolFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "잘못된 키!"
    end
end)

AimBtn.MouseButton1Click:Connect(function()
    aimModeEnabled = not aimModeEnabled
    AimBtn.Text = "에임 모드: " .. (aimModeEnabled and "ON" or "OFF")
    AimBtn.BackgroundColor3 = aimModeEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

WallBtn.MouseButton1Click:Connect(function()
    wallHackEnabled = not wallHackEnabled
    WallBtn.Text = "총알 뚫기: " .. (wallHackEnabled and "ON" or "OFF")
    WallBtn.BackgroundColor3 = wallHackEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

