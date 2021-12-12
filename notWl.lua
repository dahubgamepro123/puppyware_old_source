--[[

if getgenv().PuppywareSettings == nil then

    print("Cannot find your configuration.")

    getgenv().PuppywareSettings = {
        PerformanceMode = true,
        turksense = false,
        TargetKey = "E"
    }

end

wait(0.5)

]]

--[[

getgenv().PuppywareSettings = {
    PerformanceMode = true,
    turksense = false,
    TargetKey = "Q",
    Watermark = false
}

]]

local PuppywareSettings = getgenv().PuppywareSettings

if PuppywareSettings == nil then

getgenv().PuppywareSettings = {
    PerformanceMode = true,
    turksense = false,
    TargetKey = "E",
    Watermark = true
}

end

local Script = {
Version = "v0.0.5",
Name = "puppyware-priv"
}

local Settings = {
Prediction_Settings = {
    AutoSettings = false,
    Prediction = 0.165
},
KillSay = {
    Type = "After Dead",
    OldPlayer = "",
    Cooldown = false,
    CustomMessage = false,
    CustomMessageText = "@s is tapped!",
    Message = {
        "@s is sus.",
        "nn tapped, @s bad cheat.",
        "puppyware on top, @s is clapped.",
        "@s is rekted.",
        "puppyware>you",
        "you are just bad get puppyware",
        "u rly thought",
        "bad boy clique",
        "noob",
        "xD",
        "why are you that bad son",
        "you shall quit"
    }
},
Aimbot = {
    Enabled = false,
    Aiming = false,
    FOV = {
        Enabled = false,
        Size = 100,
        Round = 100,
        Color = Color3.fromRGB(28, 56, 139),
        Shape = "Custom",
        Filled = false,
        Transparency = 0.5
    },
    Hitbox = "Head",
    Nearest = "Mouse",
    VisibleCheck = false,
    IgnoreFOV = false,
},
SilentAim = {
    Enabled = false,
    WallCheck = false,
    FOV = {
        Enabled = false,
        Size = 100,
        Round = 100,
        Color = Color3.fromRGB(28, 56, 139),
        Shape = "Custom",
        Filled = false,
        Transparency = 0.5
    },
    Hitbox = "Head",
    Nearest = "Mouse",
    Mode = "Normal",
    VisibleCheck = false,
    IgnoreFOV = false,
    LookAt = false,
},
Triggerbot = {
    Enabled = false,
    Delay = {
        Enabled = false,
        Value = 0
    }
},
AntiAim = {
    Enabled = false,
    Type = "Jitter",
    Angle = 20,
    Speed = 100,
    Underground = false,
    AntiPointAt = false,
    NoAutoRotate = false,
    AntiPointAtDistance = 20
},
Whitelist = {
    Players = {},
    Friends = {},
    Holder = "",
    Enabled = false,
    CrewEnabled = false,
    FriendsWhitelist = false
},
Movement = {
    CFrameSpeed = false,
    Type = "Render"
},
ServerCrash = {
    Enabled = false,
    Value = 0
},
God = {
    GodBullet = false,
    GodMelee = false,
    AntiRagdoll = false,
    IsStillAlive = false
},
Target = {
    Enabled = false,
    TargetUser = nil,
    WallCheck = false,
    Bind = PuppywareSettings.TargetKey
}
}

local Service = setmetatable({}, {
__index = function(t, k)
    return game:GetService(k)
end
})

local WS = workspace
local Insert = table.insert
local Remove = table.remove
local Find = table.find
local Players = Service.Players
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = WS.CurrentCamera
local WorldToViewPortPoint = CurrentCamera.WorldToViewportPoint
local Mouse = LocalPlayer:GetMouse()
local RunService = Service.RunService
local GuiInset = Service.GuiService:GetGuiInset()
local ReplicatedStorage = Service.ReplicatedStorage
local UserInputService = Service.UserInputService
local KeyCode = Enum.KeyCode
local InputType = Enum.UserInputType
local Material = Enum.Material
local UniversalAnimation = Instance.new("Animation")
local StarterGui = Service.StarterGui

local Module = {
Instance = {},
Players = {},
DrawingInstance = {},
OldCFrame,
Ignores = {
    "UpperTorso",
    "LowerTorso",
    "Head",
    "LeftHand",
    "LeftUpperArm",
    "LeftLowerArm",
    "RightHand",
    "RightUpperArm",
    "RightLowerArm"
},
BodyParts = {
    "Head",
    "Torso",
    "HumanoidRootPart",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
},	
Functions = {
    Network = function(Data)
        if Data and Data.Character and Data.Character:FindFirstChild("HumanoidRootPart") ~= nil and Data.Character:FindFirstChild("Humanoid") ~= nil and Data.Character:FindFirstChild("Head") ~= nil then
            return true
        end
        return false
    end,
    Cham = function(Data, State)
        local BoxVar = nil
        local GlowVar = nil
        if State then
            for _, v in pairs(Data.Character:GetChildren()) do
                if v:IsA("BasePart") and v.Transparency ~= 1 then
                    if not v:FindFirstChild("Box") then
                        BoxVar = Instance.new("BoxHandleAdornment", v)
                        BoxVar.Name = "Box"
                        BoxVar.AlwaysOnTop = true
                        BoxVar.ZIndex = 4
                        BoxVar.Adornee = v
                        BoxVar.Color3 = Color3.fromRGB(0, 153, 153)
                        BoxVar.Transparency = 0.5
                        BoxVar.Size = v.Size + Vector3.new(0.02, 0.02, 0.02)
                    end
                end
            end
        else
            for i, v in pairs(Data.Character:GetChildren()) do
                if v:IsA("BasePart") and v.Transparency ~= 1 then
                    if v:FindFirstChild("Box") then
                        v["Box"]:Destroy()
                    end
                end
            end
            
            return BoxVar, GlowVar
        end
    end
},
Drawing = {
    Circle = function(Thickness)
        local Circle = Drawing.new("Circle")
        Circle.Transparency = 1
        Circle.Thickness = Thickness
        return Circle
    end
},
}

