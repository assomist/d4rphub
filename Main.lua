--[[

	D4rpHub V2 by d4rp © CC0 1.0 Universal (2023)
	https://github.com/assomist

]]


if D4rpHubLoaded or D4rpHubLoading then
	return
end

getgenv().D4rpHubLoading = true


local PlaceId = game.PlaceId

local Games = {
    ["Phantom Forces"]    = 292439477,
    ["Arsenal"]           = 286090429,
    ["Bad Business"]      = 2057006746,
    ["Rivals"]            = 17625359962,
    ["Da Hood"]           = 2788229376,
    ["Counter Blox"]      = 301549746,
    ["Murder Mystery 2"]  = 142823291,
    ["Evade"]             = 9872472334,
    ["Frontlines"]        = 11198526183,
    ["Tower of Hell"]     = 1962086868,
    ["Doors"]             = 6516141723,
    ["Flee The Facility"] = 185655149,
    ["Prison Life"]       = 155615604,
    ["Natural Disaster"]  = 189707,
    ["Blox Fruits"]       = 2753915549,
    ["Jailbreak"]         = 606849621,
    ["The Strongest"]     = 11901571838,
    ["Type Soul"]         = 11895282556,
    ["Fisch"]             = 16732694052,
    ["Brookhaven"]        = 4924922222,
}

