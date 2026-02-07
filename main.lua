-- [라이벌 전용 벽 관통/에임봇 로직]
local silentAimEnabled = false
local wallbangEnabled = true -- 벽 관통 활성화

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and silentAimEnabled then
        -- 라이벌은 주로 'Fire' 이벤트나 특정 Raycast를 사용함
        if method == "Raycast" or method == "FindPartOnRay" then
            local target = getTarget() -- 적을 찾는 함수 (ESP 기반)
            
            if target then
                -- [벽 관통 로직]
                -- RaycastParams를 변조하여 벽(Obstacles)을 무시 리스트에 추가함
                if wallbangEnabled and args[3] and typeof(args[3]) == "RaycastParams" then
                    args[3].FilterDescendantsInstances = {game.Workspace.Map} -- 맵 구조물 무시
                    args[3].FilterType = Enum.RaycastFilterType.Exclude
                end
                
                return target.Position, target
            end
        end
    end
    return oldNamecall(self, ...)
end)

