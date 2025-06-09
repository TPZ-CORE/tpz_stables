local TPZ = exports.tpz_core:getCoreAPI()

local WhistleCooldown = 0
local CurrentSavingTime = Config.SaveHorseTime

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

local function FollowOwner()
    local PlayerData = GetPlayerData()

	if PlayerData.SpawnedHorseEntity then

        local entityHandler = PlayerData.SpawnedHorseEntity
            
        FreezeEntityPosition(entityHandler,false)
        TaskStandStill(entityHandler, 1)
    
        ClearPedTasksImmediately(entityHandler)
    
        ClearPedTasks(entityHandler)
        ClearPedSecondaryTask(entityHandler)

        TaskGoToEntity(entityHandler, PlayerPedId(), -1, 7.2, 2.0, 0, 0)
    end

end

function SetFleeAway()
    local PlayerData = GetPlayerData()

	if PlayerData.SpawnedHorseEntity then

        local HorseData     = PlayerData.Horses[PlayerData.SelectedHorseIndex]
		local entityHandler = PlayerData.SpawnedHorseEntity

		local entityCoords = GetEntityCoords(entityHandler)

		ClearPedTasksImmediately(entityHandler)
						
		ClearPedTasks(entityHandler)
		ClearPedSecondaryTask(entityHandler)
		
		TaskStandStill(entityHandler, 1)

        local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entityHandler, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
        local health = GetEntityHealth(entityHandler, Citizen.ResultAsInteger())

        local trainingPoints = HorseData.training_experience
        local shoesType      = HorseData.stats.shoes_type
        local shoesKmLeft    = HorseData.stats.shoes_km_left

        local isHorseDead    = IsPedDeadOrDying(entityHandler, 1) and 1 or 0

        TriggerServerEvent("tpz_stables:server:saveHorse", PlayerData.SelectedHorseIndex, stamina + 0.0, health, trainingPoints, shoesType, shoesKmLeft, isHorseDead)
		TriggerServerEvent("tpz_stables:server:updateHorse", PlayerData.SelectedHorseIndex, "NETWORK_ID", { 0 } )
		Wait(500)
	
		TaskGoToCoordAnyMeans(entityHandler, entityCoords.x + 20.0, entityCoords.y + 20.0, entityCoords.z, 2.0)
	
		Wait(5000)

		RemoveEntityProperly(entityHandler, GetHashKey(HorseData.model) )

        PlayerData.SpawnedHorseEntity = nil
	end

end

