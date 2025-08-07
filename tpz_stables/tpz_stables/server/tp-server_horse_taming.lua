
local TPZ = exports.tpz_core:getCoreAPI()

local TamingHorses  = {}
local LoadedResults = false

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

local function LoadTamingHorses()

    if Config.Taming.Enabled then

        for _, horse in pairs (Config.Taming.Horses) do

            local randomChance = math.random(0, 100)

            if randomChance <= horse.spawn_chance then 

                TamingHorses[_] = { 
                    id           = _,
                    entity       = 0, 
                    model        = horse.model, 
                    difficulties = horse.difficulties, 
                    coords       = horse.coords,
                    cooldown     = 0,
                    source       = 0,
                    tamed        = 0,
                }

            end

        end

    end

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    LoadTamingHorses()
    LoadedResults = true
end)


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    for _, horse in pairs (TamingHorses) do

        if horse.entity ~= 0 then

            local entity = NetworkGetEntityFromNetworkId(horse.entity)

            if DoesEntityExist(entity) then
        
                DeleteEntity(entity)

            end

        end

    end
  
    TamingHorses = nil
end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:requestTamingHorsesData')
AddEventHandler('tpz_stables:server:requestTamingHorsesData', function()
	local _source = source

    while not LoadedResults do 
        Wait(500)
    end

    TriggerClientEvent('tpz_stables:client:receiveTamingHorsesData', _source, TamingHorses)

end)

RegisterServerEvent('tpz_stables:server:updateTamingHorse')
AddEventHandler('tpz_stables:server:updateTamingHorse', function(horseIndex, action, data)
	local _source = source

	if TamingHorses[horseIndex] == nil then
		return
	end

    local updateActionOnClient = false

    if action == 'REGISTER_SPAWNED' then

        Wait(math.random(1000, 2500))
    
        if TamingHorses[horseIndex].cooldown ~= 0 then
            return
        end

        local cooldown = Config.Taming.RespawnHorses == false and -1 or Config.Taming.RespawnHorses
        
		TamingHorses[horseIndex].cooldown = cooldown
		TamingHorses[horseIndex].source   = _source
		TamingHorses[horseIndex].tamed    = 0

        updateActionOnClient = true
        action = 'COOLDOWN'
        data   = { cooldown }

        TriggerClientEvent("tpz_stables:client:spawnTamingHorse", _source, horseIndex)

    elseif action == 'SET_TAMED' then

		TamingHorses[horseIndex].tamed = data[1]

        updateActionOnClient = true

    elseif action == 'NETWORK_ID' then

		TamingHorses[horseIndex].entity = data[1]

        updateActionOnClient = true

    elseif action == 'FAILED_TAMING' then

        local entity = NetworkGetEntityFromNetworkId(TamingHorses[horseIndex].entity)

        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end

        updateActionOnClient = false

    end

    -- We update the modified data on client for all players through async. 
    if updateActionOnClient then

        local coords

        local updated = false

        if TamingHorses[horseIndex].entity ~= 0 then

            local entity = NetworkGetEntityFromNetworkId(TamingHorses[horseIndex].entity)

            if DoesEntityExist(entity) then

                local tableCoords = GetEntityCoords(entity)
                coords = vector3(tableCoords.x, tableCoords.y, tableCoords.z)
                TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { horseIndex = horseIndex, action = action, data = data }, coords, 500.0, 500, true, 40)
                updated = true
            end

        end

        if not updated then
            local ped = GetPlayerPed(_source)
            local playerCoords = GetEntityCoords(ped)

            local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { horseIndex = horseIndex, action = action, data = data }, coords, 150.0, 1000, true, 40)
            updated = true
        end

    end

end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

if Config.Taming.Enabled then

    local function ArePlayersNearby(x, y, z, radius)
        local playersList = TPZ.GetPlayers()
        local found = false
    
        for _, player in pairs(playersList.players) do

            player.source = tonumber(player.source)

            local horseCoords = vector3(x, y, z)
            local coords      = GetEntityCoords(GetPlayerPed( player.source ))
            local distance    = #(coords - horseCoords)

            if distance <= radius then
                found = true
                break -- stop after finding at least one
            end
        end
    
        return found
    end

    Citizen.CreateThread(function()

        Wait(60000)

        for _, horse in pairs (TamingHorses) do

            if horse.cooldown > 0 then

                horse.cooldown = horse.cooldown - 1

                if horse.cooldown <= 0 then

                    horse.cooldown = 0
                    horse.tamed    = 0

                    local coords = vector3(horse.coords.x, horse.coords.y, horse.coords.z)
                    TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { 
                        horseIndex = horse.id, 
                        action = 'COOLDOWN', 
                        data = { horse.cooldown } 
                    }, coords, 350.0, 1000, true, 40)

                end

            end

            if horse.entity ~= 0 then

                local entity = NetworkGetEntityFromNetworkId(horse.entity)

                if DoesEntityExist(entity) then

                    local entityCoords  = GetEntityCoords(entity)
                    local nearbyPlayers = ArePlayersNearby(entityCoords.x, entityCoords.y, entityCoords.z, Config.Taming.DespawnDistance)
    
                    if not nearbyPlayers then

                        DeleteEntity(entity)

                        TamingHorses[horse.id].cooldown = 0
                        TamingHorses[horse.id].source   = 0
                        TamingHorses[horse.id].tamed    = 0
    
                        local coords = vector3(horse.coords.x, horse.coords.y, horse.coords.z)
                        TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { 
                            horseIndex = horse.id, 
                            action = 'COOLDOWN', 
                            data = { 0 } 
                        }, coords, 350.0, 1000, true, 40)
    
                    end

                end

            end

        end

    end)

end