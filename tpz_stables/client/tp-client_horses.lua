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

local IsPermittedToAccessBag = function(currentJob, requiredJobs)

    if requiredJobs == nil or requiredJobs and TPZ.GetTableLength(requiredJobs) <= 0 then
        return false
    end

    for index, job in pairs (requiredJobs) do

        if currentJob == job then
            return true
        end

    end

    return false

end


local IsEntityValidHorse = function(entity)

    local PlayerData = GetPlayerData()
    for index, horse in pairs (PlayerData.Horses) do

        if horse.entity == entity then

            return horse.id
        end

    end

    return 0

end


-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

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
	
        if isHorseDead == 0 then
            TaskGoToCoordAnyMeans(entityHandler, entityCoords.x + 10.0, entityCoords.y + 10.0, entityCoords.z, 2.0)
            Wait(5000)
        end

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

    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 28, 1, true) -- HORSE_ITEMS / Horse Cargo
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 45, 1, true) -- HORSE_WEAPONS_HOLD / Horse Weapons
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 49, 1, true) -- HORSE_BRUSH
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 50, 1, true) -- HORSE_FEED
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 28, 1, true) -- HORSE_ITEMS
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 35, 1, true) -- PP_TRACK_ANIMAL
    Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), entity, 36, 1, true) -- PP_TARGET_INFO

    local network = NetworkGetNetworkIdFromEntity(entity)

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


    if HorseData.stats.health <= 0 or HorseData.isdead == 1 then

		SetEntityCanBeDamaged(entity, true)
        Citizen.InvokeNative(0x697157CED63F18D4, entity, 10000)

        SendNotification(nil, Locales['HORSE_UNCONSIOUS'], "error")

    else
		FollowOwner()
    end

end

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

function GetPlayerHorses(charIdentifier)

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

function GetComponentCategoryIndexByType(equipmentType)

    for index, equipment in pairs (Config.Equipments) do

        if equipment.Type == equipmentType then
            return index
        end

    end
end