function SpawnHorseEntity()
    local PlayerData = GetPlayerData()
    local HorseData  = PlayerData.Horses[PlayerData.SelectedHorseIndex]

	local player = PlayerPedId()
	local coords = GetEntityCoords( player )

	LoadModel(HorseData.model)

	local entity = CreatePed(GetHashKey(HorseData.model), coords.x + 2.0, coords.y + 2.0, coords.z, 0, 1, 1, 0, 0 )
    SetModelAsNoLongerNeeded(GetHashKey(HorseData.model))

    local horseFlags = {
        [6] = true,
        [113] = false,
        [136] = false,
        [208] = true,
        [209] = true,
        [211] = true,
        [277] = true,
        [297] = true,
        [300] = false,
        [301] = false,
        [312] = false,
        [319] = true,
        [400] = true,
        [412] = false,
        [419] = false,
        [438] = false,
        [439] = false,
        [440] = false,
        [561] = true,
        [324] = true,
    }

    for flag, val in pairs(horseFlags) do
        Citizen.InvokeNative(0x1913FE4CBF41C463, entity, flag, val); -- SetPedConfigFlag (kind of sets defaultbehavior)
    end

    SetPedConfigFlag(entity, 471, Config.DisableHorseKicking) -- PCF_DisableHorseKick

    local horseTunings = { 24, 25, 48 }
    for _, flag in ipairs(horseTunings) do
        Citizen.InvokeNative(0x1913FE4CBF41C463, entity, flag, false); -- SetHorseTuning
    end

    Citizen.InvokeNative(0x283978A15512B2FE, entity, true)

	Citizen.InvokeNative(0xA91E6CF94404E8C9, entity) 	        -- pet fade in when spawning
	Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)      	-- spawn pet properly in the ground
    Citizen.InvokeNative(0xFD6943B6DF77E449, entity, Config.CanLassoHorses) -- disable players to use lasso on pets
    Citizen.InvokeNative(0x4DB9D03AC4E1FA84, entity, -1, -1, 0)
    Citizen.InvokeNative(0xB8B6430EAD2D2437, entity, GetHashKey("PLAYER_HORSE"))
    Citizen.InvokeNative(0xDF93973251FB2CA5, player, true) -- SetPlayerMountStateActive
    Citizen.InvokeNative(0xe6d4e435b56d5bd0, player, entity) -- SetPlayerOwnsMount
    Citizen.InvokeNative(0xED1C764997A86D5A, PlayerPedId(), entity) 
    Citizen.InvokeNative(0xAEB97D84CDF3C00B, entity, false) 
    Citizen.InvokeNative(0xEB8886E1065654CD, entity, 10, "ALL", 0)
    Citizen.InvokeNative(0x024EC9B649111915, entity, true)
    Citizen.InvokeNative(0xFE26E4609B1C3772, entity, "HorseCompanion", true) -- DecorSetBool

    SetAnimalTuningBoolParam(entity, 25, false)
    SetAnimalTuningBoolParam(entity, 24, false)
    SetAnimalTuningBoolParam(entity, 48, false)

    TaskAnimalUnalerted(entity, -1, false, 0, 0)

	SetPedNameDebug(entity, HorseData.name)
	SetPedPromptName(entity, HorseData.name)
    
    if HorseData.sex == 1 then
        Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 1.0)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
    else
        Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 0.0)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
    end

    Citizen.InvokeNative(0xA3DB37EDF9A74635, player, entity, 28, 1, true) -- HORSE_ITEMS / Horse Cargo
    Citizen.InvokeNative(0xA3DB37EDF9A74635, player, entity, 45, 1, true) -- HORSE_WEAPONS_HOLD / Horse Weapons
    Citizen.InvokeNative(0xA3DB37EDF9A74635, player, entity, 49, 1, true) -- HORSE_BRUSH
    Citizen.InvokeNative(0xA3DB37EDF9A74635, player, entity, 50, 1, true) -- HORSE_FEED
    Citizen.InvokeNative(0xA3DB37EDF9A74635, player, entity, 28, 1, true) -- HORSE_ITEMS

    local network = NetworkGetNetworkIdFromEntity(entity) -- !!!!!!!!!!!

    TriggerServerEvent("tpz_stables:server:updateHorse", PlayerData.SelectedHorseIndex, 'NETWORK_ID', { network })

	Wait(500)

    local bliph = Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity)
    Citizen.InvokeNative(0x9CB1A1623062F402, bliph, HorseData.name)

    -- HORSE MODEL STATISTICS
    local horseModelData = GetHorseModelData(HorseData.model)
    local stats          = horseModelData[5]

    local speed        = (stats[1] / 100) * 1700
    speed = math.floor(speed)

    local stamina      = (stats[2] / 100) * 1700
    stamina = math.floor(stamina)

    local health       = (stats[3] / 100) * 1700
    health = math.floor(health)

    local acceleration = (stats[4] / 100) * 1700
    acceleration = math.floor(acceleration)

    local handling     = (stats[5] / 100) * 1700
    handling = math.floor(handling)

    SetAttributePoints(entity, 5, speed ) -- SPEED
    SetAttributePoints(entity, 1, stamina ) -- STAMINA
    SetAttributePoints(entity, 0, health) -- HEALTH
    SetAttributePoints(entity, 6, acceleration ) -- ACCELERATION
    SetAttributePoints(entity, 4, handling ) -- AGILITY

    -- END OF HORSE STATISTICS

    local stamina2 = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --current stamina 
    local stamina = Citizen.InvokeNative(0xCB42AFE2B613EE55,entity, Citizen.ResultAsFloat()) --max stamina 

    local maxhealth = GetEntityMaxHealth(entity, Citizen.ResultAsInteger())

    local check = (HorseData.stats.stamina-stamina2)

    if stamina2 + check >= stamina then 
        local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, entity, 1, Citizen.ResultAsInteger()) 
        Citizen.InvokeNative(0xC6258F41D86676E0, entity, 1, valueStamina + 100)
    end

    if HorseData.stats.health >= maxhealth then 
        local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, entity, 0, Citizen.ResultAsInteger())
        Citizen.InvokeNative(0xC6258F41D86676E0, entity, 0, valueHealth + 100)
    end

    if HorseData.stats.health > 0 then 
        SetEntityHealth(entity, HorseData.stats.health,0)
    end

    if (stamina2 + check) > 0 then 
        Citizen.InvokeNative(0xC3D4B754C0E86B9E,entity,check+0.0)
    end
    
    -- CHECKING IF HORSE HAS BEEN TRAINED.
    if HorseData.training_experience == -1 then

        -- ADDING HORSE TRICKS.
        Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 7, 2 ) 
        Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 7, 3 ) 
        Citizen.InvokeNative( 0x5DA12E025D47D4E5, entity, 7, 4 ) 
    
        Citizen.InvokeNative( 0xA69899995997A63B, entity, 2) 
        Citizen.InvokeNative( 0xA69899995997A63B, entity, 3) 
        Citizen.InvokeNative( 0xA69899995997A63B, entity, 4) 
        Citizen.InvokeNative( 0x931B241409216C1F, PlayerPedId(), entity, false) 

        -- Defines horse relationship group to be the same as the player
        local playerGroupId = GetPedRelationshipGroupHash(PlayerPedId())
        SetPedRelationshipGroupHash(entity, playerGroupId)
    else

        local DecreaseData = Config.Trainers.UntrainedHorse.DecreaseHorseStatistics

        if DecreaseData["speed"].Modify and DecreaseData["speed"].DivideBy > 1 then
            SetAttributePoints(entity, 5, math.floor(speed / DecreaseData["speed"].DivideBy) ) -- SPEED
        end

        if DecreaseData["stamina"].Modify and DecreaseData["stamina"].DivideBy > 1 then
            SetAttributePoints(entity, 1, math.floor(stamina / DecreaseData["stamina"].DivideBy) ) -- STAMINA
        end

        if DecreaseData["health"].Modify and DecreaseData["health"].DivideBy > 1 then
            SetAttributePoints(entity, 0, math.floor(health / DecreaseData["health"].DivideBy) ) -- HEALTH
        end

        if DecreaseData["acceleration"].Modify and DecreaseData["acceleration"].DivideBy > 1 then
            SetAttributePoints(entity, 6, math.floor(acceleration / DecreaseData["acceleration"].DivideBy) ) -- ACCELERATION
        end

        if DecreaseData["handling"].Modify and DecreaseData["handling"].DivideBy > 1 then
            SetAttributePoints(entity, 4, math.floor(handling / DecreaseData["handling"].DivideBy) ) -- HANDLING
        end

    end

    PlayerData.SpawnedHorseEntity = entity

    local isAgedDead = HorseData.age >= Config.Ageing.MaximumAge

    if HorseData.stats.health <= 0 then

		SetEntityCanBeDamaged(entity, true)
        Citizen.InvokeNative(0x697157CED63F18D4, entity, 10000)

        SendNotification(nil, Locales['HORSE_UNCONSIOUS'], "error")

    elseif isAgedDead then
        SendNotification(nil, Locales['HORSE_DEAD_FROM_AGEING'], "error")

    else
		FollowOwner()
    end

