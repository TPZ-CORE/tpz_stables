
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

RegisterServerEvent('tpz_stables:server:sell_tamed_horse')
AddEventHandler('tpz_stables:server:sell_tamed_horse', function(horseIndex)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)

    local HorseData      = TamingHorses[horseIndex]

    if (HorseData == nil) or (HorseData and HorseData.entity == 0) then
        SendNotification(_source, Locales['ONLY_TAMED_HORSES_CAN_BE_SOLD'], "error")
        return
    end

    local ModelData = GetHorseModelData(HorseData.model)

    local receiveMoney = ModelData[7]
    local sellDescription = string.format(Locales['HORSE_SOLD_CASH'], receiveMoney)

    xPlayer.addAccount(0, receiveMoney)

    SendNotification(_source, sellDescription, "success")

    TamingHorses[horseIndex].source = 0
    TamingHorses[horseIndex].tamed  = 0
    TamingHorses[horseIndex].entity = 0

    local entity = NetworkGetEntityFromNetworkId(HorseData.entity)

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    local coords = vector3(HorseData.coords.x, HorseData.coords.y, HorseData.coords.z)
    TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { 
        horseIndex = horseIndex, 
        action = 'SOLD', 
        data = {} 
    }, coords, 350.0, 1000, true, 40)

    if Config.Webhooks['SOLD_TAMED_HORSE'].Enabled then

        local _w, _c      = Config.Webhooks['SOLD_TAMED_HORSE'].Url, Config.Webhooks['SOLD_TAMED_HORSE'].Color
        local title       = "🐎`Player Sold Tamed Horse`"
        local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has sold a tamed horse.\n\n**Horse Model:** `%s (%s)`.\n\n **Received:** `%s`.',
        steamName, identifier, charIdentifier, HorseData.model, ModelData[2], receiveMoney .. ' ' .. Locales['DOLLARS'])

        TPZ.SendToDiscord(_w, title, description, _c)
    end

end)

RegisterServerEvent('tpz_stables:server:tamed_horse_ownership')
AddEventHandler('tpz_stables:server:tamed_horse_ownership', function(horseIndex)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)
	local group          = xPlayer.getGroup()
	local job            = xPlayer.getJob()

    local HorseData      = TamingHorses[horseIndex]

    if (HorseData == nil) or (HorseData and HorseData.entity == 0) then
        SendNotification(_source, Locales['ONLY_TAMED_HORSES'], "error")
        return
    end

    local currentHorses  = GetPlayerHorses(charIdentifier)	
	local count          = currentHorses.count

	local maxHorsesLimit = GetPlayerMaximumHorsesLimit(identifier, group, job)

	if count >= maxHorsesLimit then
		SendNotification(_source, Locales['REACHED_HORSES_LIMIT'], "error", 3000 )
		return
	end

	SendNotification(_source, Locales['SUCCESSFULLY_RECEIVED_TAMED_HORSE'], "success", 5000 )

    TamingHorses[horseIndex].source = 0
    TamingHorses[horseIndex].tamed  = 0
    TamingHorses[horseIndex].entity = 0

    local entity = NetworkGetEntityFromNetworkId(HorseData.entity)

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    local coords = vector3(HorseData.coords.x, HorseData.coords.y, HorseData.coords.z)
    TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateTamingHorse", { 
        horseIndex = horseIndex, 
        action = 'RECEIVED', 
        data = {} 
    }, coords, 350.0, 1000, true, 40)

    local date          = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
	local randomAge     = math.random(Config.Ageing.StartAdultAge.min, Config.Ageing.StartAdultAge.max)
	randomAge           = math.floor(randomAge * 1440)

	local randomSex     = math.random(0, 1)

    local ModelData     = GetHorseModelData(HorseData.model)
    local category      = GetHorseModelCategory(HorseData.model)

	local Parameters = { 
		['identifier']     = identifier,
		['charidentifier'] = charIdentifier,
		['model']          = HorseData.model,
		['name']           = 'N/A',
		['stats']          = json.encode( { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 } ),
		['components']     = json.encode( { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 }),
		['type']           = category,
		['age']            = randomAge,
		['sex']            = randomSex,
		['bought_account'] = 0,
		['training_stage_type'] = Config.Trainers.HorseTraining.Stages[1].Type,
		['date']           = date,
	}

	exports.ghmattimysql:execute("INSERT INTO `horses` ( `identifier`, `charidentifier`, `model`, `name`, `stats`, `components`, `type`, `age`, `sex`, `bought_account`, `date`, `training_stage_type` ) VALUES ( @identifier, @charidentifier, @model, @name, @stats, @components, @type, @age, @sex, @bought_account, @date, @training_stage_type )", Parameters)

	Wait(1500)

	exports["ghmattimysql"]:execute("SELECT `id` FROM `horses` WHERE `date` = @date", { ["@date"] = date }, function(result)

		if result and result[1] then

			local horse_data = {
				identifier           = identifier,
				charidentifier       = charIdentifier,
				model                = HorseData.model,
				name                 = 'N/A',
				stats                = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
				components           = { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 },
				type                 = category,
				age                  = randomAge,
				sex                  = randomSex,
				training_experience  = 0,
				training_stage_index = 1,
				training_stage_type  = Config.Trainers.HorseTraining.Stages[1].Type,
				breeding             = 0,
				bought_account       = 0,
				container            = 0,
				date                 = date,
				isdead               = 0,
			}

			local Horses = GetHorses()

			Horses[result[1].id]    = {}
			Horses[result[1].id]    = horse_data
			Horses[result[1].id].id = result[1].id

			Horses[result[1].id].entity = 0
			Horses[result[1].id].source = _source

			TriggerEvent("tpz_inventory:registerContainerInventory", "horse_" .. result[1].id, Config.Storages.Horses.MaxWeightCapacity, true)

			Wait(2500) -- mandatory wait.
			local containerId = exports.tpz_inventory:getInventoryAPI().getContainerIdByName("horse_" .. result[1].id)
			Horses[result[1].id].container = containerId
	
			exports.ghmattimysql:execute("UPDATE `horses` SET `container` = @container WHERE `id` = @id ", { ['id'] = result[1].id, ['container'] = containerId })

			local ped = GetPlayerPed(_source)
            local playerCoords = GetEntityCoords(ped)

            local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { 
				horseIndex = result[1].id, 
				action = 'REGISTER', 
				data = { identifier, charIdentifier, HorseData.model, category, randomAge, randomSex, 0, containerId, date, _source} 
			}, coords, 350.0, 1000, true, 40)

			if Config.Webhooks['RECEIVED_TAMED_HORSE'].Enabled then

				local _w, _c      = Config.Webhooks['RECEIVED_TAMED_HORSE'].Url, Config.Webhooks['RECEIVED_TAMED_HORSE'].Color

				local title       = "🐎`Player Received Tamed Horse`"
				local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has received a new tamed horse.\n\n**Horse Model:** `%s, %s - %s `.',
				steamName, identifier, charIdentifier, HorseData.model, category, ModelData[2])
	
				TPZ.SendToDiscord(_w, title, description, _c)
			end

		end

	end)

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

            if horse.cooldown > 0 and horse.entity == 0 then

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