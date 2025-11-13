local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function GetHorseModelCategory(model)
    for index, category in pairs (Config.Horses) do

        for _, horse in pairs (category.Horses) do

            if model == horse[1] then
                return category.Category
            end

        end

    end

    return "N/A"
end

function GetHorseModelData(model)

    for index, category in pairs (Config.Horses) do

        for _, horse in pairs (category.Horses) do

            if model == horse[1] then
                return horse
            end

        end

    end

    return nil

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

-- We reset the source and delete a horse if spawned when player is dropped (disconnected).
AddEventHandler('playerDropped', function (reason)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)

	if not xPlayer.loaded() then 
		return 
	end
		
	local charIdentifier = xPlayer.getCharacterIdentifier()

	local Horses         = GetHorses()

	if TPZ.GetTableLength(Horses) > 0 then

		local currentHorses  = GetPlayerHorses(charIdentifier)	

		for _, horseIndex in pairs (currentHorses.horsesIndex) do
	
			local HorseData = Horses[tonumber(horseIndex)]
	
			if HorseData.entity and HorseData.entity ~= 0 then
	
				local entity = NetworkGetEntityFromNetworkId(HorseData.entity)
                local coords

				if DoesEntityExist(entity) then
                    local tableCoords = GetEntityCoords(entity)
                    coords = vector3(tableCoords.x, tableCoords.y, tableCoords.z)
					DeleteEntity(entity)
				else
                    coords = vector3(0.0, 0.0, 0.0)
                end

                Horses[tonumber(horseIndex)].entity = 0
                TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { horseIndex = tonumber(horseIndex), action = "NETWORK_ID", data = { 0 } }, coords, 200.0, 500, true, 40)
			end
			
			HorseData.source = 0
	
		end

	end

end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:buyHorse')
AddEventHandler('tpz_stables:server:buyHorse', function(locationIndex, categoryIndex, modelIndex, account)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)
	local group          = xPlayer.getGroup()
	local job            = xPlayer.getJob()

	local StableData     = Config.Locations[locationIndex]
	local HorseData      = Config.Horses[categoryIndex].Horses[modelIndex]

	local currentHorses  = GetPlayerHorses(charIdentifier)	
	local count          = currentHorses.count

	local maxHorsesLimit = GetPlayerMaximumHorsesLimit(identifier, group, job)

	if count >= maxHorsesLimit then
		TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales['REACHED_HORSES_LIMIT'], "error", 3000 )
		return
	end

	local money  = xPlayer.getAccount(0)
	local cost   = HorseData[3]
	local isGold = false
	local notEnoughDisplay = Locales['NOT_ENOUGH_TO_BUY_HORSE']
	local paidDescription  = cost .. " dollars."

	-- If the selected account is gold, we check for gold.
	if account and Locales['INPUT_BUY_CURRENCIES'][2] == account then
		isGold = true

		money = xPlayer.getAccount(1)
		cost  = HorseData[4]
		notEnoughDisplay  = Locales['NOT_ENOUGH_TO_BUY_HORSE_GOLD']

		paidDescription = cost .. " gold."
	end

	if money < cost then
		TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, notEnoughDisplay, "error", 3000)
		return
	end

	if not isGold then
		xPlayer.removeAccount(0, cost)
	else
		xPlayer.removeAccount(1, cost)
	end

    SendNotification(_source, Locales['HORSE_NOTIFY_TITLE'], Locales["SUCCESSFULLY_BOUGHT_A_HORSE"], "success", 5, "horse", "left")

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
	
	local date          = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
	local randomAge     = math.random(Config.Ageing.StartAdultAge.min, Config.Ageing.StartAdultAge.max)
	randomAge           = math.floor(randomAge * 1440)

	local randomSex     = math.random(0, 1)
	local boughtAccount = isGold and 1 or 0

	local Parameters = { 
		['identifier']     = identifier,
		['charidentifier'] = charIdentifier,
		['model']          = HorseData[1],
		['name']           = 'N/A',
		['stats']          = json.encode( { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 } ),
		['components']     = json.encode( { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 }),
		['type']           = Config.Horses[categoryIndex].Category,
		['age']            = randomAge,
		['sex']            = randomSex,
		['bought_account'] = boughtAccount,
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
				model                = HorseData[1],
				name                 = 'N/A',
				stats                = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
				components           = { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 },
				type                 = Config.Horses[categoryIndex].Category,
				age                  = randomAge,
				sex                  = randomSex,
				training_experience  = 0,
				training_stage_index = 1,
				training_stage_type  = Config.Trainers.HorseTraining.Stages[1].Type,
				breeding             = 0,
				bought_account       = boughtAccount,
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
				data = { identifier, charIdentifier, HorseData[1], Config.Horses[categoryIndex].Category, randomAge, randomSex, boughtAccount, containerId, date, _source} 
			}, coords, 350.0, 1000, true, 40)

			if Config.Webhooks['BOUGHT'].Enabled then

				local ModelData = GetHorseModelData(HorseData[1])

				local category    = Config.Horses[categoryIndex].Category
				local _w, _c      = Config.Webhooks['BOUGHT'].Url, Config.Webhooks['BOUGHT'].Color

				local title       = "🐎`Player Bought Horse`"
				local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has bought a new horse.\n\n**Horse Model:** `%s, %s - %s `.\n\n **Paid:** `%s`.',
				steamName, identifier, charIdentifier, HorseData[1], category, ModelData[2], paidDescription)
	
				TPZ.SendToDiscord(_w, title, description, _c)
			end

		end

	end)
	
