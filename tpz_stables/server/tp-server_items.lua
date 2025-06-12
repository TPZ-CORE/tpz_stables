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

	
end)