local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local function IsLocationPermitted(currentTown)

    if not Config.HorseCalling.PreventCallOnTowns then
        return true
    end

	for k,v in pairs(Config.HorseCalling.BannedTowns) do

		if town == GetHashKey(v) then
			return true
		end

	end

	return false

end

local function IsNearbyStableLocation(coords)

    for stableIndex, stableConfig in pairs(Config.Locations) do

        local coordsDist   = vector3(coords.x, coords.y, coords.z)
        local coordsStable = vector3(stableConfig.Coords.x, stableConfig.Coords.y, stableConfig.Coords.z)
        local distance     = #(coordsDist - coordsStable)

        if (distance <= Config.HorseCalling.CallOnlyNearStablesDistance) then
            return true
        end

    end

    return false

end

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

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local PlayerData = GetPlayerData()

    if PlayerData.SpawnedWagonEntity then
       -- local model = GetHashKey(PlayerData.Wagons[PlayerData.SelectedWagonIndex].model )
     --   RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
    end

end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------