end)

RegisterServerEvent('tpz_stables:server:sellHorse')
AddEventHandler('tpz_stables:server:sellHorse', function(horseIndex)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)

	local Horses          = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

	exports["ghmattimysql"]:execute("SELECT `selected_horse_index` FROM `characters` WHERE `charidentifier` = @charidentifier", { ["@charidentifier"] = charIdentifier }, function(result)

		local HorseData = Horses[horseIndex]
		local ModelData = GetHorseModelData(HorseData.model)
	
		local receiveMoney, receiveGold = ModelData[7], ModelData[8]
	
		local sellDescription, receivedDescription
	
		if HorseData.bought_account == 0 then
			sellDescription = string.format(Locales['HORSE_SOLD_CASH'], receiveMoney)
	
			xPlayer.addAccount(0, receiveMoney)

			receivedDescription = receiveMoney .. " dollars."
	
		elseif HorseData.bought_account == 1 then
			sellDescription = string.format(Locales['HORSE_SOLD_GOLD'], receiveGold)
	
			xPlayer.addAccount(1, receiveGold)

			receivedDescription = receiveGold .. " gold."
	
		elseif HorseData.bought_account == -1 then
			sellDescription = Locales['HORSE_SOLD_NO_EARNINGS']

			receivedDescription = "nothing"
		end

        SendNotification(_source, Locales['HORSE_NOTIFY_TITLE'], sellDescription, "success", 5, "horse", "left")

		-- We reset the selected horse index.
		if result and result[1] then

			if tonumber(result[1].selected_horse_index) == horseIndex then

				local Parameters = { 
					["charidentifier"]       = charIdentifier,
					['selected_horse_index'] = 0,
				}
		
				exports.ghmattimysql:execute("UPDATE `characters` SET `selected_horse_index` = @selected_horse_index WHERE `charidentifier` = @charidentifier", Parameters)
			
				TriggerClientEvent("tpz_stables:client:resetSelectedHorseIndex", _source, horseIndex, true)
			end

		end

		if tonumber(HorseData.container) ~= 0 then
			TriggerEvent("tpz_inventory:unregisterCustomContainer", HorseData.container) -- unregister container of the horse.
		end

		exports.ghmattimysql:execute("DELETE FROM `horses` WHERE `id` = @id", {["@id"] = horseIndex}) 
		Horses[horseIndex] = nil

		local ped = GetPlayerPed(_source)
		local playerCoords = GetEntityCoords(ped)

		local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
		TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { 
			horseIndex = horseIndex, 
			action = 'DELETE', 
			data = {} 
		}, coords, 350.0, 1000, true, 40)

		if Config.Webhooks['SOLD'].Enabled then

			local category = GetHorseModelCategory(HorseData.model)

			local _w, _c      = Config.Webhooks['SOLD'].Url, Config.Webhooks['SOLD'].Color
			local title       = "🐎`Player Sold Horse`"
			local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has sold a horse.\n\n**Horse Model:** `%s, %s - %s `.\n\n **Received:** `%s`.',
		    steamName, identifier, charIdentifier, HorseData.model, category, ModelData[2], receivedDescription)

			TPZ.SendToDiscord(_w, title, description, _c)
		end

	end)

end)

