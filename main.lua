-- HBV Hub Jailbird Script v3
-- Modified with HBV branding by HBV_dev

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
getgenv().SpinBotSettings = {
    Enabled = false,
    Mode = "Spin"
}

getgenv().AimbotSettings = {
    Enabled = false,
    Smoothness = 1,
    TargetPart = "Head",
    TeamCheck = false,
    FOV = 100,
    ShowFOV = false,
    VisibleOnly = false,
    RainbowFOV = false,
    FOVTransparency = 0.8
}

getgenv().EspSettings = {
    Boxes = false,
    Tracers = false,
    Skeleton = false,
    Name = false,
    Health = false,
    Tool = false,
    Rainbow = false
}

getgenv().HitboxSettings = {
    Enabled = false,
    Size = 4,
    WallCheck = false
}

getgenv().SilentAimSettings = {
    Enabled = false,
    HitChance = 100,
    TargetPart = "Head",
    TeamCheck = false,
    VisibleOnly = false,
    FOV = 100
}

getgenv().DeviceSpooferSettings = {
    Enabled = false,
    DeviceType = "Computer",
    Platform = "Windows"
}

getgenv().WalkSpeedValue = 16
getgenv().JumpPowerValue = 50
getgenv().TPWalkSpeed = 50
getgenv().CameraFOVEnabled = false
getgenv().CameraFOVValue = 70

getgenv().RandomHighPingEnabled = false

local Connections = {
    Spin = nil,
    Noclip = nil,
    Backstab = nil,
    InfiniteAmmo = nil,
    TPWalk = nil,
    InfJump = nil,
    Esp = nil,
    Chams = nil,
    CameraFOV = nil,
    PingChanger = nil,
    SilentAim = nil,
    DeviceSpoof = nil
}

-- Load UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local customThemes = {
    {
        Name = "Obsidian",
        Accent = Color3.fromHex("#1a1a1a"),
        Background = Color3.fromHex("#0d0d0d"),
        Outline = Color3.fromHex("#404040"),
        Text = Color3.fromHex("#e0e0e0"),
        Placeholder = Color3.fromHex("#6b6b6b"),
        Button = Color3.fromHex("#2b2b2b"),
        Icon = Color3.fromHex("#9e9e9e"),
    },
    {
        Name = "Crimson",
        Accent = Color3.fromHex("#2d1111"),
        Background = Color3.fromHex("#1a0a0a"),
        Outline = Color3.fromHex("#ff4444"),
        Text = Color3.fromHex("#ffffff"),
        Placeholder = Color3.fromHex("#8b5e5e"),
        Button = Color3.fromHex("#4a2020"),
        Icon = Color3.fromHex("#ff6666"),
    },
    {
        Name = "Ocean",
        Accent = Color3.fromHex("#0b1a2a"),
        Background = Color3.fromHex("#050d14"),
        Outline = Color3.fromHex("#3a8fd4"),
        Text = Color3.fromHex("#e6f0ff"),
        Placeholder = Color3.fromHex("#5b7a9e"),
        Button = Color3.fromHex("#1a2e42"),
        Icon = Color3.fromHex("#5aa9e6"),
    },
    {
        Name = "Sunset",
        Accent = Color3.fromHex("#2a1a1a"),
        Background = Color3.fromHex("#140a0a"),
        Outline = Color3.fromHex("#ff8c42"),
        Text = Color3.fromHex("#ffe0cc"),
        Placeholder = Color3.fromHex("#8c6242"),
        Button = Color3.fromHex("#3d2626"),
        Icon = Color3.fromHex("#ffb380"),
    },
    {
        Name = "Forest",
        Accent = Color3.fromHex("#1a2e1a"),
        Background = Color3.fromHex("#0d1a0d"),
        Outline = Color3.fromHex("#4caf50"),
        Text = Color3.fromHex("#e0ffe0"),
        Placeholder = Color3.fromHex("#5e8c5e"),
        Button = Color3.fromHex("#2b472b"),
        Icon = Color3.fromHex("#81c784"),
    },
}