function LoadHorseComponents(entity, horseId)

    local PlayerData = GetPlayerData()
    local HorseData  = PlayerData.Horses[horseId]

    if HorseData then

        for equipmentType, equipmentValue in pairs (HorseData.components) do

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
            container           = data[8],
            date                = data[9],
        }

        PlayerData.Horses[horseIndex] = {}
        PlayerData.Horses[horseIndex] = horse_data

        PlayerData.Horses[horseIndex].entity = 0
        PlayerData.Horses[horseIndex].source = 0

        PlayerData.Horses[horseIndex].loaded_components = false

    elseif action == 'TRANSFERRED' then

        if PlayerData.SpawnedHorseEntity and PlayerData.SelectedHorseIndex == horseIndex then
            local model = GetHashKey(PlayerData.Horses[PlayerData.SelectedHorseIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedHorseEntity, model)
        end

        PlayerData.Horses[horseIndex].identifier     = data[1]
        PlayerData.Horses[horseIndex].charidentifier = data[2]

        PlayerData.Horses[horseIndex].loaded_components = false

    elseif action == 'DELETE' then

        PlayerData.Horses[horseIndex] = nil

	elseif action == 'NETWORK_ID' then
		PlayerData.Horses[horseIndex].entity = data[1]

        PlayerData.Horses[horseIndex].loaded_components = false

    elseif action == 'HORSE_SHOES' then

        PlayerData.Horses[horseIndex].stats.shoes_type     = data[1]
        PlayerData.Horses[horseIndex].stats.shoes_km_left  = data[2]

    elseif action == 'UPDATE_COMPONENTS' then

        PlayerData.Horses[horseIndex].components = data[1]

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

        local getRealAge = math.floor(PlayerData.Horses[PlayerData.SelectedHorseIndex].age * 1 / 1440)
        local isAgedDead = getRealAge >= Config.Ageing.MaximumAge
    
        if isAgedDead then
            SendNotification(nil, Locales['HORSE_DEAD_FROM_AGEING'], "error")
            return
        end

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

RegisterNetEvent('tpz_stables:client:onFeedItemUse')
AddEventHandler('tpz_stables:client:onFeedItemUse', function(item)

    if Config.HorseFeedItems[item] == nil then
        return
    end

    local ItemData   = Config.HorseFeedItems[item]

    local PlayerData = GetPlayerData()
    local playerPed  = PlayerPedId()

    if not IsPedOnMount(playerPed) then
        SendNotification(nil, Locales['HORSE_FEED_ON_MOUNT'], "error")
        return
    end

    if not PlayerData.SpawnedHorseEntity then
        SendNotification(nil, Locales['HORSE_FEED_NOT_OWNED'], "error")
        return
    end

    local HorseData = PlayerData.Horses[PlayerData.SelectedHorseIndex]

    local horse = GetMount(playerPed)
    local rider = GetRiderOfMount(horse, true)

    if horse == PlayerData.SpawnedHorseEntity and rider == playerPed then

        Citizen.InvokeNative(0xCD181A959CFDD7F4, playerPed, horse, -224471938, 0, 0)
        PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

        TriggerServerEvent("tpz_stables:server:onFeedItemUse", item)

        if ItemData.Health > 0 then

            local currentCoreHealth = GetAttributeCoreValue(horse, 0)
            SetAttributeCoreValue(horse, 0, currentCoreHealth + ItemData.Health)
        end

        if ItemData.Stamina > 0 then
            local currentCoreStamina = GetAttributeCoreValue(horse, 1)
            SetAttributeCoreValue(horse, 1, currentCoreStamina + ItemData.Stamina )
        end

    else
        SendNotification(nil, Locales['HORSE_FEED_NOT_OWNED'], "error")
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
        Wait(2000)

        local PlayerData = GetPlayerData()

        if PlayerData.IsLoaded then

            local itemSet = CreateItemset(true)
            local size = Citizen.InvokeNative(0x59B57C4B06531E1E, GetEntityCoords(PlayerPedId()), 40.0, itemSet, 1, Citizen.ResultAsInteger())
            if size > 0 then
                for index = 0, size - 1 do
                    local entity = GetIndexedItemInItemset(index, itemSet)  

                    if GetPedType(entity) == 28 then

                        local model = GetEntityModel(entity)

                        if Citizen.InvokeNative(0x772A1969F649E902, model) == 1 then -- IS_MODEL_A_HORSE

                            if NetworkGetEntityIsNetworked(entity) then

                                local network = NetworkGetNetworkIdFromEntity(entity)

                                if network and network ~= 0 then
    
                                    local horseId = IsEntityValidHorse(network)
    
                                    if horseId ~= 0 and not PlayerData.Horses[horseId].loaded_prompts then
                                        AddHorsePrompts(entity)
                                        PlayerData.Horses[horseId].loaded_prompts = true
                                    end

                                    if horseId ~= 0 and not PlayerData.Horses[horseId].loaded_components then
                                        LoadHorseComponents(entity, horseId)
                                        PlayerData.Horses[horseId].loaded_components = true
                                    end
        
                                end

                            end

                        end
                    end
                end
            end
            
            if IsItemsetValid(itemSet) then
               DestroyItemset(itemSet)
            end

        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local id = PlayerId()

        if IsPlayerTargettingAnything(id) then

            local result, entity = GetPlayerTargetEntity(id)

            if NetworkGetEntityIsNetworked(entity) then

                local network = NetworkGetNetworkIdFromEntity(entity)

                local PlayerData = GetPlayerData()

                if network and network ~= 0 and PlayerData.IsLoaded then
    
                    local horseId = IsEntityValidHorse(network)
                    local HorsePrompts = GetHorsePrompts()

                    if horseId ~= 0 and HorsePrompts[entity] then

                        local HorseData = PlayerData.Horses[horseId]

                        local coords       = GetEntityCoords(PlayerPedId())
                        local entityCoords = GetEntityCoords(entity)
                        local distance     = #(coords - entityCoords)

                        local isSecondaryInventoryActive = exports.tpz_inventory:getInventoryAPI().isSecondaryInventoryActive()

                        if distance <= 1.5 and not PlayerData.IsBusy and not isSecondaryInventoryActive then
                            PromptSetEnabled(HorsePrompts[entity]['SADDLEBAG'], 1)
                            PromptSetEnabled(HorsePrompts[entity]['BRUSH'], 1)
                        else
                            PromptSetEnabled(HorsePrompts[entity]['SADDLEBAG'], 0)
                            PromptSetEnabled(HorsePrompts[entity]['BRUSH'], 0)
                        end

                        local isHorseDead = IsPedDeadOrDying(entity, 1) and 1 or 0

                        if isHorseDead == 1 or HorseData.isdead == 1 then
                            PromptSetEnabled(HorsePrompts[entity]['BRUSH'], 0)
                        end

                        if PromptHasStandardModeCompleted(HorsePrompts[entity]['SADDLEBAG']) then 

                            local isOwner = tonumber(HorseData.charidentifier) == tonumber(PlayerData.CharIdentifier)
                            local hasRequiredJob = IsPermittedToAccessBag(PlayerData.Job, Config.Storages.Horses.SearchByJobs.Jobs)
    
                            -- checking for jobs (if enabled) or ownership
                            if (isOwner) or (Config.Storages.Horses.SearchByJobs.Enabled and hasRequiredJob) then

                                Citizen.InvokeNative(0x4707E9C23D8CA3FE, PlayerPedId(), entity)
                                Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), entity, GetHashKey("Interaction_LootSaddleBags"), 0, 1)

                                exports.tpz_inventory:getInventoryAPI().openInventoryContainerById(tonumber(HorseData.container), Config.Storages.Horses.InventoryStorageHeader)
                            else
                                SendNotification(nil, Locales['NOT_PERMITTED_ACCESS_BAG'], "error")
                            end

                        end

                        if PromptHasStandardModeCompleted(HorsePrompts[entity]['BRUSH']) then

                            PlayerData.IsBusy = true

                            TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_stables:callbacks:canBrushHorse", function(success)

                                if success then

                                    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), entity, GetHashKey("INTERACTION_BRUSH"), 0, 0)
                                    Wait(9000)
                                    Citizen.InvokeNative(0xE3144B932DFDFF65, entity, 0.0, -1, 1, 1)
                                    ClearPedEnvDirt(entity)
                                    ClearPedDamageDecalByZone(entity, 10 , "ALL")
                                    ClearPedBloodDamage(entity)
                                    Citizen.InvokeNative(0xD8544F6260F5F01E, entity, 10)
        
                                end

                                PlayerData.IsBusy = false
                            end)

                        end

                    end

                end

            end

        end

    end