RegisterServerEvent('tpz_stables:server:transferHorse')
AddEventHandler('tpz_stables:server:transferHorse', function(horseIndex, target)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)

	local Horses         = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

    target = tonumber(target)

    local targetSteamName = GetPlayerName(target)

	if target == _source then
		TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales['CANNOT_TRANSFER_TO_SELF'], "error")
		return
	end

    if targetSteamName == nil then
      TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales['NOT_ONLINE'], "error")
      return
    end

    local tPlayer = TPZ.GetPlayer(target)

    if not tPlayer.loaded() then
      TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales['PLAYER_IS_ON_SESSION'], "error")
      return
    end

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
    local targetSteamName      = GetPlayerName(target)
    local targetGroup          = tPlayer.getGroup()
    local targetJob            = tPlayer.getJob()

    local currentHorses       = GetPlayerHorses(targetCharIdentifier)	
    local count               = currentHorses.count
    local maxHorsesLimit      = GetPlayerMaximumHorsesLimit(targetIdentifier, targetGroup, targetJob)

    if count >= maxHorsesLimit then
      TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales['TARGET_REACHED_HORSES_LIMIT'], "error", 3000 )
      return
    end

	Horses[horseIndex].identifier     = targetIdentifier
	Horses[horseIndex].charidentifier = targetCharIdentifier

    SendNotification(_source, Locales['HORSE_NOTIFY_TITLE'], Locales["HORSE_TRANSFERRED"], "success", 5, "horse", "left")
    SendNotification(target, Locales['HORSE_NOTIFY_TITLE'], Locales["HORSE_TRANSFERRED_TARGET"], "success", 5, "horse", "left")

	TriggerClientEvent("tpz_stables:client:updateHorse", _source, { horseIndex = horseIndex, action = 'TRANSFERRED', data = { targetIdentifier, targetCharIdentifier } } )
	TriggerClientEvent("tpz_stables:client:updateHorse", target, { horseIndex = horseIndex, action = 'TRANSFERRED', data = { targetIdentifier, targetCharIdentifier } } )
	
	if Config.Webhooks['TRANSFERRED'].Enabled then

		local category = GetHorseModelCategory(HorseData.model)

		local _w, _c      = Config.Webhooks['TRANSFERRED'].Url, Config.Webhooks['TRANSFERRED'].Color
		local title       = "🐎`Player Transferred Horse`"
		local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has transferred a horse.\n\n**Horse Model:** `%s, %s - %s `.\n\n**Target Identifier:** `%s`\n\n**Target Character Identifier:** `%s`.',
		steamName, identifier, charIdentifier, HorseData.model, category, ModelData[2], targetIdentifier, targetCharIdentifier)

		TPZ.SendToDiscord(_w, title, description, _c)
	end

end)


RegisterServerEvent('tpz_stables:server:saveHorse')
AddEventHandler('tpz_stables:server:saveHorse', function(horseIndex, stamina, health, trainingExperience, trainingMissionIndex, trainingMissionIndexType, shoesType, shoesKmLeft, isDead)
	local _source = source
	local Horses  = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

	Horses[horseIndex].stats.stamina        = stamina
	Horses[horseIndex].stats.health         = health
	Horses[horseIndex].stats.shoes_type     = shoesType
	Horses[horseIndex].stats.shoes_km_left  = shoesKmLeft

	Horses[horseIndex].training_experience  = trainingExperience
	Horses[horseIndex].training_stage_index = trainingMissionIndex
	Horses[horseIndex].training_stage_type  = trainingMissionIndexType

	Horses[horseIndex].isdead = isDead

	exports.ghmattimysql:execute("UPDATE `horses` SET `stats` = @stats, `training_experience` = @training_experience, `training_stage_index` = @training_stage_index, `training_stage_type` = @training_stage_type, `isdead` = @isdead WHERE `id` = @id ", { 
		['id']                   = horseIndex, 
		['stats']                = json.encode( Horses[horseIndex].stats ),
		['training_experience']  = trainingExperience,
		['training_stage_index'] = trainingMissionIndex,
		['training_stage_type']  = trainingMissionIndexType,
		['isdead']               = isdead,
	})

end)


