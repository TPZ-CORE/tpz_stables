local TPZ = exports.tpz_core:getCoreAPI()

local Horses, Wagons = {}, {}
local LoadedResults = false

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local LoadOwnedHorses = function()

	exports["ghmattimysql"]:execute("SELECT * FROM horses", {}, function(result)

		local length = TPZ.GetTableLength(result)

        if length > 0 then

            for _, res in pairs (result) do

                Horses[res.id] = {}
                Horses[res.id] = res

				Horses[res.id].entity = 0
				Horses[res.id].source = 0

				Horses[res.id].stats      = json.decode(res.stats)
				Horses[res.id].components = json.decode(res.components)

				if res.training_experience > 0 and Config.Trainers.HorseTraining.MaxLevelUpExperience <= res.training_experience then
					Horses[res.id].training_experience = -1
				end

				local shoesType = Horses[res.id].stats.shoes_type
				local kmLeft    = Horses[res.id].stats.shoes_km_left

				-- We check if shoes type ~= 0 and does not exist on the types to reset the type and km.
				if (shoesType ~= 0 and Config.HorseShoes[shoesType] == nil) then
					Horses[res.id].stats.shoes_type = 0
					Horses[res.id].stats.shoes_km_left = 0

				end

				-- We check if shoes type ~= 0 and type exist but km have been modified to lower than what it was, so we reset.
				if shoesType ~= 0 and Config.HorseShoes[shoesType] and kmLeft >= Config.HorseShoes[shoesType].maxKilometers then
					Horses[res.id].stats.shoes_type    = 0
					Horses[res.id].stats.shoes_km_left = 0
				end

            end

			if Config.Debug then
                print(string.format("Successfully loaded %s owned horses.", length ))
            end

		end


	end)

end

local LoadOwnedWagons = function()

	exports["ghmattimysql"]:execute("SELECT * FROM wagons", {}, function(result)

		local length = TPZ.GetTableLength(result)

        if length > 0 then

            for _, res in pairs (result) do

                Wagons[res.id] = {}
                Wagons[res.id] = res

				Wagons[res.id].entity = 0
				Wagons[res.id].source = 0

				Wagons[res.id].wheels     = json.decode(res.wheels)
				Wagons[res.id].components = json.decode(res.components)
            end

			if Config.Debug then
                print(string.format("Successfully loaded %s owned wagons.", length ))
            end

		end


	end)

end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

-- @return total owned count and owned horse id's.
GetPlayerHorses = function(charIdentifier)

	local length = TPZ.GetTableLength(Horses)

	if length <= 0 then
		return { count = 0, horsesIndex = {} }
	end

	local currentHorses = {}
	local count  = 0

	for index, horse in pairs (Horses) do

		if tonumber(horse.charidentifier) == tonumber(charIdentifier) then
			count = count + 1

			table.insert(currentHorses, horse.id)
		end

	end

	return { count = count, horsesIndex = currentHorses }
end

-- @return total owned count and owned wagon id's.
function GetPlayerWagons(charIdentifier)

	local length = TPZ.GetTableLength(Wagons)

	if length <= 0 then
		return { count = 0, wagonsIndex = {} }
	end

	local currentWagons = {}
	local count  = 0

	for index, wagon in pairs (Wagons) do

		if tonumber(wagon.charidentifier) == tonumber(charIdentifier) then
			count = count + 1

			table.insert(currentWagons, wagon.id)
		end

	end

	return { count = count, wagonsIndex = currentWagons }
end

-- @return the maximum horses the player can have on his / her ownership.
GetPlayerMaximumHorsesLimit = function(identifier, group, job)

	if Config.OwnedLimitations.SteamHexIdentifiers[identifier] then
		return Config.OwnedLimitations.SteamHexIdentifiers[identifier]
	end

	if Config.OwnedLimitations.Groups[group] then
		return Config.OwnedLimitations.Groups[group]
	end

	local isTrainer = false

	for index, trainerJob in pairs (Config.Trainers.Jobs) do 
		if trainerJob == job then
			isTrainer = true
		end
	end

	if isTrainer then
		return Config.OwnedLimitations.HorseTrainerMaxHorses
	end

	return Config.OwnedLimitations.MaxHorses

end

function GetHorses()
    return Horses
end

function GetWagons()
	return Wagons
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	LoadOwnedHorses()
	LoadOwnedWagons()

    LoadedResults = true
end)


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
  
    Horses = nil
    Wagons = nil

end)


-- player quit