Module.Functions.NoSpace = function(Data)
return Data:gsub("%s+", "") or Data
end

Module.Functions.Find = function(Data)
local Target = nil

for i, v in next, Players:GetPlayers() do
    if v.Name ~= LocalPlayer.Name and v.Name:lower():match('^'.. Module.Functions.NoSpace(Data):lower()) then
        Target = v.Name
    end
end

return Target
end

Module.Functions.PlayAnimation = function(Data, SpeedData, ActionData)
if Module.Functions.Network(LocalPlayer) then
    UniversalAnimation.AnimationId = "rbxassetid://" .. tostring(Data)
    local Track = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(UniversalAnimation)
    if ActionData then
        Track.Priority = Enum.AnimationPriority.Action
    end
    if SpeedData ~= nil then
        Track:AdjustSpeed(SpeedData)
    end
    Track:Play()
end
end

Module.Functions.StopAnimation = function()
if Module.Functions.Network(LocalPlayer) then
    for _, v in next, LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks() do
        if v.Animation.AnimationId:match("rbxassetid") then
            v:Stop()
        end
    end
end
end

Module.Functions.Underground = function(Data)
if Module.Functions.Network(LocalPlayer) then
    if Data then
        LocalPlayer.Character.Humanoid.HipHeight = -1
        Module.Functions.PlayAnimation(3152378852, nil, true)
    else
        LocalPlayer.Character.Humanoid.HipHeight = 2.1
        Module.Functions.StopAnimation()
    end
end
end

Module.Functions.AntiHead = function(State)
if Module.Functions.Network(LocalPlayer) then
    if State then
        Module.Functions.PlayAnimation(3189777795, 0.1, false)
    else
        Module.Functions.StopAnimation()
    end
end
end

Module.Functions.IsVisible = function(OriginPart, Part)
if Module.Functions.Network(LocalPlayer) then
    local IgnoreList = {CurrentCamera, LocalPlayer.Character, OriginPart.Parent}
    local Parts = CurrentCamera:GetPartsObscuringTarget(
        {
            OriginPart.Position, 
            Part.Position
        },
        IgnoreList
    )

    for i, v in pairs(Parts) do
        if v.Transparency >= 0.3 then
            Module.Instance[#Module.Instance + 1] = v
        end

        if v.Material == Enum.Material.Glass then
            Module.Instance[#Module.Instance + 1] = v
        end
    end

    return #Parts == 0
end
return true
end

Module.Functions.NilBody = function()
if Module.Functions.Network(LocalPlayer) then
    for i, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Part") or v:IsA("MeshPart") then
            if v.Name ~= "HumanoidRootPart" then
                v:Destroy()
            end
        end
    end
end
end

Module.Functions.TableRemove = function(Data, Data2)
for i, v in pairs(Data) do
    if v == Data2 then
        Remove(Data, i)
    end
end
end

Module.Functions.GodFunc = function(Variable)
LocalPlayer.Character.RagdollConstraints:Destroy()
local Folder = Instance.new("Folder", LocalPlayer.Character)
Folder.Name = "FULLY_LOADED_CHAR"
wait()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
Variable = false
end

Module.Functions.Init = function()
for _, v in next, Players:GetPlayers() do
    if v ~= LocalPlayer and v:IsFriendsWith(LocalPlayer.UserId) then
        Insert(Settings.Whitelist.Friends, v.Name)
    end
end

Players.PlayerAdded:Connect(function(_Player)
    if _Player ~= LocalPlayer and _Player:IsFriendsWith(LocalPlayer.UserId) then
        Insert(Settings.Whitelist.Friends, _Player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(_Player)
    if _Player ~= LocalPlayer and _Player:IsFriendsWith(LocalPlayer.UserId) then
        Module.Functions.TableRemove(Settings.Whitelist.Friends, _Player.Name)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    Settings.God.IsStillAlive = false
    if LocalPlayer.Character:FindFirstChild("BodyEffects") then
        if Settings.God.GodBullet then
            Module.Functions.GodFunc(Settings.God.GodBullet)
            LocalPlayer.Character.BodyEffects.BreakingParts:Destroy()
        end
        if Settings.God.GodMelee then
            Module.Functions.GodFunc(Settings.God.GodMelee)
            Settings.God.IsStillAlive = true
            LocalPlayer.Character.BodyEffects.Armor:Destroy()
            LocalPlayer.Character.BodyEffects.Defense:Destroy()
        end
        if Settings.God.AntiRagdoll then
            Module.Functions.GodFunc(Settings.God.AntiRagdoll)
        end
    end
    wait(0.5)
    if Settings.AntiAim.Underground then
        Module.Functions.Underground(true)
    end
    wait(0.4)
    if Settings.AntiAim.UndergroundWallbang then
        Float = Instance.new("BodyVelocity")
        Float.Parent = LocalPlayer.Character.HumanoidRootPart
        Float.MaxForce = Vector3.new(100000, 100000, 100000)
        Float.Velocity = Vector3.new(0, 0, 0)
        wait(0.25)
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -11.5, 0)
        Module.Functions.Cham(LocalPlayer, true)
        Settings.AntiAim.UndergroundWallbang = true
    end
end)
end

Module.Functions.NearestMouse = function()
local Target = nil
local Distance = math.huge

for _, v in next, Players:GetPlayers() do
    if Module.Functions.Network(v) and v ~= LocalPlayer then
        local RootPosition, RootVisible = WorldToViewPortPoint(CurrentCamera, v.Character.HumanoidRootPart.Position)
        local NearestToMouse = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(RootPosition.X, RootPosition.Y)).magnitude
        if RootVisible and Distance > NearestToMouse then
            if (not Settings.Whitelist.FriendsWhitelist or not Find(Settings.Whitelist.Friends, v.Name)) and (not Settings.Whitelist.CrewEnabled or v:FindFirstChild("DataFolder") and v.DataFolder.Information:FindFirstChild("Crew") and not tonumber(v.DataFolder.Information.Crew.Value) == tonumber(LocalPlayer.DataFolder.Information.Crew.Value)) and (not Settings.Whitelist.Enabled or not Find(Settings.Whitelist.Players, v.Name)) then
                Target = v
                Distance = NearestToMouse
            end
        end
    end
end

return Target, Distance
end

Module.Functions.NearestRoot = function()
local Target = nil
local Distance = math.huge

for _, v in next, Players:GetPlayers() do
    if Module.Functions.Network(v) and Module.Functions.Network(LocalPlayer) and v ~= LocalPlayer then
        local NearestToRoot = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
        if Distance > NearestToRoot then
            if (not Settings.Whitelist.FriendsWhitelist or not Find(Settings.Whitelist.Friends, v.Name)) and (not Settings.Whitelist.CrewEnabled or v:FindFirstChild("DataFolder") and v.DataFolder.Information:FindFirstChild("Crew") and not tonumber(v.DataFolder.Information.Crew.Value) == tonumber(LocalPlayer.DataFolder.Information.Crew.Value)) and (not Settings.Whitelist.Enabled or not Find(Settings.Whitelist.Players, v.Name)) then
                Target = v
                Distance = NearestToRoot
            end
        end
    end
end

return Target, Distance
end

Module.Functions.TargetCheck = function(Data)
if Data == "Mouse" then
    return Module.Functions.NearestMouse()
elseif Data == "Distance" then
    return Module.Functions.NearestRoot()
end
end

Module.Functions.Invisible = function()
if Module.Functions.Network(LocalPlayer) then
    Module.OldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    wait(0.1)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 96995694596945934234234234, 0)
    wait(0.1)
    LocalPlayer.Character.LowerTorso.Root:Destroy()
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("MeshPart") and not table.find(Module.Ignores, v.Name) then
            v:Destroy()
        end
    end
    wait(0.1)
    LocalPlayer.Character.HumanoidRootPart.CFrame = Module.OldCFrame
