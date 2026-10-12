-- NULL DOORS HUB - CUSTOM STUDIO EDITION
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts
-- Intended for a Roblox experience you own/control.
-- Includes: red/black UI, loading screen, mobile scaling, draggable panel,
-- Speed Boost slider + toggle, Fly toggle, Noclip toggle, Infinite Jumps toggle,
-- camera FOV controls, character status, reset controls, and cleanup.
-- It does not bypass anti-cheat or automate another game's private systems.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RED = Color3.fromRGB(245, 42, 55)
local DARK = Color3.fromRGB(14, 14, 19)
local PANEL = Color3.fromRGB(24, 24, 31)
local BUTTON = Color3.fromRGB(38, 38, 48)
local WHITE = Color3.fromRGB(245, 245, 250)
local GRAY = Color3.fromRGB(165, 165, 180)
local GREEN = Color3.fromRGB(70, 220, 135)

local old = playerGui:FindFirstChild("NullDoorsCustom")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NullDoorsCustom"
gui.ResetOnSpawn = false
gui.DisplayOrder = 50
gui.Parent = playerGui

local uiScale = Instance.new("UIScale")
uiScale.Parent = gui

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    uiScale.Scale = math.clamp(math.min(size.X / 760, size.Y / 650), 0.55, 1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, obj)
end

local function stroke(obj, color, thickness)
    make("UIStroke", {Color = color or RED, Thickness = thickness or 1, Transparency = 0.12}, obj)
end

local function tw(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local main
local function toast(message)
    if not main or not main.Parent then return end
    local label = make("TextLabel", {
        Size = UDim2.new(1, -24, 0, 36),
        Position = UDim2.new(0, 12, 1, -46),
        BackgroundColor3 = PANEL,
        Text = tostring(message),
        TextColor3 = WHITE,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextWrapped = true,
        ZIndex = 30
    }, main)
    corner(label, 8)
    stroke(label, RED)
    task.delay(2.1, function()
        if label.Parent then
            tw(label, {TextTransparency = 1, BackgroundTransparency = 1}, 0.2)
            task.wait(0.22)
            if label.Parent then label:Destroy() end
        end
    end)
end

local loading = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundColor3 = DARK, ZIndex = 100}, gui)
local loadTitle = make("TextLabel", {
    AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.42),
    Size = UDim2.new(.9,0,0,52), BackgroundTransparency = 1,
    Text = "NULL DOORS HUB", TextColor3 = RED, Font = Enum.Font.GothamBlack,
    TextSize = 28, ZIndex = 101
}, loading)
local loadStatus = make("TextLabel", {
    AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.51),
    Size = UDim2.new(.9,0,0,24), BackgroundTransparency = 1,
    Text = "Preparing custom interface...", TextColor3 = GRAY,
    Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 101
}, loading)
local barBack = make("Frame", {
    AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.57),
    Size = UDim2.new(.65,0,0,7), BackgroundColor3 = BUTTON, ZIndex = 101
}, loading)
corner(barBack, 5)
local bar = make("Frame", {Size = UDim2.new(0,0,1,0), BackgroundColor3 = RED, ZIndex = 102}, barBack)
corner(bar, 5)

main = make("Frame", {
    Name = "Main", Size = UDim2.new(0,600,0,470),
    Position = UDim2.new(.5,-300,.5,-235), BackgroundColor3 = DARK,
    Visible = false, ClipsDescendants = true
}, gui)
corner(main, 12)
stroke(main, RED, 1.5)

local top = make("Frame", {Size = UDim2.new(1,0,0,58), BackgroundColor3 = PANEL}, main)
corner(top, 12)
make("Frame", {Position = UDim2.new(0,0,1,-12), Size = UDim2.new(1,0,0,12), BackgroundColor3 = PANEL, BorderSizePixel = 0}, top)
make("TextLabel", {
    Position = UDim2.new(0,16,0,6), Size = UDim2.new(1,-100,0,27),
    BackgroundTransparency = 1, Text = "NULL DOORS HUB", TextColor3 = RED,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBlack, TextSize = 19
}, top)
make("TextLabel", {
    Position = UDim2.new(0,17,0,32), Size = UDim2.new(1,-100,0,15),
    BackgroundTransparency = 1, Text = "CUSTOM EDITION • STUDIO SAFE",
    TextColor3 = GRAY, TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Gotham, TextSize = 9
}, top)

local close = make("TextButton", {
    Position = UDim2.new(1,-43,0,11), Size = UDim2.new(0,30,0,30),
    BackgroundColor3 = RED, Text = "X", TextColor3 = WHITE,
    Font = Enum.Font.GothamBold, TextSize = 14
}, top)
corner(close, 8)

