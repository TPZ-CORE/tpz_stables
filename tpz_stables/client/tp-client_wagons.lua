local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function GetWagonModelData(model)

    for index, category in pairs (Config.Wagons) do

        for _, wagon in pairs (category.Wagons) do

            if model == wagon[1] then
                return wagon
            end

        end

    end

    return nil

end

function GetPlayerWagons(charIdentifier)

    local PlayerData = GetPlayerData()

	local length = TPZ.GetTableLength(PlayerData.Wagons)

	if length <= 0 then
		return { count = 0, wagonsIndex = {} }
	end

	local currentWagons = {}
	local count  = 0

	for index, wagon in pairs (PlayerData.Wagons) do

		if tonumber(wagon.charidentifier) == tonumber(charIdentifier) then
			count = count + 1

			table.insert(currentWagons, wagon.id)
		end

	end

	return { count = count, wagonsIndex = currentWagons }
end

function LoadWagonComponents(entity, wagonId)

    local PlayerData = GetPlayerData()
    local WagonData  = PlayerData.Wagons[wagonId]

    if WagonData then

        for equipmentType, equipmentValue in pairs (WagonData.components) do

            if equipmentValue ~= 0 then

                local categoryIndex = GetComponentCategoryIndexByType(equipmentType)

                local EquipmentData = Config.Equipments[categoryIndex]
                local ComponentData = EquipmentData.Types[equipmentValue]

                local componentHash = tostring(ComponentData[1])
                local model         = GetHashKey(tonumber(componentHash))
    
                if not HasModelLoaded(model) then
                    Citizen.InvokeNative(0xFA28FE3A6246FC30, model)
                end
    
                Citizen.InvokeNative(0xD3A7B003ED343FD9, entity, tonumber(componentHash), true, true, true)
            end

        end

        Citizen.InvokeNative(0xAAB86462966168CE, entity, true)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, false, true, true, true, false)

    end

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local PlayerData = GetPlayerData()

    if PlayerData.SpawnedWagonEntity then
        local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
        RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
    end

end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_stables:client:updateWagon')
AddEventHandler('tpz_stables:client:updateWagon', function(cb)
	local PlayerData = GetPlayerData()
	local wagonIndex, action, data = cb.wagonIndex, cb.action, cb.data

    wagonIndex = tonumber(wagonIndex)

    if action == 'REGISTER' then

        local wagon_data = {
            id             = wagonIndex,
            identifier     = data[1],
            charidentifier = data[2],
            model          = data[3],
            name           = 'N/A',
            stats          = { body = 1000, wheels = 0 },
            components     = { colors = 0, livery = 0, props = 0, lights = 0 },
            type           = data[4],
            bought_account = data[5],
            container      = data[6],
            date           = data[7],
            loaded_components  = false,
        }

        print(wagonIndex)
        PlayerData.Wagons[wagonIndex] = wagon_data

    elseif action == 'TRANSFERRED' then

        if PlayerData.SpawnedWagonEntity and PlayerData.SpawnedWagonIndex == wagonIndex then
            local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
        end

        PlayerData.Wagons[wagonIndex].identifier     = data[1]
        PlayerData.Wagons[wagonIndex].charidentifier = data[2]

        PlayerData.Wagons[wagonIndex].loaded_components = false

    elseif action == 'DELETE' then

        if PlayerData.SpawnedWagonEntity and PlayerData.SpawnedWagonIndex == wagonIndex then
            local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
        end

        print('removed')

        PlayerData.Wagons[wagonIndex] = nil

	elseif action == 'NETWORK_ID' then
        
        PlayerData.Wagons[wagonIndex].entity = data[1]
        PlayerData.Wagons[wagonIndex].loaded_components = false
        PlayerData.Wagons[wagonIndex].loaded_prompts    = false

    elseif action == 'UPDATE_COMPONENTS' then

        PlayerData.Wagons[wagonIndex].components = data[1]

	elseif action == 'RENAME' then
		PlayerData.Wagons[wagonIndex].name = data[1]
	end

end)