end
end

Module.Functions.Jitter = function(Speed, Angle)
if Module.Functions.Network(LocalPlayer) then
    local Jit = Speed or math.random(30, 90)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, math.rad(Angle) + math.rad((math.random(1, 2) == 1 and Jit or -Jit)), 0) 
end
end

Module.Functions.Spin = function(Speed)
if Module.Functions.Network(LocalPlayer) then
    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Speed), 0)
end
end

Module.Functions.HttpGet = function(Data)
return loadstring(game:HttpGet(Data))()
end

local Library = Module.Functions.HttpGet("https://astolfo.top/scripts/library/cattoware-ui.lua")
local NotifyLibrary = Module.Functions.HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua")
local Notify = NotifyLibrary.Notify
Module.Functions.Init()

Library.theme.topheight = 50
--Library.theme.accentcolor = Color3.fromRGB(255, 105, 180)
--Library.theme.accentcolor2 = Color3.fromRGB(128, 23, 90)
Library.theme.fontsize = 15
Library.theme.titlesize = 17

if PuppywareSettings.Watermark == true then

Library:CreateWatermark("Puppy-Ware | {fps} | {game}")

end

local Window = Library:CreateWindow(Script.Name, Vector2.new(492, 598), Enum.KeyCode.RightShift)
local LegitTab = Window:CreateTab("Legit")
local AimbotSection = LegitTab:CreateSector("Aimbot", "left")

local AimbotToggle = AimbotSection:AddToggle('Enabled', false, function(State)
Settings.Aimbot.Enabled = State
end)

AimbotSection:AddToggle('Visible Check', false, function(State)
Settings.Aimbot.VisibleCheck = State
end)

AimbotSection:AddDropdown('Hitbox', {"Head", "HumanoidRootPart"}, "Head", false, function(Option)
Settings.Aimbot.Hitbox = Option
end)

AimbotSection:AddDropdown('Nearest', {"Mouse", "Distance"}, "Mouse", false, function(Option)
Settings.Aimbot.Nearest = Option
end)

local AimbotFOVSection = LegitTab:CreateSector("FOV", "left")

AimbotFOVSection:AddToggle('Enabled', false, function(State)
Settings.Aimbot.FOV.Enabled = State
end)

AimbotFOVSection:AddToggle('Filled', false, function(State)
Settings.Aimbot.FOV.Filled = State
end)

AimbotFOVSection:AddDropdown('Shape', {"Custom", "Octagon", "Circle"}, "Custom", false, function(Option)
Settings.Aimbot.FOV.Shape = Option
end)

AimbotFOVSection:AddSlider("Size", 25, 100, 500, 1, function(Value)
Settings.Aimbot.FOV.Size = Value
end)

