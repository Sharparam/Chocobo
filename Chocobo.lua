--[[
	Chocobo AddOn
	Made by F16Gaming
	Dedicated to Shishu on Azuremyst-EU
	
	Feel free to modify the code but leave credits!
	
	Information:
		This AddOn plays the chocobo song when mounting on a hawkstrider mount.
		Type /chocobo for options
		Some useful commands:
		/chocobo allmounts   -- Will play chocobo song regardless of mount
		/chocobo hawkstrider -- Only play when on a hawkstrider
	
	CHOCOBO!!!
--]]

local Chocobo = {
	Version	= 2.0,
	Loaded	= false,
	Mounted	= false,
	Songs	= {
		"Interface\\AddOns\\Chocobo\\music\\chocobo.mp3",
		"Interface\\AddOns\\Chocobo\\music\\chocobo_ffiv.mp3"
	},
	Names	= {
		"Black Hawkstrider",
		"Blue Hawkstrider",
		"Purple Hawkstrider",
		"Red Hawkstrider",
		"Silvermoon Hawkstrider",
		"Sunreaver Hawkstrider",
		"Swift Green Hawkstrider",
		"Swift Pink Hawkstrider",
		"Swift Purple Hawkstrider",
		"Swift Red Hawkstrider",
		"Swift White Hawkstrider"
	},
	IDs	= {
		35022, --Black Hawkstrider
		35020, --Blue Hawkstrider
		35018, --Purple Hawkstrider
		34795, --Red Hawkstrider
		63642, --Silvermoon Hawkstrider
		66091, --Sunreaver Hawkstrider
		35025, --Swift Green Hawkstrider
		33660, --Swift Pink Hawkstrider
		35027, --Swift Purple Hawkstrider
		65639, --Swift Red Hawkstrider
		46628  --Swift White Hawkstrider
	}
}

local t = 0

function Chocobo_OnEvent(self, event, ...)
	Chocobo_DebugMsg("OnEvent Fired")
	if (event == "ADDON_LOADED") then
		--Currently, this seems a bit bugged when having multiple addons. The "loaded" message will disappear sometimes.
		local addonName = select(1, ...)
		if (addonName == "Chocobo") then
			Chocobo_Msg("Chocobo version " .. Chocobo.Version .. " has been loaded successfully! Use /chocobo for options")
			Chocobo_Msg("Enjoy your chocobo!")
			Chocobo.Loaded = true
		end
		if (CHOCOBO_DEBUG == nil) then
			--Should be fired on first launch, set the saved variable to default value
			Chocobo_Msg("Debug variable not set, setting debug variable to FALSE")
			CHOCOBO_DEBUG = false
		end
		if (CHOCOBO_ALLMOUNTS == nil) then
			--Should be fired on first launch, set the saved variable to default value
			Chocobo_Msg("AllMounts variable not set, setting AllMounts variable to FALSE")
			CHOCOBO_ALLMOUNTS = false
		end
	elseif (event == "UNIT_AURA" and select(1, ...) == "player") then
		local unitName = select(1, ...)
		Chocobo_DebugMsg("UNIT_AURA Event Detected (" .. unitName .. ")")
		if (Chocobo.Loaded == false) then
			--This should NOT happen
			Chocobo_ErrorMsg("Something is wrong, addon doesn't seem to have loaded correctly")
		end
		t = 0
		ChocoboFrame:SetScript("OnUpdate", Chocobo_OnUpdate)
	end
end