RegisterServerEvent('tpz_stables:server:saveHorseTrainingExperience')
AddEventHandler('tpz_stables:server:saveHorseTrainingExperience', function(horseIndex, trainingExperience, trainingMissionIndex, trainingMissionIndexType)
	local _source = source
	local Horses  = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

	Horses[horseIndex].training_experience  = trainingExperience
	Horses[horseIndex].training_stage_index = trainingMissionIndex
	Horses[horseIndex].training_stage_type  = trainingMissionIndexType

	exports.ghmattimysql:execute("UPDATE `horses` SET `training_experience` = @training_experience, `training_stage_index` = @training_stage_index, `training_stage_type` = @training_stage_type WHERE `id` = @id ", { 
		['id']                   = horseIndex, 
		['training_experience']  = trainingExperience,
		['training_stage_index'] = trainingMissionIndex,
		['training_stage_type']  = trainingMissionIndexType,
	})

end)

RegisterServerEvent('tpz_stables:server:updateHorse')
AddEventHandler('tpz_stables:server:updateHorse', function(horseIndex, action, data)
	local _source = source
	local Horses  = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

    local updateActionOnClient = false

	if action == 'NETWORK_ID' then
		Horses[horseIndex].entity = data[1]

        updateActionOnClient = true

	elseif action == 'RENAME' then
		Horses[horseIndex].name = data[1]

        updateActionOnClient = true

	elseif action == 'SET_DEFAULT' then

		local Parameters = { 
			["charidentifier"]       = Horses[horseIndex].charidentifier,
			['selected_horse_index'] = horseIndex,
		}

		exports.ghmattimysql:execute("UPDATE `characters` SET `selected_horse_index` = @selected_horse_index WHERE `charidentifier` = @charidentifier", Parameters)

        updateActionOnClient = false

	elseif action == 'UPDATE_COMPONENTS' then

		Horses[horseIndex].components = data[1]

		local Parameters = { 
			["id"]         = horseIndex,
			['components'] = json.encode(Horses[horseIndex].components),
		}

		exports.ghmattimysql:execute("UPDATE `horses` SET `components` = @components WHERE `id` = @id", Parameters)

		updateActionOnClient = true
	end

    -- We update the modified data on client for all players through async. 
    if updateActionOnClient then

        local coords

        local updated = false

        if Horses[horseIndex].entity ~= 0 then
            local entity = NetworkGetEntityFromNetworkId(Horses[horseIndex].entity)

            if DoesEntityExist(entity) then

                local tableCoords = GetEntityCoords(entity)
                coords = vector3(tableCoords.x, tableCoords.y, tableCoords.z)
                TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { horseIndex = horseIndex, action = action, data = data }, coords, 500.0, 500, true, 40)
                updated = true
            end

        end

        if not updated then
            local ped = GetPlayerPed(_source)
            local playerCoords = GetEntityCoords(ped)

            coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { horseIndex = horseIndex, action = action, data = data }, coords, 150.0, 1000, true, 40)
            updated = true
        end

    end

end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

-- The specified task is for the horses ageing. 
Citizen.CreateThread(function()

    while true do
        Wait(Config.Ageing.UpdateTime * 60000)
    
		local Horses = GetHorses()

        if TPZ.GetTableLength(Horses) > 0 and LoadedResults then
            
            for index, horse in pairs (Horses) do
                
                horse.age = horse.age + Config.Ageing.UpdateTime
                
				local ModelData = GetHorseModelData(horse.model)

                if age >= ModelData[10] then
                    
					exports["ghmattimysql"]:execute("SELECT `selected_horse_index` FROM `characters` WHERE `charidentifier` = @charidentifier", { ["@charidentifier"] = horse.charidentifier }, function(result)

						if result and result[1] then

							if tonumber(result[1].selected_horse_index) == horse.id then

								local Parameters = { 
									["charidentifier"]       = horse.charidentifier,
									['selected_horse_index'] = 0,
								}
						
								exports.ghmattimysql:execute("UPDATE `characters` SET `selected_horse_index` = @selected_horse_index WHERE `charidentifier` = @charidentifier", Parameters)
							
							end

						end

						if horse.entity and horse.entity ~= 0 then
	
							local entity = NetworkGetEntityFromNetworkId(horse.entity)
							if DoesEntityExist(entity) then
								DeleteEntity(entity)
							end
				
						end
						
						if horse.container ~= 0 then
							TriggerEvent("tpz_inventory:unregisterCustomContainer", horse.container) -- unregister container of the horse.
						end
	
						exports.ghmattimysql:execute("DELETE FROM `horses` WHERE `id` = @id", {["@id"] = horse.id}) 
						Horses[horse.id] = nil

					end)

                end
                
            end
            
        
        end
    
    end

end)
