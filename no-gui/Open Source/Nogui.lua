/// idk if work or not :/ modify your self

local color = BrickColor.new("Really red")
local plr = game.Players.LocalPlayer
local empty = Vector3.new()
local hit = game.ReplicatedStorage.Remotes.ParryAttempt
local cam = workspace.CurrentCamera
 
local Settings = {
    Autoparry = {
        Toggle = boo,
        Cooldown = .0*.0*.0,
        Range = 25,
        MinConstantRange = 25,  -- ปรับค่าต่ำสุดของระยะที่ควร Parry
        MaxConstantRange = 95,  -- ปรับค่าสูงสุดของระยะที่ควร Parry
    },
}
 
function getspeed()
    for _, v in pairs(workspace.Balls:GetChildren()) do
        if v.zoomies.VectorVelocity ~= empty then
            return v.zoomies.VectorVelocity.Magnitude
        end
    end
end
 
function estimateTime(ball)
    local maxDistance = Settings.Autoparry.MaxConstantRange
    local minDistance = Settings.Autoparry.MinConstantRange
    local distance = getdistance(ball)
    return math.clamp(distance, minDistance, maxDistance)
end
 
function getdistance(ball)
    return (ball.Position - plr.Character.HumanoidRootPart.Position).Magnitude
end
 
-- Auto Parry Function
local hitcd = false
function counter()
    wait(Settings.Autoparry.Cooldown)
    hitcd = false
end
 
workspace.Balls.ChildAdded:Connect(function(v)
    v:GetPropertyChangedSignal("BrickColor"):Connect(function()
        if v.BrickColor ~= color then
            hitcd = false
        end
    end)
    v:GetPropertyChangedSignal("Position"):Connect(function()
        if Settings.Autoparry.Toggle and v["BrickColor"] == color then
            local ballSpeed = getspeed()
            local adjustedConstantRange = math.clamp(Settings.Autoparry.MinConstantRange + (ballSpeed / 5), Settings.Autoparry.MinConstantRange, Settings.Autoparry.MaxConstantRange)
 
            if (estimateTime(v) < Settings.Autoparry.Range or getdistance(v) < adjustedConstantRange) and not hitcd then
                hitcd = true
                print("Hit", Settings.Autoparry.Range, adjustedConstantRange, Settings.Autoparry.Cooldown)
                hit:FireServer(0.5, CFrame.new(), {}, {})
                spawn(counter)
            end
        end
    end)
end)
end,