AimbotFOVSection:AddSlider("Round", 2.5, 100, 500, 1, function(Value)
Settings.Aimbot.FOV.Round = Value
end)

AimbotFOVSection:AddSlider("Transparency", 0, 5, 10, 1, function(Value)
Settings.Aimbot.FOV.Transparency = tonumber("0." .. Value)
end)

AimbotFOVSection:AddColorpicker("Color", Settings.Aimbot.FOV.Color, function(Color)
Settings.Aimbot.FOV.Color = Color
end)

local TriggerbotSection = LegitTab:CreateSector("Triggerbot", "right")

TriggerbotSection:AddToggle('Enabled', Settings.Triggerbot.Enabled, function(State)
Settings.Triggerbot.Enabled = State
end)

local TValue = TriggerbotSection:AddToggle('Delay', Settings.Triggerbot.Delay.Enabled, function(State)
Settings.Triggerbot.Delay.Enabled = State
end)

TValue:AddSlider(1, Settings.Triggerbot.Delay.Value, 60, 1, function(Value)
Settings.Triggerbot.Delay.Value = Value
end)

local RageTab = Window:CreateTab("Rage")
local SilentAimSection = RageTab:CreateSector("Silent Aim", "left")

local SilentToggle = SilentAimSection:AddToggle('Silent Aim', false, function(State)
Settings.SilentAim.Enabled = State
end)

SilentAimSection:AddToggle('Wallbang (Beta)', false, function(State)
Settings.SilentAim.WallBang = State
end)


SilentAimSection:AddToggle('Ping Based Prediction',false,function(State)
Settings.Prediction_Settings.AutoSettings = State
end)

SilentAimSection:AddToggle('Visible Check', false, function(State)
Settings.SilentAim.VisibleCheck = State
end)

SilentAimSection:AddToggle('Ignore FOV', false, function(State)
Settings.SilentAim.IgnoreFOV = State
end)

SilentAimSection:AddToggle('Look At', false, function(State)
Settings.SilentAim.LookAt = State
end)

SilentAimSection:AddDropdown('Modes', {"Normal", "Insane"}, "Insane", false, function(Option)
Settings.SilentAim.Mode = Option
end)

SilentAimSection:AddDropdown('Hitbox', {"Head", "HumanoidRootPart"}, "Head", false, function(Option)
Settings.SilentAim.Hitbox = Option
end)

SilentAimSection:AddDropdown('Nearest', {"Mouse", "Distance"}, "Mouse", false, function(Option)
Settings.SilentAim.Nearest = Option
end)

local FOVSection = RageTab:CreateSector("FOV", "left")

FOVSection:AddToggle('Enabled', false, function(State)
Settings.SilentAim.FOV.Enabled = State
end)

FOVSection:AddToggle('Filled', false, function(State)
Settings.SilentAim.FOV.Filled = State
end)

FOVSection:AddDropdown('Shape', {"Custom", "Octagon", "Circle"}, "Custom", false, function(Option)
Settings.SilentAim.FOV.Shape = Option
end)

FOVSection:AddSlider("Size", 25, 100, 500, 1, function(Value)
Settings.SilentAim.FOV.Size = Value
end)

FOVSection:AddSlider("Round", 2.5, 100, 500, 1, function(Value)
Settings.SilentAim.FOV.Round = Value
end)

FOVSection:AddSlider("Transparency", 0, 5, 10, 1, function(Value)
Settings.SilentAim.FOV.Transparency = tonumber("0." .. Value)
end)

FOVSection:AddColorpicker("Color", Settings.SilentAim.FOV.Color, function(Color)
Settings.SilentAim.FOV.Color = Color
end)

local AntiAimSeciton = RageTab:CreateSector("Anti Aim", "right")

AntiAimSeciton:AddToggle('Enabled', false, function(State)
Settings.AntiAim.Enabled = State
end)

AntiAimSeciton:AddDropdown('Type', {"Spin", "Jitter"}, "Jitter", false, function(Option)
Settings.AntiAim.Type = Option
end)

AntiAimSeciton:AddSlider("Speed", 10, 50, 300, 1, function(Value)
Settings.AntiAim.Speed = Value
end)

AntiAimSeciton:AddSlider("Angle", 0, 180, 360, 1, function(Value)
Settings.AntiAim.Angle = Value
end)

AntiAimSeciton:AddToggle('Anti Point At', false, function(State)
Settings.AntiAim.AntiPointAt = State
end)

AntiAimSeciton:AddSlider("Anti Point At Distance", 2.5, 20, 100, 1, function(Value)
Settings.AntiAim.AntiPointAtDistance = Value
end)

AntiAimSeciton:AddToggle('Underground', false, function(State)
if State then
    Settings.AntiAim.Underground = true
    Module.Functions.Underground(true)
else
    Settings.AntiAim.Underground = false
    Module.Functions.Underground(false)
end
end)

local Undergroundwallbangtoggle = AntiAimSeciton:AddToggle('Underground Wallbang', Settings.AntiAim.UndergroundWallbang, function(State)
    pcall(function()
        if State then
			wait(0.5)
			Float = Instance.new("BodyVelocity")
			Float.Parent = LocalPlayer.Character.HumanoidRootPart
			Float.MaxForce = Vector3.new(100000, 100000, 100000)
			Float.Velocity = Vector3.new(0, 0, 0)
			wait(0.25)
			LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -11.5, 0)
			Module.Functions.Cham(LocalPlayer, true)
			Settings.AntiAim.UndergroundWallbang = true
		else
			LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 11.5, 0)
			Module.Functions.Cham(LocalPlayer, false)
			Float:Destroy()
			Settings.AntiAim.UndergroundWallbang = false
		end
    end)
