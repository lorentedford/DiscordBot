resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Discord Bot' 			-- Resource Description

server_script {						-- Server Scripts
	'config.lua',
	'server/server.lua',
}
client_script 'client/client.lua'	-- Client Script

