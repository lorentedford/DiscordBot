--local DiscordWebhook = 'WEBHOOK_LINK_HERE'
local DiscordWebhook = 'https://discordapp.com/api/webhooks/397531505791991819/9B8R9uR_sw7G2KoiB5eN1EbtplImBMd3WQNWjVe6BY8y2pLUa3xjCT7K3znOrFO_B1PW'

local SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

local UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

local SystemName = 'SYSTEM'

--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command

-- These Special Commands will be printed differently in Discord, depending on what you set it to
local SpecialCommands = {
						 {'/ooc', '**[OOC]:**'},
						 {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
						}

-- These Blacklisted Commands will not be printed in Discord
local BlacklistedCommands = {
							 '/fix',
							 '/revive',
							}

PerformHttpRequest(DiscordWebhook, function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM Server Webhook Started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('chatMessage', function(Source, Name, Message)
	if Message == nil or Message == '' then
		return false
	end
	
	local newMessage = Message
	
	if IsSpecialCommand(newMessage) then
		newMessage = ReplaceSpecialCommand(newMessage, Source)
	end
	
	if not IsBlacklistedCommand(Message) then
		if GetIDFromSource('steam', Source) then
			local SteamIDHex = GetIDFromSource('steam', Source)
			local SteamIDInt = tonumber(SteamIDHex, 16)
			local AvatarURL
			PerformHttpRequest('http://steamcommunity.com/profiles/' .. SteamIDInt .. '/?xml=1', function(Error, Content, Head)
				local SteamProfileInfosSplitted = stringsplit(Content, '\n')
				for i, Info in ipairs(SteamProfileInfosSplitted) do
					if Info:find('<avatarFull>') then
						local AvatarURL = Info:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
						ToDiscord(Name .. ' [ ServerID: ' .. Source .. ' ]', newMessage, AvatarURL)
					end
				end
			end)
		else
			ToDiscord(Name .. ' [ ServerID: ' .. Source .. ' ]', newMessage, AvatarURL)
		end
	end
end)

AddEventHandler('playerConnecting', function()
	ToDiscord(SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```', SystemAvatar)
end)

AddEventHandler('playerDropped', function(Reason)
	ToDiscord(SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```', SystemAvatar)
end)

RegisterServerEvent('PlayerDied')
AddEventHandler('PlayerDied', function(Message, Weapon)
	local date = os.date('*t')
	
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	if Weapon then
		Message = Message .. ' [' .. Weapon .. ']'
	end
	ToDiscord(SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar)
end)

function ToDiscord(Name, Message, Image)
	if Message == nil or Message == '' then
		return false
	end
	
	PerformHttpRequest(DiscordWebhook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image}), { ['Content-Type'] = 'application/json' })
end

function IsBlacklistedCommand(String)
	local newStringSplitted = stringsplit(String, ' ')
	for i, BlacklistedCommand in ipairs(BlacklistedCommands) do
		if newStringSplitted[1]:lower() == BlacklistedCommand:lower() then
			return true
		end
	end
	return false
end

function IsSpecialCommand(String)
	local newStringSplitted = stringsplit(String, ' ')
	for i, SpecialCommand in ipairs(SpecialCommands) do
		if newStringSplitted[1]:lower() == SpecialCommand[1]:lower() then
			return true
		end
	end
	return false
end

function ReplaceSpecialCommand(String, Source)
	local StringSplitted = stringsplit(String, ' ')
	for i, SpecialCommand in ipairs(SpecialCommands) do
		if StringSplitted[1]:lower() == SpecialCommand[1]:lower() then
			StringSplitted[1] = SpecialCommand[2]
			local newString = ''
			for k, StringPart in ipairs(StringSplitted) do
				if newString == '' then
					newString = StringPart
				else
					newString = newString .. ' ' .. StringPart
				end
			end
			newString = newString:gsub('USERNAME_NEEDED_HERE', GetPlayerName(Source))
			newString = newString:gsub('USERID_NEEDED_HERE', Source)
			return newString
		end
	end
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

-- Version Checking down here, better don't touch

local CurrentVersion = '1.3.1'

PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/DiscordBot_Resources/master/VERSION', function(Error, NewestVersion, Header)
	PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/DiscordBot_Resources/master/CHANGES', function(Error, Changes, Header)
		print('\n')
		print('####################################################################')
		print('############################ Discord Bot ###########################')
		print('####################################################################')
		print('#####                  Current Version: ' .. CurrentVersion .. '                  #####')
		print('#####                   Newest Version: ' .. NewestVersion .. '                  #####')
		print('####################################################################')
		if CurrentVersion ~= NewestVersion then
			print('##### Outdated, please check the Topic for the newest Version! #####')
			print('####################################################################')
			print('CHANGES:\n' .. Changes)
		else
			print('#####                        Up to date!                       #####')
			print('####################################################################')
		end
		print('\n')
	end)
end)