end)

Undergroundwallbangtoggle:AddKeybind(Enum.KeyCode.X)

AntiAimSeciton:AddToggle('No Auto Rotate', false, function(State)
Settings.AntiAim.NoAutoRotate = State
end)

AntiAimSeciton:AddButton('Invisible', function(State)
Module.Functions.Invisible()
end)

AntiAimSeciton:AddButton('Nil Body', function(State)
Module.Functions.NilBody()
end)

local WhitelistSection = RageTab:CreateSector("Settings", "right")

WhitelistSection:AddTextbox("Player Username", nil, function(Text)
if Text ~= nil and Module.Functions.Find(Text) ~= nil and Players:FindFirstChild(Module.Functions.Find(Text)) then
    Settings.Whitelist.Holder = Module.Functions.Find(Text)
else
    Notify({
        Title = Script.Name,
        Description = "Player is not found.",
        Duration = 3
    })
end
end)

WhitelistSection:AddButton('Add Whitelist', function(State)
if Settings.Whitelist.Holder ~= nil and Players:FindFirstChild(Settings.Whitelist.Holder) then
    if Find(Settings.Whitelist.Players, Settings.Whitelist.Holder) then
        Notify({
            Title = Script.Name,
            Description = Settings.Whitelist.Holder .. " is whitelisted.",
            Duration = 3
        })
    else
        Insert(Settings.Whitelist.Players, Settings.Whitelist.Holder)
        Notify({
            Title = Script.Name,
            Description = "Whitelisted " .. Settings.Whitelist.Holder,
            Duration = 3
        })
    end
else
    Notify({
        Title = Script.Name,
        Description = "Player is not found.",
        Duration = 3
    })
end
end)

WhitelistSection:AddButton('Remove Whitelist', function()
if Settings.Whitelist.Holder ~= nil and Players:FindFirstChild(Settings.Whitelist.Holder) then
    if Find(Settings.Whitelist.Players, Settings.Whitelist.Holder) then
        Module.Functions.TableRemove(Settings.Whitelist.Players, Settings.Whitelist.Holder)
        Notify({
            Title = Script.Name,
            Description = "Removed " .. Settings.Whitelist.Holder,
            Duration = 5
        })
    else
        Notify({
            Title = Script.Name,
            Description = Settings.Whitelist.Holder .. " is not whitelisted.",
            Duration = 5
        })
    end
else
    Notify({
        Title = Script.Name,
        Description = "Player is not found.",
        Duration = 3
    })
end
end)

WhitelistSection:AddToggle('Whitelist Enabled', false, function(State)
Settings.Whitelist.Enabled = State
end)

WhitelistSection:AddToggle('Crew Whitelist', false, function(State)
Settings.Whitelist.CrewEnabled = State
end)

WhitelistSection:AddToggle('Friends Whitelist', false, function(State)
Settings.Whitelist.FriendsWhitelist = State
end)

local MiscTab = Window:CreateTab("Misc")
local ServerSection = MiscTab:CreateSector("Server Crasher", "left")

ServerSection:AddToggle('Enabled', false, function(State)
if State then
    Module.Functions.Invisible()
end
Settings.ServerCrash.Enabled = State
end)

local CrashPercent = ServerSection:AddLabel('Percent : 0%')

local KillSaySection = MiscTab:CreateSector("Kill Say", "right")

KillSaySection:AddDropdown('Method', {"After Dead", "Before Dead"}, "After Dead", false, function(Option)
Settings.KillSay.Type = Option
end)

KillSaySection:AddToggle('Enabled', false, function(State)
Settings.KillSay.Enabled = State
end)

KillSaySection:AddToggle('Custom Message', false, function(State)
Settings.KillSay.CustomMessage = State
end)

KillSaySection:AddTextbox("Custom Message Text", "@s is tapped!", function(Text)
Settings.KillSay.CustomMessageText = Text
end)

local MovementSection = MiscTab:CreateSector("Movement", "right")

MovementSection:AddDropdown('Method', {"Render", "Heartbeat"}, "Render", false, function(Option)
Settings.Movement.Type = Option
end)

MovementSection:AddToggle('CFrame Speed Enabled', false, function(State)
Settings.Movement.CFrameSpeed = State
end)

local GodSection = MiscTab:CreateSector("God", "left")

GodSection:AddButton('God Block', function(State)
pcall(function()
    LocalPlayer.Character.BodyEffects.Defense.CurrentTimeBlock:Destroy()
end)
end)

GodSection:AddButton('God Bullet', function(State)
Settings.God.GodBullet = State
Module.Functions.NilBody()
end)

GodSection:AddButton('God Melee', function(State)
Settings.God.GodMelee = State
Module.Functions.NilBody()
end)

GodSection:AddButton('Anti Ragdoll', function(State)
Settings.God.AntiRagdoll = State
Module.Functions.NilBody()
end)

local TargetTab = Window:CreateTab("Target")
local MainSection = TargetTab:CreateSector("Main", "left")

MainSection:AddToggle('Enabled', false, function(State)
Settings.Target.Enabled = State
end)

MainSection:AddToggle('Wall Check', false, function(State)
Settings.Target.WallCheck = State
end)

if not PuppywareSettings.PerformanceMode then
local ESPLibrary = Module.Functions.HttpGet("https://gist.githubusercontent.com/VaultGitos/5a937cdc7a753160232d86dcc3ce79a6/raw/99cce502c74b1574abfd8d79d36da3c8aa3be83d/ESP.lua")
local VisualsTab = Window:CreateTab("Visuals")
local ESPSection = VisualsTab:CreateSector("ESP", "left")