local GameSettings = {
    ["Phantom Forces"] = {
        LockPart = "Head",
        FOV = 120,
        Sensitivity = 0.45,
        TeamCheck = true,
    },
    ["Arsenal"] = {
        LockPart = "Head",
        FOV = 150,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["Bad Business"] = {
        LockPart = "Head",
        FOV = 130,
        Sensitivity = 0.5,
        TeamCheck = true,
    },
    ["Rivals"] = {
        LockPart = "HumanoidRootPart",
        FOV = 140,
        Sensitivity = 0.5,
        TeamCheck = true,
    },
    ["Da Hood"] = {
        LockPart = "Head",
        FOV = 180,
        Sensitivity = 0.55,
        TeamCheck = false,
    },
    ["Counter Blox"] = {
        LockPart = "Head",
        FOV = 100,
        Sensitivity = 0.4,
        TeamCheck = true,
    },
    ["Murder Mystery 2"] = {
        LockPart = "Head",
        FOV = 200,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["Evade"] = {
        LockPart = "HumanoidRootPart",
        FOV = 160,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["Frontlines"] = {
        LockPart = "Head",
        FOV = 110,
        Sensitivity = 0.45,
        TeamCheck = true,
    },
    ["Flee The Facility"] = {
        LockPart = "HumanoidRootPart",
        FOV = 180,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["Prison Life"] = {
        LockPart = "Head",
        FOV = 150,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["Jailbreak"] = {
        LockPart = "Head",
        FOV = 150,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
    ["The Strongest"] = {
        LockPart = "HumanoidRootPart",
        FOV = 200,
        Sensitivity = 0.55,
        TeamCheck = false,
    },
    ["Type Soul"] = {
        LockPart = "HumanoidRootPart",
        FOV = 180,
        Sensitivity = 0.5,
        TeamCheck = false,
    },
}

local CurrentGame = "Unknown"
for name, id in next, Games do
    if PlaceId == id then
        CurrentGame = name
        break
    end
end



local game = game
local loadstring, typeof, select, next, pcall = loadstring, typeof, select, next, pcall
local tablefind, tablesort = table.find, table.sort
local mathfloor = math.floor
local stringgsub = string.gsub
local wait, delay, spawn = task.wait, task.delay, task.spawn
local osdate = os.date


local function safeLoad(url, name)
	local ok, result = pcall(function()
		return loadstring(game:HttpGet(url, true))()
	end)
	if not ok then
		warn("[D4rpHub] Erreur chargement " .. name .. ": " .. tostring(result))
		return nil
	end
	return result
end

safeLoad("https://raw.githubusercontent.com/Exunys/Roblox-Functions-Library/main/Library.lua", "RobloxFunctions")

local GUI = safeLoad("https://raw.githubusercontent.com/assomist/d4rphub/main/src/UI_Library.lua", "UI_Library")
local ESP = safeLoad("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua", "ESP")
local Aimbot = safeLoad("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua", "Aimbot")

if not GUI then
	warn("[D4rpHub] ❌ UI_Library introuvable — vérifie que src/UI_Library.lua est bien sur le GitHub.")
	getgenv().D4rpHubLoading = nil
	return
end
if not ESP then
	warn("[D4rpHub] ⚠️ ESP introuvable — aimbot/ESP désactivés mais le script continue.")
end
if not Aimbot then
	warn("[D4rpHub] ⚠️ Aimbot introuvable — aimbot désactivé mais le script continue.")
end

-- Note: cfg appliqué après déclaration des settings Aimbot (ligne ~188)



local MainFrame = GUI:Load()

-- Souris toujours visible
UserInputService.MouseIconEnabled = true

-- Guards nil pour ESP/Aimbot (si leur chargement a échoué)
local ESP_DeveloperSettings = ESP and ESP.DeveloperSettings or {}
local ESP_Settings = ESP and ESP.Settings or {}
local ESP_Properties = ESP and ESP.Properties or { Crosshair = { CenterDot = {} } }
local Crosshair = ESP_Properties.Crosshair or { CenterDot = {} }
local CenterDot = Crosshair.CenterDot or {}

local Aimbot_DeveloperSettings = Aimbot and Aimbot.DeveloperSettings or {}
local Aimbot_Settings = Aimbot and Aimbot.Settings or {}
local Aimbot_FOV = Aimbot and Aimbot.FOVSettings or {}
local Aimbot_CPT = Aimbot and Aimbot.ClosestPlayerTracer or {}
local Triggerbot = Aimbot and Aimbot.Triggerbot or {}

ESP_Settings.LoadConfigOnLaunch = false
ESP_Settings.Enabled = false
Crosshair.Enabled = false
Aimbot_Settings.Enabled = false

-- Appliquer les paramètres par jeu maintenant que les settings sont déclarés
local cfg = GameSettings[CurrentGame]
if cfg then
    Aimbot_Settings.LockPart = cfg.LockPart
    Aimbot_Settings.TeamCheck = cfg.TeamCheck
    Aimbot_FOV.Radius = cfg.FOV
    Aimbot_Settings.Sensitivity = cfg.Sensitivity
end

-- Services déclarés tôt pour tout le script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Fonts = {"UI", "System", "Plex", "Monospace"}
local TracerPositions = {"Bottom", "Center", "Mouse"}
local HealthBarPositions = {"Top", "Bottom", "Left", "Right"}
local BoxTypes = {"Square", "Quad", "Corner"}


local General, GeneralSignal = MainFrame:Tab("General")
local _Aimbot = MainFrame:Tab("Aimbot")
local _ESP = MainFrame:Tab("ESP")
local _Crosshair = MainFrame:Tab("Crosshair")
local Settings = MainFrame:Tab("Settings")

local BF_Tab = nil
if CurrentGame == "Blox Fruits" then
    BF_Tab = MainFrame:Tab("🍊 Blox Fruits")
end


local AddValues = function(Section, Object, Exceptions, Prefix)
	local Keys, Copy = {}, {}

	for Index, _ in next, Object do
		Keys[#Keys + 1] = Index
	end

	tablesort(Keys, function(A, B)
		return A < B
	end)

	for _, Value in next, Keys do
		Copy[Value] = Object[Value]
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "boolean" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:Toggle({
			Name = stringgsub(Index, "(%l)(%u)", function(...)
				return select(1, ...).." "..select(2, ...)
			end),
			Flag = Prefix..Index,
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "Color3" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:Colorpicker({
			Name = stringgsub(Index, "(%l)(%u)", function(...)
				return select(1, ...).." "..select(2, ...)
			end),
			Flag = Prefix..Index,
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end
end


local AimbotSection = General:Section({
	Name = "Aimbot Settings",
	Side = "Left"
})

local ESPSection = General:Section({
	Name = "ESP Settings",
	Side = "Right"
})

local ESPDeveloperSection = General:Section({
	Name = "ESP Developer Settings",
	Side = "Right"
})

AddValues(ESPDeveloperSection, ESP_DeveloperSettings, {}, "ESP_DeveloperSettings_")

ESPDeveloperSection:Dropdown({
	Name = "Update Mode",
	Flag = "ESP_UpdateMode",
	Content = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = ESP_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		ESP_DeveloperSettings.UpdateMode = Value
	end
})

ESPDeveloperSection:Dropdown({
	Name = "Team Check Option",
	Flag = "ESP_TeamCheckOption",
	Content = {"TeamColor", "Team"},
	Default = ESP_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		ESP_DeveloperSettings.TeamCheckOption = Value
	end
})

ESPDeveloperSection:Slider({
	Name = "Rainbow Speed",
	Flag = "ESP_RainbowSpeed",
	Default = ESP_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

ESPDeveloperSection:Slider({
	Name = "Width Boundary",
	Flag = "ESP_WidthBoundary",
	Default = ESP_DeveloperSettings.WidthBoundary * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.WidthBoundary = Value / 10
	end
})

ESPDeveloperSection:Button({
	Name = "Refresh",
	Callback = function()
		ESP:Restart()
	end
})

ESPDeveloperSection:Button({
	Name = "Rewrite Entries / Hard Reboot",
	Callback = function()
		ESP:Restart(true)
	end
})

AddValues(ESPSection, ESP_Settings, {"LoadConfigOnLaunch", "PartsOnly"}, "ESPSettings_")

AimbotSection:Toggle({
	Name = "Enabled",
	Flag = "Aimbot_Enabled",
	Default = Aimbot_Settings.Enabled,
	Callback = function(Value)
		Aimbot_Settings.Enabled = Value
	end
})

AddValues(AimbotSection, Aimbot_Settings, {"Enabled", "Toggle", "OffsetToMoveDirection"}, "Aimbot_")

local AimbotDeveloperSection = General:Section({
	Name = "Aimbot Developer Settings",
	Side = "Left"
})

AimbotDeveloperSection:Dropdown({
	Name = "Update Mode",
	Flag = "Aimbot_UpdateMode",
	Content = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = Aimbot_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		Aimbot_DeveloperSettings.UpdateMode = Value
	end
})

AimbotDeveloperSection:Dropdown({
	Name = "Team Check Option",
	Flag = "Aimbot_TeamCheckOption",
	Content = {"TeamColor", "Team"},
	Default = Aimbot_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		Aimbot_DeveloperSettings.TeamCheckOption = Value
	end
})

AimbotDeveloperSection:Slider({
	Name = "Rainbow Speed",
	Flag = "Aimbot_RainbowSpeed",
	Default = Aimbot_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		Aimbot_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

AimbotDeveloperSection:Button({
	Name = "Refresh",
	Callback = function()
		Aimbot.Restart()
	end
})


local AimbotPropertiesSection = _Aimbot:Section({
	Name = "Properties",
	Side = "Left"
})

AimbotPropertiesSection:Toggle({
	Name = "Toggle",
	Flag = "Aimbot_Toggle",
	Default = Aimbot_Settings.Toggle,
	Callback = function(Value)
		Aimbot_Settings.Toggle = Value
	end
})

AimbotPropertiesSection:Toggle({
	Name = "Offset To Move Direction",
	Flag = "Aimbot_OffsetToMoveDirection",
	Default = Aimbot_Settings.OffsetToMoveDirection,
	Callback = function(Value)
		Aimbot_Settings.OffsetToMoveDirection = Value
	end
})

AimbotPropertiesSection:Slider({
	Name = "Offset Increment",
	Flag = "Aimbot_OffsetIncrementy",
	Default = Aimbot_Settings.OffsetIncrement,
	Min = 1,
	Max = 30,
	Callback = function(Value)
		Aimbot_Settings.OffsetIncrement = Value
	end
})

AimbotPropertiesSection:Slider({
	Name = "Animation Sensitivity (ms)",
	Flag = "Aimbot_Sensitivity",
	Default = Aimbot_Settings.Sensitivity * 100,
	Min = 0,
	Max = 100,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity = Value / 100
	end
})

AimbotPropertiesSection:Slider({
	Name = "mousemoverel Sensitivity",
	Flag = "Aimbot_Sensitivity2",
	Default = Aimbot_Settings.Sensitivity2 * 100,
	Min = 0,
	Max = 500,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity2 = Value / 100
	end
})

AimbotPropertiesSection:Dropdown({
	Name = "Lock Mode",
	Flag = "Aimbot_Settings_LockMode",
	Content = {"CFrame", "mousemoverel", "mousemoveabs"},
	Default = Aimbot_Settings.LockMode == 1 and "CFrame" or Aimbot_Settings.LockMode == 2 and "mousemoverel" or "mousemoveabs",
	Callback = function(Value)
		Aimbot_Settings.LockMode = Value == "CFrame" and 1 or Value == "mousemoverel" and 2 or 3
	end
})

AimbotPropertiesSection:Dropdown({
	Name = "Lock Part",
	Flag = "Aimbot_LockPart",
	Content = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"},
	Default = Aimbot_Settings.LockPart,
	Callback = function(Value)
		Aimbot_Settings.LockPart = Value
	end
})

AimbotPropertiesSection:Keybind({
	Name = "Trigger Key",
	Flag = "Aimbot_TriggerKey",
	Default = Aimbot_Settings.TriggerKey,
	Callback = function(Keybind)
		Aimbot_Settings.TriggerKey = Keybind
	end
})

local UserBox = AimbotPropertiesSection:Box({
	Name = "Player Name (shortened allowed)",
	Flag = "Aimbot_PlayerName",
	Placeholder = "Username"
})

AimbotPropertiesSection:Button({
	Name = "Blacklist (Ignore) Player",
	Callback = function()
		pcall(Aimbot.Blacklist, Aimbot, GUI.flags["Aimbot_PlayerName"])
		UserBox:Set("")
	end
})

AimbotPropertiesSection:Button({
	Name = "Whitelist Player",
	Callback = function()
		pcall(Aimbot.Whitelist, Aimbot, GUI.flags["Aimbot_PlayerName"])
		UserBox:Set("")
	end
})

local AimbotFOVSection = _Aimbot:Section({
	Name = "Field Of View Settings",
	Side = "Right"
})

AddValues(AimbotFOVSection, Aimbot_FOV, {}, "Aimbot_FOV_")

AimbotFOVSection:Slider({
	Name = "Field Of View",
	Flag = "Aimbot_FOV_Radius",
	Default = Aimbot_FOV.Radius,
	Min = 0,
	Max = 720,
	Callback = function(Value)
		Aimbot_FOV.Radius = Value
	end
})

AimbotFOVSection:Slider({
	Name = "Sides",
	Flag = "Aimbot_FOV_NumSides",
	Default = Aimbot_FOV.NumSides,
	Min = 3,
	Max = 60,
	Callback = function(Value)
		Aimbot_FOV.NumSides = Value
	end
})

AimbotFOVSection:Slider({
	Name = "Transparency",
	Flag = "Aimbot_FOV_Transparency",
	Default = Aimbot_FOV.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Aimbot_FOV.Transparency = Value / 10
	end
})

AimbotFOVSection:Slider({
	Name = "Thickness",
	Flag = "Aimbot_FOV_Thickness",
	Default = Aimbot_FOV.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Aimbot_FOV.Thickness = Value
	end
})

local AimbotCPTSection = _Aimbot:Section({
	Name = "Closest Player Tracer Settings",
	Side = "Right"
})

AddValues(AimbotCPTSection, Aimbot_CPT, {}, "Aimbot_CPT_")

AimbotCPTSection:Dropdown({
	Name = "Position",
	Flag = "CPT_Position",
	Content = TracerPositions,
	Default = TracerPositions[Aimbot_CPT.Position],
	Callback = function(Value)
		Aimbot_CPT.Position = tablefind(TracerPositions, Value)
	end
})

AimbotCPTSection:Slider({
	Name = "Transparency",
	Flag = "CPT_Transparency",
	Default = Aimbot_CPT.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Aimbot_CPT.Transparency = Value / 10
	end
})

AimbotCPTSection:Slider({
	Name = "Thickness",
	Flag = "CPT_Thickness",
	Default = Aimbot_CPT.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Aimbot_CPT.Thickness = Value
	end
})

local TriggerbotSection = _Aimbot:Section({
	Name = "Triggerbot Settings",
	Side = "Right"
})

AddValues(TriggerbotSection, Triggerbot, {}, "Triggerbot_")

TriggerbotSection:Slider({
	Name = "Delay (ms)",
	Flag = "Triggerbot_Delay",
	Default = Triggerbot.Delay * 100,
	Min = 0,
	Max = 200,
	Callback = function(Value)
		Triggerbot.Delay = Value / 100
	end
})


local ESP_Properties_Section = _ESP:Section({
	Name = "ESP Properties",
	Side = "Left"
})

AddValues(ESP_Properties_Section, ESP_Properties.ESP, {}, "ESP_Propreties_")

ESP_Properties_Section:Dropdown({
	Name = "Text Font",
	Flag = "ESP_TextFont",
	Content = Fonts,
	Default = Fonts[ESP_Properties.ESP.Font + 1],
	Callback = function(Value)
		ESP_Properties.ESP.Font = Drawing.Fonts[Value]
	end
})

ESP_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "ESP_TextTransparency",
	Default = ESP_Properties.ESP.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.ESP.Transparency = Value / 10
	end
})

ESP_Properties_Section:Slider({
	Name = "Font Size",
	Flag = "ESP_FontSize",
	Default = ESP_Properties.ESP.Size,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		ESP_Properties.ESP.Size = Value
	end
})

ESP_Properties_Section:Slider({
	Name = "Offset",
	Flag = "ESP_Offset",
	Default = ESP_Properties.ESP.Offset,
	Min = 10,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.ESP.Offset = Value
	end
})

local Tracer_Properties_Section = _ESP:Section({
	Name = "Tracer Properties",
	Side = "Right"
})

AddValues(Tracer_Properties_Section, ESP_Properties.Tracer, {}, "Tracer_Properties_")

Tracer_Properties_Section:Dropdown({
	Name = "Position",
	Flag = "Tracer_Position",
	Content = TracerPositions,
	Default = TracerPositions[ESP_Properties.Tracer.Position],
	Callback = function(Value)
		ESP_Properties.Tracer.Position = tablefind(TracerPositions, Value)
	end
})

Tracer_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Tracer_Transparency",
	Default = ESP_Properties.Tracer.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Tracer.Transparency = Value / 10
	end
})

Tracer_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Tracer_Thickness",
	Default = ESP_Properties.Tracer.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Tracer.Thickness = Value
	end
})

local Skeleton_Properties_Section = _ESP:Section({
	Name = "Skeleton Properties",
	Side = "Right"
})

AddValues(Skeleton_Properties_Section, ESP_Properties.Skeleton, {}, "Skeleton_Properties_")

Skeleton_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Skeleton_Transparency",
	Default = ESP_Properties.Skeleton.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Skeleton.Transparency = Value / 10
	end
})

Skeleton_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Skeleton_Thickness",
	Default = ESP_Properties.Skeleton.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Skeleton.Thickness = Value
	end
})

local HeadDot_Properties_Section = _ESP:Section({
	Name = "Head Dot Properties",
	Side = "Left"
})

AddValues(HeadDot_Properties_Section, ESP_Properties.HeadDot, {}, "HeadDot_Properties_")

HeadDot_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "HeadDot_Transparency",
	Default = ESP_Properties.HeadDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HeadDot.Transparency = Value / 10
	end
})

HeadDot_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "HeadDot_Thickness",
	Default = ESP_Properties.HeadDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HeadDot.Thickness = Value
	end
})

HeadDot_Properties_Section:Slider({
	Name = "Sides",
	Flag = "HeadDot_Sides",
	Default = ESP_Properties.HeadDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.HeadDot.NumSides = Value
	end
})

local Box_Properties_Section1 = _ESP:Section({
	Name = "Box Properties (1 / 2)",
	Side = "Left"
})

local Box_Properties_Section2 = _ESP:Section({
	Name = "Box Properties (2 / 2)",
	Side = "Right"
})

AddValues(Box_Properties_Section1, ESP_Properties.Box, {}, "Box_Properties_")

Box_Properties_Section2:Slider({
	Name = "Transparency",
	Flag = "Box_Transparency",
	Default = ESP_Properties.Box.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Box.Transparency = Value / 10
	end
})

Box_Properties_Section2:Slider({
	Name = "Fill Transparency",
	Flag = "Box_FillTransparency",
	Default = ESP_Properties.Box.FillTransparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Box.FillTransparency = Value / 10
	end
})

Box_Properties_Section2:Slider({
	Name = "Thickness",
	Flag = "Box_Thickness",
	Default = ESP_Properties.Box.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Box.Thickness = Value
	end
})

Box_Properties_Section2:Slider({
	Name = "Line Size (Corner Type)",
	Flag = "Box_LineSize",
	Default = ESP_Properties.Box.LineSize,
	Min = 2,
	Max = 20,
	Callback = function(Value)
		ESP_Properties.Box.LineSize = Value
	end
})

Box_Properties_Section2:Dropdown({
	Name = "Box Type",
	Flag = "Box_Type",
	Content = BoxTypes,
	Default = ESP_Properties.Box.Type == 1 and "Square" or ESP_Properties.Box.Type == 2 and "Quad" or "Corner",
	Callback = function(Value)
		ESP_Properties.Box.Type = Value == "Square" and 1 or Value == "Quad" and 2 or 3
	end
})

local HealthBar_Properties_Section = _ESP:Section({
	Name = "Health Bar Properties",
	Side = "Right"
})

AddValues(HealthBar_Properties_Section, ESP_Properties.HealthBar, {}, "HealthBar_Properties_")

HealthBar_Properties_Section:Dropdown({
	Name = "Position",
	Flag = "HealthBar_Position",
	Content = HealthBarPositions,
	Default = HealthBarPositions[ESP_Properties.HealthBar.Position],
	Callback = function(Value)
		ESP_Properties.HealthBar.Position = tablefind(HealthBarPositions, Value)
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "HealthBar_Transparency",
	Default = ESP_Properties.HealthBar.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HealthBar.Transparency = Value / 10
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "HealthBar_Thickness",
	Default = ESP_Properties.HealthBar.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HealthBar.Thickness = Value
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Offset",
	Flag = "HealthBar_Offset",
	Default = ESP_Properties.HealthBar.Offset,
	Min = 4,
	Max = 12,
	Callback = function(Value)
		ESP_Properties.HealthBar.Offset = Value
	end
})

HealthBar_Properties_Section:Slider({
	Name = "Blue",
	Flag = "HealthBar_Blue",
	Default = ESP_Properties.HealthBar.Blue,
	Min = 0,
	Max = 255,
	Callback = function(Value)
		ESP_Properties.HealthBar.Blue = Value
	end
})

--[=[
local Chams_Properties_Section = _ESP:Section({
	Name = "Chams Properties",
	Side = "Right"
})

AddValues(Chams_Properties_Section, ESP_Properties.Chams, {}, "Chams_Properties_")

Chams_Properties_Section:Slider({
	Name = "Transparency",
	Flag = "Chams_Transparency",
	Default = ESP_Properties.Chams.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Chams.Transparency = Value / 10
	end
})

Chams_Properties_Section:Slider({
	Name = "Thickness",
	Flag = "Chams_Thickness",
	Default = ESP_Properties.Chams.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Chams.Thickness = Value
	end
})
]=]

local Highlight_Properties_Section = _ESP:Section({
	Name = "Highlight Properties",
	Side = "Left"
})

AddValues(Highlight_Properties_Section, ESP_Properties.Highlight, {}, "Highlight_Properties_")

Highlight_Properties_Section:Slider({
	Name = "Fill Transparency",
	Flag = "Highlight_Transparency",
	Default = ESP_Properties.Highlight.FillTransparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Highlight.FillTransparency = Value / 10
	end
})

Highlight_Properties_Section:Slider({
	Name = "Outline Transparency",
	Flag = "Highlight_Outline_Transparency",
	Default = ESP_Properties.Highlight.OutlineTransparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Highlight.OutlineTransparency = Value / 10
	end
})

Highlight_Properties_Section:Slider({
	Name = "Health Color Blue",
	Flag = "Highlight_Blue",
	Default = ESP_Properties.Highlight.HealthColorBlue,
	Min = 0,
	Max = 255,
	Callback = function(Value)
		ESP_Properties.Highlight.HealthColorBlue = Value
	end
})

Highlight_Properties_Section:Dropdown({
	Name = "Depth Mode",
	Flag = "Highlight_DepthMode",
	Content = {"AlwaysOnTop", "Occluded"},
	Default = ESP_Properties.Highlight.DepthMode == Enum.HighlightDepthMode.AlwaysOnTop and "AlwaysOnTop" or "Occluded",
	Callback = function(Value)
		ESP_Properties.Highlight.DepthMode = Value == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
	end
})


-- Curseur souris quand GUI ouvert
local function SetMouseIconVisibility(Value)
	UserInputService.MouseIconEnabled = Value
end

local Crosshair_Settings = _Crosshair:Section({
	Name = "Crosshair Settings (1 / 2)",
	Side = "Left"
})

Crosshair_Settings:Toggle({
	Name = "Enabled",
	Flag = "Crosshair_Enabled",
	Default = Crosshair.Enabled,
	Callback = function(Value)
		Crosshair.Enabled = Value
	end
})

Crosshair_Settings:Toggle({
	Name = "Enable ROBLOX Cursor",
	Flag = "Cursor_Enabled",
	Default = UserInputService.MouseIconEnabled,
	Callback = SetMouseIconVisibility
})

AddValues(Crosshair_Settings, Crosshair, {"Enabled"}, "Crosshair_")

Crosshair_Settings:Dropdown({
	Name = "Position",
	Flag = "Crosshair_Position",
	Content = {"Mouse", "Center"},
	Default = ({"Mouse", "Center"})[Crosshair.Position],
	Callback = function(Value)
		Crosshair.Position = Value == "Mouse" and 1 or 2
	end
})

Crosshair_Settings:Slider({
	Name = "Size",
	Flag = "Crosshair_Size",
	Default = Crosshair.Size,
	Min = 1,
	Max = 24,
	Callback = function(Value)
		Crosshair.Size = Value
	end
})

Crosshair_Settings:Slider({
	Name = "Gap Size",
	Flag = "Crosshair_GapSize",
	Default = Crosshair.GapSize,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.GapSize = Value
	end
})

Crosshair_Settings:Slider({
	Name = "Rotation (Degrees)",
	Flag = "Crosshair_Rotation",
	Default = Crosshair.Rotation,
	Min = -180,
	Max = 180,
	Callback = function(Value)
		Crosshair.Rotation = Value
	end
})

Crosshair_Settings:Slider({
	Name = "Rotation Speed",
	Flag = "Crosshair_RotationSpeed",
	Default = Crosshair.RotationSpeed,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		Crosshair.RotationSpeed = Value
	end
})

Crosshair_Settings:Slider({
	Name = "Pulsing Step",
	Flag = "Crosshair_PulsingStep",
	Default = Crosshair.PulsingStep,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingStep = Value
	end
})

local _Crosshair_Settings = _Crosshair:Section({
	Name = "Crosshair Settings (2 / 2)",
	Side = "Left"
})

_Crosshair_Settings:Slider({
	Name = "Pulsing Speed",
	Flag = "Crosshair_PulsingSpeed",
	Default = Crosshair.PulsingSpeed,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		Crosshair.PulsingSpeed = Value
	end
})

_Crosshair_Settings:Slider({
	Name = "Pulsing Boundary (Min)",
	Flag = "Crosshair_Pulse_Min",
	Default = Crosshair.PulsingBounds[1],
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingBounds[1] = Value
	end
})

_Crosshair_Settings:Slider({
	Name = "Pulsing Boundary (Max)",
	Flag = "Crosshair_Pulse_Max",
	Default = Crosshair.PulsingBounds[2],
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingBounds[2] = Value
	end
})

_Crosshair_Settings:Slider({
	Name = "Transparency",
	Flag = "Crosshair_Transparency",
	Default = Crosshair.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Crosshair.Transparency = Value / 10
	end
})

_Crosshair_Settings:Slider({
	Name = "Thickness",
	Flag = "Crosshair_Thickness",
	Default = Crosshair.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Crosshair.Thickness = Value
	end
})

local Crosshair_CenterDot = _Crosshair:Section({
	Name = "Center Dot Settings",
	Side = "Right"
})

Crosshair_CenterDot:Toggle({
	Name = "Enabled",
	Flag = "Crosshair_CenterDot_Enabled",
	Default = CenterDot.Enabled,
	Callback = function(Value)
		CenterDot.Enabled = Value
	end
})

AddValues(Crosshair_CenterDot, CenterDot, {"Enabled"}, "Crosshair_CenterDot_")

Crosshair_CenterDot:Slider({
	Name = "Size / Radius",
	Flag = "Crosshair_CenterDot_Radius",
	Default = CenterDot.Radius,
	Min = 2,
	Max = 8,
	Callback = function(Value)
		CenterDot.Radius = Value
	end
})

Crosshair_CenterDot:Slider({
	Name = "Sides",
	Flag = "Crosshair_CenterDot_Sides",
	Default = CenterDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		CenterDot.NumSides = Value
	end
})

Crosshair_CenterDot:Slider({
	Name = "Transparency",
	Flag = "Crosshair_CenterDot_Transparency",
	Default = CenterDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		CenterDot.Transparency = Value / 10
	end
})

Crosshair_CenterDot:Slider({
	Name = "Thickness",
	Flag = "Crosshair_CenterDot_Thickness",
	Default = CenterDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		CenterDot.Thickness = Value
	end
})


local SettingsSection = Settings:Section({
	Name = "Settings",
	Side = "Left"
})

local ProfilesSection = Settings:Section({
	Name = "Profiles",
	Side = "Left"
})

local InformationSection = Settings:Section({
	Name = "Information",
	Side = "Right"
})

SettingsSection:Keybind({
	Name = "Show / Hide GUI",
	Flag = "UI Toggle",
	Default = Enum.KeyCode.RightShift,
	Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
	Callback = function(_, NewKeybind)
		if not NewKeybind then
			GUI:Close()
		end
	end
})

SettingsSection:Button({
	Name = "Unload Script",
	Callback = function()
		getgenv().D4rpHubLoaded = nil
		pcall(GUI.Unload, GUI)
		pcall(ESP.Exit, ESP)
		pcall(Aimbot.Exit, Aimbot)
	end
})

local ConfigList = ProfilesSection:Dropdown({
	Name = "Configurations",
	Flag = "Config Dropdown",
	Content = GUI:GetConfigs()
})

ProfilesSection:Box({
	Name = "Configuration Name",
	Flag = "Config Name",
	Placeholder = "Config Name"
})

ProfilesSection:Button({
	Name = "Load Configuration",
	Callback = function()
		GUI:LoadConfig(GUI.flags["Config Dropdown"])
	end
})

ProfilesSection:Button({
	Name = "Delete Configuration",
	Callback = function()
		GUI:DeleteConfig(GUI.flags["Config Dropdown"])
		ConfigList:Refresh(GUI:GetConfigs())
	end
})

ProfilesSection:Button({
	Name = "Save Configuration",
	Callback = function()
		GUI:SaveConfig(GUI.flags["Config Dropdown"] or GUI.flags["Config Name"])
		ConfigList:Refresh(GUI:GetConfigs())
	end
})

InformationSection:Label("Made by d4rp")
InformationSection:Label("Game: " .. CurrentGame)

InformationSection:Button({
	Name = "Copy GitHub",
	Callback = function()
		setclipboard("https://github.com/assomist/d4rphub")
	end
})

InformationSection:Label("D4rpHub © 2022 - "..osdate("%Y"))
InformationSection:Label("SE Engine: "..identifyexecutor()) -- Script Execution Engine

InformationSection:Button({
	Name = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/VOTRE_DISCORD")
	end
})

local MiscellaneousSection = Settings:Section({
	Name = "Miscellaneous",
	Side = "Right"
})

local TimeLabel = MiscellaneousSection:Label("...")
local PlayersLabel = MiscellaneousSection:Label("...")
local MemoryLabel = MiscellaneousSection:Label("...") -- Client RAM Usage
local FPSLabel = MiscellaneousSection:Label("...") -- Frames Per Second
local PPSLabel = MiscellaneousSection:Label("...") -- Physics Per Second
local TPSLabel = MiscellaneousSection:Label("...") -- Ticks Per Second

MiscellaneousSection:Button({
	Name = "Rejoin",
	Callback = Rejoin
})

delay(2, function()
	spawn(function()
		while wait(1) do
			TimeLabel:Set("Date: "..osdate("%c"))
			PlayersLabel:Set("Server count: "..tostring(#Players:GetPlayers()))
			MemoryLabel:Set("luauMemory: "..string.format("%.1f", gcinfo() / 1024).." MB")
			FPSLabel:Set("FPS (RenderStepped): "..mathfloor(1 / RunService.RenderStepped:Wait()))
			PPSLabel:Set("PPS (Stepped): "..mathfloor(1 / RunService.RenderStepped:Wait()))
			TPSLabel:Set("TPS (Heartbeat): "..mathfloor(1 / RunService.RenderStepped:Wait()))
		end
	end)
end)



local Utils = MainFrame:Tab("Utils")

local PlayerSection = Utils:Section({
	Name = "Player",
	Side = "Left"
})

local WorldSection = Utils:Section({
	Name = "World",
	Side = "Left"
})

local SkySection = Utils:Section({
	Name = "Sky",
	Side = "Right"
})

local MiscSection = Utils:Section({
	Name = "Misc",
	Side = "Right"
})

local WalkSpeed = 16
local JumpPower = 50
local Flying = false
local Noclip = false
local AntiAFK = false
local InfiniteJump = false
local HitboxSize = 4
local HitboxEnabled = false
local AutoReconnect = false
local OriginalHitboxes = {}

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	if WalkSpeed ~= 16 then Humanoid.WalkSpeed = WalkSpeed end
	if JumpPower ~= 50 then Humanoid.JumpPower = JumpPower end
	if HitboxEnabled then
		task.wait(1)
		for _, player in next, Players:GetPlayers() do
			if player ~= LocalPlayer and player.Character then
				local root = player.Character:FindFirstChild("HumanoidRootPart")
				if root then root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize) end
			end
		end
	end
end)

PlayerSection:Slider({
	Name = "WalkSpeed",
	Flag = "Utils_WalkSpeed",
	Default = 16,
	Min = 1,
	Max = 300,
	Callback = function(Value)
		WalkSpeed = Value
		local lp = Players.LocalPlayer
		local char = lp and lp.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = Value end
	end
})

PlayerSection:Slider({
	Name = "JumpPower",
	Flag = "Utils_JumpPower",
	Default = 50,
	Min = 1,
	Max = 500,
	Callback = function(Value)
		JumpPower = Value
		if Humanoid then Humanoid.JumpPower = Value end
	end
})

PlayerSection:Slider({
	Name = "Gravity",
	Flag = "Utils_Gravity",
	Default = 196,
	Min = 0,
	Max = 500,
	Callback = function(Value)
		workspace.Gravity = Value
	end
})

PlayerSection:Slider({
	Name = "FOV (Zoom)",
	Flag = "Utils_FOV",
	Default = 70,
	Min = 1,
	Max = 120,
	Callback = function(Value)
		workspace.CurrentCamera.FieldOfView = Value
	end
})

local FlyBody
local FlyGyro
local FlyConnection
local FlySpeed = 50
PlayerSection:Toggle({
	Name = "Fly",
	Flag = "Utils_Fly",
	Default = false,
	Callback = function(Value)
		Flying = Value
		local root = Character and Character:FindFirstChild("HumanoidRootPart")
		local hum = Character and Character:FindFirstChildOfClass("Humanoid")
		if not root then return end
		if Value then
			-- Désactive la physique du perso pour éviter le "bloc"
			if hum then
				hum.PlatformStand = true
			end
			FlyBody = Instance.new("BodyVelocity")
			FlyBody.Name = "D4rpFlyBody"
			FlyBody.Velocity = Vector3.new(0, 0, 0)
			FlyBody.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			FlyBody.Parent = root
			FlyGyro = Instance.new("BodyGyro")
			FlyGyro.Name = "D4rpFlyGyro"
			FlyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			FlyGyro.D = 100
			FlyGyro.Parent = root
			local cam = workspace.CurrentCamera
			if FlyConnection then FlyConnection:Disconnect() end
			FlyConnection = RunService.RenderStepped:Connect(function()
				if not Flying or not FlyBody then
					if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
					return
				end
				local cf = cam.CFrame
				local dir = Vector3.new(0, 0, 0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
				FlyBody.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.new(0, 0, 0)
				if dir.Magnitude > 0 and FlyGyro then
					FlyGyro.CFrame = CFrame.new(root.Position, root.Position + dir)
				end
			end)
		else
			if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
			if FlyBody then FlyBody:Destroy(); FlyBody = nil end
			if FlyGyro then FlyGyro:Destroy(); FlyGyro = nil end
			-- Rétablit la physique normale
			if hum then hum.PlatformStand = false end
		end
	end
})

PlayerSection:Slider({
	Name = "Fly Speed",
	Flag = "Utils_FlySpeed",
	Default = 50,
	Min = 5,
	Max = 300,
	Callback = function(Value)
		FlySpeed = Value
	end
})

PlayerSection:Toggle({
	Name = "Infinite Jump",
	Flag = "Utils_InfiniteJump",
	Default = false,
	Callback = function(Value)
		InfiniteJump = Value
		UserInputService.JumpRequest:Connect(function()
			if InfiniteJump and Character and Humanoid then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
})

PlayerSection:Toggle({
	Name = "Noclip",
	Flag = "Utils_Noclip",
	Default = false,
	Callback = function(Value)
		Noclip = Value
		RunService.Stepped:Connect(function()
			if not Noclip then return end
			if Character then
				for _, part in next, Character:GetDescendants() do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	end
})

PlayerSection:Slider({
	Name = "Transparence",
	Flag = "Utils_Transparency",
	Default = 0,
	Min = 0,
	Max = 100,
	Callback = function(Value)
		local transparency = Value / 100
		if Character then
			for _, part in next, Character:GetDescendants() do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = transparency
				end
			end
		end
		LocalPlayer.CharacterAdded:Connect(function(char)
			task.wait(0.5)
			local t = (GUI.flags["Utils_Transparency"] or 0) / 100
			for _, part in next, char:GetDescendants() do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = t
				end
			end
		end)
	end
})

PlayerSection:Toggle({
	Name = "Rainbow Body",
	Flag = "Utils_RainbowBody",
	Default = false,
	Callback = function(Value)
		task.spawn(function()
			while Value and GUI.flags["Utils_RainbowBody"] do
				local hue = tick() % 3 / 3
				local color = Color3.fromHSV(hue, 1, 1)
				if Character then
					for _, part in next, Character:GetDescendants() do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.Color = color
						end
					end
				end
				task.wait(0.05)
			end
		end)
	end
})

PlayerSection:Toggle({
	Name = "Hitbox Expander",
	Flag = "Utils_HitboxExpander",
	Default = false,
	Callback = function(Value)
		HitboxEnabled = Value
		for _, player in next, Players:GetPlayers() do
			if player ~= LocalPlayer and player.Character then
				local root = player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					if Value then
						OriginalHitboxes[player.Name] = root.Size
						root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
					else
						root.Size = OriginalHitboxes[player.Name] or Vector3.new(2, 2, 1)
						OriginalHitboxes[player.Name] = nil
					end
				end
			end
		end
	end
})

PlayerSection:Slider({
	Name = "Hitbox Size",
	Flag = "Utils_HitboxSize",
	Default = 4,
	Min = 2,
	Max = 20,
	Callback = function(Value)
		HitboxSize = Value
		if HitboxEnabled then
			for _, player in next, Players:GetPlayers() do
				if player ~= LocalPlayer and player.Character then
					local root = player.Character:FindFirstChild("HumanoidRootPart")
					if root then root.Size = Vector3.new(Value, Value, Value) end
				end
			end
		end
	end
})

WorldSection:Toggle({
	Name = "Fullbright",
	Flag = "Utils_Fullbright",
	Default = false,
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		if Value then
			lighting.Brightness = 10
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
			lighting.Ambient = Color3.fromRGB(255, 255, 255)
		else
			lighting.Brightness = 1
			lighting.ClockTime = 14
			lighting.GlobalShadows = true
			lighting.Ambient = Color3.fromRGB(0, 0, 0)
		end
	end
})

WorldSection:Slider({
	Name = "Time of Day",
	Flag = "Utils_TimeOfDay",
	Default = 14,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		game:GetService("Lighting").ClockTime = Value
	end
})

WorldSection:Toggle({
	Name = "Remove Fog",
	Flag = "Utils_RemoveFog",
	Default = false,
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		lighting.FogEnd = Value and 100000 or 1000
		lighting.FogStart = Value and 100000 or 0
	end
})

WorldSection:Toggle({
	Name = "Remove Effects",
	Flag = "Utils_RemoveEffects",
	Default = false,
	Callback = function(Value)
		if Value then
			for _, obj in next, workspace:GetDescendants() do
				if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
					pcall(function() obj.Enabled = false end)
					pcall(function() obj.Rate = 0 end)
				end
			end
			workspace.DescendantAdded:Connect(function(obj)
				if not GUI.flags["Utils_RemoveEffects"] then return end
				if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
					pcall(function() obj.Enabled = false end)
					pcall(function() obj.Rate = 0 end)
				end
			end)
		end
	end
})

WorldSection:Toggle({
	Name = "No Shadows",
	Flag = "Utils_NoShadows",
	Default = false,
	Callback = function(Value)
		game:GetService("Lighting").GlobalShadows = not Value
	end
})

WorldSection:Toggle({
	Name = "Vision Nuit (NightVision)",
	Flag = "Utils_NightVision",
	Default = false,
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		if Value then
			local cc = Instance.new("ColorCorrectionEffect")
			cc.Name = "D4rpNightVision"
			cc.Brightness = 0.1
			cc.Contrast = 0.3
			cc.Saturation = -0.5
			cc.TintColor = Color3.fromRGB(80, 255, 80)
			cc.Parent = lighting
			lighting.Brightness = 5
			lighting.Ambient = Color3.fromRGB(0, 80, 0)
		else
			local cc = lighting:FindFirstChild("D4rpNightVision")
			if cc then cc:Destroy() end
			lighting.Brightness = 1
			lighting.Ambient = Color3.fromRGB(0, 0, 0)
		end
	end
})

WorldSection:Toggle({
	Name = "Rainbow World",
	Flag = "Utils_RainbowWorld",
	Default = false,
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		task.spawn(function()
			while Value and GUI.flags["Utils_RainbowWorld"] do
				local hue = tick() % 8 / 8
				local color = Color3.fromHSV(hue, 0.6, 1)
				lighting.Ambient = color
				lighting.OutdoorAmbient = color
				lighting.FogColor = color
				task.wait(0.05)
			end
			lighting.Ambient = Color3.fromRGB(0, 0, 0)
			lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		end)
	end
})

WorldSection:Toggle({
	Name = "Champ de vision max",
	Flag = "Utils_MaxFOV",
	Default = false,
	Callback = function(Value)
		workspace.CurrentCamera.FieldOfView = Value and 120 or 70
	end
})

local Skies = {
	["Default"]   = "",
	["Night"]     = "rbxassetid://159454286",
	["Bleu ciel"] = "rbxassetid://159454260",
	["Coucher"]   = "rbxassetid://159454276",
	["Space"]     = "rbxassetid://159454299",
}

SkySection:Dropdown({
	Name = "Skybox",
	Flag = "Utils_Skybox",
	Content = {"Default", "Night", "Bleu ciel", "Coucher", "Space"},
	Default = "Default",
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		local existing = lighting:FindFirstChildOfClass("Sky")
		if Value == "Default" then
			if existing then existing:Destroy() end
			return
		end
		local sky = existing or Instance.new("Sky", lighting)
		local id = Skies[Value]
		sky.SkyboxBk = id
		sky.SkyboxDn = id
		sky.SkyboxFt = id
		sky.SkyboxLf = id
		sky.SkyboxRt = id
		sky.SkyboxUp = id
	end
})

SkySection:Toggle({
	Name = "Rainbow Sky",
	Flag = "Utils_RainbowSky",
	Default = false,
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		task.spawn(function()
			while Value and GUI.flags["Utils_RainbowSky"] do
				local hue = tick() % 5 / 5
				local color = Color3.fromHSV(hue, 1, 1)
				lighting.Ambient = color
				lighting.OutdoorAmbient = color
				task.wait(0.05)
			end
			lighting.Ambient = Color3.fromRGB(0, 0, 0)
			lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		end)
	end
})

MiscSection:Toggle({
	Name = "Anti-AFK",
	Flag = "Utils_AntiAFK",
	Default = false,
	Callback = function(Value)
		AntiAFK = Value
		if Value then
			local VirtualUser = game:GetService("VirtualUser")
			game:GetService("Players").LocalPlayer.Idled:Connect(function()
				if AntiAFK then
					VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
					task.wait(1)
					VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				end
			end)
		end
	end
})

MiscSection:Toggle({
	Name = "Auto Reconnect",
	Flag = "Utils_AutoReconnect",
	Default = false,
	Callback = function(Value)
		AutoReconnect = Value
		if Value then
			game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
				if state == Enum.TeleportState.Failed and AutoReconnect then
					task.wait(3)
					game:GetService("TeleportService"):Teleport(game.PlaceId)
				end
			end)
		end
	end
})

MiscSection:Toggle({
	Name = "Hide Nameplates",
	Flag = "Utils_HideNameplates",
	Default = false,
	Callback = function(Value)
		for _, player in next, Players:GetPlayers() do
			if player ~= LocalPlayer and player.Character then
				local head = player.Character:FindFirstChild("Head")
				if head then
					local billboard = head:FindFirstChildOfClass("BillboardGui")
					if billboard then billboard.Enabled = not Value end
				end
			end
		end
		Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(char)
				task.wait(1)
				if GUI.flags["Utils_HideNameplates"] then
					local head = char:FindFirstChild("Head")
					if head then
						local billboard = head:FindFirstChildOfClass("BillboardGui")
						if billboard then billboard.Enabled = false end
					end
				end
			end)
		end)
	end
})

MiscSection:Button({
	Name = "Print Coordinates",
	Callback = function()
		local root = Character and Character:FindFirstChild("HumanoidRootPart")
		if root then
			local pos = root.Position
			local msg = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
			warn("[D4rpHub] " .. msg)
			pcall(function() setclipboard(msg) end)
		end
	end
})

MiscSection:Button({
	Name = "Rejoin",
	Callback = Rejoin
})

MiscSection:Button({
	Name = "Copy Server ID",
	Callback = function()
		setclipboard(tostring(game.JobId))
	end
})

MiscSection:Button({
	Name = "Server Hop",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		local servers = {}
		local ok, result = pcall(function()
			return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
		end)
		if ok then
			local data = game:GetService("HttpService"):JSONDecode(result)
			for _, server in next, data.data do
				if server.id ~= game.JobId and server.playing < server.maxPlayers then
					table.insert(servers, server.id)
				end
			end
		end
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
		else
			warn("[D4rpHub] Aucun serveur disponible.")
		end
	end
})


if BF_Tab then
    local BF_Players = game:GetService("Players")
    local BF_LP = BF_Players.LocalPlayer
    local BF_RS = game:GetService("RunService")
    local BF_AutoFarm = false
    local BF_AutoQuest = false
    local BF_AutoEat = false
    local BF_AutoCollect = false
    local BF_InfiniteEnergy = false
    local BF_AutoRaid = false

    local BF_FarmSection  = BF_Tab:Section({ Name = "Farm",     Side = "Left"  })
    local BF_BossSection  = BF_Tab:Section({ Name = "Boss",     Side = "Left"  })
    local BF_PlayerSection= BF_Tab:Section({ Name = "Joueur",   Side = "Left"  })
    local BF_TeleSection  = BF_Tab:Section({ Name = "Teleport", Side = "Right" })
    local BF_QuestSection = BF_Tab:Section({ Name = "Quetes",   Side = "Right" })
    local BF_MiscSection  = BF_Tab:Section({ Name = "Misc",     Side = "Right" })

    local function getBFChar()
        return BF_LP.Character
    end

    local function getBFHum()
        local c = getBFChar()
        return c and c:FindFirstChildOfClass("Humanoid")
    end

    local function getBFRoot()
        local c = getBFChar()
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local BF_FarmRadius = 500
    local BF_FarmDelay = 0.15
    local BF_AutoHealEnabled = true
    local BF_HealThreshold = 50
    local BF_FarmTarget = nil
    local BF_FarmStatus = "Inactif"
    local BF_AttackHeight = 3
    local BF_SavedSpeed = 16
    local BF_SavedJump = 50
    local BF_FlyConnection = nil  -- connexion unique pour éviter les fuites mémoire

    -- Cache mob: re-scan max 1x/seconde au lieu de chaque frame
    local BF_MobCache = {}
    local BF_MobCacheTime = 0
    local BF_MOB_CACHE_TTL = 0.8  -- secondes

    local function refreshMobCache()
        local now = tick()
        if now - BF_MobCacheTime < BF_MOB_CACHE_TTL then return end
        BF_MobCacheTime = now
        BF_MobCache = {}
        local char = getBFChar()
        for _, obj in next, workspace:GetDescendants() do
            if obj:IsA("Model") and obj ~= char then
                -- Exclure les joueurs (nom dans Players)
                if not BF_Players:FindFirstChild(obj.Name) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local r = obj:FindFirstChild("HumanoidRootPart")
                    if hum and hum.MaxHealth > 0 and r then
                        table.insert(BF_MobCache, { model = obj, hum = hum, root = r })
                    end
                end
            end
        end
    end

    local function getClosestMob(maxDist)
        maxDist = maxDist or BF_FarmRadius
        local root = getBFRoot()
        if not root then return nil end
        refreshMobCache()
        local closest, closestDist = nil, maxDist
        for _, entry in next, BF_MobCache do
            -- Vérifier que le mob est encore vivant (cache peut être légèrement périmé)
            if entry.hum and entry.hum.Health > 0 and entry.root then
                local ok, dist = pcall(function()
                    return (entry.root.Position - root.Position).Magnitude
                end)
                if ok and dist < closestDist then
                    closest = entry.model
                    closestDist = dist
                end
            end
        end
        return closest
    end

    local function getToolRemote()
        local char = getBFChar()
        if not char then return nil end
        for _, tool in next, char:GetChildren() do
            if tool:IsA("Tool") then
                for _, v in next, tool:GetDescendants() do
                    if v:IsA("RemoteEvent") then return v end
                end
            end
        end
        return nil
    end

    -- RS cached pour éviter GetService répété
    local BF_RS_ref = game:GetService("ReplicatedStorage")

    local BF_AttackRemoteNames = {
        "DamageFunction","HitEvent","Attack","Skill1","Skill2",
        "Skill3","Skill4","Z_Skill","X_Skill","C_Skill","V_Skill","F_Skill"
    }
    -- Cache des remotes d'attaque (cherchés une seule fois)
    local BF_AttackRemoteCache = nil
    local function getAttackRemotes()
        if BF_AttackRemoteCache then return BF_AttackRemoteCache end
        BF_AttackRemoteCache = {}
        for _, rName in next, BF_AttackRemoteNames do
            local r = BF_RS_ref:FindFirstChild(rName, true)
            if r and r:IsA("RemoteEvent") then
                table.insert(BF_AttackRemoteCache, r)
            end
        end
        return BF_AttackRemoteCache
    end

    local function BF_Attack(target)
        local ok, err = pcall(function()
            local root = getBFRoot()
            if not root or not target then return end
            local mobRoot = target:FindFirstChild("HumanoidRootPart")
            if not mobRoot then return end
            -- TP sur le mob
            local offset = Vector3.new(math.random(-2,2), BF_AttackHeight, math.random(-2,2))
            root.CFrame = CFrame.new(mobRoot.Position + offset)
            -- Remote de l'outil équipé
            local toolRemote = getToolRemote()
            if toolRemote then
                pcall(function()
                    toolRemote:FireServer(CFrame.new(mobRoot.Position), mobRoot.Position)
                end)
            end
            -- Remotes génériques BF
            for _, r in next, getAttackRemotes() do
                pcall(function() r:FireServer(target, mobRoot.Position) end)
            end
            -- MoveTo pour compléter le déplacement
            pcall(function()
                local hum = getBFHum()
                if hum then hum:MoveTo(mobRoot.Position) end
            end)
        end)
        if not ok then
            -- Si erreur, vider le cache (mob peut avoir disparu)
            BF_MobCache = {}
            BF_AttackRemoteCache = nil
        end
    end

    local function BF_AutoHeal()
        local ok = pcall(function()
            local hum = getBFHum()
            if not hum then return end
            local hpPct = (hum.Health / hum.MaxHealth) * 100
            if hpPct < BF_HealThreshold then
                local healRemote = BF_RS_ref:FindFirstChild("Heal", true)
                    or BF_RS_ref:FindFirstChild("HealPlayer", true)
                    or BF_RS_ref:FindFirstChild("UseHeal", true)
                if healRemote then
                    pcall(function() healRemote:FireServer() end)
                else
                    -- Fallback: set HP direct
                    hum.Health = hum.MaxHealth
                end
            end
        end)
        if not ok then warn("[D4rpHub] AutoHeal error (ignoré)") end
    end

    -- Restaure vitesse/saut après respawn
    BF_LP.CharacterAdded:Connect(function(char)
        -- Couper le fly et nettoyer BodyVelocity immédiatement
        if BF_FlyConnection then
            pcall(function() BF_FlyConnection:Disconnect() end)
            BF_FlyConnection = nil
        end
        GUI.flags["BF_Fly"] = false
        task.wait(1)  -- attendre que le perso soit prêt
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("BF_FlyBody")
            if bv then bv:Destroy() end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = BF_SavedSpeed
            hum.JumpPower = BF_SavedJump
        end
        -- Vider les caches après respawn
        BF_MobCache = {}
        BF_AttackRemoteCache = nil
        warn("[D4rpHub] Respawn — fly coupé, vitesse restaurée (Speed:" .. BF_SavedSpeed .. " Jump:" .. BF_SavedJump .. ")")
    end)

    BF_FarmSection:Button({
        Name = "📊 Statut Farm (voir output)",
        Callback = function()
            warn("[D4rpHub] Farm Status: " .. BF_FarmStatus
                .. " | Delay: " .. BF_FarmDelay .. "s"
                .. " | Rayon: " .. BF_FarmRadius
                .. " | Cache mobs: " .. #BF_MobCache
                .. " | Remotes: " .. #getAttackRemotes())
        end
    })

    BF_FarmSection:Toggle({
        Name = "Auto Farm (Mobs)",
        Flag = "BF_AutoFarm",
        Default = false,
        Callback = function(Value)
            BF_AutoFarm = Value
            if not Value then BF_FarmStatus = "Inactif"; return end
            task.spawn(function()
                while BF_AutoFarm do
                    local waitTime = BF_FarmDelay  -- snapshot du delay actuel
                    local ok, err = pcall(function()
                        local hum = getBFHum()
                        local root = getBFRoot()
                        if not hum or not root then
                            BF_FarmStatus = "⏳ Respawn..."
                            task.wait(1)
                            return
                        end
                        if hum.Health <= 0 then
                            BF_FarmStatus = "💀 Mort — attente respawn"
                            task.wait(3)
                            return
                        end
                        if BF_AutoHealEnabled then BF_AutoHeal() end
                        local mob = BF_FarmTarget or getClosestMob(BF_FarmRadius)
                        if mob then
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            if not mobHum or mobHum.Health <= 0 then
                                BF_FarmTarget = nil
                                BF_MobCache = {}  -- invalider le cache
                                return
                            end
                            BF_FarmStatus = "⚔️ " .. mob.Name
                            BF_Attack(mob)
                        else
                            BF_FarmStatus = "🔍 Cherche mobs... (rayon: " .. BF_FarmRadius .. ")"
                            BF_MobCache = {}  -- forcer rescan
                            task.wait(1)
                        end
                    end)
                    if not ok then
                        BF_FarmStatus = "⚠️ Erreur: " .. tostring(err):sub(1, 50)
                        warn("[D4rpHub] Farm error: " .. tostring(err))
                        task.wait(1)
                    else
                        task.wait(waitTime)
                    end
                end
                BF_FarmStatus = "Inactif"
            end)
        end
    })

    BF_FarmSection:Slider({
        Name = "Rayon de Farm (studs)",
        Flag = "BF_FarmRadius",
        Default = 500,
        Min = 50,
        Max = 2000,
        Callback = function(Value)
            BF_FarmRadius = Value
            BF_MobCache = {}  -- invalider cache quand rayon change
        end
    })

    BF_FarmSection:Slider({
        Name = "Vitesse Farm (ms entre attaques)",
        Flag = "BF_FarmDelay",
        Default = 150,
        Min = 10,
        Max = 2000,
        Callback = function(Value)
            BF_FarmDelay = Value / 1000  -- stocker en secondes
        end
    })

    BF_FarmSection:Slider({
        Name = "Hauteur d'attaque (studs)",
        Flag = "BF_AttackHeight",
        Default = 3,
        Min = 0,
        Max = 20,
        Callback = function(Value)
            BF_AttackHeight = Value
        end
    })

    BF_FarmSection:Toggle({
        Name = "Auto Heal pendant Farm",
        Flag = "BF_AutoHeal",
        Default = true,
        Callback = function(Value)
            BF_AutoHealEnabled = Value
        end
    })

    BF_FarmSection:Slider({
        Name = "HP Heal Threshold (%)",
        Flag = "BF_HealThreshold",
        Default = 50,
        Min = 10,
        Max = 95,
        Callback = function(Value)
            BF_HealThreshold = Value
        end
    })

    BF_FarmSection:Button({
        Name = "Lock Target (mob le plus proche)",
        Callback = function()
            local mob = getClosestMob(BF_FarmRadius)
            if mob then
                BF_FarmTarget = mob
                warn("[D4rpHub] Target lock: " .. mob.Name)
            else
                warn("[D4rpHub] Aucun mob dans le rayon.")
            end
        end
    })

    BF_FarmSection:Button({
        Name = "Reset Target",
        Callback = function()
            BF_FarmTarget = nil
            warn("[D4rpHub] Target reset — retour en auto.")
        end
    })

    BF_FarmSection:Toggle({
        Name = "Auto Collect Fruits",
        Flag = "BF_AutoCollect",
        Default = false,
        Callback = function(Value)
            BF_AutoCollect = Value
            task.spawn(function()
                while BF_AutoCollect do
                    local root = getBFRoot()
                    if root then
                        for _, obj in next, workspace:GetDescendants() do
                            if obj.Name == "Fruit" or obj.Name:find("Fruit") or obj.Name:find("Devil") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                                if part then
                                    local dist = (part.Position - root.Position).Magnitude
                                    if dist < 500 then
                                        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                        task.wait(0.5)
                                        local pickupRemote = game:GetService("ReplicatedStorage"):FindFirstChild("PickupFruit", true)
                                        if pickupRemote then
                                            pcall(function() pickupRemote:FireServer(obj) end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    })

    BF_FarmSection:Toggle({
        Name = "Auto Eat Fruit",
        Flag = "BF_AutoEat",
        Default = false,
        Callback = function(Value)
            BF_AutoEat = Value
            task.spawn(function()
                while BF_AutoEat do
                    local eatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("EatFruit", true)
                    if eatRemote then pcall(function() eatRemote:FireServer() end) end
                    task.wait(2)
                end
            end)
        end
    })

    BF_FarmSection:Toggle({
        Name = "Infinite Energy",
        Flag = "BF_InfiniteEnergy",
        Default = false,
        Callback = function(Value)
            BF_InfiniteEnergy = Value
            task.spawn(function()
                while BF_InfiniteEnergy do
                    local energyRemote = game:GetService("ReplicatedStorage"):FindFirstChild("AddEnergy", true)
                        or game:GetService("ReplicatedStorage"):FindFirstChild("Energy", true)
                    if energyRemote then pcall(function() energyRemote:FireServer(99999) end) end
                    task.wait(1)
                end
            end)
        end
    })

    -- Auto Chest: scan et TP sur tous les coffres de la map
    local BF_AutoChest = false
    local BF_ChestNames = {
        "Chest","chest","Treasure","treasure","TreasureChest","GoldChest",
        "StoneChest","Silver","BoneChest","BossChest","Mochizuki","BronzeChest"
    }

    BF_FarmSection:Toggle({
        Name = "Auto Chest (ouvre coffres)",
        Flag = "BF_AutoChest",
        Default = false,
        Callback = function(Value)
            BF_AutoChest = Value
            task.spawn(function()
                while BF_AutoChest do
                    local root = getBFRoot()
                    if root then
                        for _, obj in next, workspace:GetDescendants() do
                            if not BF_AutoChest then break end
                            local isChest = false
                            for _, cname in next, BF_ChestNames do
                                if obj.Name:find(cname) then isChest = true; break end
                            end
                            if isChest and (obj:IsA("BasePart") or obj:IsA("Model")) then
                                local partPos
                                if obj:IsA("BasePart") then
                                    partPos = obj.Position
                                else
                                    local p = obj:FindFirstChildOfClass("BasePart")
                                    if p then partPos = p.Position end
                                end
                                if partPos then
                                    local dist = (partPos - root.Position).Magnitude
                                    if dist < 3000 then
                                        root.CFrame = CFrame.new(partPos + Vector3.new(0, 3, 0))
                                        task.wait(0.4)
                                        -- Essaie d'ouvrir via click detector
                                        local cd = obj:FindFirstChildOfClass("ClickDetector")
                                            or (obj:IsA("Model") and obj:FindFirstChildOfClass("ClickDetector", true))
                                        if cd then
                                            pcall(function()
                                                local fe = game:GetService("ReplicatedStorage"):FindFirstChild("OpenChest", true)
                                                    or game:GetService("ReplicatedStorage"):FindFirstChild("Chest", true)
                                                if fe then fe:FireServer(obj) end
                                                fireclickdetector(cd)
                                            end)
                                        end
                                        task.wait(0.3)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    })

    BF_FarmSection:Toggle({
        Name = "Auto Mastery (utilise skills en boucle)",
        Flag = "BF_AutoMastery",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                local skillKeys = {
                    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C,
                    Enum.KeyCode.V, Enum.KeyCode.F
                }
                while Value and GUI.flags["BF_AutoMastery"] do
                    local mob = getClosestMob(BF_FarmRadius)
                    if mob then
                        BF_Attack(mob)
                        for _, key in next, skillKeys do
                            pcall(function()
                                local vp = Instance.new("InputObject")
                                vp.KeyCode = key
                                vp.UserInputType = Enum.UserInputType.Keyboard
                                game:GetService("UserInputService").InputBegan:Fire(vp, false)
                            end)
                            task.wait(0.1)
                        end
                    end
                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    BF_PlayerSection:Toggle({
        Name = "Godmode (Rejoindre)",
        Flag = "BF_Godmode",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_Godmode"] do
                    local hum = getBFHum()
                    if hum then
                        hum.Health = hum.MaxHealth
                    end
                    task.wait(0.1)
                end
            end)
        end
    })

    BF_PlayerSection:Slider({
        Name = "Vitesse",
        Flag = "BF_Speed",
        Default = 16,
        Min = 1,
        Max = 500,
        Callback = function(Value)
            BF_SavedSpeed = Value
            local hum = getBFHum()
            if hum then hum.WalkSpeed = Value end
        end
    })

    BF_PlayerSection:Slider({
        Name = "Saut",
        Flag = "BF_Jump",
        Default = 50,
        Min = 1,
        Max = 500,
        Callback = function(Value)
            BF_SavedJump = Value
            local hum = getBFHum()
            if hum then hum.JumpPower = Value end
        end
    })

    local BF_FlySpeed = 80
    BF_PlayerSection:Slider({
        Name = "Vitesse Vol",
        Flag = "BF_FlySpeed",
        Default = 80,
        Min = 10,
        Max = 500,
        Callback = function(Value)
            BF_FlySpeed = Value
        end
    })

    BF_PlayerSection:Toggle({
        Name = "Vol (Fly)",
        Flag = "BF_Fly",
        Default = false,
        Callback = function(Value)
            -- Déconnecter l'ancienne connexion si elle existe
            if BF_FlyConnection then
                pcall(function() BF_FlyConnection:Disconnect() end)
                BF_FlyConnection = nil
            end
            local root = getBFRoot()
            if not root then return end
            if Value then
                -- Supprimer ancien BodyVelocity s'il existe
                local oldBv = root:FindFirstChild("BF_FlyBody")
                if oldBv then oldBv:Destroy() end
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BF_FlyBody"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Parent = root
                local cam = workspace.CurrentCamera
                local uis = game:GetService("UserInputService")
                -- UNE SEULE connexion stockée
                BF_FlyConnection = BF_RS.RenderStepped:Connect(function()
                    if not GUI.flags["BF_Fly"] then
                        if BF_FlyConnection then
                            BF_FlyConnection:Disconnect()
                            BF_FlyConnection = nil
                        end
                        local bvClean = root:FindFirstChild("BF_FlyBody")
                        if bvClean then bvClean:Destroy() end
                        return
                    end
                    local r = getBFRoot()
                    if not r then return end
                    local flyBv = r:FindFirstChild("BF_FlyBody")
                    if not flyBv then return end
                    local cf = cam.CFrame
                    local dir = Vector3.new(0, 0, 0)
                    if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
                    flyBv.Velocity = dir.Magnitude > 0 and (dir.Unit * BF_FlySpeed) or Vector3.new(0,0,0)
                end)
            else
                local bv = root:FindFirstChild("BF_FlyBody")
                if bv then bv:Destroy() end
            end
        end
    })

    local BF_AllBosses = {
        ["SEA 1"] = {
            { name = "Gorilla King",    lvl = 20,  pos = Vector3.new(-1536, 10, -195),   drop = "Gorilla King Crown" },
            { name = "Bobby",           lvl = 55,  pos = Vector3.new(-2097, 1, -34),     drop = "Nothing" },
            { name = "Yeti",            lvl = 105, pos = Vector3.new(-2635, 55, -1200),  drop = "Nothing" },
            { name = "Mob Leader",      lvl = 120, pos = Vector3.new(-2020, 1, -1282),   drop = "Refined Musket" },
            { name = "Vice Admiral",    lvl = 130, pos = Vector3.new(-1961, 1, -1282),   drop = "Vice Admiral's Coat" },
            { name = "Saber Expert",    lvl = 200, pos = Vector3.new(-3380, 100, -890),  drop = "Saber" },
            { name = "Swan",            lvl = 240, pos = Vector3.new(-2230, 1, 215),     drop = "Pink Coat" },
            { name = "Magma Admiral",   lvl = 350, pos = Vector3.new(475, 1, -2550),     drop = "Nothing" },
            { name = "Fishman Lord",    lvl = 425, pos = Vector3.new(-3870, -20, 1690),  drop = "Trident" },
            { name = "Wysper",          lvl = 500, pos = Vector3.new(-3600, 480, 500),   drop = "Thunder God" },
            { name = "Thunder God",     lvl = 575, pos = Vector3.new(-3600, 530, 500),   drop = "Thunder God Helmet" },
            { name = "Cyborg",          lvl = 675, pos = Vector3.new(-580, 100, 1950),   drop = "Cool Shades" },
            { name = "Ice Admiral",     lvl = 700, pos = Vector3.new(-2635, 55, -1200),  drop = "Nothing" },
        },
        ["SEA 2"] = {
            { name = "Diamond",         lvl = 750,  pos = Vector3.new(947, 1, -2745),    drop = "Diamond Necklace" },
            { name = "Jeremy",          lvl = 850,  pos = Vector3.new(1105, 1, -1750),   drop = "Black Spikey Coat" },
            { name = "Fajita",          lvl = 925,  pos = Vector3.new(1875, 1, 1600),    drop = "Meteorite, Gravity Blade" },
            { name = "Don Swan",        lvl = 1000, pos = Vector3.new(1105, 1, -750),    drop = "Swan Glasses (2.5%)" },
            { name = "Smoke Admiral",   lvl = 1150, pos = Vector3.new(-3270, 1, -1455),  drop = "Jitte" },
            { name = "Cursed Captain",  lvl = 1325, pos = Vector3.new(-870, 1, -4530),   drop = "Leather Cape" },
            { name = "Awakened Ice Admiral", lvl = 1400, pos = Vector3.new(-2635, 55, -1200), drop = "Hidden Key, Library Key" },
        },
        ["SEA 3"] = {
            { name = "Stone",           lvl = 1550, pos = Vector3.new(-3270, 50, -1455),  drop = "Gamma Sword" },
            { name = "Island Empress",  lvl = 1675, pos = Vector3.new(-3550, 490, -1250), drop = "Flower Crown" },
            { name = "Kilo Admiral",    lvl = 1750, pos = Vector3.new(-870, 50, -4530),   drop = "Nothing" },
            { name = "Captain Elephant",lvl = 1875, pos = Vector3.new(-3870, -20, 1690),  drop = "Elephant Shield" },
            { name = "Beautiful Pirate",lvl = 1950, pos = Vector3.new(-580, 100, 1950),   drop = "Canvander" },
            { name = "Longma",          lvl = 2000, pos = Vector3.new(-3550, 490, -1250), drop = "Tushita" },
            { name = "Cake Queen",      lvl = 2100, pos = Vector3.new(475, 1, -2550),     drop = "Sweet Chalice" },
        },
        ["RAID"] = {
            { name = "Greybeard",       lvl = 700,  pos = Vector3.new(-1961, 1, -1282),  drop = "Red Spikey Coat" },
            { name = "Darkbeard",       lvl = 1000, pos = Vector3.new(947, 1, -2745),    drop = "Dark Coat" },
            { name = "Order",           lvl = 1250, pos = Vector3.new(-3270, 1, -1455),  drop = "Dark Dagger" },
            { name = "Cursed Captain",  lvl = 1325, pos = Vector3.new(-870, 1, -4530),   drop = "Leather Cape" },
            { name = "Soul Reaper",     lvl = 2100, pos = Vector3.new(-3550, 490, -1250),drop = "Hallow Scythe" },
            { name = "Cake Prince",     lvl = 2300, pos = Vector3.new(475, 1, -2550),    drop = "Cake Chalice" },
            { name = "Dough King",      lvl = 2300, pos = Vector3.new(1875, 1, 1600),    drop = "Dough Chalice" },
        },
    }

    local BF_MobsByIsland = {
        ["SEA 1 - Starter Island"]   = { mobs = {"Bandit","Monkey"}, lvlRange = "1-15",   pos = Vector3.new(-1300, 5, -1283) },
        ["SEA 1 - Jungle"]           = { mobs = {"Gorilla","Monkey"}, lvlRange = "15-30", pos = Vector3.new(-1618, 5, -68)   },
        ["SEA 1 - Pirate Village"]   = { mobs = {"Pirate","Brute"}, lvlRange = "30-60",   pos = Vector3.new(-1434, 5, 1180)  },
        ["SEA 1 - Desert"]           = { mobs = {"Bandit","Desert Soldier"}, lvlRange = "60-90", pos = Vector3.new(927, 5, 1430) },
        ["SEA 1 - Frozen Village"]   = { mobs = {"Snow Trooper","Yeti"}, lvlRange = "90-120", pos = Vector3.new(-2635, 55, -1200) },
        ["SEA 1 - Marine Fortress"]  = { mobs = {"Marine","Marine Lieutenant"}, lvlRange = "120-175", pos = Vector3.new(-2060, 5, -1282) },
        ["SEA 1 - Skypiea (Lower)"]  = { mobs = {"Sky Soldier","Shanda"}, lvlRange = "175-275", pos = Vector3.new(-3550, 400, -1250) },
        ["SEA 1 - Prison"]           = { mobs = {"Prisoner","Dangerous Prisoner"}, lvlRange = "190-275", pos = Vector3.new(-2230, 5, 215) },
        ["SEA 1 - Colosseum"]        = { mobs = {"Toga Warrior"}, lvlRange = "300-325", pos = Vector3.new(-1250, 5, 1850) },
        ["SEA 1 - Magma Village"]    = { mobs = {"Magma Ninja","Lava Pirate"}, lvlRange = "300-375", pos = Vector3.new(475, 5, -2550) },
        ["SEA 1 - Underwater City"]  = { mobs = {"Fishman Warrior","Fishman Lord"}, lvlRange = "375-450", pos = Vector3.new(-3870, -20, 1690) },
        ["SEA 1 - Skypiea (Upper)"]  = { mobs = {"Wysper","Thunder God"}, lvlRange = "450-575", pos = Vector3.new(-3600, 490, 500) },
        ["SEA 1 - Fountain City"]    = { mobs = {"Galley Pirate","Galley Captain"}, lvlRange = "625-700", pos = Vector3.new(-580, 5, 1950) },
        ["SEA 2 - Kingdom of Rose"]  = { mobs = {"Factory Staff","Factory Worker"}, lvlRange = "700-800", pos = Vector3.new(1105, 5, -750) },
        ["SEA 2 - Hot & Cold"]       = { mobs = {"Snow Lurker","Magma Ninja++"}, lvlRange = "1100-1200", pos = Vector3.new(-3270, 5, -1455) },
        ["SEA 2 - Cursed Ship"]      = { mobs = {"Cursed Pirate","Cursed Captain"}, lvlRange = "1200-1325", pos = Vector3.new(-870, 5, -4530) },
        ["SEA 2 - Ice Castle"]       = { mobs = {"Ice Fighter","Arctic Warrior"}, lvlRange = "1350-1400", pos = Vector3.new(-2635, 55, -1200) },
        ["SEA 3 - Port Town"]        = { mobs = {"Sea Soldier","Port Guard"}, lvlRange = "1500-1575", pos = Vector3.new(-3270, 50, -1455) },
        ["SEA 3 - Great Tree"]       = { mobs = {"Forest Pirate","Forest Fighter"}, lvlRange = "1575-1675", pos = Vector3.new(-3550, 490, -1250) },
        ["SEA 3 - Floating Turtle"]  = { mobs = {"Tropical Pirate","Turtle Fighter"}, lvlRange = "1675-1800", pos = Vector3.new(-3870, -20, 1690) },
        ["SEA 3 - Haunted Castle"]   = { mobs = {"Reborn Zombie","Living Zombie"}, lvlRange = "1975-2075", pos = Vector3.new(-580, 100, 1950) },
        ["SEA 3 - Cake Land"]        = { mobs = {"Cake Guard","Candy Soldier"}, lvlRange = "2075-2275", pos = Vector3.new(475, 5, -2550) },
        ["SEA 3 - Flame Utopia"]     = { mobs = {"Flame Soldier","Flame Warrior"}, lvlRange = "2100-2375", pos = Vector3.new(1875, 5, 1600) },
    }

    local BF_IslandNames = {}
    for k, _ in next, BF_MobsByIsland do table.insert(BF_IslandNames, k) end
    table.sort(BF_IslandNames)

    BF_TeleSection:Dropdown({
        Name = "Téléport par Island/Mobs",
        Flag = "BF_TeleIsland",
        Content = BF_IslandNames,
        Default = BF_IslandNames[1],
        Callback = function(Value)
            local root = getBFRoot()
            local data = BF_MobsByIsland[Value]
            if root and data then
                root.CFrame = CFrame.new(data.pos + Vector3.new(0, 5, 0))
                local mobList = table.concat(data.mobs, ", ")
                warn(string.format("[D4rpHub] Téléporté: %s | Mobs: %s | Niveaux: %s", Value, mobList, data.lvlRange))
            end
        end
    })

    BF_TeleSection:Button({
        Name = "Téléport Fruit Proche",
        Callback = function()
            local root = getBFRoot()
            if not root then return end
            local closest, closestDist = nil, math.huge
            for _, obj in next, workspace:GetDescendants() do
                if (obj.Name:find("Fruit") or obj.Name:find("Devil")) and obj:IsA("BasePart") then
                    local d = (obj.Position - root.Position).Magnitude
                    if d < closestDist then closest = obj; closestDist = d end
                end
            end
            if closest then
                root.CFrame = CFrame.new(closest.Position + Vector3.new(0, 4, 0))
                warn("[D4rpHub] Fruit: " .. closest.Name .. " à " .. math.floor(closestDist) .. " studs")
            else
                warn("[D4rpHub] Aucun fruit sur la map.")
            end
        end
    })

    local BF_Sea1BossNames = {}
    local BF_Sea2BossNames = {}
    local BF_Sea3BossNames = {}
    local BF_RaidBossNames = {}
    for _, b in next, BF_AllBosses["SEA 1"] do table.insert(BF_Sea1BossNames, b.name) end
    for _, b in next, BF_AllBosses["SEA 2"] do table.insert(BF_Sea2BossNames, b.name) end
    for _, b in next, BF_AllBosses["SEA 3"] do table.insert(BF_Sea3BossNames, b.name) end
    for _, b in next, BF_AllBosses["RAID"]  do table.insert(BF_RaidBossNames, b.name)  end

    local function tpToBoss(seaKey, bossName)
        local root = getBFRoot()
        if not root then return end
        for _, b in next, BF_AllBosses[seaKey] do
            if b.name == bossName then
                local bossModel = workspace:FindFirstChild(b.name, true)
                if bossModel then
                    local br = bossModel:FindFirstChild("HumanoidRootPart")
                    if br then
                        root.CFrame = CFrame.new(br.Position + Vector3.new(0, 5, 0))
                        warn("[D4rpHub] TP boss actif: " .. b.name .. " | Drop: " .. b.drop)
                        return
                    end
                end
                root.CFrame = CFrame.new(b.pos + Vector3.new(0, 5, 0))
                warn("[D4rpHub] TP spawn: " .. b.name .. " (Lv." .. b.lvl .. ") | Drop: " .. b.drop)
                return
            end
        end
    end

    BF_BossSection:Dropdown({
        Name = "Boss Sea 1",
        Flag = "BF_Boss_S1",
        Content = BF_Sea1BossNames,
        Default = BF_Sea1BossNames[1],
        Callback = function(Value) tpToBoss("SEA 1", Value) end
    })

    BF_BossSection:Dropdown({
        Name = "Boss Sea 2",
        Flag = "BF_Boss_S2",
        Content = BF_Sea2BossNames,
        Default = BF_Sea2BossNames[1],
        Callback = function(Value) tpToBoss("SEA 2", Value) end
    })

    BF_BossSection:Dropdown({
        Name = "Boss Sea 3",
        Flag = "BF_Boss_S3",
        Content = BF_Sea3BossNames,
        Default = BF_Sea3BossNames[1],
        Callback = function(Value) tpToBoss("SEA 3", Value) end
    })

    BF_BossSection:Dropdown({
        Name = "Raid Boss",
        Flag = "BF_Boss_Raid",
        Content = BF_RaidBossNames,
        Default = BF_RaidBossNames[1],
        Callback = function(Value) tpToBoss("RAID", Value) end
    })

    BF_BossSection:Toggle({
        Name = "Auto Farm Boss Sélectionné",
        Flag = "BF_AutoBoss",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_AutoBoss"] do
                    local hum = getBFHum()
                    if not hum or hum.Health <= 0 then task.wait(3); continue end
                    if BF_AutoHealEnabled then BF_AutoHeal() end
                    local seaList = { BF_AllBosses["SEA 1"], BF_AllBosses["SEA 2"], BF_AllBosses["SEA 3"], BF_AllBosses["RAID"] }
                    local seaKeys = { "SEA 1", "SEA 2", "SEA 3", "RAID" }
                    local selectedBoss = nil
                    for i, seaKey in next, seaKeys do
                        local flag = GUI.flags["BF_Boss_S" .. (i < 4 and i or "")] or GUI.flags["BF_Boss_Raid"]
                        for _, b in next, seaList[i] do
                            local bossModel = workspace:FindFirstChild(b.name, true)
                            if bossModel then
                                local bHum = bossModel:FindFirstChildOfClass("Humanoid")
                                if bHum and bHum.Health > 0 then
                                    selectedBoss = bossModel
                                    break
                                end
                            end
                        end
                        if selectedBoss then break end
                    end
                    if selectedBoss then
                        BF_Attack(selectedBoss)
                    end
                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    local BF_Quests = {
        ["SEA 1"] = {
            { name = "Gorilla King Quest",   npc = "Gorilla Quest Giver",   island = "SEA 1 - Jungle",           boss = "Gorilla King" },
            { name = "Marine Quest",         npc = "Quest Giver",           island = "SEA 1 - Marine Fortress",  boss = "Vice Admiral" },
            { name = "Saber Expert Quest",   npc = "Saber Quest",           island = "SEA 1 - Skypiea (Lower)",  boss = "Saber Expert" },
            { name = "Fishman Quest",        npc = "Fishman Quest",         island = "SEA 1 - Underwater City",  boss = "Fishman Lord" },
            { name = "Thunder God Quest",    npc = "Thunder Quest",         island = "SEA 1 - Skypiea (Upper)",  boss = "Thunder God" },
            { name = "Cyborg Quest",         npc = "Cyborg Quest",          island = "SEA 1 - Fountain City",    boss = "Cyborg" },
        },
        ["SEA 2"] = {
            { name = "Diamond Quest",        npc = "Diamond Quest",         island = "SEA 2 - Kingdom of Rose",  boss = "Diamond" },
            { name = "Jeremy Quest",         npc = "Jeremy Quest",          island = "SEA 2 - Kingdom of Rose",  boss = "Jeremy" },
            { name = "Don Swan Quest",       npc = "Swan Quest",            island = "SEA 2 - Kingdom of Rose",  boss = "Don Swan" },
            { name = "Smoke Admiral Quest",  npc = "Smoke Quest",           island = "SEA 2 - Hot & Cold",       boss = "Smoke Admiral" },
            { name = "Cursed Captain Quest", npc = "Curse Quest",           island = "SEA 2 - Cursed Ship",      boss = "Cursed Captain" },
        },
        ["SEA 3"] = {
            { name = "Stone Quest",          npc = "Stone Quest",           island = "SEA 3 - Port Town",        boss = "Stone" },
            { name = "Island Empress Quest", npc = "Empress Quest",         island = "SEA 3 - Great Tree",       boss = "Island Empress" },
            { name = "Beautiful Pirate",     npc = "Pirate Quest",          island = "SEA 3 - Floating Turtle",  boss = "Beautiful Pirate" },
            { name = "Longma Quest",         npc = "Longma Quest",          island = "SEA 3 - Floating Turtle",  boss = "Longma" },
            { name = "Cake Queen Quest",     npc = "Cake Quest",            island = "SEA 3 - Cake Land",        boss = "Cake Queen" },
        },
    }

    -- Flatten toutes les quêtes dans l'ordre SEA 1 → 2 → 3
    local BF_AllQuestNames = {}
    local BF_QuestFlat = {}
    for _, seaKey in next, {"SEA 1", "SEA 2", "SEA 3"} do
        for _, q in next, BF_Quests[seaKey] do
            table.insert(BF_AllQuestNames, q.name)
            table.insert(BF_QuestFlat, { sea=seaKey, quest=q })
        end
    end

    -- Quête chain: liste ordonnée pour progression automatique
    local BF_QuestChain = {}  -- noms des quêtes dans l'ordre voulu
    local BF_QuestChainIdx = 1
    local BF_QuestChainActive = false

    local function getBossForQuest(questName)
        for _, entry in next, BF_QuestFlat do
            if entry.quest.name == questName then return entry.quest.boss, entry.quest.island end
        end
        return nil, nil
    end

    BF_QuestSection:Dropdown({
        Name = "Quête active",
        Flag = "BF_QuestSelect",
        Content = BF_AllQuestNames,
        Default = BF_AllQuestNames[1],
        Callback = function(Value)
            local boss, island = getBossForQuest(Value)
            if boss then
                local idata = BF_MobsByIsland[island]
                local root = getBFRoot()
                if root and idata then
                    root.CFrame = CFrame.new(idata.pos + Vector3.new(0, 5, 0))
                end
                warn(string.format("[D4rpHub] Quête: %s | Boss: %s | Île: %s", Value, boss, island or "?"))
            end
        end
    })

    BF_QuestSection:Toggle({
        Name = "Auto Quest (boucle quête active)",
        Flag = "BF_AutoQuest",
        Default = false,
        Callback = function(Value)
            BF_AutoQuest = Value
            task.spawn(function()
                while BF_AutoQuest do
                    local questName = GUI.flags["BF_QuestSelect"]
                    if not questName then task.wait(1); continue end
                    local hum = getBFHum()
                    if not hum or hum.Health <= 0 then task.wait(3); continue end
                    if BF_AutoHealEnabled then BF_AutoHeal() end

                    local targetBoss, island = getBossForQuest(questName)
                    if not targetBoss then task.wait(1); continue end

                    -- 1) Accepter la quête via NPC (cherche dans workspace)
                    local questNpc = nil
                    for _, entry in next, BF_QuestFlat do
                        if entry.quest.name == questName then
                            questNpc = workspace:FindFirstChild(entry.quest.npc, true)
                            break
                        end
                    end
                    if questNpc then
                        local npcRoot = questNpc:FindFirstChild("HumanoidRootPart")
                            or questNpc:FindFirstChildOfClass("BasePart")
                        if npcRoot then
                            local root = getBFRoot()
                            if root then
                                root.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0,3,0))
                                task.wait(0.3)
                            end
                        end
                        local qRemote = game:GetService("ReplicatedStorage"):FindFirstChild("StartQuest", true)
                            or game:GetService("ReplicatedStorage"):FindFirstChild("AcceptQuest", true)
                            or game:GetService("ReplicatedStorage"):FindFirstChild("Quest", true)
                        if qRemote then pcall(function() qRemote:FireServer(questNpc) end) end
                        task.wait(0.5)
                    end

                    -- 2) Kill le boss cible
                    local bossModel = workspace:FindFirstChild(targetBoss, true)
                    if bossModel then
                        local bHum = bossModel:FindFirstChildOfClass("Humanoid")
                        if bHum and bHum.Health > 0 then
                            BF_Attack(bossModel)
                        else
                            -- Boss mort: attend respawn 5-10s
                            warn("[D4rpHub] Boss mort, respawn dans 5s: " .. targetBoss)
                            task.wait(5)
                        end
                    else
                        -- Boss pas encore spawn: TP sur l'île
                        local idata = BF_MobsByIsland[island]
                        if idata then
                            local root = getBFRoot()
                            if root then root.CFrame = CFrame.new(idata.pos + Vector3.new(0,5,0)) end
                        end
                        task.wait(4)
                    end

                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    -- Chain: sélectionne plusieurs quêtes dans l'ordre et les enchaîne
    BF_QuestSection:Dropdown({
        Name = "Chain: Quête 1",
        Flag = "BF_Chain1",
        Content = BF_AllQuestNames,
        Default = BF_AllQuestNames[1],
        Callback = function(v) end
    })
    BF_QuestSection:Dropdown({
        Name = "Chain: Quête 2",
        Flag = "BF_Chain2",
        Content = BF_AllQuestNames,
        Default = BF_AllQuestNames[2] or BF_AllQuestNames[1],
        Callback = function(v) end
    })
    BF_QuestSection:Dropdown({
        Name = "Chain: Quête 3",
        Flag = "BF_Chain3",
        Content = BF_AllQuestNames,
        Default = BF_AllQuestNames[3] or BF_AllQuestNames[1],
        Callback = function(v) end
    })

    BF_QuestSection:Toggle({
        Name = "Auto Quest Chain (enchaine les 3)",
        Flag = "BF_AutoChain",
        Default = false,
        Callback = function(Value)
            BF_QuestChainActive = Value
            task.spawn(function()
                local chainFlags = {"BF_Chain1", "BF_Chain2", "BF_Chain3"}
                while BF_QuestChainActive do
                    for _, flag in next, chainFlags do
                        if not BF_QuestChainActive then break end
                        local questName = GUI.flags[flag]
                        if not questName then continue end
                        local hum = getBFHum()
                        if not hum or hum.Health <= 0 then task.wait(3); continue end
                        if BF_AutoHealEnabled then BF_AutoHeal() end

                        local targetBoss, island = getBossForQuest(questName)
                        if not targetBoss then continue end
                        warn("[D4rpHub] Chain → " .. questName .. " | Boss: " .. targetBoss)

                        -- Kill le boss jusqu'à ce qu'il soit mort (quête complete)
                        local startTime = tick()
                        local maxDuration = 120  -- 2 minutes max par quête avant de passer
                        local bossKilled = false
                        while BF_QuestChainActive and (tick() - startTime) < maxDuration do
                            local h = getBFHum()
                            if not h or h.Health <= 0 then task.wait(3); continue end
                            if BF_AutoHealEnabled then BF_AutoHeal() end
                            local bm = workspace:FindFirstChild(targetBoss, true)
                            if bm then
                                local bh = bm:FindFirstChildOfClass("Humanoid")
                                if bh and bh.Health > 0 then
                                    BF_Attack(bm)
                                else
                                    bossKilled = true
                                    break  -- boss mort = quête accomplie
                                end
                            else
                                -- Boss pas spawn: TP sur l'île et attendre
                                local idata = BF_MobsByIsland[island]
                                if idata then
                                    local root = getBFRoot()
                                    if root then root.CFrame = CFrame.new(idata.pos + Vector3.new(0,5,0)) end
                                end
                                warn("[D4rpHub] Chain: " .. targetBoss .. " pas spawn, attente... (" .. math.floor(tick()-startTime) .. "s)")
                                task.wait(5)
                                BF_MobCache = {}
                            end
                            task.wait(BF_FarmDelay)
                        end
                        if bossKilled then
                            warn("[D4rpHub] ✅ Chain: " .. questName .. " terminée → prochaine")
                        else
                            warn("[D4rpHub] ⏱️ Chain: " .. questName .. " timeout (2min) → prochaine")
                        end
                        task.wait(1)
                    end
                end
            end)
        end
    })

    -- Raids organisés par sea
    local BF_RaidSection = BF_Tab:Section({ Name = "Raids", Side = "Right" })

    local BF_RaidData = {
        { name = "Greybeard (Sea 1)",       lvl = 700,  sea = 1, keyword = "Greybeard",    island = "SEA 1 - Marine Fortress", drop = "Red Spikey Coat, GrayBear" },
        { name = "Darkbeard (Sea 2)",        lvl = 1000, sea = 2, keyword = "Darkbeard",    island = "SEA 2 - Kingdom of Rose", drop = "Darkblade, Dark Coat" },
        { name = "Order (Sea 2)",            lvl = 1250, sea = 2, keyword = "Order",        island = "SEA 2 - Hot & Cold",      drop = "Dark Dagger, Order's Hat" },
        { name = "Cursed Captain (Sea 2)",   lvl = 1325, sea = 2, keyword = "Cursed Captain",island = "SEA 2 - Cursed Ship",    drop = "Leather Cape, Cursed Dual Katana" },
        { name = "Soul Reaper (Sea 3)",      lvl = 2100, sea = 3, keyword = "Soul Reaper",  island = "SEA 3 - Haunted Castle",  drop = "Hallow Scythe, Soul Cane" },
        { name = "Cake Prince (Sea 3)",      lvl = 2300, sea = 3, keyword = "Cake Prince",  island = "SEA 3 - Cake Land",       drop = "Cake Chalice, Pastil Pistols" },
        { name = "Dough King (Sea 3)",       lvl = 2300, sea = 3, keyword = "Dough King",   island = "SEA 3 - Cake Land",       drop = "Dough Chalice, Mochi Mochi" },
        { name = "rip_indra (Sea 3)",        lvl = 1500, sea = 3, keyword = "rip_indra",    island = "SEA 3 - Port Town",       drop = "Leviathan Heart, Dark Fragment" },
    }
    local BF_RaidNames = {}
    for _, r in next, BF_RaidData do table.insert(BF_RaidNames, r.name) end

    local BF_SelectedRaid = BF_RaidData[1]

    BF_RaidSection:Dropdown({
        Name = "Choisir Raid",
        Flag = "BF_RaidSelect",
        Content = BF_RaidNames,
        Default = BF_RaidNames[1],
        Callback = function(Value)
            for _, r in next, BF_RaidData do
                if r.name == Value then
                    BF_SelectedRaid = r
                    warn(string.format("[D4rpHub] Raid sélectionné: %s | Lv%d | Drop: %s", r.name, r.lvl, r.drop))
                    break
                end
            end
        end
    })

    BF_RaidSection:Button({
        Name = "TP vers Raid Boss",
        Callback = function()
            local root = getBFRoot()
            if not root or not BF_SelectedRaid then return end
            local bm = workspace:FindFirstChild(BF_SelectedRaid.keyword, true)
            if bm then
                local br = bm:FindFirstChild("HumanoidRootPart")
                if br then
                    root.CFrame = CFrame.new(br.Position + Vector3.new(0,5,0))
                    warn("[D4rpHub] TP raid boss actif: " .. BF_SelectedRaid.name)
                    return
                end
            end
            local idata = BF_MobsByIsland[BF_SelectedRaid.island]
            if idata then
                root.CFrame = CFrame.new(idata.pos + Vector3.new(0,5,0))
                warn("[D4rpHub] Raid boss pas spawn, TP île: " .. BF_SelectedRaid.island)
            end
        end
    })

    BF_RaidSection:Toggle({
        Name = "Auto Farm Raid Boss",
        Flag = "BF_AutoRaidFarm",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_AutoRaidFarm"] do
                    local hum = getBFHum()
                    if not hum or hum.Health <= 0 then task.wait(3); continue end
                    if BF_AutoHealEnabled then BF_AutoHeal() end
                    if not BF_SelectedRaid then task.wait(1); continue end
                    local bm = workspace:FindFirstChild(BF_SelectedRaid.keyword, true)
                    if bm then
                        local bh = bm:FindFirstChildOfClass("Humanoid")
                        if bh and bh.Health > 0 then
                            BF_Attack(bm)
                        else
                            warn("[D4rpHub] Raid boss mort, attente respawn: " .. BF_SelectedRaid.name)
                            task.wait(8)
                        end
                    else
                        local idata = BF_MobsByIsland[BF_SelectedRaid.island]
                        if idata then
                            local root = getBFRoot()
                            if root then root.CFrame = CFrame.new(idata.pos + Vector3.new(0,5,0)) end
                        end
                        task.wait(4)
                    end
                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    BF_RaidSection:Toggle({
        Name = "Auto Dark Fragment (rip_indra)",
        Flag = "BF_AutoFragment",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_AutoFragment"] do
                    local hum = getBFHum()
                    if not hum or hum.Health <= 0 then task.wait(3); continue end
                    if BF_AutoHealEnabled then BF_AutoHeal() end
                    local boss = workspace:FindFirstChild("rip_indra", true)
                    if boss then
                        local bh = boss:FindFirstChildOfClass("Humanoid")
                        if bh and bh.Health > 0 then
                            BF_Attack(boss)
                        else
                            task.wait(8)
                        end
                    else
                        local idata = BF_MobsByIsland["SEA 3 - Port Town"]
                        if idata then
                            local root = getBFRoot()
                            if root then root.CFrame = CFrame.new(idata.pos + Vector3.new(0,5,0)) end
                        end
                        task.wait(5)
                    end
                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    -- PVP Section
    local BF_PvpSection = BF_Tab:Section({ Name = "PVP", Side = "Left" })

    local BF_PvpTarget = nil
    local BF_PvpActive = false

    BF_PvpSection:Dropdown({
        Name = "Cible PVP (joueur)",
        Flag = "BF_PvpTarget",
        Content = (function()
            local names = {}
            for _, p in next, BF_Players:GetPlayers() do
                if p ~= BF_LP then table.insert(names, p.Name) end
            end
            if #names == 0 then names = {"(aucun joueur)"}  end
            return names
        end)(),
        Default = "none",
        Callback = function(Value)
            BF_PvpTarget = BF_Players:FindFirstChild(Value)
            if BF_PvpTarget then
                warn("[D4rpHub] PVP cible: " .. Value)
            end
        end
    })

    BF_PvpSection:Button({
        Name = "Refresh liste joueurs",
        Callback = function()
            warn("[D4rpHub] Relance le script pour refresh la liste PVP.")
        end
    })

    BF_PvpSection:Toggle({
        Name = "Auto PVP (attaque cible)",
        Flag = "BF_AutoPvp",
        Default = false,
        Callback = function(Value)
            BF_PvpActive = Value
            task.spawn(function()
                while BF_PvpActive do
                    if BF_AutoHealEnabled then BF_AutoHeal() end
                    local hum = getBFHum()
                    if not hum or hum.Health <= 0 then task.wait(3); continue end
                    local target = BF_PvpTarget
                    if not target or not target.Character then
                        task.wait(1); continue
                    end
                    local tChar = target.Character
                    local tHum = tChar:FindFirstChildOfClass("Humanoid")
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    if tHum and tHum.Health > 0 and tRoot then
                        BF_Attack(tChar)
                    end
                    task.wait(BF_FarmDelay)
                end
            end)
        end
    })

    BF_PvpSection:Toggle({
        Name = "Silent Aim (PVP)",
        Flag = "BF_SilentAim",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_SilentAim"] do
                    if BF_PvpTarget and BF_PvpTarget.Character then
                        local root = BF_PvpTarget.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            workspace.CurrentCamera.CFrame = CFrame.new(
                                workspace.CurrentCamera.CFrame.Position,
                                root.Position
                            )
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    })

    BF_PvpSection:Toggle({
        Name = "Teleport sur cible (PVP)",
        Flag = "BF_PvpTP",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_PvpTP"] do
                    if BF_PvpTarget and BF_PvpTarget.Character then
                        local tRoot = BF_PvpTarget.Character:FindFirstChild("HumanoidRootPart")
                        local myRoot = getBFRoot()
                        if tRoot and myRoot then
                            myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, BF_AttackHeight, 0))
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    })

    BF_PvpSection:Slider({
        Name = "PVP Rayon Kill Aura",
        Flag = "BF_PvpAuraRange",
        Default = 10,
        Min = 5,
        Max = 100,
        Callback = function(Value)
            -- utilisé par Kill Aura PVP
        end
    })

    BF_PvpSection:Toggle({
        Name = "Kill Aura PVP (joueurs)",
        Flag = "BF_PvpAura",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_PvpAura"] do
                    local root = getBFRoot()
                    local range = tonumber(GUI.flags["BF_PvpAuraRange"]) or 10
                    if root then
                        for _, p in next, BF_Players:GetPlayers() do
                            if p ~= BF_LP and p.Character then
                                local pr = p.Character:FindFirstChild("HumanoidRootPart")
                                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                                if pr and ph and ph.Health > 0 then
                                    local d = (pr.Position - root.Position).Magnitude
                                    if d <= range then
                                        pcall(function()
                                            BF_Attack(p.Character)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.15)
                end
            end)
        end
    })

    BF_PvpSection:Toggle({
        Name = "Anti-TP (reste fixe si TP ennemis)",
        Flag = "BF_AntiTP",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                local lastPos = nil
                while Value and GUI.flags["BF_AntiTP"] do
                    local root = getBFRoot()
                    if root then
                        if lastPos and (root.Position - lastPos).Magnitude > 50 then
                            root.CFrame = CFrame.new(lastPos + Vector3.new(0,3,0))
                            warn("[D4rpHub] Anti-TP: retour position précédente")
                        else
                            lastPos = root.Position
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "Anti-Lag (Remove Mesh)",
        Flag = "BF_AntiLag",
        Default = false,
        Callback = function(Value)
            if Value then
                for _, obj in next, workspace:GetDescendants() do
                    if obj:IsA("SpecialMesh") then pcall(function() obj:Destroy() end) end
                end
                workspace.DescendantAdded:Connect(function(obj)
                    if GUI.flags["BF_AntiLag"] and obj:IsA("SpecialMesh") then
                        pcall(function() obj:Destroy() end)
                    end
                end)
            end
        end
    })

    BF_MiscSection:Toggle({
        Name = "Afficher Stats",
        Flag = "BF_ShowStats",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_ShowStats"] do
                    local hum = getBFHum()
                    if hum then
                        warn(string.format("[D4rpHub] HP: %.0f/%.0f | Speed: %.0f", hum.Health, hum.MaxHealth, hum.WalkSpeed))
                    end
                    task.wait(2)
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "Kill Aura Mobs (auto)",
        Flag = "BF_KillAura",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_KillAura"] do
                    local root = getBFRoot()
                    if root then
                        for _, obj in next, workspace:GetDescendants() do
                            if obj:IsA("Model") and obj ~= getBFChar() and not BF_Players:FindFirstChild(obj.Name) then
                                local hum = obj:FindFirstChildOfClass("Humanoid")
                                local r = obj:FindFirstChild("HumanoidRootPart")
                                if hum and hum.Health > 0 and r then
                                    local dist = (r.Position - root.Position).Magnitude
                                    if dist < 25 then pcall(function() hum.Health = 0 end) end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "No Clip (traverse les murs)",
        Flag = "BF_NoClip",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_NoClip"] do
                    local char = getBFChar()
                    if char then
                        for _, part in next, char:GetDescendants() do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.05)
                end
                -- Réactive la collision quand on désactive
                local char = getBFChar()
                if char then
                    for _, part in next, char:GetDescendants() do
                        if part:IsA("BasePart") then
                            pcall(function() part.CanCollide = true end)
                        end
                    end
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "Fake Lag (spam positions)",
        Flag = "BF_FakeLag",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_FakeLag"] do
                    local root = getBFRoot()
                    if root then
                        local pos = root.CFrame
                        for i = 1, 5 do
                            root.CFrame = pos * CFrame.new(math.random(-2,2), 0, math.random(-2,2))
                            task.wait(0.01)
                        end
                        root.CFrame = pos
                    end
                    task.wait(0.05)
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "Auto Respawn rapide",
        Flag = "BF_AutoRespawn",
        Default = false,
        Callback = function(Value)
            task.spawn(function()
                while Value and GUI.flags["BF_AutoRespawn"] do
                    local hum = getBFHum()
                    if hum and hum.Health <= 0 then
                        task.wait(1)
                        local respRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Respawn", true)
                        if respRemote then
                            pcall(function() respRemote:FireServer() end)
                        else
                            BF_LP:LoadCharacter()
                        end
                        task.wait(2)
                    end
                    task.wait(0.5)
                end
            end)
        end
    })

    BF_MiscSection:Toggle({
        Name = "Print Drops (log dans output)",
        Flag = "BF_PrintDrops",
        Default = false,
        Callback = function(Value)
            if Value then
                workspace.DescendantAdded:Connect(function(obj)
                    if not GUI.flags["BF_PrintDrops"] then return end
                    local dropKeywords = {"Drop","Loot","Fruit","Sword","Gun","Accessory","Blox","Item","Reward"}
                    for _, kw in next, dropKeywords do
                        if obj.Name:find(kw) then
                            warn("[D4rpHub] DROP DETECTÉ: " .. obj.Name .. " | Parent: " .. tostring(obj.Parent))
                            break
                        end
                    end
                end)
                warn("[D4rpHub] Print Drops activé — surveille les drops dans l'output.")
            end
        end
    })

    BF_MiscSection:Button({
        Name = "Afficher infos perso",
        Callback = function()
            local hum = getBFHum()
            local root = getBFRoot()
            if hum and root then
                warn(string.format(
                    "[D4rpHub] HP: %.0f/%.0f | Speed: %.0f | Jump: %.0f | Pos: (%.0f, %.0f, %.0f)",
                    hum.Health, hum.MaxHealth, hum.WalkSpeed, hum.JumpPower,
                    root.Position.X, root.Position.Y, root.Position.Z
                ))
            end
        end
    })

    BF_MiscSection:Button({
        Name = "Scan Remotes actifs",
        Callback = function()
            warn("[D4rpHub] ===== SCAN REMOTES =====")
            local rs = game:GetService("ReplicatedStorage")
            for _, obj in next, rs:GetDescendants() do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    warn("[D4rpHub] Remote: " .. obj:GetFullName())
                end
            end
            warn("[D4rpHub] ===== FIN SCAN =====")
        end
    })
end

if ESP and ESP.Load then pcall(ESP.Load) end
if Aimbot and Aimbot.Load then pcall(Aimbot.Load) end
getgenv().D4rpHubLoaded = true
getgenv().D4rpHubLoading = nil

warn("[D4rpHub] ✅ Chargé avec succès | Jeu: " .. CurrentGame .. " | github.com/assomist/d4rphub")

GeneralSignal:Fire()

for _ = 1, 3 do
	wait(0.1); GUI:Close()
end