for _, theme in ipairs(customThemes) do
    WindUI:AddTheme(theme)
end

local savedTheme = nil
pcall(function()
    if isfile and isfolder and makefolder and readfile then
        if not isfolder("HBV_Hub") then makefolder("HBV_Hub") end
        if isfile("HBV_Hub/theme.txt") then
            savedTheme = readfile("HBV_Hub/theme.txt")
        end
    end
end)
WindUI:SetTheme(savedTheme or "Ocean")

local Window = WindUI:CreateWindow({
    Title = "HBV Hub | JailBird",
    Icon = "shield",
    Author = "by HBV_owner on discord",
    Folder = "HBV_Hub"
})

Window:EditOpenButton({
    Title = "HBV Hub | Jailbird",
    Icon = "terminal",
    CornerRadius = UDim.new(0, 12),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local ConfigManager = Window.ConfigManager
local currentConfig = ConfigManager:CreateConfig("DefaultConfig")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- UI Toggle
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        uiVisible = not uiVisible
        pcall(function() Window.Main.Visible = uiVisible end)
    end
end)

-- FOV Circle
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FOVCircle"
fovGui.IgnoreGuiInset = true
fovGui.Parent = playerGui

local fovFrame = Instance.new("Frame")
fovFrame.Name = "Circle"
fovFrame.Size = UDim2.new(0, 200, 0, 200)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Parent = fovGui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 0, 100)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.8
fovStroke.Parent = fovFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

fovFrame.Visible = getgenv().AimbotSettings.ShowFOV

local function UpdateFOVCircle(radius)
    fovFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
end
UpdateFOVCircle(getgenv().AimbotSettings.FOV)

-- Visibility check
local function IsVisible(targetPart)
    if not targetPart then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    rayParams.IgnoreWater = true
    local origin = Camera.CFrame.Position
    local dir = targetPart.Position - origin
    local result = workspace:Raycast(origin, dir, rayParams)
    return result == nil
end

-- Get closest player for aimbot
local function GetClosestPlayer()
    local target = nil
    local shortest = math.huge
    local settings = getgenv().AimbotSettings
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local aimPart = plr.Character:FindFirstChild(settings.TargetPart)
            if not hrp or not aimPart then continue end

            if settings.TeamCheck and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                continue
            end

            if settings.VisibleOnly and not IsVisible(aimPart) then
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist <= settings.FOV and dist < shortest then
                    target = plr
                    shortest = dist
                end
            end
        end
    end
    return target
end

-- Get closest player for Silent Aim
local function GetClosestPlayerForSilentAim()
    local target = nil
    local shortest = math.huge
    local settings = getgenv().SilentAimSettings
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local aimPart = plr.Character:FindFirstChild(settings.TargetPart)
            if not hrp or not aimPart then continue end

            if settings.TeamCheck and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                continue
            end

            if settings.VisibleOnly then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, plr.Character}
                rayParams.IgnoreWater = true
                local origin = Camera.CFrame.Position
                local dir = aimPart.Position - origin
                local result = workspace:Raycast(origin, dir, rayParams)
                if result ~= nil then continue end
            end

            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist <= settings.FOV and dist < shortest then
                    target = plr
                    shortest = dist
                end
            end
        end
    end
    return target
end

-- Silent Aim hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if getgenv().SilentAimSettings.Enabled and method == "FireServer" then
        if tostring(self) == "Damage" then
            local target = GetClosestPlayerForSilentAim()
            if target and target.Character and math.random(1, 100) <= getgenv().SilentAimSettings.HitChance then
                local targetPart = target.Character:FindFirstChild(getgenv().SilentAimSettings.TargetPart)
                if targetPart then
                    if args[4] and type(args[4]) == "table" then
                        args[4].Instance = targetPart
                        args[4].EndPosition = targetPart.Position
                        args[4].Normal = (Camera.CFrame.Position - targetPart.Position).Unit
                        args[4].Direction = (targetPart.Position - Camera.CFrame.Position).Unit
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, unpack(args))
end))