local BoxToggle = ESPSection:AddToggle('Boxes', false, function(State)
    ESPLibrary.Boxes = State
end)

BoxToggle:AddColorpicker(Color3.fromRGB(255, 255, 255), function(Color)
    ESPLibrary.BoxesColor = Color
end)

local NameToggle = ESPSection:AddToggle('Name', false, function(State)
    ESPLibrary.Names = State
end)

NameToggle:AddColorpicker(Color3.fromRGB(255, 255, 255), function(Color)
    ESPLibrary.NamesColor = Color
end)

local DistanceToggle = ESPSection:AddToggle('Distance', false, function(State)
    ESPLibrary.Distance = State
end)

DistanceToggle:AddColorpicker(Color3.fromRGB(255, 255, 255), function(Color)
    ESPLibrary.DistanceColor = Color
end)

local ChamToggle = ESPSection:AddToggle('Chams', false, function(State)
    ESPLibrary.Cham = State
end)

ESPSection:AddColorpicker("Cham Color 1", Color3.fromRGB(255, 255, 255), function(Color)
    ESPLibrary.ChamColor1 = Color
end)

ESPSection:AddColorpicker("Cham Color 2", Color3.fromRGB(255, 255, 255), function(Color)
    ESPLibrary.ChamColor2 = Color
end)
end

game:GetService("Workspace").Players.ChildRemoved:Connect(function(PlayerThatIsGone)
if PlayerThatIsGone.Name == Settings.KillSay.OldPlayer and Settings.KillSay.Type == "After Dead" then
    if Settings.KillSay.CustomMessage then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.KillSay.CustomMessageText:gsub("@s", Settings.KillSay.OldPlayer), "All")
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.KillSay.Message[math.random(1, 4)]:gsub("@s", Settings.KillSay.OldPlayer), "All")
    end
end
end)

UserInputService.InputBegan:Connect(function(Key, Break)
if Key.UserInputType == InputType.MouseButton2 and not Break then
    Settings.Aimbot.Aiming = true
end
if Key.UserInputType == InputType.MouseButton1 and not Break then
    if Module.Functions.Network(LocalPlayer) then
        if LocalPlayer.Character:FindFirstChildOfClass("Tool") and LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Ammo") and LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Ammo").Value ~= 0 then
            Settings.KillSay.OldPlayer = Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Name
            Settings.KillSay.Cooldown = true
            spawn(function()
                wait(1)
                Settings.KillSay.Cooldown = false
            end)
        end
    end
    if Settings.SilentAim.Enabled and Settings.SilentAim.WallBang and Module.Functions.Network(LocalPlayer) then
        if not Module.Functions.IsVisible(Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart) and LocalPlayer.Character:FindFirstChildOfClass("Tool") and LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Ammo") and LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Ammo").Value ~= 0 then
            if LocalPlayer.Character.RightHand:FindFirstChild("RightWrist") then
                LocalPlayer.Character.RightHand:FindFirstChild("RightWrist"):Destroy()
            end
            wait(0.1)
            LocalPlayer.Character.Humanoid:ChangeState(11)
            LocalPlayer.Character.RightHand.CFrame = Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
        end
    end
end
if Key.KeyCode == Enum.KeyCode[Settings.Target.Bind] and not Break then
    if Settings.Target.Enabled then
        if Module.Functions.IsVisible(Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart) then
            Settings.Target.TargetUser = Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Name
            Notify({
                Title = Script.Name .. " " .. Script.Version,
                Description = "Targetted " .. Module.Functions.TargetCheck(Settings.SilentAim.Nearest).Name .. " (" .. Module.Functions.TargetCheck(Settings.SilentAim.Nearest).DisplayName .. ")",
                Duration = 3
            })
        end
    end
end
end)

