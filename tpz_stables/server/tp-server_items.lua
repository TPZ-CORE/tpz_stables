local TPZ    = exports.tpz_core:getCoreAPI()
local TPZInv = exports.tpz_inventory:getInventoryAPI()

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:onFeedItemUse')
AddEventHandler('tpz_stables:server:onFeedItemUse', function(item)
	local _source = source

    if Config.HorseFeedItems[item] == nil then
        return
    end

	TPZInv.removeItem(_source, item, 1)

end)

RegisterServerEvent("tpz_stables:server:revive_item_use")
AddEventHandler("tpz_stables:server:revive_item_use", function(horseIndex)
	local _source = source
	local Horses  = GetHorses()

	horseIndex    = tonumber(horseIndex)

	if Horses[horseIndex] == nil then
		return
	end

	TPZInv.removeItem(_source, Config.HorseDeath.Reviving.Item, 1)

	Horses[horseIndex].stats.health  = 200
	Horses[horseIndex].stats.stamina = 200
	Horses[horseIndex].isdead        = 0

	local ped = GetPlayerPed(_source)
	local playerCoords = GetEntityCoords(ped)

	local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
	TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { 
		horseIndex = horseIndex, 
		action = 'RESURRECT', 
		data = nil 
	}, coords, 350.0, 1000, true, 40)
end)

-----------------------------------------------------------
--[[ Items Registration ]]--
-----------------------------------------------------------

Citizen.CreateThread(function ()
	
	for item, item_data in pairs (Config.HorseFeedItems) do

		TPZInv.registerUsableItem(item, "tpz_stables", function(data)
			local _source = data.source
		
			TriggerClientEvent('tpz_stables:client:onFeedItemUse', _source, item)
		
			TPZInv.closeInventory(_source)
		end)

	end

	if Config.HorseDeath.Reviving.Enabled then

		local IsPermitted = function(currentJob) 

			if Config.HorseDeath.Reviving.Jobs == false then
				return true
			end

			for _, job in pairs (Config.HorseDeath.Reviving.Jobs) do

				if job == currentJob then
					return true
				end

			end

			return false


		end

		TPZInv.registerUsableItem(Config.HorseDeath.Reviving.Item, "tpz_stables", function(data)
			local _source    = data.source
			local currentJob = TPZ.GetPlayer(_source).getJob()
		
			if IsPermitted(currentJob) then

				TriggerClientEvent('tpz_stables:client:revive_item_use', _source)
		
			else

			end

			TPZInv.closeInventory(_source)
		end)

	end

	
end)