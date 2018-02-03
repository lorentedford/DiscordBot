-- YOU JUST HAVE TO EDIT THE CONFIG.LUA!

-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!
-- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE! -- DO NOT EDIT THESE!

-- Error Check
if DiscordWebhookSystemInfos == nil and DiscordWebhookKillinglogs == nil and DiscordWebhookChat == nil then
	local Content = LoadResourceFile(GetCurrentResourceName(), 'config.lua')
	Content = load(Content)
	Content()
end
if DiscordWebhookSystemInfos == 'WEBHOOK_LINK_HERE' then
	print(GetCurrentResourceName() .. ': Please add your "System Infos" Webhook')
end
if DiscordWebhookKillinglogs == 'WEBHOOK_LINK_HERE' then
	print(GetCurrentResourceName() .. ': Please add your "Killing Log" Webhook')
end
if DiscordWebhookChat == 'WEBHOOK_LINK_HERE' then
	print(GetCurrentResourceName() .. ': Please add your "Chat" Webhook')
end
	
-- System Infos

PerformHttpRequest(DiscordWebhookSystemInfos, function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM Server Webhook Started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('playerConnecting', function()
	ToDiscord(DiscordWebhookSystemInfos, SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```', SystemAvatar)
end)

AddEventHandler('playerDropped', function(Reason)
	ToDiscord(DiscordWebhookSystemInfos, SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```', SystemAvatar)
end)


-- Killing Log

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
	ToDiscord(DiscordWebhookKillinglogs, SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar)
end)


-- Chat

AddEventHandler('chatMessage', function(Source, Name, Message)
	if Message == nil or Message == '' then
		return false
	end
	
	local newMessage = Message
	local newName = Name
	
	for i = 0, 9 do
		newMessage = newMessage:gsub('%^' .. i, '')
		newName = newName:gsub('%^' .. i, '')
	end
	
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
						ToDiscord(DiscordWebhookChat, newName .. ' [ ServerID: ' .. Source .. ' ]', newMessage, AvatarURL)
						break
					end
				end
			end)
		else
			ToDiscord(DiscordWebhookChat, newName .. ' [ ServerID: ' .. Source .. ' ]', newMessage, AvatarURL)
		end
	end
end)

-- Functions

function ToDiscord(Type, Name, Message, Image)
	if Message == nil or Message == '' then
		return false
	end
	
	PerformHttpRequest(Type, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image}), { ['Content-Type'] = 'application/json' })
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


-- Version Checking down here, better don't touch this

local CurrentVersion = '1.4.2'
local UpdateAvailable = false
local GithubResourceName = 'DiscordBot'

PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/' .. GithubResourceName .. '_Resources/master/VERSION', function(Error, NewestVersion, Header)
	PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/' .. GithubResourceName .. '_Resources/master/CHANGES', function(Error, Changes, Header)
		print('\n')
		print('####################################################################')
		print('############################ ' .. GithubResourceName .. ' ############################')
		print('####################################################################')
		print('#####                  Current Version: ' .. CurrentVersion .. '                  #####')
		print('#####                   Newest Version: ' .. NewestVersion .. '                  #####')
		print('####################################################################')
		if CurrentVersion ~= NewestVersion then
			PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/' .. GithubResourceName .. '_Resources/master/PREVIOUSVERSION', function(Error, PreviousVersion, Header)
				if CurrentVersion == PreviousVersion then
					UpdateAvailable = true
				end
			end)
			print('############################# Outdated #############################')
			print('######################### Check the Topic ##########################')
			if UpdateAvailable then
				print('################### Or type "update ' .. GetCurrentResourceName() .. '" ###################')
			end
			print('##################### For the newest Version! ######################')
			print('####################################################################')
			print('CHANGES: ' .. Changes)
		else
			UpdateAvailable = false
			print('#####                        Up to date!                       #####')
			print('####################################################################')
		end
		print('\n')
	end)
end)


-- Instant Update down here, better don't touch this as well

AddEventHandler('rconCommand', function(CMDName, Arguments)
    if CMDName:lower() == 'update' then
		if #Arguments == 1 then
			if Arguments[1]:lower() == GetCurrentResourceName():lower() then
				TriggerEvent(GetCurrentResourceName() .. ':StartUpdate')
			end
		else
			print('Argument count mismatch (Passed: ' .. #Arguments .. ', Wanted: 1)')
		end
		CancelEvent()
	end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':StartUpdate')
AddEventHandler(GetCurrentResourceName() .. ':StartUpdate', function()
	if UpdateAvailable then
		PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/' .. GithubResourceName .. '_Resources/master/CHANGEDFILES', function(Error, Content, Header)
			ContentSplitted = stringsplit(Content, '\n')
			for k, Line in ipairs(ContentSplitted) do
				local PreviousContent = ''
				if Line:find('-add') then
					Line = Line:gsub('-add')
					PreviousContent = LoadResourceFile(GetCurrentResourceName(), Line) .. '\n'
				end
				PerformHttpRequest('https://raw.githubusercontent.com/Flatracer/' .. GithubResourceName .. '/master/' .. Line, function(Error, NewContent, Header)
					SaveResourceFile(GetCurrentResourceName(), Line, PreviousContent .. NewContent, -1)
				end)
			end
		end)
		print('Update finished! Enter "restart ' .. GetCurrentResourceName() .. '" now!')
	else
		print('This is already the newest version! [' .. CurrentVersion .. ']')
	end
end)

-- Functions

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