end)

--[[
-- Loading components through rendering.
Citizen.CreateThread(function()

    RegisterHorseActionPrompts()

    while true do

        Wait(0)

        local PlayerData = GetPlayerData()
        local sleep      = true
        
        if PlayerData.IsLoaded then

            local player     = PlayerPedId()

            local coords     = GetEntityCoords(player)
            local coordsDist = vector3(coords.x, coords.y, coords.z)

            for index, horse in pairs (PlayerData.Horses) do

                if horse.entity and horse.entity ~= 0 then

                    local entityPed = Citizen.InvokeNative(0xBDCD95FC216A8B3E, horse.entity)

                    if DoesEntityExist(entityPed) then
                        
                        local entityCoords = GetEntityCoords(entityPed)
                        local entityDist   = vector3(entityCoords.x, entityCoords.y, entityCoords.z)
                        local distance     = #(coordsDist - entityDist)

                        if (distance <= Config.LoadComponentsRendering) and not horse.loaded_components then

                            LoadHorseComponents(entityPed, horse.id)
                            PlayerData.Horses[horse.id].loaded_components = true

                        end

                        -- Checking near horse distance while player is not on mount and horse has a bag equipped.
                        if distance <= Config.Storages.Horses.SearchActionDistance then

                            -- We check below in order to not check all of them at the same time but only when distance near.
                            if not IsPedOnMount(player) then
                                sleep = false

                                local promptGroup, promptList = GetHorseActionsPromptData()
    
                                local label = CreateVarString(10, 'LITERAL_STRING', PlayerData.Horses[horse.id].name )
                                PromptSetActiveGroupThisFrame(promptGroup, label)

                                local isOwner = tonumber(horse.charidentifier) == tonumber(PlayerData.CharIdentifier)
    
                                for index, prompt in pairs (promptList) do 

                                    PromptSetEnabled(prompt.prompt, 1)
                                    PromptSetVisible(prompt.prompt, 1)

                                    if (prompt.type == 'SEARCH' and horse.components['BAG'] == 0 or horse.container == 0) or (prompt.type == 'MENU' and not isOwner) then
                                        PromptSetEnabled(prompt.prompt, 0)
                                        PromptSetVisible(prompt.prompt, 0)
                                    end

                                    if PromptHasHoldModeCompleted(prompt.prompt) then
    
                                        if prompt.type == 'SEARCH' then

                                            local hasRequiredJob = IsPermittedToAccessBag(PlayerData.Job, Config.Storages.Horses.SearchByJobs.Jobs)
        
                                            -- checking for jobs (if enabled) or ownership
                                            if (isOwner) or (Config.Storages.Horses.SearchByJobs.Enabled and hasRequiredJob) then
                                                Citizen.InvokeNative(0xCD181A959CFDD7F4, player, entityPed, GetHashKey("Interaction_LootSaddleBags"), 0, 1)

                                                exports.tpz_inventory:getInventoryAPI().openInventoryContainerById(tonumber(horse.container), Config.Storages.Horses.InventoryStorageHeader)
                                            else
                                                SendNotification(nil, Locales['NOT_PERMITTED_ACCESS_BAG'], "error")
                                            end

                                        elseif prompt.type == 'MENU' then

                                            local isHorseDead = IsPedDeadOrDying(entityHandler, 1) and 1 or 0

                                            if isHorseDead == 0 and horse.isdead == 0 then

                                            else
                                                SendNotification(nil, Locales['HORSE_UNCONSIOUS'], "error")
                                            end

                                        end
    
                                        Wait(1000)
        
                                    end

                                    
                                end

                            end

                        end

                    end

                end

            end

        end

        if sleep then
            Wait(1000)
        end

    end


end)]]--


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