end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------


function GetHorseCategoryData(model)
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

GetPlayerHorses = function(charIdentifier)

    local PlayerData = GetPlayerData()

	local length = TPZ.GetTableLength(PlayerData.Horses)

	if length <= 0 then
		return { count = 0, horsesIndex = {} }
	end

	local currentHorses = {}
	local count  = 0

	for index, horse in pairs (PlayerData.Horses) do

		if tonumber(horse.charidentifier) == tonumber(charIdentifier) then
			count = count + 1

			table.insert(currentHorses, horse.id)
		end

	end

	return { count = count, horsesIndex = currentHorses }
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local PlayerData = GetPlayerData()

    if PlayerData.SpawnedHorseEntity then
        local model = GetHashKey(PlayerData.Horses[PlayerData.SelectedHorseIndex].model )
        RemoveEntityProperly(PlayerData.SpawnedHorseEntity, model)
    end

end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_stables:client:updateHorse')
AddEventHandler('tpz_stables:client:updateHorse', function(cb)
	local PlayerData = GetPlayerData()
	horseIndex, action, data = cb.horseIndex, cb.action, cb.data

	if PlayerData.Horses[horseIndex] == nil and action ~= 'REGISTER' then
		return
	end

    if action == 'REGISTER' then

        local horse_data = {
            id                  = horseIndex,
            identifier          = data[1],
            charidentifier      = data[2],
            model               = data[3],
            name                = 'N/A',
            stats               = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
            components          = { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 },
            type                = data[4],
            age                 = data[5],
            sex                 = data[6],
            training_experience = 0,
            breeding            = 0,
            bought_account      = data[7],
            container           = 0,
            date                = data[8],
        }

        PlayerData.Horses[horseIndex] = {}
        PlayerData.Horses[horseIndex] = horse_data

        PlayerData.Horses[horseIndex].entity = 0
        PlayerData.Horses[horseIndex].source = 0

    elseif action == 'TRANSFERRED' then

        if PlayerData.SpawnedHorseEntity and PlayerData.SelectedHorseIndex == horseIndex then
            local model = GetHashKey(PlayerData.Horses[PlayerData.SelectedHorseIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedHorseEntity, model)
        end

        PlayerData.Horses[horseIndex].identifier     = data[1]
        PlayerData.Horses[horseIndex].charidentifier = data[2]

    elseif action == 'DELETE' then

        PlayerData.Horses[horseIndex] = nil

	elseif action == 'NETWORK_ID' then
		PlayerData.Horses[horseIndex].entity = data[1]

    elseif action == 'HORSE_SHOES' then

        PlayerData.Horses[horseIndex].stats.shoes_type     = data[1]
        PlayerData.Horses[horseIndex].stats.shoes_km_left  = data[2]

	elseif action == 'RENAME' then
		PlayerData.Horses[horseIndex].name = data[1]
	end

end)

RegisterNetEvent("tpz_stables:client:whistle") -- always for horses.
AddEventHandler("tpz_stables:client:whistle", function()

	local playerPed  = PlayerPedId()
    local coords     = GetEntityCoords(playerPed)

    local PlayerData = GetPlayerData()
    local Horses     = PlayerData.Horses

    if WhistleCooldown > 0 then
		SendNotification(nil, Locales['WAIT_FOR_CALLING'], "error")
		return
	end

    if PlayerData.IsLoaded and PlayerData.SelectedHorseIndex >= 0 then

        if PlayerData.Horses[PlayerData.SelectedHorseIndex] == nil then
            SendNotification(nil, Locales['HORSE_NOT_OWNED'], "error")
            return
        end

        local currentTownHash = Citizen.InvokeNative(0x43AD8FC02B429D33, coords, 1)
        if not IsLocationPermitted(currentTownHash) then
            SendNotification(nil, Locales['CALL_TOWN_IS_RESTRICTED'], "error")
            return
        end

        local isSwimming = Citizen.InvokeNative(0x9DE327631295B4C2, playerPed)
        local isSwimmingUnderWater = Citizen.InvokeNative(0xC024869A53992F34, playerPed)

        if isSwimming or isSwimmingUnderWater then
            SendNotification(nil, Locales['CALL_SWIMMING'], "error")
            return
        end

        if Config.HorseCalling.CallOnlyNearStables then

            local isNearbyStableLocation = IsNearbyStableLocation(coords)

            if not isNearbyStableLocation then
                SendNotification(nil, Locales['CALL_NOT_NEARBY_STABLE'], "error")
                return
            end

        end

        WhistleCooldown = Config.HorseCalling.CallCooldown

        if PlayerData.SpawnedHorseEntity == nil then
            SpawnHorseEntity()
            return
        end

        -- If pet is too far when called, spawn close to the player.
        local entityCoords, coords = GetEntityCoords(PlayerData.SpawnedHorseEntity), GetEntityCoords(playerPed)
        
        if GetDistanceBetweenCoords(coords, entityCoords, true) > Config.HorseCalling.CallDistance then
    
            SetFleeAway()
    
            Wait(1000)
            SpawnHorseEntity()
        else
            FollowOwner()
        end
        
	else
        SendNotification(nil, Locales['HORSE_NOT_OWNED'], "error")
    end

end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        
        Wait(1)

        local PlayerData = GetPlayerData()

        if PlayerData.IsLoaded then

            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x24978A28) then -- Whistle (Call)
                local player       = PlayerPedId()
                local isPlayerDead = IsEntityDead(player)

                if not PlayerData.IsBusy and not PlayerData.IsOnMenu and not isPlayerDead then 
                    TriggerEvent('tpz_stables:client:whistle')
                    Wait(1000)
                else
                    SendNotification(nil, Locales['CANT_WHISTLE_HORSE'], "error")
                end

            end

            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x4216AF06) then -- Flee Horse          
                SetFleeAway()
            end		

        end

    end