-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:requestPlayerData')
AddEventHandler('tpz_stables:server:requestPlayerData', function()
	local _source = source
	local xPlayer = TPZ.GetPlayer(_source)

	if not xPlayer.loaded() then
		return
	end

	local charIdentifier = xPlayer.getCharacterIdentifier()

	while not LoadedResults do
		Wait(1000)
	end

	exports["ghmattimysql"]:execute("SELECT * FROM `characters` WHERE `charidentifier` = @charidentifier", { ["@charidentifier"] = charIdentifier }, function(result)

		local currentWagons = GetPlayerWagons(charIdentifier)

		if currentWagons.count > 0 then -- Updating all owned wagons the Source ID.
			for index, wagonIndex in pairs (currentWagons.wagonsIndex) do
				Wagons[wagonIndex].source = _source
			end
		end
	
		local currentHorses = GetPlayerHorses(charIdentifier)

		if currentHorses.count > 0 then -- Updating all owned horses the Source ID.
			for index, horseIndex in pairs (currentHorses.horsesIndex) do
				Horses[horseIndex].source = _source
			end
		end

		local selectedHorseIndex = result[1].selected_horse_index
		selectedHorseIndex = Horses[selectedHorseIndex] == nil and 0 or selectedHorseIndex

		local selectedWagonIndex = result[1].selected_wagon_index
		selectedWagonIndex = Wagons[selectedWagonIndex] == nil and 0 or selectedWagonIndex

		TriggerClientEvent("tpz_stables:client:sendPlayerData", _source, Horses, Wagons, selectedHorseIndex, selectedWagonIndex )

	end)

end)

-- Requesting account information for the UI.
RegisterServerEvent('tpz_stables:server:requestAccountInformation')
AddEventHandler('tpz_stables:server:requestAccountInformation', function()
	local _source = source
	local xPlayer = TPZ.GetPlayer(_source)

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
end)


-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

local CurrentSavingTime = 0

-- The following thread is used to save all data before server restarts.
Citizen.CreateThread(function()
	while true do
		Wait(60000)

        local time        = os.date("*t") 
        local currentTime = table.concat({time.hour, time.min}, ":")
    
        local finished    = false
        local shouldSave  = false
    
        for index, restartHour in pairs (Config.RestartHours) do
    
            if currentTime == restartHour then
                shouldSave = true
            end
    
            if next(Config.RestartHours, index) == nil then
                finished = true
            end
        end
    
        while not finished do
          Wait(1000)
        end

        CurrentSavingTime = CurrentSavingTime + 1

		if CurrentSavingTime == Config.SavingDurationDelay then
			CurrentSavingTime = 0
			shouldSave        = true
		end
        
        if shouldSave then

            local length = TPZ.GetTableLength(Horses)

            if length > 0 then
                
                for _, horse in pairs (Horses) do

					local Parameters = { 
						['id']                   = tonumber(horse.id),
						['identifier']           = horse.identifier, -- in case for transfers.
						['charidentifier']       = horse.charidentifier, -- in case for transfers.
						['name']                 = horse.name,
						['stats']                = json.encode( horse.stats ),
						['components']           = json.encode (horse.components),
						['age']                  = horse.age,
						['isdead']               = horse.isdead,
						['training_experience']  = horse.training_experience,
						['training_stage_index'] = horse.training_stage_index,
						['training_stage_type']  = horse.training_stage_type,
						['breeding']             = horse.breeding,
						['container']            = horse.container
					}

					exports.ghmattimysql:execute("UPDATE `horses` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `name` = @name, `stats` = @stats, `components` = @components, `age` = @age, `isdead` = @isdead, `training_experience` = @training_experience, `training_stage_index` = @training_stage_index, `training_stage_type` = @training_stage_type, `breeding` = @breeding, `container` = @container WHERE id = @id", Parameters)

                end
    
                if Config.Debug then
                    print("Saved (" .. length .. ") horses successfully.")
                end

            end

			local length = TPZ.GetTableLength(Wagons)

            if length > 0 then
                
                for _, wagon in pairs (Wagons) do

					local Parameters = { 
						['id']                  = tonumber(wagon.id),
						['identifier']          = wagon.identifier, -- in case for transfers.
						['charidentifier']      = wagon.charidentifier, -- in case for transfers.
						['name']                = wagon.name,
						['components']          = json.encode(wagon.components),
						['wheels']              = json.encode(wagon.wheels),
						['container']           = wagon.container
					}
			
					exports.ghmattimysql:execute("UPDATE `wagons` SET `identifier` = @identifier, `charidentifier` = @charidentifier, `name` = @name, `components` = @components, `wheels` = @wheels, `container` = @container WHERE id = @id", Parameters)

                end
    
                if Config.Debug then
                    print("Saved (" .. length .. ") wagons successfully.")
                end

            end

        
        end

    end

end)