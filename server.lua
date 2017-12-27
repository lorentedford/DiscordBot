local DiscordWebhook = 'https://discordapp.com/api/webhooks/395395074759983104/q5p6E1umsXbXnME6IMihyDUtBcYJCKPJyXfrqoRbY3m4Kh33f8jcwoQw0k7wJACIJZu8'

local UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

local SystemName = 'SYSTEM'

PerformHttpRequest(DiscordWebhook, function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM Server Webhook Started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('chatMessage', function(Source, Name, Message)
	if Message == nil or Message == '' then
		return false
	end
	
	PerformHttpRequest(DiscordWebhook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = UserAvatar}), { ['Content-Type'] = 'application/json' })
end)

function ToDiscord(Name, Message)
	if Message == nil or Message == '' then
		return false
	end
	
	PerformHttpRequest(DiscordWebhook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerConnecting', function()
	ToDiscord(SystemName, '```css\n' .. GetPlayerName(source) .. ' connecting\n```')
end)

AddEventHandler('playerDropped', function(Reason)
	ToDiscord(SystemName, '```fix\n' .. GetPlayerName(source) .. ' left (' .. Reason .. ')\n```')
end)

RegisterServerEvent('PlayerDied')
AddEventHandler('PlayerDied', function(Message)
	local now = os.date('*t')
	
	if now.day < 10 then now.day = '0' .. tostring(now.day) end
	if now.month < 10 then now.month = '0' .. tostring(now.month) end
	if now.hour < 10 then now.hour = '0' .. tostring(now.hour) end
	if now.min < 10 then now.min = '0' .. tostring(now.min) end
	if now.sec < 10 then now.sec = '0' .. tostring(now.sec) end
	ToDiscord(SystemName, Message .. ' **(' .. now.day .. '.' .. now.month .. '.' .. now.year .. ' - ' .. now.hour .. ':' .. now.min .. ':' .. now.sec .. ')**')
end)