-- Device Spoofer
local function SpoofDevice()
    if getgenv().DeviceSpooferSettings.Enabled then
        local deviceType = getgenv().DeviceSpooferSettings.DeviceType
        local platform = getgenv().DeviceSpooferSettings.Platform
        
        -- Spoof UserInputService
        local uis = game:GetService("UserInputService")
        local oldTouchEnabled = uis.TouchEnabled
        local oldMouseEnabled = uis.MouseEnabled
        local oldKeyboardEnabled = uis.KeyboardEnabled
        local oldGamepadEnabled = uis.GamepadEnabled
        
        if deviceType == "Mobile" then
            setreadonly(uis, false)
            uis.TouchEnabled = true
            uis.MouseEnabled = false
            uis.KeyboardEnabled = false
            uis.GamepadEnabled = false
            setreadonly(uis, true)
        elseif deviceType == "Console" then
            setreadonly(uis, false)
            uis.TouchEnabled = false
            uis.MouseEnabled = false
            uis.KeyboardEnabled = false
            uis.GamepadEnabled = true
            setreadonly(uis, true)
        elseif deviceType == "Computer" then
            setreadonly(uis, false)
            uis.TouchEnabled = false
            uis.MouseEnabled = true
            uis.KeyboardEnabled = true
            uis.GamepadEnabled = false
            setreadonly(uis, true)
        end
        
        -- Spoof Platform
        local plr = game:GetService("Players").LocalPlayer
        local oldPlatform = plr.OsPlatform
        setreadonly(plr, false)
        plr.OsPlatform = platform
        setreadonly(plr, true)
        
        print(string.format("[HBV] Device spoofed to: %s (%s)", deviceType, platform))
    end
end

-- Main heartbeat loop
RunService.Heartbeat:Connect(function()
    local aimSettings = getgenv().AimbotSettings
    local hitSettings = getgenv().HitboxSettings
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if head and hrp then
                local inFov = false
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    inFov = dist <= aimSettings.FOV
                end
                local wallOk = true
                if hitSettings.WallCheck then
                    wallOk = IsVisible(hrp)
                end

                if hitSettings.Enabled and inFov and wallOk then
                    local sz = Vector3.new(hitSettings.Size, hitSettings.Size, hitSettings.Size)
                    head.Size = sz
                    head.CanCollide = false
                    hrp.Size = sz
                    hrp.CanCollide = false
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.CanCollide = true
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.CanCollide = true
                end
            end
        end
    end

    if aimSettings.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(aimSettings.TargetPart) then
            local targetPos = target.Character[aimSettings.TargetPart].Position
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, targetPos),
                1 / aimSettings.Smoothness
            )
        end
    end

    if aimSettings.RainbowFOV and fovFrame.Visible then
        local hue = (tick() * 0.5) % 1
        fovStroke.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- ESP System
local espGui = Instance.new("ScreenGui")
espGui.Name = "ESP_Gui"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.Parent = playerGui

local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end ocal function createLine2D(from, to, color, thickness)
    local length = (to - from).Magnitude
    if length < 1 then return nil end
    local angle = math.atan2(to.Y - from.Y, to.X - from.X)
    local mid = (from + to) / 2

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, length, 0, thickness or 2)
    frame.Position = UDim2.new(0, mid.X - length/2, 0, mid.Y - (thickness or 2)/2)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Rotation = math.deg(angle)
    frame.Parent = espGui
    return frame
end

local function createText(text, position, color, size, center)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = false
    label.TextSize = size or 14
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, position.X - 100, 0, position.Y - 15)
    if center then
        label.TextXAlignment = Enum.TextXAlignment.Center
    else
        label.TextXAlignment = Enum.TextXAlignment.Left
    end
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = espGui
    return label
end