UserInputService.InputEnded:Connect(function(Key, Break)
if Key.UserInputType == InputType.MouseButton2 and not Break then
    Settings.Aimbot.Aiming = false
end
if Key.UserInputType == InputType.MouseButton1 and not Break then
    if Module.Functions.Network(LocalPlayer) then
        --[[
            local GRightWrist = Instance.new("Motor6D", LocalPlayer.Character.RightHand)
            GRightWrist.C0 = CFrame.new(1.18422506e-07, -0.5009287, -6.81715525e-18, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            GRightWrist.C1 = CFrame.new(3.55267503e-07, 0.125045404, 5.92112528e-08, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            GRightWrist.CurrentAngle = 0
            GRightWrist.Name = "RightWrist"
            GRightWrist.Part0 = LocalPlayer.Character.RightLowerArm
            GRightWrist.Part1 = LocalPlayer.Character.RightHand
        ]]
        wait(0.75)
        LocalPlayer.Character.RightHand.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
    end
end
end)

local __Index;
__Index = hookmetamethod(game, "__index", function(t, k)
if t == Mouse and (tostring(k) == "Hit" or tostring(k) == "Target") then
    if Settings.Target.Enabled then
        if Settings.Target.TargetUser ~= nil then
            if Players:FindFirstChild(Settings.Target.TargetUser) ~= nil and Module.Functions.Network(Players[Settings.Target.TargetUser]) then
                if (not Settings.Target.WallCheck or Module.Functions.IsVisible(Players[Settings.Target.TargetUser].Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart)) then
                    local TargetBody
                    if Players[Settings.Target.TargetUser].Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        TargetBody = Players[Settings.Target.TargetUser].Character.LeftFoot
                    else
                        TargetBody = Players[Settings.Target.TargetUser].Character[Settings.SilentAim.Hitbox]
                    end
                    local Prediction = TargetBody.CFrame + (TargetBody.Velocity * Settings.Prediction_Settings.Prediction)

                    return (tostring(k) == "Hit" and Prediction or tostring(k) == "Target" and TargetBody)
                end
            end
        end
    else
        if Settings.SilentAim.Enabled then
            local NearestTarget, NearestPos = Module.Functions.TargetCheck(Settings.SilentAim.Nearest)
            if NearestTarget and (not Settings.SilentAim.VisibleCheck or Module.Functions.IsVisible(NearestTarget.Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart)) and (not Settings.SilentAim.FOV.Enabled or Settings.SilentAim.FOV.Size > NearestPos) then
                local TargetBody
                if NearestTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Settings.SilentAim.Mode == "Insane" then
                    TargetBody = NearestTarget.Character.LeftFoot
                else
                    TargetBody = NearestTarget.Character[Settings.SilentAim.Hitbox]
                end

                local Prediction 
                if Settings.Prediction_Settings.AutoSettings then
                    Prediction = TargetBody.CFrame + (TargetBody.Velocity * Settings.Prediction_Settings.Prediction)
                else
                    Prediction = TargetBody.CFrame + (TargetBody.Velocity * 0.165)
                end

                return (tostring(k) == "Hit" and Prediction or tostring(k) == "Target" and TargetBody)
            end
        end
    end
end

return __Index(t, k)
end)

local __Namecall;
__Namecall = hookmetamethod(game, "__namecall", function(self, ...)
local Args = {...}
local Method = getnamecallmethod()

if tostring(self.Name) == "MainEvent" and tostring(Method) == "FireServer" then
    if Args[1] == "TeleportDetect" or Args[1] == "CHECKER_1" or Args[1] == "OneMoreTime" then
        return
    end
end

return __Namecall(self, ...)
end)

if not Module.DrawingInstance["FOV"] then
Module.DrawingInstance["FOV"] = Module.Drawing.Circle(1)
end

if not Module.DrawingInstance["FOV2"] then
Module.DrawingInstance["FOV2"] = Module.Drawing.Circle(1)
end

RunService.RenderStepped:Connect(function()
if Settings.Prediction_Settings.AutoSettings then
    local PingStats = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(PingStats)
    local PingValue = Value:split(" ")
    local PingNumber = tonumber(PingValue[1])

        Settings.Prediction_Settings.Prediction = PingNumber / 1000 + 0.037
end

if Settings.Aimbot.Enabled and Settings.Aimbot.Aiming then
    local NearestTarget, NearestPos = Module.Functions.TargetCheck(Settings.Aimbot.Nearest)
    if NearestTarget and (not Settings.Aimbot.VisibleCheck or Module.Functions.IsVisible(NearestTarget.Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart)) and (not Settings.Aimbot.FOV.Enabled or Settings.Aimbot.FOV.Size > NearestPos) then
        local Prediction = NearestTarget.Character[Settings.Aimbot.Hitbox].CFrame + (NearestTarget.Character[Settings.Aimbot.Hitbox].Velocity * Settings.Prediction_Settings.Prediction)
        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Prediction.Position)
    end
end

if Settings.SilentAim.FOV.Enabled then
    Module.DrawingInstance["FOV"].Visible = true
    Module.DrawingInstance["FOV"].Radius = Settings.SilentAim.FOV.Size
    Module.DrawingInstance["FOV"].Transparency = Settings.SilentAim.FOV.Transparency
    Module.DrawingInstance["FOV"].Filled = Settings.SilentAim.FOV.Filled
    if Settings.SilentAim.FOV.Shape == "Custom" then
        Module.DrawingInstance["FOV"].NumSides = Settings.SilentAim.FOV.Round
    elseif Settings.SilentAim.FOV.Shape == "Octagon" then
        Module.DrawingInstance["FOV"].NumSides = 12.5
    else 
        Module.DrawingInstance["FOV"].NumSides = 100
    end
    Module.DrawingInstance["FOV"].Color = Settings.SilentAim.FOV.Color
    Module.DrawingInstance["FOV"].Position = Vector2.new(Mouse.X, Mouse.Y + GuiInset.Y)
else
    Module.DrawingInstance["FOV"].Visible = false
end

if Settings.Aimbot.FOV.Enabled then
    Module.DrawingInstance["FOV2"].Visible = true
    Module.DrawingInstance["FOV2"].Radius = Settings.Aimbot.FOV.Size
    Module.DrawingInstance["FOV2"].Transparency = Settings.Aimbot.FOV.Transparency
    Module.DrawingInstance["FOV2"].Filled = Settings.Aimbot.FOV.Filled
    if Settings.Aimbot.FOV.Shape == "Custom" then
        Module.DrawingInstance["FOV2"].NumSides = Settings.Aimbot.FOV.Round
    elseif Settings.Aimbot.FOV.Shape == "Octagon" then
        Module.DrawingInstance["FOV2"].NumSides = 12.5
    else 
        Module.DrawingInstance["FOV"].NumSides = 100
    end
    Module.DrawingInstance["FOV2"].Color = Settings.Aimbot.FOV.Color
    Module.DrawingInstance["FOV2"].Position = Vector2.new(Mouse.X, Mouse.Y + GuiInset.Y)
else
    Module.DrawingInstance["FOV2"].Visible = false
end

if Module.Functions.Network(LocalPlayer) then
    local Char = LocalPlayer.Character
    local Root = Char.HumanoidRootPart
    local Hum = Char.Humanoid

    if Settings.ServerCrash.Enabled then
        Hum:ChangeState(11)
    end

    if Settings.Movement.CFrameSpeed then
        if Settings.Movement.Type == "Render" then
            if Hum.MoveDirection.Magnitude > 0 then
                Char:TranslateBy(Hum.MoveDirection)
            end
        end
    end
end
end)

loadstring[[
game:GetService("RunService").Stepped:Connect(function() --// The broken part
    if Settings.AntiAim.UndergroundWallbang then
        for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)
]]

RunService.Heartbeat:Connect(function()
if Module.Functions.Network(LocalPlayer) then
    local Char = LocalPlayer.Character
    local Root = Char.HumanoidRootPart
    local Hum = Char.Humanoid

    if Settings.Movement.CFrameSpeed then
        if Settings.Movement.Type == "Heartbeat" then
            if Hum.MoveDirection.Magnitude > 0 then
                Char:TranslateBy(Hum.MoveDirection)
            end
        end
    end

    if Settings.SilentAim.LookAt then
        local PrimaryPartOfChar = Char.PrimaryPart
        local NearestMouse, NearestPos = Module.Functions.TargetCheck(Settings.SilentAim.Nearest)
        if Module.Functions.Network(NearestMouse) then
            if (not Settings.SilentAim.VisibleCheck or Module.Functions.IsVisible(NearestMouse.Character.HumanoidRootPart, LocalPlayer.Character.HumanoidRootPart)) and (not Settings.SilentAim.FOV.Enabled or Settings.SilentAim.FOV.Size > NearestPos) then
                local NearestChar = NearestMouse.Character
                local NearestRoot = NearestChar.HumanoidRootPart
                local NearestPos = CFrame.new(PrimaryPartOfChar.Position, Vector3.new(NearestRoot.Position.X, NearestRoot.Position.Y, NearestRoot.Position.Z))
                Char:SetPrimaryPartCFrame(NearestPos)
            end
        end
    end

    if Settings.AntiAim.NoAutoRotate then
        Hum.AutoRotate = false
    else
        Hum.AutoRotate = true
    end

    if Settings.AntiAim.AntiPointAt then
        for i, v in next, Players:GetPlayers() do
            if v ~= LocalPlayer and Module.Functions.Network(v) and Module.Functions.Network(LocalPlayer) then
                local BodyEffects = v.Character:FindFirstChild("BodyEffects")
                local MousePos = BodyEffects:FindFirstChild("MousePos")
                if BodyEffects ~= nil and MousePos ~= nil then
                    local EnemyMouseMagnitude = (LocalPlayer.Character.HumanoidRootPart.Position - MousePos.Value).Magnitude
                    if Settings.AntiAim.AntiPointAtDistance > EnemyMouseMagnitude then
                        Root.CFrame = Root.CFrame * CFrame.new(math.random(1, 2) == 1 and 2 or -2, 0, 0)
                    end
                end
            end
        end
    end

    if Settings.AntiAim.UndergroundWallbang then
        Hum:ChangeState(11)
    end

    if Settings.AntiAim.Enabled then
        if Settings.AntiAim.Type == "Jitter" then
            Module.Functions.Jitter(Settings.AntiAim.Speed, Settings.AntiAim.Angle)
        else
            Module.Functions.Spin(Settings.AntiAim.Speed)
        end
    end
end
end)

while wait() do
if Module.Functions.Network(LocalPlayer) then
    local Char = LocalPlayer.Character
    local Root = Char.HumanoidRootPart
    local Hum = Char.Humanoid

    if Settings.Triggerbot.Enabled then
        for i, v in next, Players:GetPlayers() do 
            if Module.Functions.Network(v) then 
                if Mouse.Target:IsDescendantOf(v.Character) then 
                    mouse1press()
                    wait()
                    mouse1release()
                    if Settings.Triggerbot.Delay.Enabled then
                        wait(Settings.Triggerbot.Delay.Value)
                    end
                end 
            end
        end
    end

    if Settings.KillSay.Type == "Before Dead" and Settings.KillSay.OldPlayer ~= nil then
        if Players[Settings.KillSay.OldPlayer].Character.BodyEffects.Dead then
            if Settings.KillSay.CustomMessage then
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.KillSay.CustomMessageText:gsub("@s", Settings.KillSay.OldPlayer), "All")
            else
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.KillSay.Message[math.random(1, 4)]:gsub("@s", Settings.KillSay.OldPlayer), "All")
            end
        end
    end

    if Settings.ServerCrash.Enabled then
        Root.CFrame = workspace.Ignored.Shop["[Cranberry] - $3"].Head.CFrame * CFrame.new(0, -7, 0)
        fireclickdetector(workspace.Ignored.Shop["[Cranberry] - $3"].ClickDetector)
        fireclickdetector(workspace.Ignored.Shop["[Cranberry] - $3"].ClickDetector)
        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v.Name == tostring("[Cranberry]") then
                v.Parent = LocalPlayer.Character
                Settings.ServerCrash.Value = Settings.ServerCrash.Value + 1
                CrashPercent:Set("Percent : " .. tostring(Settings.ServerCrash.Value * 100 / 500) .. "%" .. " / " .. "100%")
                if Settings.ServerCrash.Value == 500 then
                    Module.Functions.NilBody()
                end
            end
        end
    end
end
end

while wait(3) do
if Settings.KillSay.Cooldown then
    Settings.KillSay.OldPlayer = ""
end
end