end)


Citizen.CreateThread(function()

    local prevPos = nil

    while true do
        Wait(1000)

        local PlayerData = GetPlayerData()
 
        if PlayerData.IsLoaded and PlayerData.SpawnedHorseEntity then

            local playerPed  = PlayerPedId()
            local HorseData  = PlayerData.Horses[PlayerData.SelectedHorseIndex]

            if IsPedOnMount(playerPed) then
    
                local horse = GetMount(playerPed)
                local rider = GetRiderOfMount(horse, true)

                if horse == PlayerData.SpawnedHorseEntity and rider == playerPed then

                    local pos = GetEntityCoords(horse)

                    local dist

                    if prevPos then
                        dist = #(pos - prevPos)
                    end

                    prevPos = pos

                    local isPedRunning = IsPedRunning(horse) or IsPedSprinting(horse)

                    if isPedRunning ~= false then

                        -- Faster consumption on untrained horses.
                        if Config.Trainers.UntrainedHorse.FasterStaminaConsumption.Enabled and HorseData.training_experience >= 0 then
                            ChangePedStamina(horse, - Config.Trainers.UntrainedHorse.FasterStaminaConsumption.DecreaseBy + 0.0)
                        end

                        -- No consumption on shoes.
                        if HorseData.training_experience == -1 and HorseData.stats.shoes_type ~= 0 and HorseData.stats.shoes_km_left > 0 then
                            local currentStamina = GetPedStamina(horse)
                            ChangePedStamina(horse, currentStamina)

                            HorseData.stats.shoes_km_left = HorseData.stats.shoes_km_left - dist

                            if HorseData.stats.shoes_km_left <= 0 then 
                                HorseData.stats.shoes_type    = 0
                                HorseData.stats.shoes_km_left = 0

                                local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entityHandler, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                                local health = GetEntityHealth(entityHandler, Citizen.ResultAsInteger())

                                local trainingPoints = HorseData.training_experience
                                local shoesType      = HorseData.stats.shoes_type
                                local shoesKmLeft    = HorseData.stats.shoes_km_left

                                TriggerServerEvent("tpz_stables:server:saveHorse", PlayerData.SelectedHorseIndex, stamina + 0.0, health, trainingPoints, shoesType, shoesKmLeft, 0)
                    
                            end

                        end

                    end

                    CurrentSavingTime = CurrentSavingTime - 0 

                    if CurrentSavingTime <= 0 then
                        CurrentSavingTime = Config.SaveHorseTime

                        local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entityHandler, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                        local health = GetEntityHealth(entityHandler, Citizen.ResultAsInteger())

                        local trainingPoints = HorseData.training_experience
                        local shoesType      = HorseData.stats.shoes_type
                        local shoesKmLeft    = HorseData.stats.shoes_km_left

                        TriggerServerEvent("tpz_stables:server:saveHorse", PlayerData.SelectedHorseIndex, stamina + 0.0, health, trainingPoints, shoesType, shoesKmLeft, 0)
            
                    end

                end

            else
                Wait(2000)
            end

        end

    end
 
end)

Citizen.CreateThread(function()

    while true do
        Wait(1000)

        local PlayerData = GetPlayerData()

        if PlayerData.IsLoaded and WhistleCooldown > 0 then

            WhistleCooldown = WhistleCooldown - 1

            if WhistleCooldown <= 0 then
                WhistleCooldown = 0
            end

        end

    end

end)
