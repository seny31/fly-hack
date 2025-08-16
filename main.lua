local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local direction = Vector3.new()
local speed = 5
local rightMouseDown = false
local mouseDelta = Vector2.new()
local sensitivity = 0.25

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseDown = true
        mouseDelta = Vector2.new()
    elseif input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        hrp.Anchored = flying

        if flying then
            humanoid.Sit = true -- Oturma pozisyonu
        else
            humanoid.Sit = false -- Normal pozisyona dön
        end
    elseif input.KeyCode == Enum.KeyCode.W then
        direction = direction + Vector3.new(0,0,1)
    elseif input.KeyCode == Enum.KeyCode.S then
        direction = direction + Vector3.new(0,0,-1)
    elseif input.KeyCode == Enum.KeyCode.A then
        direction = direction + Vector3.new(-1,0,0)
    elseif input.KeyCode == Enum.KeyCode.D then
        direction = direction + Vector3.new(1,0,0)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseDown = false
    elseif input.KeyCode == Enum.KeyCode.W then
        direction = direction - Vector3.new(0,0,1)
    elseif input.KeyCode == Enum.KeyCode.S then
        direction = direction - Vector3.new(0,0,-1)
    elseif input.KeyCode == Enum.KeyCode.A then
        direction = direction - Vector3.new(-1,0,0)
    elseif input.KeyCode == Enum.KeyCode.D then
        direction = direction - Vector3.new(1,0,0)
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and rightMouseDown then
        mouseDelta = Vector2.new(input.Delta.x, input.Delta.y)
    end
end)

local yaw = 0
local pitch = 0

RunService.RenderStepped:Connect(function()
    if flying then
        if rightMouseDown then
            yaw = yaw - mouseDelta.X * sensitivity
            pitch = math.clamp(pitch - mouseDelta.Y * sensitivity, -80, 80)
            mouseDelta = Vector2.new()

            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position) *
                CFrame.Angles(math.rad(pitch), math.rad(yaw), 0)

            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + workspace.CurrentCamera.CFrame.LookVector)
        end

        if direction.Magnitude > 0 then
            local camCFrame = workspace.CurrentCamera.CFrame
            local moveDir = camCFrame.RightVector * direction.X + camCFrame.LookVector * direction.Z
            hrp.CFrame = hrp.CFrame + moveDir.Unit * speed
        end

        hrp.Anchored = true
    else
        hrp.Anchored = false
    end
end)
