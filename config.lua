DiscordWebhookSystemInfos = 'WEBHOOK_LINK_HERE'
DiscordWebhookKillinglogs = 'WEBHOOK_LINK_HERE'
DiscordWebhookChat = 'WEBHOOK_LINK_HERE'

DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/413119686205636639/j0Lzibpk_u9RFSu8Wx9gIMGw5MznP11vf0XCxfQmeqDB3sjAGRAMoeVlfpXiagL1meEZ'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/413119576361009153/5v6kNS1D8s5yxnhcvfnoiZbO0Ejsl63DzALa20ZPbHV9ahHxQrVyw-hi88ogBEodxb81'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/413119341563871244/eduRugpAkzCVGPcBVN8GgmbYXAuJBNDV0lL2xwiP7rC3pqanDvGaYo0bAtRPFn_UmpXB'

SystemAvatar = 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png'

UserAvatar = 'https://i.imgur.com/KIcqSYs.png'

SystemName = 'SYSTEM'


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
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These Blacklisted Commands will not be printed in Discord
BlacklistedCommands = {
					   '/fix',
					   '/revive',
					  }

