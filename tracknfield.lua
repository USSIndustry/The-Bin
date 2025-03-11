-- Credit : USSIndustry

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local sizes = {}
local lock = false
local beams = {}

local races = { 
    "110 METER HURDLES",
    "200 METER DASH"
}

local function makebeam(part)
    local att1 = Instance.new("Attachment")
    att1.Parent = character.HumanoidRootPart
    
    local att2 = Instance.new("Attachment") 
    att2.Parent = part
    
    local beam = Instance.new("Beam")
    beam.Parent = character.HumanoidRootPart
    beam.Attachment0 = att1
    beam.Attachment1 = att2
    beam.Width0 = 0.5
    beam.Width1 = 0.5
    beam.FaceCamera = true
    beam.Color = ColorSequence.new(Color3.new(0, 0, 1))
    
    table.insert(beams, {beam = beam, att1 = att1, att2 = att2})
end

local function curve(part)
    local box = Instance.new("SelectionBox")
    box.Parent = part
    box.Adornee = part
    box.LineThickness = 0.1
    box.Color3 = Color3.new(0, 0, 1)
    makebeam(part)
end

local function resize()
    local title = Workspace.Map.Timers.Timer.Title.SurfaceGui.TitleText
    
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Part") then
            if v.Name == "EndPoint" or v.Name:match("^Checkpoint%d+$") then
                if v.Name == "EndPoint" then
                    v.Transparency = 0.9
                    curve(v)
                end
                
                if not sizes[v] then
                    sizes[v] = v.Size
                end
                
                local target
                if title.Text == "300 METER DASH" then
                    target = Vector3.new(v.Size.X, v.Size.Y, 285)
                elseif title.Text == "60 METER DASH" then
                    target = Vector3.new(v.Size.X, v.Size.Y, 60)
                elseif title.Text == "100 METER DASH" then
                    target = Vector3.new(v.Size.X, v.Size.Y, 60)
                elseif table.find(races, title.Text) then
                    target = Vector3.new(v.Size.X, v.Size.Y, 85)
                elseif title.Text:find("RELAY") then
                    target = Vector3.new(v.Size.X, v.Size.Y, 65)
                else
                    target = Vector3.new(v.Size.X, v.Size.Y, 380)
                end
                
                if v.Size ~= target then
                    v.Size = target
                    v.CanCollide = false
                end
            end
        end
    end
end

local function added()
    if lock then return end
    lock = true
    task.wait(0.5)
    resize()
    lock = false
end

local function cleanup()
    for _, obj in ipairs(beams) do
        obj.beam:Destroy()
        obj.att1:Destroy() 
        obj.att2:Destroy()
    end
    beams = {}
end

player.CharacterAdded:Connect(cleanup)
Workspace.DescendantAdded:Connect(added)
RunService.Heartbeat:Connect(resize)
