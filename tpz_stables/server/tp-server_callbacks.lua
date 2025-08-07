
local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

local GetHorseShoeDataByLabel = function(label)

	for index, shoe in pairs (Config.HorseShoes) do

		if shoe.Label == label then
			return { index = index, data = shoe }
		end

	end

end

-----------------------------------------------------------
--[[ Callbacks  ]]--
-----------------------------------------------------------

exports.tpz_core:getCoreAPI().addNewCallBack("tpz_stables:callbacks:canBrushHorse", function(source, cb)
	local _source = source
	local xPlayer = TPZ.GetPlayer(_source)

	local contents = xPlayer.getInventoryContents()

	if TPZ.GetTableLength(contents) > 0 then

		for index, content in pairs (contents) do

			if content.item == Config.HorseBrushItem.Item then

				if Config.HorseBrushItem.RemoveDurability then

					if content.metadata.durability > 0 then
						xPlayer.removeItemDurability(Config.HorseBrushItem.Item, Config.HorseBrushItem.Value, content.itemId, Config.HorseBrushItem.Destroy)
						return cb(true)
					end

				else
					return cb(true)
				end

			end

		end

	end

	SendNotification(_source, Locales['NO_HORSE_BRUSH'], "error")

	return cb(false)

end)


exports.tpz_core:getCoreAPI().addNewCallBack("tpz_stables:callbacks:hasHorseShoes", function(source, cb, data)
	local _source      = source
	local xPlayer      = TPZ.GetPlayer(_source)
	local ShoeData     = GetHorseShoeDataByLabel(data[2])

	if ShoeData == nil then
		return cb(false)
	end

	local Horses = GetHorses()

	local itemQuantity = xPlayer.getItemQuantity(ShoeData.data.Item)

	if itemQuantity < 4 then
		SendNotification(_source, Locales['NOT_ENOUGH_HORSE_SHOES_QUANTITY'], "error")
		return cb(false)
	end

	xPlayer.removeItem(ShoeData.data.Item, 4)

	Horses[data[1]].stats.shoes_type     = ShoeData.index
	Horses[data[1]].stats.shoes_km_left  = ShoeData.data.MaxKilometers

	SendNotification(_source, Locales['PLACED_HORSE_SHOES'], "success")

	local ped = GetPlayerPed(_source)
	local playerCoords = GetEntityCoords(ped)

	coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)

	TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { 
		horseIndex = data[1], 
		action = 'HORSE_SHOES', 
		data = { ShoeData.index, ShoeData.data.MaxKilometers } 
	}, coords, 50.0, 1500, true, 40)

	return cb(true)
end)

exports.tpz_core:getCoreAPI().addNewCallBack("tpz_stables:callbacks:canBuyComponent", function(source, cb, data)
	local _source      = source
	local xPlayer      = TPZ.GetPlayer(_source)

	local categoryIndex, selectedComponentIndex = data[1], data[2]

	local EquipmentData = Config.Equipments[categoryIndex]
	local ComponentData = EquipmentData.Types[selectedComponentIndex]

	local money         = xPlayer.getAccount(0)
	local cost          = ComponentData[2]

	if money < cost then
		SendNotification(_source, Locales['NOT_ENOUGH_DOLLARS_TO_BUY_COMP'], "error")
		return cb(false)
	end

	xPlayer.removeAccount(0, cost)
	SendNotification(_source, Locales['BOUGHT_COMPONENT'], "error")

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
	
	return cb(true)
end)
