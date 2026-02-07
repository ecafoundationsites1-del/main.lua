local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- [설정 변수]
local CORRECT_KEY = "DORS123"
local KEY_URL = "https://link-center.net/your_link_here" -- 여기에 키 링크 넣기

-- 기존 UI 제거 (중복 실행 방지)
if game:GetService("CoreGui"):FindFirstChild("AntiLua_Final") then
    game:GetService("CoreGui").AntiLua_Final:Destroy()
end

-- [UI 생성]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AntiLua_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- 다른 UI보다 무조건 위에 뜨게 설정

-- [1] 키 시스템 UI (가장 먼저 보여야 함)
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 300, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true -- 강제 활성화
KeyFrame.ZIndex = 10
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 15)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "AntiLua HUB"
KeyTitle.TextColor3 = Color3.fromRGB(171, 60, 255)
KeyTitle.TextSize = 22
KeyTitle.Font = Enum.Font.UbuntuBold
KeyTitle.BackgroundTransparency = 1
KeyTitle.ZIndex = 11

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 45)
KeyInput.Position = UDim2.new(0.5, -120, 0.38, 0)
KeyInput.PlaceholderText = "키를 입력하세요..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.ZIndex = 11
Instance.new("UICorner", KeyInput)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 115, 0, 40)
GetKeyBtn.Position = UDim2.new(0.5, -120, 0.68, 0)
GetKeyBtn.Text = "키 받기"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.ZIndex = 11
Instance.new("UICorner", GetKeyBtn)

local CheckBtn = Instance.new("TextButton", KeyFrame)
CheckBtn.Size = UDim2.new(0, 115, 0, 40)
CheckBtn.Position = UDim2.new(0.5, 5, 0.68, 0)
CheckBtn.Text = "확인"
CheckBtn.BackgroundColor3 = Color3.fromRGB(171, 60, 255)
CheckBtn.TextColor3 = Color3.new(1, 1, 1)
CheckBtn.ZIndex = 11
Instance.new("UICorner", CheckBtn)

-- [2] 메인 기능 UI (처음엔 숨김)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame)

-- (나머지 프로필, 버튼, 기능 로직은 동일)
-- ... [이전과 동일한 ESP, 갓모드 기능 코드 포함] ...

-----------------------------------------------------------
-- 기능 작동 부분 (수정됨)
-----------------------------------------------------------

-- 키 시스템 로직
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_URL)
    GetKeyBtn.Text = "링크 복사됨!"
    task.wait(2)
    GetKeyBtn.Text = "키 받기"
end)

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        print("Key Correct!")
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "잘못된 키입니다!"
        task.wait(1.5)
        KeyInput.PlaceholderText = "키를 입력하세요..."
    end
end)

-- [프로필 이미지 추가]
local ProfileImg = Instance.new("ImageLabel", MainFrame)
ProfileImg.Size = UDim2.new(0, 80, 0, 80)
ProfileImg.Position = UDim2.new(0.5, -40, 0.05, 0)
ProfileImg.Image = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
ProfileImg.ZIndex = 6
local ImgCorner = Instance.new("UICorner", ProfileImg)
ImgCorner.CornerRadius = UDim.new(1, 0)

-- [닫기 버튼]
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.ZIndex = 7
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [메인 버튼 생성 함수]
local function CreateButton(name, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 260, 0, 55)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.ZIndex = 6
    Instance.new("UICorner", btn)
    return btn
end

local EspBtn = CreateButton("ESP (팀 구별): OFF", UDim2.new(0.5, -130, 0.35, 0), Color3.fromRGB(171, 60, 255))
local GodBtn = CreateButton("갓모드: OFF", UDim2.new(0.5, -130, 0.55, 0), Color3.fromRGB(255, 100, 0))

-- ESP 및 갓모드 기능 실행 (이전 버전과 동일하게 작동)
-- ... (이하 ESP/갓모드 루프 코드)

