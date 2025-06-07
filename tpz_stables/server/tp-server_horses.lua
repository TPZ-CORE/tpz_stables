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
	local charIdentifier = xPlayer.getCharacterIdentifier()

	local Horses         = GetHorses()

	if TPZ.GetTableLength(Horses) > 0 then

		local currentHorses  = GetPlayerHorses(charIdentifier)	

		for _, horseIndex in pairs (currentHorses.horsesIndex) do
	
			local HorseData = Horses[tonumber(horseIndex)]
	
			if HorseData.entity and HorseData.entity ~= 0 then
	
				local entity = NetworkGetEntityFromNetworkId(HorseData.entity)
				if DoesEntityExist(entity) then
					DeleteEntity(entity)
				end

                Horses[tonumber(horseIndex)].entity = 0
	
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
	local group          = xPlayer.getGroup()
	local job            = xPlayer.getJob()

	local StableData     = Config.Locations[locationIndex]
	local HorseData      = Config.Horses[categoryIndex].Horses[modelIndex]

	local currentHorses  = GetPlayerHorses(charIdentifier)	
	local count          = currentHorses.count

	local maxHorsesLimit = GetPlayerMaximumHorsesLimit(identifier, group, job)

	if count >= maxHorsesLimit then
		SendNotification(_source, Locales['REACHED_HORSES_LIMIT'], "error", 3000 )
		return
	end

	local money  = xPlayer.getAccount(0)
	local cost   = HorseData[3]
	local isGold = false
	local notEnoughDisplay = Locales['NOT_ENOUGH_TO_BUY_HORSE']

	-- If the selected account is gold, we check for gold.
	if account and Locales['INPUT_BUY_CURRENCIES'][2] == account then
		isGold = true

		money = xPlayer.getAccount(1)
		cost  = HorseData[4]
		notEnoughDisplay  = Locales['NOT_ENOUGH_TO_BUY_HORSE_GOLD']
	end

	if money < cost then
		SendNotification(_source, notEnoughDisplay, "error", 3000)
		return
	end

	if not isGold then
		xPlayer.removeAccount(0, cost)
	else
		xPlayer.removeAccount(1, cost)
	end

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
	
	local date      = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
	local randomAge = math.random(Config.Ageing.StartAdultAge.min, Config.Ageing.StartAdultAge.max)
	randomAge       = math.floor(randomAge * 1440)

	local randomSex = math.random(0, 1)

	local Parameters = { 
		['identifier']     = identifier,
		['charidentifier'] = charIdentifier,
		['model']          = HorseData[1],
		['name']           = 'N/A',
		['stats']          = json.encode( { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 } ),
		['components']     = json.encode( { saddle = 0, bags = 0, mask = 0, bed = 0, blank = 0, mane = 0, mus = 0, tail = 0, horn = 0, stir = 0, brid = 0, lantern = 0, holster = 0 }),
		['type']           = Config.Horses[categoryIndex].Category,
		['age']            = randomAge,
		['sex']            = randomSex,
		['date']           = date,
	}

	exports.ghmattimysql:execute("INSERT INTO `horses` ( `identifier`, `charidentifier`, `model`, `name`, `stats`, `components`, `type`, `age`, `sex`, `date` ) VALUES ( @identifier, @charidentifier, @model, @name, @stats, @components, @type, @age, @sex, @date )", Parameters)

	Wait(1500)

	exports["ghmattimysql"]:execute("SELECT `id` FROM `horses` WHERE `date` = @date", { ["@date"] = date }, function(result)

		if result and result[1] then

			local horse_data = {
				identifier     = identifier,
				charidentifier = charIdentifier,
				model          = HorseData[1],
				name           = 'N/A',
				stats          = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
				components     = { saddle = 0, bags = 0, mask = 0, bed = 0, blank = 0, mane = 0, mus = 0, tail = 0, horn = 0, stir = 0, brid = 0, lantern = 0, holster = 0 },
				type           = Config.Horses[categoryIndex].Category,
				age            = randomAge,
				sex            = randomSex,
				date           = date,
			}

			local Horses = GetHorses()

			Horses[result[1].id]    = {}
			Horses[result[1].id]    = horse_data
			Horses[result[1].id].id = result[1].id

			Horses[result[1].id].entity = 0
			Horses[result[1].id].source = _source

			SendNotification(_source, Locales['SUCCESSFULLY_BOUGHT_A_HORSE'], "success", 5000 )
		end

	end)
	
end)

RegisterServerEvent('tpz_stables:server:saveHorse')
AddEventHandler('tpz_stables:server:saveHorse', function(horseIndex, stamina, health, trainingExperience, shoesType, shoesKmLeft, isDead, remove)
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

	Horses[horseIndex].isdead = isDead

	exports.ghmattimysql:execute("UPDATE `horses` SET `stats` = @stats, `training_experience` = @training_experience, `isdead` = @isdead WHERE `id` = @id ", { 
		['id']                  = horseIndex, 
		['stats']               = json.encode( Horses[horseIndex].stats ),
		['training_experience'] = trainingExperience,
		['isdead']              = isdead,
	})

	if remove then
		Horses[horseIndex].entity = 0
	end

end)

RegisterServerEvent('tpz_stables:server:updateHorse')
AddEventHandler('tpz_stables:server:updateHorse', function(horseIndex, action, data)
	local _source = source
	local Horses  = GetHorses()

	if Horses[horseIndex] == nil then
		return
	end

	if action == 'NETWORK_ID' then
		Horses[horseIndex].entity = data[1]

	elseif action == 'RENAME' then
		Horses[horseIndex].name = data[1]

	elseif action == 'SET_DEFAULT' then

		local Parameters = { 
			["charidentifier"]       = Horses[horseIndex].charidentifier,
			['selected_horse_index'] = horseIndex,
		}

		exports.ghmattimysql:execute("UPDATE `characters` SET `selected_horse_index` = @selected_horse_index WHERE `charidentifier` = @charidentifier", Parameters)

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
                
                if age >= Config.Ageing.DeleteAge then
                    
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
