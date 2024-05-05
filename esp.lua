
--[[
    Monolith | ESP Module
]]
local customFont = Drawing.new("Font", "Tahoma")
customFont.Data = game:HttpGet("https://cdn.discordapp.com/attachments/1223357077041320067/1235641227639128175/Tahoma.ttf?ex=66391091&is=6637bf11&hm=faa4d7011699ec11d1098b8701729661de06aa6f6a6f86eb0c38ae0305912122&")



local Path = 
	"https://raw.githubusercontent.com/archives11/assets/main/"
local images = {
    ["[Phone]"] = game:HttpGet(Path.. "[Phone].png"),
    ["Combat"] = game:HttpGet(Path.. "Combat.png"),
    ["Wallet"] = game:HttpGet(Path.. "Wallet.png"),
	["[AK47]"] = game:HttpGet(Path.. "ak.png"),
	["[AR]"] = game:HttpGet(Path.. "ar.png"),
	["[AUG]"] = game:HttpGet(Path.. "aug.png"),
	["[Double-Barrel SG]"] = game:HttpGet(Path.. "db.png"),
	["[DrumGun]"] = game:HttpGet(Path.. "drumgun.png"),
	["[Flamethrower]"] = game:HttpGet(Path.. "flame.png"),
	["[Glock]"] = game:HttpGet(Path.. "glock.png"),
	["[LMG]"] = game:HttpGet(Path.. "lmg.png"),
	["[P90]"]= game:HttpGet(Path.. "p90.png"),
    ["[RPG]"]= game:HttpGet(Path.. "rpg.png"),
	["[Revolver]"] = game:HttpGet(Path.. "rev.png"),
	["[SMG]"] = game:HttpGet(Path.. "smg.png"),
	["[Shotgun]"] = game:HttpGet(Path.. "shotgun.png"),
	["[SilencerAR]"] = game:HttpGet(Path.. "ar.png"),
	["[TacticalShotgun]"] = game:HttpGet(Path.. "tac.png"),
	["[Knife]"] = game:HttpGet(Path.. "knife.png"),
	["[Rifle]"] = game:HttpGet(Path.. "rifle.png")
} 




-- // Tables
local Monolith, Visuals, Color, Math = {
    Safe = false,
    Connections = {},
}, {
    Drawings = {},
    Bases = {},
    Base = {}
}, {
}, {}

-- // Services
local RunService, Workspace, Lighting, Players = game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("Players") 

-- // Locals
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Optimization Variables
local Find, Clear, Insert, Remove = table.find, table.clear, table.insert, table.remove
local Huge, Pi, Clamp, Ceil, Round, Abs, Floor, Random, Cos, Acos = math.huge, math.pi, math.clamp, math.ceil, math.round, math.abs, math.floor, math.random, math.cos, math.acos
local NewVector2, NewVector3, NewCFrame = Vector2.new, Vector3.new, CFrame.new
local NewRGB, NewHex = Color3.fromRGB, Color3.fromHex
local Spawn, Wait = task.spawn, task.wait
local Create, Resume = coroutine.create, coroutine.resume
local Sub, Lower, Upper = string.sub, string.lower, string.upper

local Settings = {
    Enabled = true,
    MaxDistance = 250,
    FadeTime = 2,
    TextCase = "Normal", -- {"UPPERCASE", "Normal", "lowercase"}
    TextLength = 24,
    Box = {false, "Corner", NewHex("#ff006a"), NewHex("#000000")},
    BoxFill = {false, NewHex("#000000"), 0.6},
    Name = {true, NewHex("#ffffff")},
    HealthBar = {true, NewHex("#09ff00"), NewHex("#ff0000")},
    HealthNumber = {true},
    ArmorBar = {false, NewHex("#3492eb"), NewHex("#29fff4")},
    ArmorNumber = {false},
    Weapon = {true, NewHex("#ffffff")},
    WeaponIcon = {true, NewHex("#ffffff")},
    --Distance = {true, NewHex("#ffffff")},
    Flag = {true, NewHex("#e1e1e1")},
    Distance = {true},
    Knocked = {true},
    Moving = {true},
    Jumping = {true},
    Desynced = {true},
    Swimming = {true},
    Reload = {true} -- Tells when player is reloading weapon

}