function Chocobo_OnUpdate(_, elapsed)
	t = t + elapsed
	--When 1 second has elapsed, this is because it takes ~0.5 secs from the event detection for IsMounted() to return true.
	if (t >= 1) then
		--Unregister the OnUpdate script
		ChocoboFrame:SetScript("OnUpdate", nil)
		--Is the player mounted?
		if (IsMounted()) then
			Chocobo_DebugMsg("Player is mounted")
			--Loop through all the "hawkstrider" names to see if the player is mounted on one or check if allmounts (override) is true
			if (HasHawkstrider() or CHOCOBO_ALLMOUNTS) then
				Chocobo_DebugMsg("Player is on a hawkstrider or CHOCOBO_ALLMOUNTS is set to true")
				--Check so that the player is not already mounted
				if (Chocobo.Mounted == false) then
					Chocobo_DebugMsg("Playing music")
					Chocobo.Mounted = true
					--Note that in 4.0.1 PlayMusic will NOT stop the game music currently playing. There is no fix for this (Stupid Blizzard)
					local songID = math.random(1, 2)
					Chocobo_DebugMsg(string.format("Playing song id |cff00CCFF%d|r (|cff00CCFF%s|r)", songID, Chocobo.Songs[songID]))
					PlayMusic(Chocobo.Songs[songID])
				else
					--If the player has already mounted
					Chocobo_DebugMsg("Player was already mounted, song already playing")
				end
			else
				--Playeris not on a hawkstrider
				Chocobo_DebugMsg("Player is not on a hawkstrider")
			end
		else
			--When the player has dismounted
			if (Chocobo.Mounted) then
				Chocobo_DebugMsg("Player not mounted, stopping music")
				Chocobo.Mounted = false
				--Note that StopMusic() will also stop any other custom music playing (such as from EpicMusicPlayer)
				StopMusic()
			end
		end
	end
end

function HasHawkstrider()
	for i=1,40 do --Loop through all 40 possible active buffs
		local name,_,_,_,_,_,_,_,_,_,id = UnitAura("player", i) --Get the name and spellID of the buff
		if (name == nil or id == nil) then return false end
		for _,v in pairs(Chocobo.IDs) do --Compare the ID to the ones in the table to see if they match
			if (id == v) then --If they do, report that the player has a hawkstrider and return true
				Chocobo_DebugMsg("Found that \"" .. name .. "\" is your current mount")
				return true
			end
		end
	end
	return false --Else return false
end

function Chocobo_Msg(msg)
	DEFAULT_CHAT_FRAME:AddMessage("\124cff00FF00[Chocobo AddOn]\124r " .. msg)
end

function Chocobo_ErrorMsg(msg)
	DEFAULT_CHAT_FRAME:AddMessage("\124cff00FF00[Chocobo AddOn]\124r \124cffFF0000ERROR:\124r " .. msg)
end

function Chocobo_DebugMsg(msg)
	if (CHOCOBO_DEBUG == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cff00FF00[Chocobo AddOn]\124r \124cffFFFF00DEBUG:\124r " .. msg)
	end
end

SLASH_CHOCOBO1 = "/chocobo"
function SlashCmdList.CHOCOBO(msg, editBox)
	msg = string.lower(msg)
	if (msg == "allmounts") then
		Chocobo_Msg("Now playing chocobo on all mounts!")
		CHOCOBO_ALLMOUNTS = true
	elseif (msg == "hawkstrider") then
		Chocobo_Msg("Now playing chocobo on hawkstriders only!")
		CHOCOBO_ALLMOUNTS = false
	elseif (msg == "debug") then
		if (CHOCOBO_DEBUG) then
			Chocobo_Msg("Debugging is enabled")
		else
			Chocobo_Msg("Debugging is disabled")
		end
	elseif (msg == "debug enable") then
		Chocobo_Msg("Debugging enabled!")
		CHOCOBO_DEBUG = true
	elseif (msg == "debug disable") then
		Chocobo_Msg("Debugging disabled!")
		CHOCOBO_DEBUG = false
	else
		Chocobo_Msg("Commands:")
		Chocobo_Msg("allmounts: play chocobo song on any mount")
		Chocobo_Msg("hawkstrider: only play chocobo song on hawkstriders")
		Chocobo_Msg("debug: check debug status, type enable or disable after to enable or disable debugging")
	end
end

--Create the frame, no need for an XML file!
local ChocoboFrame = CreateFrame("Frame", "ChocoboFrame")
ChocoboFrame:SetScript("OnEvent", Chocobo_OnEvent)
ChocoboFrame:RegisterEvent("ADDON_LOADED")
ChocoboFrame:RegisterEvent("UNIT_AURA")
