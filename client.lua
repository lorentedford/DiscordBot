local DeathReason

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPlayerDead(PlayerId()) then
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			local DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			local Killer

			if IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			else
				Killer = nil
			end
			
			if (Killer == PlayerId()) then
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				DeathReason = 'died'
			else
				if DeathCauseHash == GetHashKey('WEAPON_CROWBAR') or DeathCauseHash == GetHashKey('WEAPON_BAT') or 
				   DeathCauseHash == GetHashKey('WEAPON_UNARMED') or  DeathCauseHash == GetHashKey('WEAPON_GOLFCLUB') or
				   DeathCauseHash == GetHashKey('WEAPON_HAMMER') or  DeathCauseHash == GetHashKey('WEAPON_NIGHTSTICK') then
					DeathReason = 'murdered'
				elseif DeathCauseHash == GetHashKey('WEAPON_MOLOTOV') then
					DeathReason = 'torched'
				elseif DeathCauseHash == GetHashKey('WEAPON_DAGGER') or DeathCauseHash == GetHashKey('WEAPON_KNIFE') or
					   DeathCauseHash == GetHashKey('WEAPON_SWITCHBLADE') or DeathCauseHash == GetHashKey('WEAPON_HATCHET') or
					   DeathCauseHash == GetHashKey('WEAPON_BOTTLE') then
					DeathReason = 'knifed'
				elseif DeathCauseHash == GetHashKey('WEAPON_SNSPISTOL') or DeathCauseHash == GetHashKey('WEAPON_HEAVYPISTOL') or
					   DeathCauseHash == GetHashKey('WEAPON_VINTAGEPISTOL') or DeathCauseHash == GetHashKey('WEAPON_PISTOL') or
					   DeathCauseHash == GetHashKey('WEAPON_APPISTOL') or DeathCauseHash == GetHashKey('WEAPON_COMBATPISTOL') then
					DeathReason = 'pistoled'
				elseif DeathCauseHash == GetHashKey('WEAPON_MICROSMG') or DeathCauseHash == GetHashKey('WEAPON_SMG') then
					DeathReason = 'riddled'
				elseif DeathCauseHash == GetHashKey('WEAPON_CARBINERIFLE') or DeathCauseHash == GetHashKey('WEAPON_MUSKET') or
					   DeathCauseHash == GetHashKey('WEAPON_ADVANCEDRIFLE') or DeathCauseHash == GetHashKey('WEAPON_ASSAULTRIFLE') or
					   DeathCauseHash == GetHashKey('WEAPON_SPECIALCARBINE') or DeathCauseHash == GetHashKey('WEAPON_COMPACTRIFLE') or
					   DeathCauseHash == GetHashKey('WEAPON_BULLPUPRIFLE') then
					DeathReason = 'rifled'
				elseif DeathCauseHash == GetHashKey('WEAPON_MG') or DeathCauseHash == GetHashKey('WEAPON_COMBATMG') then
					DeathReason = 'machine gunned'
				elseif DeathCauseHash == GetHashKey('WEAPON_BULLPUPSHOTGUN') or DeathCauseHash == GetHashKey('WEAPON_ASSAULTSHOTGUN') or
					   DeathCauseHash == GetHashKey('WEAPON_DBSHOTGUN') or DeathCauseHash == GetHashKey('WEAPON_PUMPSHOTGUN') or
					   DeathCauseHash == GetHashKey('WEAPON_HEAVYSHOTGUN') or DeathCauseHash == GetHashKey('WEAPON_SAWNOFFSHOTGUN') then
					DeathReason = 'pulverized'
				elseif DeathCauseHash == GetHashKey('WEAPON_MARKSMANRIFLE') or DeathCauseHash == GetHashKey('WEAPON_SNIPERRIFLE') or
					   DeathCauseHash == GetHashKey('WEAPON_HEAVYSNIPER') or DeathCauseHash == GetHashKey('WEAPON_ASSAULTSNIPER') or
					   DeathCauseHash == GetHashKey('WEAPON_REMOTESNIPER') then
					DeathReason = 'sniped'
				elseif DeathCauseHash == GetHashKey('WEAPON_GRENADELAUNCHER') or DeathCauseHash == GetHashKey('WEAPON_RPG') or
					   DeathCauseHash == GetHashKey('WEAPON_FLAREGUN') or DeathCauseHash == GetHashKey('WEAPON_HOMINGLAUNCHER') or
					   DeathCauseHash == GetHashKey('WEAPON_FIREWORK') or DeathCauseHash == GetHashKey('VEHICLE_WEAPON_TANK') then
					DeathReason = 'obliterated'
				elseif DeathCauseHash == GetHashKey('WEAPON_MINIGUN') then
					DeathReason = 'shredded'
				elseif DeathCauseHash == GetHashKey('WEAPON_GRENADE') or DeathCauseHash == GetHashKey('WEAPON_PROXMINE') or
					   DeathCauseHash == GetHashKey('WEAPON_EXPLOSION') or DeathCauseHash == GetHashKey('WEAPON_STICKYBOMB') then
					DeathReason = 'bombed'
				elseif DeathCauseHash == GetHashKey('VEHICLE_WEAPON_ROTORS') then
					DeathReason = 'mowed over'
				elseif DeathCauseHash == GetHashKey('WEAPON_RUN_OVER_BY_CAR') or DeathCauseHash == GetHashKey('WEAPON_RAMMED_BY_CAR') then
					DeathReason = 'flattened'
				else
					DeathReason = 'killed'
				end
			end
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	if DeathReason then
		if DeathReason == 'committed suicide' then
			TriggerServerEvent('PlayerDied', GetPlayerName(PlayerId()) .. ' committed suicide.')
		elseif DeathReason == 'died' then
			TriggerServerEvent('PlayerDied', GetPlayerName(PlayerId()) .. ' died.')
		else
			TriggerServerEvent('PlayerDied', GetPlayerName(PlayerId()) .. ' ' .. DeathReason .. ' ' .. GetPlayerName(PlayerId()) .. '.')
		end
		DeathReason = nil
	end
end)