do -- // Color
    function Color:Lerp(Value, MinColor, MaxColor)
        if Value <= 0 then return MaxColor end
        if Value >= 100 then return MinColor end
        --
        return Color3.new(
            MaxColor.R + (MinColor.R - MaxColor.R) * Value,
            MaxColor.G + (MinColor.G - MaxColor.G) * Value,
            MaxColor.B + (MinColor.B - MaxColor.B) * Value
        )
    end
end
--
do -- // Math
    function Math:RoundVector(Vector)
        return NewVector2(Round(Vector.X), Round(Vector.Y))
    end
    --
    function Math:Shift(Number)
        return Acos(Cos(Number * Pi)) / Pi
    end
    --
    function Math:Random(Number)
        return Random(-Number, Number)
    end
    --
    function Math:RandomVec3(X, Y, Z)
        return NewVector3(Math:Random(X), Math:Random(Y), Math:Random(Z))
    end
end
--
do -- // Monolith
    function Monolith:ThreadFunction(Func, Name, ...)
        local Func = Name and function()
            local Passed, Statement = pcall(Func)
            --
            if not Passed and not Monolith.Safe then
                warn("Monolith:\n", "              " .. Name .. ":", Statement)
            end
        end or Func
        local Thread = Create(Func)
        --
        Resume(Thread, ...)
        return Thread
    end
    --
    function Monolith:Connection(Type, Callback)
        local Connection = Type:Connect(Callback)
        Monolith.Connections[#Monolith.Connections + 1] = Connection
        --
        return Connection
    end
    --
    function Monolith:GetBodyParts(Character, RootPart, Indexes, Hitboxes)
        local Parts = {}
        local Hitboxes = Hitboxes or {"Head", "Torso", "Arms", "Legs"}
        --
        for Index, Part in pairs(Character:GetChildren()) do
            if Part:IsA("BasePart") and Part ~= RootPart then
                if Find(Hitboxes, "Head") and Part.Name:lower():find("head") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Torso") and Part.Name:lower():find("torso") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Arms") and Part.Name:lower():find("arm") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif Find(Hitboxes, "Legs") and Part.Name:lower():find("leg") then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                elseif (Find(Hitboxes, "Arms") and Part.Name:lower():find("hand")) or (Find(Hitboxes, "Legs ") and Part.Name:lower():find("foot")) then
                    Parts[Indexes and Part.Name or #Parts + 1] = Part
                end
            end
        end
        --
        return Parts
    end
    --
    function Monolith:GetPlayerParent(Player)
        return Player.Parent
    end
    --
    function Monolith:GetCharacter(Player)
        return Player.Character
    end
    --
    function Monolith:GetHumanoid(Player, Character)
        return Character:FindFirstChildOfClass("Humanoid")
    end
    --
    function Monolith:GetRootPart(Player, Character, Humanoid)
        return Humanoid.RootPart
    end
    --
    function Monolith:GetHealth(Player, Character, Humanoid)
        if Humanoid then
            return Clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
        end
    end
    --
    function Monolith:ValidateClient(Player)
        local Object = Monolith:GetCharacter(Player)
        local Humanoid = (Object and Monolith:GetHumanoid(Player, Object))
        local RootPart = (Humanoid and Monolith:GetRootPart(Player, Object, Humanoid))
        --
        return Object, Humanoid, RootPart
    end
    --
    function Monolith:ClientAlive(Player, Character, Humanoid)
        local Health, MaxHealth = Monolith:GetHealth(Player, Character, Humanoid)
        --
        return (Health > 0)
    end
    --
    function Monolith:ClampString(String, Length, Font)
        local Font = (Font or customFont)
        local Split = String:split("\n")
        --
        local Clamped = ""
        --
        for Index, Value2 in pairs(Split) do
            if (Index * 13) <= Length then
                Clamped = Clamped .. Value2 .. (Index == #Split and "" or "\n")
            end
        end
        --
        return (Clamped ~= String and (Clamped == "" and "" or Clamped:sub(0, #Clamped - 1) .. " ...") or Clamped)
    end
end
--
do -- // Visuals
    function Visuals:Draw(Type, Properties)
        local Drawing = Drawing.new(Type)
        --
        for Property, Value in pairs(Properties) do
            Drawing[Property] = Value
        end
        --
        Insert(Visuals.Drawings, Drawing)
        return Drawing
    end
    --
    function Visuals:FormatString(String)
        local Case = Settings["TextCase"]
        local Length = Settings["TextLength"]
        --
        if Case == "lowercase" then
           return Lower(Sub(String, 1, Length))
        elseif Case == "UPPERCASE" then
            return Upper(Sub(String, 1, Length))
        else
            return Sub(String, 1, Length)
        end
    end
    --
    function Visuals:Create(Properties)
        if Properties then
            if Properties.Player then
                local Self = setmetatable({
                    Player = Properties.Player,
                    Info = {
                        Tick = tick(),
                        gunTick = tick()
                    },
                    Renders = {
                        Weapon = Visuals:Draw("Text", {Text = "Weapon", Visible = false, Size = 13, Center = true, Color = NewHex("#ffffff"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                       -- Distance = Visuals:Draw("Text", {Text = "Distance", Visible = false, Size = 13, Center = true, Color = NewHex("#ffffff"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                        HealthBarOutline = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = true, Color = NewHex("#000000")}),
                        HealthBarInline = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = true, Color = NewHex("#09ff00")}),
                        HealthBarValue = Visuals:Draw("Text", {Text = "100", Visible = false, Size = 13, Center = true, Color = NewHex("#09ff00"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                        ArmorBarOutline = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = true, Color = NewHex("#000000")}),
                        ArmorBar = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = true, Color = NewHex("#09ff00")}),
                        ArmorBarText = Visuals:Draw("Text", {Text = "100", Visible = false, Size = 13, Center = true, Color = NewHex("#09ff00"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                        BoxFill = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = true, Color = NewHex("#000000")}),
                        BoxOutline = Visuals:Draw("Square", {Thickness = 2, Visible = false, Filled = false, Color = NewHex("#000000")}),
                        BoxInline = Visuals:Draw("Square", {Thickness = 1, Visible = false, Filled = false, Color = NewHex("#C30B00")}),
                        Name = Visuals:Draw("Text", {Text = "Name", Visible = false, Size = 13, Center = true, Color = NewHex("#ffffff"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                        Flag = Visuals:Draw("Text", {Text = "Flag", Visible = false, Size = 13, Center = false, Color = NewHex("#ffffff"), Outline = true, OutlineColor = NewHex("#000000"), Font = customFont}),
                        GunIcon = Visuals:Draw("Image", {Data = "", Transparency = 1, Visible = false, Size = NewVector2(129,55)}),

                        Corners = {}
                    }
                }, {__index = Visuals.Base})
                --
                do -- // Corner Boxes
                    for Index = 9, 16 do
                        Self.Renders.Corners[Index] = Visuals:Draw("Line", {Thickness = 3, Color = NewHex("#000000")})
                    end
                    --
                    for Index = 1, 8 do
                        Self.Renders.Corners[Index] = Visuals:Draw("Line", {Thickness = 0, Color = NewHex("#1A66FF")})
                    end
                end
                --
                Visuals.Bases[Properties.Player] = Self
                --
                return Self
            end
        end
    end
    --
    function Visuals.Base:Opacity(State)
        local Self = self
        --
        if Self then
            local Renders = rawget(Self, "Renders")
            --
            for Index, Drawing in pairs(Renders) do
                if Index ~= "Corners" then
                    Drawing.Visible = State -- what
                end
            end
            --
            for Index = 1, 16 do
                Self.Renders.Corners[Index].Visible = State
            end
            --
            if not State then
                Self.Info.RootPosition = nil
                Self.Info.Health = nil
                Self.Info.MaxHealth = nil
            end
        end
    end
    --
    function Visuals.Base:Remove()
        local Self = self
        --
        if Self then
            setmetatable(Self, {})
            --
            Visuals.Bases[Self.Player] = nil
            --
            Self.Object = nil
            --
            for Index, Drawing in pairs(Self.Renders) do
                if Index ~= "Corners" then
                    Drawing:Remove()
                end
            end
            --
            for Index = 1, 16 do
                Self.Renders.Corners[Index]:Remove()
            end
            --
            Self.Renders = nil
            Self = nil
        end
    end
    --
    function Visuals.Base:Update()
        local Self = self
        --
        if Self then
            local Renders = rawget(Self, "Renders")
            local Player = rawget(Self, "Player")
            local Info = rawget(Self, "Info")
            local Parent = Monolith:GetPlayerParent(Player)
            --
            if (Player and Parent and Parent ~= nil) or (Info.RootPosition and Info.Health and Info.MaxHealth) then
                if (Settings.Enabled == true) then
                    local Object, Humanoid, RootPart = Monolith:ValidateClient(Player)
                    local BodyParts = (RootPart and Monolith:GetBodyParts(Object, RootPart, true))
                    local TransparencyMultplier = 1
                    --
                    if Object and Object.Parent and (Humanoid and RootPart and BodyParts) then
                        local Health, MaxHealth = Monolith:GetHealth(Player, Object, Humanoid)
                        --
                        if Health > 0 then
                            Info.Pass = true
                            Info.RootPosition = RootPart.Position
                            Info.Health = Health
                            Info.MaxHealth = MaxHealth
                            Info.ArmorValue = Object:FindFirstChild("BodyEffects") and Object["BodyEffects"]:FindFirstChild("Armor") and Object["BodyEffects"]:FindFirstChild("Armor").Value

                            Info.ToolHeld =  (Object:FindFirstChildOfClass("Tool") and Object:FindFirstChildOfClass("Tool").Name) or "None"
                        else
                            Info.Pass = false
                        end
                    else
                        Info.Pass = false
                    end
                    --
                    if Info.Pass then
                        Info.Tick = tick()
                    else
                        local FadeTime = (250 / ((Settings.FadeTime) * 100))
                        local Value = Info.Tick - tick()
                        --
                        if Value <= FadeTime then
                            TransparencyMultplier = Clamp((Value + FadeTime) * 1 / FadeTime, 0, 1)
                        else
                            Info.RootPosition = nil
                            Info.Health = nil
                            Info.MaxHealth = nil
                        end
                    end
                    --
                    if Info.RootPosition and Info.Health and Info.MaxHealth then
                        local DistanceToPlayer = (Camera.CFrame.Position - Info.RootPosition).Magnitude
                        local Position, OnScreen = Camera:WorldToViewportPoint(Info.RootPosition)
                        --
                        local Size, BoxSize, BoxPosition, BoxCenter, TL, BL, TR, BR
                        --
                        if OnScreen then
                            local MaxDistance = tonumber(Settings.MaxDistance)
                            --
                            if DistanceToPlayer <= MaxDistance then
                                Size = (Camera:WorldToViewportPoint(Info.RootPosition - NewVector3(0, 3, 0)).Y - Camera:WorldToViewportPoint(Info.RootPosition + NewVector3(0, 2.6, 0)).Y) / 2
                                BoxSize = Math:RoundVector(NewVector2(Floor(Size * 1.5), Floor(Size * 1.9)))
                                BoxPosition = Math:RoundVector(NewVector2(Floor(Position.X - Size * 1.5 / 2), Floor(Position.Y - Size * 1.6 / 2)))
                                --
                                if (Settings["Box"][1] == true and Settings["Box"][2] == "Corner") then -- // Corner Boxes
                                    BoxCenter = Math:RoundVector(NewVector2(BoxPosition.X + BoxSize.X / 2, BoxPosition.Y + BoxSize.Y / 2));
                                    TL = Math:RoundVector(NewVector2(BoxCenter.X - BoxSize.X / 2, BoxCenter.Y - BoxSize.Y / 2));
                                    BL = Math:RoundVector(NewVector2(BoxCenter.X - BoxSize.X / 2, BoxCenter.Y + BoxSize.Y / 2));
                                    TR = Math:RoundVector(NewVector2(BoxCenter.X + BoxSize.X / 2, BoxCenter.Y - BoxSize.Y / 2));
                                    BR = Math:RoundVector(NewVector2(BoxCenter.X + BoxSize.X / 2, BoxCenter.Y + BoxSize.Y / 2));
                                end
                            end
                        end
                        --
                        if (Size and BoxSize and BoxPosition) then
                            local GeneralOpacity = ((1 - 0.2) * TransparencyMultplier)
                            --
                            for Index, Drawing in pairs(Renders) do
                                if Index ~= "Corners" then
                                    if Drawing.Visible then
                                        Drawing.Visible = false
                                    end
                                end
                            end
                            --
                            for Index = 1, 16 do
                                if Renders.Corners[Index].Visible then
                                    Renders.Corners[Index].Visible = false
                                end
                            end
                            --
                            do -- // Name
                                if (Settings["Name"][1] == true) then
                                    local Name = Renders.Name
                                    --
                                    Name.Text = Visuals:FormatString(Player.Name)
                                    Name.Position = NewVector2(BoxSize.X / 2 + BoxPosition.X, BoxPosition.Y - 16)
                                    Name.Visible = true
                                    Name.Transparency = GeneralOpacity
                                    Name.Color = Settings["Name"][2]
                                end
                            end
                            --
                            do -- // Corner Boxes
                                if (Settings["Box"][1] == true) then
                                    if (Settings["Box"][2] == "Corner") then
                                        local BoxCorners, BoxColor1, BoxColor2 = Renders.Corners, Settings["Box"][3], Settings["Box"][4]
                                        -- // Inlines
                                        do
                                            BoxCorners[1].Visible = true
                                            BoxCorners[1].From = TL
                                            BoxCorners[1].To = BoxCorners[1].From + NewVector2(0, BoxSize.X / 3)  
                                            BoxCorners[1].Color = BoxColor1
                                            --
                                            BoxCorners[2].Visible = true
                                            BoxCorners[2].From = TL + NewVector2(1, 0)
                                            BoxCorners[2].To = BoxCorners[2].From + NewVector2(BoxSize.X / 3, 0)
                                            BoxCorners[2].Color = BoxColor1
                                            --
                                            BoxCorners[3].Visible = true
                                            BoxCorners[3].From = TR
                                            BoxCorners[3].To = BoxCorners[3].From + NewVector2(-BoxSize.X / 3, 0)
                                            BoxCorners[3].Color = BoxColor1
                                            --
                                            BoxCorners[4].Visible = true
                                            BoxCorners[4].From = TR
                                            BoxCorners[4].To = BoxCorners[4].From + NewVector2(0, BoxSize.X / 3)
                                            BoxCorners[4].Color = BoxColor1
                                            --
                                            BoxCorners[5].Visible = true
                                            BoxCorners[5].From = BR + NewVector2(0, 1)
                                            BoxCorners[5].To = BoxCorners[5].From + NewVector2(0, -BoxSize.X / 3)
                                            BoxCorners[5].Color = BoxColor1
                                            --
                                            BoxCorners[6].Visible = true
                                            BoxCorners[6].From = BR
                                            BoxCorners[6].To = BoxCorners[6].From + NewVector2(-BoxSize.X / 3, 0)
                                            BoxCorners[6].Color = BoxColor1
                                            --
                                            BoxCorners[7].Visible = true
                                            BoxCorners[7].From = BL + NewVector2(0, 1)
                                            BoxCorners[7].To = BoxCorners[7].From + NewVector2(0, -BoxSize.X / 3)
                                            BoxCorners[7].Color = BoxColor1
                                            --
                                            BoxCorners[8].Visible = true
                                            BoxCorners[8].From = BL
                                            BoxCorners[8].To = BoxCorners[8].From + NewVector2(BoxSize.X / 3, 0)
                                            BoxCorners[8].Color = BoxColor1
                                        end
                                        -- // Outlines
                                        do
                                            BoxCorners[9].Visible = true
                                            BoxCorners[9].From = BoxCorners[1].From + NewVector2(0, -1)
                                            BoxCorners[9].To = BoxCorners[1].To + NewVector2(0, 1)
                                            BoxCorners[9].Color = BoxColor2
                                            --
                                            BoxCorners[10].Visible = true
                                            BoxCorners[10].From = BoxCorners[2].From
                                            BoxCorners[10].To = BoxCorners[2].To + NewVector2(1, 0)
                                            BoxCorners[10].Color = BoxColor2
                                            --
                                            BoxCorners[11].Visible = true
                                            BoxCorners[11].From = BoxCorners[3].From + NewVector2(2, 0)
                                            BoxCorners[11].To = BoxCorners[3].To + NewVector2(-1, 0)
                                            BoxCorners[11].Color = BoxColor2
                                            --
                                            BoxCorners[12].Visible = true
                                            BoxCorners[12].From = BoxCorners[4].From
                                            BoxCorners[12].To = BoxCorners[4].To + NewVector2(0, 1)
                                            BoxCorners[12].Color = BoxColor2
                                            --
                                            BoxCorners[13].Visible = true
                                            BoxCorners[13].From = BoxCorners[5].From
                                            BoxCorners[13].To = BoxCorners[5].To + NewVector2(0, -1)
                                            BoxCorners[13].Color = BoxColor2
                                            --
                                            BoxCorners[14].Visible = true
                                            BoxCorners[14].From = BoxCorners[6].From + NewVector2(2, 0)
                                            BoxCorners[14].To = BoxCorners[6].To + NewVector2(-1, 0)
                                            BoxCorners[14].Color = BoxColor2
                                            --
                                            BoxCorners[15].Visible = true
                                            BoxCorners[15].From = BoxCorners[7].From
                                            BoxCorners[15].To = BoxCorners[7].To + NewVector2(0, -1)
                                            BoxCorners[15].Color = BoxColor2
                                            --
                                            BoxCorners[16].Visible = true
                                            BoxCorners[16].From = BoxCorners[8].From + NewVector2(-1, 0)
                                            BoxCorners[16].To = BoxCorners[8].To + NewVector2(1, 0)
                                            BoxCorners[16].Color = BoxColor2
                                        end
                                        --
                                        for Index = 1, 16 do
                                            BoxCorners[Index].Transparency = GeneralOpacity
                                        end
                                    else
                                        local Box = Renders.BoxInline
                                        local BoxOutline = Renders.BoxOutline
                                        --
                                        Box.Size = BoxSize
                                        Box.Position = BoxPosition
                                        Box.Transparency = GeneralOpacity
                                        Box.Color = Settings["Box"][3]
                                        Box.Visible = true
                                        --
                                        BoxOutline.Size = BoxSize
                                        BoxOutline.Position = BoxPosition
                                        BoxOutline.Transparency = GeneralOpacity
                                        BoxOutline.Color = Settings["Box"][4]
                                        BoxOutline.Visible = true
                                    end
                                end
                                --
                                if (Settings["BoxFill"][1] == true) then
                                    local BoxFill = Renders.BoxFill
                                    --
                                    BoxFill.Size = BoxSize
                                    BoxFill.Position = BoxPosition
                                    BoxFill.Transparency = ((1 - Settings["BoxFill"][3]) * TransparencyMultplier)
                                    BoxFill.Color = Settings["BoxFill"][2]
                                    BoxFill.Visible = true
                                end
                            end
                            --
                            do -- // HeatlhBar
                                if (Settings["HealthBar"][1] == true) then
                                    local ArmorColor = Color:Lerp(Info.Health / Info.MaxHealth, Settings["ArmorBar"][2], Settings["ArmorBar"][3])
                                    local HealthSize = (Floor(BoxSize.Y * (Info.Health / Info.MaxHealth)))
                                    local Color = Color:Lerp(Info.Health / Info.MaxHealth, Settings["HealthBar"][2], Settings["HealthBar"][3])
                                    local Height = ((BoxPosition.Y + BoxSize.Y) - HealthSize)
                                    --
                                    -- // Bars
                                    local HealthBarInline, HealthBarOutline, HealthBarValue = Renders.HealthBarInline, Renders.HealthBarOutline, Renders.HealthBarValue
                                    local HealthBarTransparency = GeneralOpacity
                                    --
                                    HealthBarInline.Color = Color
                                    HealthBarInline.Size = NewVector2(1, HealthSize)
                                    HealthBarInline.Position = NewVector2(BoxPosition.X - 4, Height)
                                    HealthBarInline.Visible = true
                                    HealthBarInline.Transparency = HealthBarTransparency
                                    --
                                    HealthBarOutline.Size = NewVector2(3, BoxSize.Y + 2)
                                    HealthBarOutline.Position = NewVector2(BoxPosition.X - 5, BoxPosition.Y - 1)
                                    HealthBarOutline.Visible = true
                                    HealthBarOutline.Transparency = HealthBarTransparency
                                    --
                                    do -- // Value
                                        if (Settings["HealthNumber"][1] == true) then
                                            local Text = Monolith:ClampString(tostring(Round(Info.Health)), BoxSize.Y)
                                            local ArmorText = Renders.ArmorBarText
                                            local HealthNumberPosition = NewVector2((BoxPosition.X + 1), BoxPosition.Y + BoxSize.Y)
                                            local Offset = (Settings["ArmorBar"][1]) and 23 or 18 
                                            --
                                            HealthBarValue.Text = Text
                                            HealthBarValue.Color = Color
                                            HealthBarValue.Position = NewVector2(HealthNumberPosition.X - Offset, HealthNumberPosition.Y - (Info.Health / Info.MaxHealth) * BoxSize.Y)
                                            HealthBarValue.Visible = true
                                            HealthBarValue.ZIndex = 100
                                            HealthBarValue.Transparency = HealthBarTransparency
                                            --
                                            if (Settings["ArmorNumber"][1] == true) then 
                                                ArmorText.Text = tostring(Info.ArmorValue)
                                                ArmorText.Color = ArmorColor
                                                ArmorText.Position = NewVector2(HealthNumberPosition.X - Offset, HealthNumberPosition.Y - (Info.ArmorValue / 200) * BoxSize.Y)
                                                ArmorText.Visible = true
                                                ArmorText.Transparency = HealthBarTransparency
                                        end
                                    end
                                end
                                do 
                                    if (Settings["ArmorBar"][1] == true) then 
                                        local ArmorBar, ArmorBarOutline = Renders.ArmorBar, Renders.ArmorBarOutline
                                        -- 
                                        local ArmorSize = (Floor(BoxSize.Y * (Info.ArmorValue / 200)))
                                        local ArmorHeight = ((BoxPosition.Y + BoxSize.Y) - ArmorSize)
                                        -- 
                                        ArmorBar.Color = ArmorColor
                                        ArmorBar.Size = NewVector2(1, ArmorSize)
                                        ArmorBar.Position = NewVector2(BoxPosition.X - 10, ArmorHeight)
                                        ArmorBar.Visible = true
                                        ArmorBar.Transparency = HealthBarTransparency
                                        --
                                        ArmorBarOutline.Size = NewVector2(3, BoxSize.Y + 2)
                                        ArmorBarOutline.Position = NewVector2(BoxPosition.X - 11, BoxPosition.Y - 1)
                                        ArmorBarOutline.Visible = true
                                        ArmorBarOutline.Transparency = HealthBarTransparency
                                    end 
                                end 
                            end
                            end
                            --
                            do -- // Gun Icons 
                                if (Settings["WeaponIcon"][1] == true) and Info.ToolHeld ~= "None" and images[Info.ToolHeld] ~= nil then 
                                    local Gun = Renders.GunIcon
                                    -- 
                                    if tick() - Info.gunTick > 0.2 then 
                                        Info.gunTick = tick()
                                        Gun.Data = images[Info.ToolHeld] 
                                    end 
                                    Gun.Visible = true 
                                    Gun.Color = Settings["WeaponIcon"][2]
                                    Gun.Size = NewVector2(51.9, 22.3)
                                    Gun.Position = BoxPosition + NewVector2(BoxSize.X / 2, (BoxSize.Y + 12)) - NewVector2(Gun.Size.X/2, 0)
                                    Add += 42.3
                                else 
                                    Add = 0 
                                end 
                            end 
                            --
                            do -- // Weapon
                                if (Settings["Weapon"][1] == true) then
                                    local Weapon = Renders.Weapon
                                    --
                                    Weapon.Text = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool").Name or "None"
                                    Weapon.Position = (BoxPosition + NewVector2(BoxSize.X / 2, (BoxSize.Y + 2)))
                                    Weapon.Color = Settings["Weapon"][2]
                                    Weapon.Transparency = GeneralOpacity
                                    Weapon.Visible = true
                                end
                            end
                            --
                          --[[  do -- // Distance
                                if (Settings["Distance"][1] == true) then
                                    local Distance = Renders.Distance
                                    --
                                    Distance.Text = ("%sm"):format(Round(DistanceToPlayer))
                                    Distance.Position = BoxPosition + NewVector2(BoxSize.X / 2, (BoxSize.Y + (Renders.Weapon.Visible and 15 or 0)))
                                    Distance.Color = Settings["Distance"][2]
                                    Distance.Visible = true
                                    Distance.Transparency = GeneralOpacity
                                end
                            end]]
 
                            --
                            do -- // Flag
                                if (Settings["Flag"][1] == true) then
                                    local Flag = Renders.Flag
                                    local FlagStr = ""
                                    --
                                    if (Settings["Distance"][1] == true)  then
                                        FlagStr ..= ("%sm\n"):format(Round(DistanceToPlayer))
                                    end  

                                    --
                               --[[      if (Settings["Knocked"][1] == true)  and Player.Character.BodyEffects then
                                       FlagStr ..= ("%s\n"):format(tostring(Player.Character.BodyEffects["K.O"].Value and "Knocked" or "Alive"))
                                    end
                                    --
                                    if (Settings["Moving"][1] == true) and RootPart.Velocity.Magnitude >= 5 then
                                        FlagStr ..= ("%s\n"):format(tostring(RootPart.Velocity.Magnitude >= 5 and "Moving" or "Standing"))
                                    end  
                                    --
                                    if (Settings["Jumping"][1] == true) and RootPart.Velocity.Y >= 5 then
                                        FlagStr ..= ("%s\n"):format(tostring(RootPart.Velocity.Y >= 5 and "Jumping" or ""))
                                    end       
                                    --
                                    if (Settings["Desynced"][1] == true) and RootPart.Velocity.Magnitude >= 100 then
                                        FlagStr ..= ("%s\n"):format(tostring(RootPart.Velocity.Magnitude >= 100 and "Desynced" or ""))
                                    end        
                                    --
                                    if (Settings["Swimming"][1] == true) and Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                                        FlagStr ..= ("%s\n"):format(tostring(Humanoid:GetState() == Enum.HumanoidStateType.Swimming and "Swimming" or ""))
                                    end            
                                    --
                                    if (Settings["Reload"][1] == true) and Player.Character.BodyEffects then
                                        FlagStr ..= ("%s\n"):format(tostring(Player.Character.BodyEffects["Reload"].Value and "Reloading" or ""))
                                    end]]
                                    --
                                    Flag.Text = FlagStr
                                    Flag.Position = NewVector2(BoxSize.X + BoxPosition.X + 3, BoxPosition.Y - 2)
                                    Flag.Visible = true
                                    Flag.Color = Settings["Flag"][2]
                                    Flag.Transparency = GeneralOpacity


                                end
                            end
                            --
                            return
                        end
                    end
                end
                --
                return Self:Opacity(false)
            end
            --
            return Self:Remove()
        end
    end
    --
    function Visuals:Unload()
        for Index, Base in pairs(Visuals.Bases) do
            Base:Remove()
        end
    end
end
--
Monolith:Connection(RunService.RenderStepped, function(Delta)
    for Index, Base in pairs(Visuals.Bases) do
        Monolith:ThreadFunction(function()
            Base:Update()
        end, "3x01")
    end 
end)
--
Monolith:Connection(Players.PlayerAdded, function(Player)
    Visuals:Create({Player = Player})
end)
--
for Index, Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Visuals:Create({Player = Player})
    end
end

return Settings
