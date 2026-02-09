-- [[ 01100101 01100011 01100001 ]]
-- 0101010101010101010101010101
-- [[ 00000000 00000001 00000000 ]]

local _01 = game:GetService("\80\108\97\121\101\114\115")
local _00 = game:GetService("\82\117\110\83\101\114\118\105\99\101")
local _11 = _01.LocalPlayer
local _10 = (gethui and gethui()) or game:GetService("\67\111\114\101\71\117\105")

-- 0101 BIT_MAP (ESP, WALL, TP, COIN, RANK)
local _0000 = { [0]=false, [1]=false, [2]=false, [3]=false, [4]=false }

local function _101010(_0)
    local _01, _10, _11, _00_pos
    _0.InputBegan:Connect(function(_i)
        if _i.UserInputType == Enum.UserInputType.MouseButton1 then
            _01 = true; _11 = _i.Position; _00_pos = _0.Position
            _i.Changed:Connect(function()
                if _i.UserInputState == Enum.UserInputState.End then _01 = false end
            end)
        end
    end)
    _0.InputChanged:Connect(function(_i)
        if _i.UserInputType == Enum.UserInputType.MouseMovement then _10 = _i end
    end)
    _00.RenderStepped:Connect(function()
        if _01 and _10 then
            local _d = _10.Position - _11
            _0.Position = UDim2.new(_00_pos.X.Scale, _00_pos.X.Offset + _d.X, _00_pos.Y.Scale, _00_pos.Y.Offset + _d.Y)
        end
    end)
end

local _gui = Instance.new("\83\99\114\101\101\110\71\117\105", _10)
local _main = Instance.new("\70\114\97\109\101", _gui)
_main.Size = UDim2.new(0, 550, 0, 400)
_main.BackgroundColor3 = Color3.new(0,0,0)
_101010(_main)

-- HIDDEN UI GENERATOR (Binary labels only)
for i = 0, 4 do
    local _b = Instance.new("\84\101\120\116\66\117\116\116\111\110", _main)
    _b.Size = UDim2.new(0, 180, 0, 40)
    _b.Position = UDim2.new(0.5, -90, 0, 20 + (i * 50))
    _b.Text = "0101_" .. i .. " : 0"
    _b.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    _b.TextColor3 = Color3.new(1, 1, 1)
    _b.Font = Enum.Font.Code
    
    _b.MouseButton1Click:Connect(function()
        _0000[i] = not _0000[i]
        _b.Text = "0101_" .. i .. " : " .. (_0000[i] and "1" or "0")
        _b.BackgroundColor3 = _0000[i] and Color3.new(0, 0.5, 0) or Color3.new(0.1, 0.1, 0.1)
    end)
end

-- 0101_0 (ESP) LOGIC
_00.RenderStepped:Connect(function()
    for _, _v in pairs(_01:GetPlayers()) do
        if _v.Character then
            local _h = _v.Character:FindFirstChild("\48\49")
            if _0000[0] and _v ~= _11 then
                if not _h then
                    _h = Instance.new("\72\105\103\104\108\105\103\104\116", _v.Character)
                    _h.Name = "\48\49"
                end
                _h.Enabled = true
            elseif _h then
                _h.Enabled = false
            end
        end
    end
end)

-- 0101_3 (COIN) & 0101_4 (RANK) LOGIC
task.spawn(function()
    while task.wait(0.1) do
        if _0000[3] then
            for _, _c in pairs(workspace:GetDescendants()) do
                if _c.Name == "\67\111\105\110" then
                    _11.Character.HumanoidRootPart.CFrame = _c.CFrame
                    task.wait(0.15)
                end
            end
        elseif _0000[4] then
            local _k = _11.Character:FindFirstChild("\75\110\105\102\101") or _11.Backpack:FindFirstChild("\75\110\105\102\101")
            if _k then
                _k.Parent = _11.Character
                for _, _t in pairs(_01:GetPlayers()) do
                    if _t ~= _11 and _t.Character and _t.Character:FindFirstChild("\72\117\109\97\110\111\105\100") then
                        _11.Character.HumanoidRootPart.CFrame = _t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                        _k:Activate()
                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)

