
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