local nav = make("Frame", {
    Position = UDim2.new(0,12,0,72), Size = UDim2.new(0,160,1,-84),
    BackgroundColor3 = PANEL
}, main)
corner(nav, 9)
make("UIPadding", {PaddingTop=UDim.new(0,9), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8)}, nav)
make("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, nav)

local content = make("ScrollingFrame", {
    Position = UDim2.new(0,184,0,72), Size = UDim2.new(1,-196,1,-84),
    BackgroundColor3 = PANEL, BorderSizePixel = 0, ScrollBarThickness = 4,
    ScrollBarImageColor3 = RED, CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, main)
corner(content, 9)
make("UIPadding", {
    PaddingTop=UDim.new(0,12), PaddingLeft=UDim.new(0,12),
    PaddingRight=UDim.new(0,12), PaddingBottom=UDim.new(0,12)
}, content)
make("UIListLayout", {Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder}, content)

local open = make("TextButton", {
    Name="OpenHub", Position=UDim2.new(0,14,.5,-22), Size=UDim2.new(0,118,0,42),
    BackgroundColor3=DARK, Text="OPEN NULL HUB", TextColor3=RED,
    Font=Enum.Font.GothamBold, TextSize=11, Visible=false
}, gui)
corner(open, 9)
stroke(open, RED, 1.5)

local state = {
    speedEnabled = false, speed = 32,
    flyEnabled = false, noclipEnabled = false, infiniteJumps = false,
    compact = false, originalFov = 70
}
local tabs = {}
local connections = {}
local noclipParts = {}
local flyVelocity, flyAttachment, flyConnection
local currentPage = "General"

local function character()
    local c = player.Character
    return c, c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
end

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
    end
end

local function heading(text)
    return make("TextLabel", {
        Size=UDim2.new(1,-2,0,28), BackgroundTransparency=1, Text=text,
        TextColor3=RED, TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamBold, TextSize=16
    }, content)
end

local function note(text, height)
    local label = make("TextLabel", {
        Size=UDim2.new(1,-2,0,height or 46), BackgroundColor3=BUTTON,
        Text=text, TextColor3=GRAY, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left, Font=Enum.Font.Gotham,
        TextSize=11
    }, content)
    corner(label, 7)
    make("UIPadding", {PaddingLeft=UDim.new(0,9), PaddingRight=UDim.new(0,7)}, label)
    return label
end

local function action(text, callback)
    local b = make("TextButton", {
        Size=UDim2.new(1,-2,0,37), BackgroundColor3=BUTTON,
        Text=text, TextColor3=WHITE, TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium, TextSize=12, AutoButtonColor=true
    }, content)
    corner(b, 7)
    make("UIPadding", {PaddingLeft=UDim.new(0,10)}, b)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then warn("[NULL DOORS HUB] "..tostring(err)); toast("Action failed; see Studio Output.") end
    end)
    return b
end

local function toggle(text, getValue, setValue)
    local b
    local function refresh()
        local enabled = getValue()
        if b and b.Parent then
            b.Text = text .. (enabled and "   [ ON ]" or "   [ OFF ]")
            b.BackgroundColor3 = enabled and Color3.fromRGB(78,30,41) or BUTTON
        end
    end
    b = action(text, function()
        setValue(not getValue())
        refresh()
    end)
    refresh()
    return b
end

local function slider(text, minimum, maximum, initial, callback)
    local holder = make("Frame", {Size=UDim2.new(1,-2,0,60), BackgroundColor3=BUTTON}, content)
    corner(holder, 7)
    local value = initial
    local label = make("TextLabel", {
        Position=UDim2.new(0,9,0,4), Size=UDim2.new(1,-18,0,20),
        BackgroundTransparency=1, Text=text..": "..tostring(value),
        TextColor3=WHITE, TextXAlignment=Enum.TextXAlignment.Left,
        Font=Enum.Font.GothamMedium, TextSize=12
    }, holder)
    local track = make("TextButton", {
        Position=UDim2.new(0,10,0,34), Size=UDim2.new(1,-20,0,8),
        BackgroundColor3=DARK, Text="", AutoButtonColor=false
    }, holder)
    corner(track, 5)
    local fill = make("Frame", {Size=UDim2.new((value-minimum)/(maximum-minimum),0,1,0), BackgroundColor3=RED}, track)
    corner(fill, 5)
    local dragging = false
    local function setFromX(x)
        local width = math.max(track.AbsoluteSize.X, 1)
        local fraction = math.clamp((x-track.AbsolutePosition.X)/width,0,1)
        value = math.floor(minimum + fraction*(maximum-minimum) + 0.5)
        label.Text = text..": "..tostring(value)
        fill.Size = UDim2.new((value-minimum)/(maximum-minimum),0,1,0)
        callback(value)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    return holder
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection=nil end
    if flyVelocity then flyVelocity:Destroy(); flyVelocity=nil end
    if flyAttachment then flyAttachment:Destroy(); flyAttachment=nil end
    local _, hum = character()
    if hum then hum.PlatformStand = false end
end

local function startFly()
    local _, hum, root = character()
    if not root or not hum then toast("Character is not ready."); state.flyEnabled=false; return end
    stopFly()
    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "NullHubFlyAttachment"
    flyAttachment.Parent = root
    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "NullHubFlyVelocity"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root
    hum.PlatformStand = false
    flyConnection = RunService.RenderStepped:Connect(function()
        if not state.flyEnabled or not root.Parent then stopFly(); return end
        local camera = workspace.CurrentCamera
        if not camera then return end
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
        if direction.Magnitude > 0 then direction = direction.Unit * 42 end
        flyVelocity.VectorVelocity = direction
    end)
end

local function applySpeed()
    local _, hum = character()
    if hum then hum.WalkSpeed = state.speedEnabled and state.speed or 16 end
end

local function applyNoclip()
    local c = player.Character
    if not c then return end
    for _, part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") then
            if state.noclipEnabled then
                if noclipParts[part] == nil then noclipParts[part] = part.CanCollide end
                part.CanCollide = false
            elseif noclipParts[part] ~= nil then
                part.CanCollide = noclipParts[part]
                noclipParts[part] = nil
            end
        end
    end
end

connections.heartbeat = RunService.Stepped:Connect(function()
    if state.noclipEnabled then applyNoclip() end
end)

connections.character = player.CharacterAdded:Connect(function()
    task.wait(0.5)
    applySpeed()
    if state.flyEnabled then startFly() end
    if state.noclipEnabled then applyNoclip() end
end)

connections.jump = UserInputService.JumpRequest:Connect(function()
    if not state.infiniteJumps then return end
    local _, hum = character()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local function showPage(name)
    currentPage = name
    clearContent()
    for tabName, b in pairs(tabs) do
        b.BackgroundColor3 = tabName == name and Color3.fromRGB(91,28,39) or BUTTON
    end

    if name == "General" then
        heading("Welcome back")
        note("NULL DOORS HUB • Custom Studio Edition. Movement toggles work locally in your own experience; server scripts may enforce their own limits.")
        action("Check character status", function()
            local _, hum, root = character()
            if hum then
                toast(("Health %d/%d • Speed %d • Root %s"):format(math.floor(hum.Health), math.floor(hum.MaxHealth), hum.WalkSpeed, root and "ready" or "loading"))
            else toast("Character is loading.") end
        end)
        action("Show position", function()
            local _, _, root = character()
            if root then
                local p = root.Position
                toast(("Position %.1f, %.1f, %.1f"):format(p.X,p.Y,p.Z))
            else toast("Character is unavailable.") end
        end)
        action("Reset movement to defaults", function()
            state.speedEnabled = false
            state.flyEnabled = false
            state.noclipEnabled = false
            state.infiniteJumps = false
            stopFly()
            applyNoclip()
            applySpeed()
            showPage("General")
            toast("Movement settings reset.")
        end)

    elseif name == "Exploits" then
        heading("Movement controls")
        note("These local character utilities are intended for your own Roblox Studio experience. No anti-cheat bypass is included.")
        toggle("Enable Speed Boost", function() return state.speedEnabled end, function(v) state.speedEnabled=v; applySpeed() end)
        slider("Speed Boost", 16, 100, state.speed, function(v) state.speed=v; if state.speedEnabled then applySpeed() end end)
        toggle("Enable Fly", function() return state.flyEnabled end, function(v)
            state.flyEnabled=v
            if v then startFly() else stopFly() end
        end)
        note("Fly controls: W/A/S/D to move, Space to rise, Left Ctrl to descend. Touch-only devices may need on-screen movement controls added.")
        toggle("Enable Noclip", function() return state.noclipEnabled end, function(v)
            state.noclipEnabled=v
            if v then applyNoclip() else applyNoclip() end
        end)
        toggle("Enable Infinite Jumps", function() return state.infiniteJumps end, function(v) state.infiniteJumps=v end)
        action("Reset speed to 16", function()
            state.speed=16; state.speedEnabled=false; applySpeed(); showPage("Exploits")
        end)

    elseif name == "Visuals" then
        heading("Visual settings")
        note("Camera FOV affects only your local camera.")
        action("FOV 70", function()
            local cam=workspace.CurrentCamera
            if cam then cam.FieldOfView=70; toast("FOV set to 70.") end
        end)
        action("FOV 85", function()
            local cam=workspace.CurrentCamera
            if cam then cam.FieldOfView=85; toast("FOV set to 85.") end
        end)
        action("FOV 100", function()
            local cam=workspace.CurrentCamera
            if cam then cam.FieldOfView=100; toast("FOV set to 100.") end
        end)
        action("Reset FOV", function()
            local cam=workspace.CurrentCamera
            if cam then cam.FieldOfView=state.originalFov; toast("FOV restored.") end
        end)
        action("Read lighting status", function()
            toast("Brightness: "..tostring(Lighting.Brightness).." • Clock: "..tostring(Lighting.ClockTime))
        end)

    elseif name == "Floors" then
        heading("Floor tools")
        note("These controls expose general character and place information. Floor-specific automation requires supported code in your own game.")
        action("Read Place ID", function() toast("Place ID: "..tostring(game.PlaceId)) end)
        action("Read server ID status", function() toast("Server ID available: "..tostring(game.JobId ~= "")) end)
        action("Count workspace parts", function()
            local count=0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then count+=1 end
            end
            toast("Workspace parts: "..count)
        end)

    elseif name == "New - Archives" then
        heading("Archives")
        note("Puzzle helpers can be connected to puzzle state in a game you own.")
        action("Count carried tools", function()
            local count=0
            local c=player.Character
            local backpack=player:FindFirstChildOfClass("Backpack")
            for _, container in ipairs({c,backpack}) do
                if container then
                    for _, obj in ipairs(container:GetChildren()) do
                        if obj:IsA("Tool") then count+=1 end
                    end
                end
            end
            toast("Tools carried: "..count)
        end)
        action("Check puzzle integration", function()
            toast("No custom puzzle data source is connected yet.")
        end)

    elseif name == "New - Stairwell" then
        heading("Stairwell")
        note("Entity tracking requires entity signals supplied by your own experience.")
        action("Check health", function()
            local _, hum=character()
            toast(hum and ("Health: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)) or "Character loading.")
        end)
        action("Check entity integration", function()
            toast("No custom entity feed is connected.")
        end)

    elseif name == "Settings" then
        heading("Settings")
        action("Toggle compact UI", function()
            state.compact=not state.compact
            updateScale()
            if state.compact then uiScale.Scale=math.min(uiScale.Scale,0.72) end
            toast(state.compact and "Compact mode enabled." or "Compact mode disabled.")
        end)
        action("Reset camera FOV", function()
            local cam=workspace.CurrentCamera
            if cam then cam.FieldOfView=state.originalFov end
            toast("Camera FOV reset.")
        end)
        action("Show version", function() toast("NULL DOORS HUB • Custom Studio Edition") end)
        action("Clean up and close", function()
            state.flyEnabled=false
            stopFly()
            state.noclipEnabled=false
            applyNoclip()
            for _, conn in pairs(connections) do
                if typeof(conn)=="RBXScriptConnection" then conn:Disconnect() end
            end
            gui:Destroy()
        end)
        note("No hidden hooks or anti-cheat bypasses are used.")
    end
end

local pageNames = {"General","Exploits","Visuals","Floors","New - Archives","New - Stairwell","Settings"}
for index, name in ipairs(pageNames) do
    local b=make("TextButton", {
        Name="Tab"..name:gsub("%W",""), Size=UDim2.new(1,0,0,35),
        BackgroundColor3=BUTTON, Text=name, TextColor3=WHITE,
        Font=Enum.Font.GothamSemibold, TextSize=11, LayoutOrder=index
    }, nav)
    corner(b,7)
    tabs[name]=b
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

close.MouseButton1Click:Connect(function() main.Visible=false; open.Visible=true end)
open.MouseButton1Click:Connect(function() main.Visible=true; open.Visible=false end)

-- Drag with mouse or touch
local dragging, dragStart, startPos = false, nil, nil
top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=main.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

task.spawn(function()
    local stages={"Preparing interface...","Loading movement controls...","Setting up visual options...","Checking local services...","Ready."}
    for i, status in ipairs(stages) do
        loadStatus.Text=status
        tw(bar,{Size=UDim2.new(i/#stages,0,1,0)},0.25)
        task.wait(0.32)
    end
    task.wait(0.2)
    main.Visible=true
    tw(loading,{BackgroundTransparency=1},0.25)
    tw(loadTitle,{TextTransparency=1},0.2)
    tw(loadStatus,{TextTransparency=1},0.2)
    task.wait(0.3)
    loading:Destroy()
    showPage("General")
end)

print("[NULL DOORS HUB] Custom Studio Edition loaded.")
