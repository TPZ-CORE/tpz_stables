local TPZ = exports.tpz_core:getCoreAPI()

local WhistleCooldown = 0

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

local function SetFleeAway()
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
        TriggerServerEvent("tpz_stables:server:saveHorse", PlayerData.SelectedHorseIndex, stamina + 0.0, health, trainingPoints, true)

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

    if HorseData == nil then
        -- does not exist anymore
        return
    end

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

    end

    PlayerData.SpawnedHorseEntity = entity

    local isAgedDead = HorseData.age >= Config.Ageing.MaximumAge

    if HorseData.stats.health <= 0 or isAgedDead then
		SetEntityCanBeDamaged(entity, true)
        Citizen.InvokeNative(0x697157CED63F18D4, entity, 10000)

        if isAgedDead then
            SendNotification(nil, Locales['HORSE_DEAD_FROM_AGEING'], "error")
        else
            SendNotification(nil, Locales['HORSE_UNCONSIOUS'], "error")
        end

    else
		FollowOwner()
    end

end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

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

       -- Citizen.InvokeNative(0xD6401A1B2F63BED6, playerPed, 0x33D023F4, 1)

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
        -- no horse owned 
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