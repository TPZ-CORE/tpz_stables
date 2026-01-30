local TPZ = exports.tpz_core:getCoreAPI()

local WhistleCooldown = 0
local IsNearbyWagon   = 0

local AttachedHammer  = nil

local STOW_ACTION_TYPE = nil

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local GetWagonBrokenWheels = function(entity)
    local broken = {}
    for i = 0, 4 do
        local isBroken = Citizen.InvokeNative(0xCB2CA620C48BC875, entity, i)
        if isBroken then
            table.insert(broken, i) -- store the wheel index
        end
    end
    return broken
end

local GetNearestStableLocation = function()

    local player        = PlayerPedId()
    local coords        = GetEntityCoords(player)
    local locationIndex = nil, nil
  
    for index, location in pairs(Config.Locations) do
  
        if location.Wagons.AllowWagonCalling then

            local locationCoords = vector3(location.Wagons.SpawnSelectCoords.x, location.Wagons.SpawnSelectCoords.y, location.Wagons.SpawnSelectCoords.z)
            local currentDistance = #(coords - locationCoords)
        
            if currentDistance <= Config.CallWagonNearStableDistance then
                locationIndex = index

              break

            end

        end
  
    end

    return locationIndex

end

local HasRequiredRepairJob = function(currentJob)

    for _, job in pairs (Config.WagonRepairs.Jobs) do 

        if job == currentJob then 
            return true
        end

    end

    return false
end

local function OnAttachedHammer()

    local attachmentData = Config.WagonRepairs.ObjectAttachment

    if AttachedHammer == nil then

        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed) 

        LoadModel(attachmentData.Object)

        local object = CreateObject(GetHashKey(attachmentData.Object), coords.x, coords.y, coords.z , 0.2, true, true, false, false, true)

        local boneIndex = GetEntityBoneIndexByName(playerPed, attachmentData.Attachment)
                
        AttachEntityToEntity(object, playerPed, boneIndex, 
        attachmentData.x, attachmentData.y, attachmentData.z, attachmentData.xRot, attachmentData.yRot, attachmentData.zRot, 
        true, true, false, true, 1, true)

        AttachedHammer = object

    else

        RemoveEntityProperly(AttachedHammer, GetHashKey(attachmentData.Object))
        AttachedHammer = nil

    end
 
end

local function GetCarcassMetaTag(entity)
    local metatag = {}
    local numComponents = GetNumComponentsInPed(entity)
    for i = 0, numComponents - 1, 1 do
        local drawable, albedo, normal, material = GetMetaPedAssetGuids(entity, i)
        local palette, tint0, tint1, tint2 = GetMetaPedAssetTint(entity, i)
        metatag[i] = {
            drawable = drawable,
            albedo = albedo,
            normal = normal,
            material = material,
            palette = palette,
            tint0 = tint0,
            tint1 = tint1,
            tint2 = tint2
        }
        -- print(i, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
    end
    return metatag
end

local function GetPedMetaOutfitHash(ped)
    return Citizen.InvokeNative(0x30569F348D126A5A, ped, Citizen.ResultAsInteger())
end

local function IsEntityFullyLooted(entity)
    return Citizen.InvokeNative(0x8DE41E9902E85756, entity)
end

local function GetPedDamageCleanliness(ped)
    return Citizen.InvokeNative(0x88EFFED5FE8B0B4A, ped, Citizen.ResultAsInteger())
end

local function GetPedQuality(ped)
    return Citizen.InvokeNative(0x7BCC6087D130312A, ped)

    -- enum ePedQuality { PQ_INVALID = -1, PQ_LOW, PQ_MEDIUM, PQ_HIGH, PQ_MAX }; -1 - 3
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


function RemoveOwnedWagonVehicleProperly(dontSave)
    local PlayerData = GetPlayerData()

    if PlayerData.SpawnedWagonEntity then

        if DoesEntityExist(PlayerData.SpawnedWagonEntity) then

            if not dontSave then
                
                local brokenWheels = GetWagonBrokenWheels(PlayerData.SpawnedWagonEntity)
                local wheelStates  = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 }
    
                for _, idx in ipairs(brokenWheels) do
                    wheelStates[tostring(idx)] = 1
                end
    
                PlayerData.Wagons[PlayerData.SelectedWagonIndex].wheels = wheelStates

                TriggerServerEvent("tpz_stables:server:saveWagon", PlayerData.SelectedWagonIndex, json.encode(brokenWheels))
            end

            TriggerServerEvent("tpz_stables:server:updateWagon", PlayerData.SelectedWagonIndex, 'NETWORK_ID', { 0 })

            local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedWagonEntity)
    
            if hasRequestedControl then
                local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
                RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
            end

            IsNearbyWagon = 0

            PlayerData.SpawnedWagonEntity = nil
            PlayerData.SpawnedWagonIndex  = 0

        end

    end

end

function ApplyCarcasMetaTag(entity, metatag)
    if #metatag < 1 then return end
    -- TriggerEvent('table', metatag)
    for i = 0, #metatag, 1 do
        local data = metatag[i]
        SetMetaPedTag(entity, data.drawable, data.albedo, data.normal, data.material, data.palette, data.tint0, data.tint1, data.tint2)
        -- print(i, data.drawable, data.albedo, data.normal, data.material, data.palette, data.tint0, data.tint1, data.tint2)
    end
    UpdatePedVariation(entity)
end

function CalculateTarpHeight(totalItem)
    if not totalItem then return 0.0 end
    local num = totalItem / Config.MaxHuntingWagonCargo
    local rounded_num = math.floor(num * 100 + 0.5) / 100
    return rounded_num
end

function TaskStatus(task)
    local count = 0
    repeat
        count += 1
        Wait(0)
    until (GetScriptTaskStatus(PlayerPedId(), task, true) == 8) or count > 100
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

        local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedWagonEntity)

        if hasRequestedControl then
            local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
        end

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
            wheels         = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 },
            components     = { colors = 0, livery = 0, props = 0, lights = 0 },
            type           = data[4],
            bought_account = data[5],
            container      = data[6],
            stow           = {},
            date           = data[7],
            loaded_components  = false,
        }

        PlayerData.Wagons[wagonIndex] = wagon_data

    elseif action == 'TRANSFERRED' then

        if PlayerData.SpawnedWagonEntity and PlayerData.SpawnedWagonIndex == wagonIndex then

            local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedWagonEntity)

            if hasRequestedControl then
                local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
                RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)

                PlayerData.SpawnedWagonEntity = nil
                PlayerData.SpawnedWagonIndex  = 0
            end

        end

        PlayerData.Wagons[wagonIndex].identifier     = data[1]
        PlayerData.Wagons[wagonIndex].charidentifier = data[2]

        PlayerData.Wagons[wagonIndex].loaded_components = false

    elseif action == 'DELETE' then

        if PlayerData.SpawnedWagonEntity and PlayerData.SpawnedWagonIndex == wagonIndex then

            local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedWagonEntity)

            if hasRequestedControl then
                local model = GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model )
                RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)

                PlayerData.SpawnedWagonEntity = nil
                PlayerData.SpawnedWagonIndex  = 0
            end

        end

        PlayerData.Wagons[wagonIndex] = nil

	elseif action == 'NETWORK_ID' then
        
        PlayerData.Wagons[wagonIndex].entity = data[1]
        PlayerData.Wagons[wagonIndex].loaded_components = false
        PlayerData.Wagons[wagonIndex].loaded_prompts    = false

        local entity = NetworkGetEntityFromNetworkId(PlayerData.Wagons[wagonIndex].entity)
    
        if DoesEntityExist(entity) then
            
            Wait(750)
            local stow_results = TPZ.GetTableLength(PlayerData.Wagons[wagonIndex].stow)
            height = CalculateTarpHeight( stow_results)
            SetBatchTarpHeight(entity, height, false)
        end

    elseif action == 'INSERT_STOW_ITEM' then 

        table.insert(PlayerData.Wagons[wagonIndex].stow, data)

        if PlayerData.Wagons[wagonIndex].entity ~= 0 then 

            local entity = NetworkGetEntityFromNetworkId(PlayerData.Wagons[wagonIndex].entity)
    
            if DoesEntityExist(entity) then
                
                local stow_results = TPZ.GetTableLength(PlayerData.Wagons[wagonIndex].stow)
                height = CalculateTarpHeight( stow_results)
    
                SetBatchTarpHeight(entity, height, false)
            end

        end
        
    elseif action == 'DELETE_STOW_ITEM' then 

        for _, item in pairs (PlayerData.Wagons[wagonIndex].stow) do 

            if tostring(item.date) == tostring(data.date) then 
    
                if tostring(item.date) == (data.date) then 
                    table.remove(PlayerData.Wagons[wagonIndex].stow, _)

                    break
                end
    
            end
    
        end

        if PlayerData.Wagons[wagonIndex].entity ~= 0 then 

            local entity = NetworkGetEntityFromNetworkId(PlayerData.Wagons[wagonIndex].entity)
    
            if DoesEntityExist(entity) then
                
                local stow_results = TPZ.GetTableLength(PlayerData.Wagons[wagonIndex].stow)
                height = CalculateTarpHeight( stow_results)

                SetBatchTarpHeight(entity, height, false)
            end

        end

    elseif action == 'UPDATE_COMPONENTS' then

        PlayerData.Wagons[wagonIndex].components = data[1]

    elseif action == 'REPAIRED' then 

        IsNearbyWagon = 0

        PlayerData.Wagons[wagonIndex].wheels = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 }

        if tonumber(PlayerData.CharIdentifier) == tonumber(PlayerData.Wagons[wagonIndex].charidentifier) then

            local coords  = nil
            local heading = 0

            if DoesEntityExist(PlayerData.SpawnedWagonEntity) then
                local entityCoords = GetEntityCoords(PlayerData.SpawnedWagonEntity)
                local heading = GetEntityHeading(PlayerData.SpawnedWagonEntity)
                coords = { x = entityCoords.x, y = entityCoords.y, z = entityCoords.z, h = heading }
            end

            RemoveOwnedWagonVehicleProperly(true)

            Wait(1000)
            WhistleCooldown = 0

            TriggerEvent("tpz_stables:client:whistle_wagon", coords)

        end

	elseif action == 'RENAME' then
		PlayerData.Wagons[wagonIndex].name = data[1]
	end

end)

Citizen.CreateThread(function()
    TriggerServerEvent("tpz_stables:server:a", 1, 'NETWORK_ID', { 1 })
end)

-- @param existingCoords is for repairs.
RegisterNetEvent("tpz_stables:client:whistle_wagon")
AddEventHandler("tpz_stables:client:whistle_wagon", function(existingCoords)
	local playerPed  = PlayerPedId()
    local PlayerData = GetPlayerData()

    if WhistleCooldown > 0 then
		SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["WAIT_FOR_CALLING"], "error", 3, "wagon", "left")
		return
	end
    
    if PlayerData.IsLoaded and PlayerData.SelectedWagonIndex ~= 0 then

        -- When spawning, we check if player has already an owned wagon spawned to remove.
        if PlayerData.SpawnedWagonEntity then
            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CALL_WAGON_ALREADY_SPAWNED"], "error", 5, "wagon", "left")
            return
        end

        local isSwimming = Citizen.InvokeNative(0x9DE327631295B4C2, playerPed)
        local isSwimmingUnderWater = Citizen.InvokeNative(0xC024869A53992F34, playerPed)

        if isSwimming or isSwimmingUnderWater then
            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CALL_WAGON_SWIMMING"], "error", 3, "wagon", "left")
            return
        end

        local nearestStableIndex = GetNearestStableLocation()

        if not nearestStableIndex then
            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CALL_NOT_NEARBY_STABLE_WAGON"], "error", 3, "wagon", "left")
            return
        end

        local coords = Config.Locations[nearestStableIndex].Wagons.SpawnSelectCoords

        if existingCoords then 
            coords = existingCoords
        end

        local nearVehicles = GetNearestVehicles(vector3(coords.x, coords.y, coords.z), 10.0, nil)

        if TPZ.GetTableLength(nearVehicles) > 0 then
            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CANNOT_SPAWN_WAGON_NEARBY_WAGONS"], "error",5, "wagon", "left")
            return
        end

        Citizen.InvokeNative(0xB31A277C1AC7B7FF, playerPed, 1, 2, GetHashKey("KIT_EMOTE_ACTION_FOLLOW_ME_1"),0,0,0,0,0)  -- FULL BODY EMOTE

        local WagonData = PlayerData.Wagons[PlayerData.SelectedWagonIndex]

        WhistleCooldown = Config.CallWagonCooldown
        TriggerEvent("tpz_stables:client:whistle_wagon_cooldown")

        LoadModel(WagonData.model)

        local vehicle = CreateVehicle(GetHashKey(WagonData.model), coords.x, coords.y, coords.z, coords.h, true, false)
        SetVehicleOnGroundProperly(vehicle)

        if WagonData.model == 'huntercart01' then 

            local tarpPropSet = `PG_MP005_HUNTINGWAGONTARP01`
            local lightPropSet = `PG_VEH_CART06_LANTERNS01`

            Citizen.InvokeNative(0x75F90E4051CC084C, vehicle, tarpPropSet)  -- AddAdditionalPropSetForVehicle
            Citizen.InvokeNative(0xC0F0417A90402742, vehicle, lightPropSet) -- AddLightPropSetToVehicle

            if WagonData.stow == nil then 
                WagonData.stow = {}
            end
        end

        SetModelAsNoLongerNeeded(GetHashKey(WagonData.model))
        SetEntityFadeIn(vehicle)

        Citizen.InvokeNative(0x79811282A9D1AE56, vehicle)
        SetEntityHealth(vehicle, 1000, 0)
        Citizen.InvokeNative(0xAC2767ED8BDFAB15, vehicle, 1000)
        Citizen.InvokeNative(0x55CCAAE4F28C67A0, vehicle, 1000)

        local network = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent("tpz_stables:server:updateWagon", PlayerData.SelectedWagonIndex, 'NETWORK_ID', { network })

        local wagon_blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, 631964804, vehicle)
        Citizen.InvokeNative(0x9CB1A1623062F402, wagon_blip, WagonData.name)

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)

        Wait(2000)
        
        for wheel, value in pairs (WagonData.wheels) do

            if tonumber(value) == 1 then 

                if tonumber(wheel) == 2 then 
                    wheel = 4
                end

                if tonumber(wheel) == 3 then 
                    wheel = 5
                end

                Citizen.InvokeNative(0xD4F5EFB55769D272, vehicle, tonumber(wheel))
            end

        end

        PlayerData.SpawnedWagonIndex  = PlayerData.SelectedWagonIndex
        PlayerData.SpawnedWagonEntity = vehicle
        PlayerData.SpawnedWagonModel  = WagonData.model
 
        TriggerEvent("tpz_stables:client:wagon_distance_tasks")

	else
        SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["WAGON_NOT_OWNED"], "error", 3, "wagon", "left")
    end
end)

-----------------------------------------------------------
--[[ Commands ]]--
-----------------------------------------------------------

RegisterCommand(Config.CallWagonCommand, function() TriggerEvent('tpz_stables:client:whistle_wagon') end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

if Config.CallWagonKey.Enabled then
    -- The specified task is required to be for everyone, its when calling a wagon with a key.
    Citizen.CreateThread(function()
        while true do
    
            local PlayerData = GetPlayerData()
            local sleep      = 2000
    
            -- The specified prevents the task to be running when player is busy or when player does not have any wagon or when already spawned a wagon.
            if IsPlayerNotBusy() and PlayerData.SelectedWagonIndex ~= 0 and PlayerData.SpawnedWagonEntity == nil then

                sleep = 1

                if IsControlJustReleased(0, Config.CallWagonKey.Key) or Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.CallWagonKey.Key) then -- Whistle (Call)
                    if not IsNuiFocused() then
                        TriggerEvent('tpz_stables:client:whistle_wagon')
                    end
                    Wait(1000)

                end
    
            end

            Wait(sleep)
    
        end
    
    end)

end

Citizen.CreateThread(function()

    RegisterWagonActionPrompts()
    
    while true do

        local sleep = 1500

        if not IsPlayerNotBusy() then
            goto END
        end

        if IsNearbyWagon == 0 then

            local PlayerData = GetPlayerData()

            local player     = PlayerPedId()
            local coords     = GetEntityCoords(player)

            for index, wagon in pairs (PlayerData.Wagons) do 

                if tonumber(wagon.entity) ~= 0 then 

                    local entity = NetworkGetEntityFromNetworkId(wagon.entity)
    
                    if DoesEntityExist(entity) then
    
                        local distance = #(coords - GetEntityCoords(entity))
                        if distance <= Config.WagonActionDistance then

                            IsNearbyWagon = wagon.id

                            UiPromptSetEnabled(GetWardrobeWagonPrompt(), 0) -- we hide the wardrobe prompt.
                            UiPromptSetVisible(GetWardrobeWagonPrompt(), 0) -- we hide the wardrobe prompt.

                            UiPromptSetEnabled(GetStoreWagonPrompt(), 0)
                            UiPromptSetVisible(GetStoreWagonPrompt(), 0) 

                            UiPromptSetEnabled(GetWagonRepairPrompt(), 0)
                            UiPromptSetVisible(GetWagonRepairPrompt(), 0) 

                            UiPromptSetEnabled(GetStowWagonPrompt(), 0) 
                            UiPromptSetVisible(GetStowWagonPrompt(), 0)

                            TriggerEvent("tpz_stables:client:wagon_action_prompts")
                        end
    
                    end
    
                end
                    
            end
        end

        if IsNearbyWagon ~= 0 then 

            sleep = 1250

            local PlayerData = GetPlayerData()
            local player     = PlayerPedId()
            local coords     = GetEntityCoords(player)

            local entity = NetworkGetEntityFromNetworkId(PlayerData.Wagons[IsNearbyWagon].entity)
    
            if DoesEntityExist(entity) then

                local distance = #(coords - GetEntityCoords(entity))

                if distance > Config.WagonActionDistance then
                    IsNearbyWagon = 0
                end

            end

        end

        ::END::
        Wait(sleep)
    end

end)

AddEventHandler("tpz_stables:client:wagon_action_prompts", function()

    local isWagonOwner = false

    Citizen.CreateThread(function()

        while IsNearbyWagon ~= 0 do
    
            Wait(1)

            local PlayerData = GetPlayerData()
            local WagonData  = PlayerData.Wagons[IsNearbyWagon]

            if not IsPlayerNotBusy() then
                IsNearbyWagon = 0
                break 
            end
            
            if WagonData then

                local promptText = WagonData.name == nil and "" or WagonData.name

                if WagonData.name == nil then 
                    WagonData.name = ""
                end

                if WagonData.model == 'huntercart01' and tonumber(PlayerData.CharIdentifier) == tonumber(WagonData.charidentifier) then 
                    local stow_results = WagonData.stow == nil and 0 or TPZ.GetTableLength(WagonData.stow)
                    promptText = WagonData.name .. " | " .. string.format(Locales['STOW_CAPACITY'], stow_results, Config.MaxHuntingWagonCargo)
                end

                PromptSetActiveGroupThisFrame(GetWagonPromptsList(), CreateVarString(10, 'LITERAL_STRING', promptText))

                if tonumber(PlayerData.CharIdentifier) == tonumber(WagonData.charidentifier) and not isWagonOwner then
                    UiPromptSetEnabled(GetWardrobeWagonPrompt(), 1)
                    UiPromptSetVisible(GetWardrobeWagonPrompt(), 1) 

                    UiPromptSetVisible(GetStoreWagonPrompt(), 1) 

                    UiPromptSetEnabled(GetSearchWagonPrompt(), 1)
                    UiPromptSetVisible(GetSearchWagonPrompt(), 1) 

                    if DoesEntityExist(PlayerData.SpawnedWagonEntity) then
                        local nearestStableIndex = GetNearestStableLocation()
                        local horse = Citizen.InvokeNative(0xA8BA0BAE0173457B, PlayerData.SpawnedWagonEntity, 0) -- GetPedInDraftHarness
                        local brokenWheels = GetWagonBrokenWheels(PlayerData.SpawnedWagonEntity)

                        if not DoesEntityExist(horse) or #brokenWheels >= 2 or nearestStableIndex then
                            UiPromptSetEnabled(GetStoreWagonPrompt(), 1)
                        end

                    end

                    if HasRequiredRepairJob(PlayerData.Job) then 

                        local entity = NetworkGetEntityFromNetworkId(WagonData.entity)

                        if DoesEntityExist(entity) then
                            
                            local brokenWheels = GetWagonBrokenWheels(entity)

                            if #brokenWheels >= 1 then
                                UiPromptSetVisible(GetWagonRepairPrompt(), 1) 
                                UiPromptSetEnabled(GetWagonRepairPrompt(), 1) 
                            end

                        end
                    end

                    isWagonOwner = true
                end

                if WagonData.model == 'huntercart01' then 
                        
                    UiPromptSetEnabled(GetStowWagonPrompt(), 1)
                    UiPromptSetVisible(GetStowWagonPrompt(), 1) 

                    local carriedEntity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())

                    if carriedEntity and (not IsPedHuman(carriedEntity) or not IsEntityAPed(carriedEntity)) then
                        UiPromptSetText(GetStowWagonPrompt(), CreateVarString(10, 'LITERAL_STRING', Config.HuntingWagonPrompts.PromptDisplay))
                        STOW_ACTION_TYPE = 'STOW'

                        UiPromptSetEnabled(GetWardrobeWagonPrompt(), 0)
                        UiPromptSetVisible(GetWardrobeWagonPrompt(), 0) 

                        UiPromptSetEnabled(GetStoreWagonPrompt(), 0)
                        UiPromptSetVisible(GetStoreWagonPrompt(), 0) 

                        UiPromptSetEnabled(GetWagonRepairPrompt(), 0)
                        UiPromptSetVisible(GetWagonRepairPrompt(), 0) 

                        UiPromptSetEnabled(GetSearchWagonPrompt(), 0)
                        UiPromptSetVisible(GetSearchWagonPrompt(), 0) 
                        

                    else
                        UiPromptSetText(GetStowWagonPrompt(), CreateVarString(10, 'LITERAL_STRING', Config.HuntingWagonPrompts.TakeOutPromptDisplay))
                        STOW_ACTION_TYPE = 'TAKE_OUT'
                    end

                end

    
                if Citizen.InvokeNative(0xC92AC953F0A982AE, GetSearchWagonPrompt()) then  -- PromptHasStandardModeCompleted
    
                    if WagonData.container ~= 0 then
                        local isOwner = tonumber(WagonData.charidentifier) == tonumber(PlayerData.CharIdentifier)
                        local hasRequiredJob = IsPermittedToAccessBag(PlayerData.Job, Config.Storages.Wagons.SearchByJobs.Jobs)

                        if (isOwner) or (Config.Storages.Wagons.SearchByJobs.Enabled and hasRequiredJob) then

                            exports.tpz_inventory:getInventoryAPI().openInventoryContainerById(tonumber(WagonData.container), Config.Storages.Wagons.InventoryStorageHeader, false, false)
        
                        else
                            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["NOT_PERMITTED_ACCESS_WAGON_STORAGE"], "error", 5, "wagon", "left")
                        end
                    else
                        SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["NO_WAGON_STORAGE_AVAILABLE"], "error", 5, "wagon", "left")
                    end

                    Wait(2000)
                end
        
                if Citizen.InvokeNative(0xC92AC953F0A982AE, GetWardrobeWagonPrompt()) then  -- PromptHasStandardModeCompleted

                    if tonumber(PlayerData.CharIdentifier) == tonumber(WagonData.charidentifier) then
                        TriggerEvent(Config.WagonWardrobeOutfits.ClientEvent)
    
                    end

                    Wait(2000)
    
                end

                if Citizen.InvokeNative(0xC92AC953F0A982AE, GetStoreWagonPrompt()) then  -- PromptHasStandardModeCompleted

                    if tonumber(PlayerData.CharIdentifier) == tonumber(WagonData.charidentifier) then
                        RemoveOwnedWagonVehicleProperly()
                    end

                    Wait(2000)
    
                end

                if Citizen.InvokeNative(0xC92AC953F0A982AE, GetStowWagonPrompt()) then  -- PromptHasStandardModeCompleted

                    if tonumber(PlayerData.CharIdentifier) == tonumber(WagonData.charidentifier) then
                        
                        if STOW_ACTION_TYPE == 'STOW' then 

                            local carriedEntity = GetFirstEntityPedIsCarrying(PlayerPedId())
                            local carriedModel  = GetEntityModel(carriedEntity)

                            if not Config.StowableModels[carriedModel] then
                                SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CANNOT_STOW_THIS"], "error", 4, "wagon", "left")
                                
                            else 

                                local canCarry = exports.tpz_core:ClientRpcCall().Callback.TriggerAwait("tpz_stables:callbacks:canCarryStowItems", { wagonIndex = WagonData.id } )

                                if canCarry then
                                    local playerPedId = PlayerPedId()
                                    local wagon = NetworkGetEntityFromNetworkId(WagonData.entity)
    
                                    local isPelt = Config.StowableModels[carriedModel].isPelt == 1 and true or false
                                    local height = 0
                                    local offset = GetOffsetFromEntityInWorldCoords(wagon, 0.0, -2.7, 0.0)
                                 
                                    TaskTurnPedToFaceEntity(playerPedId, wagon, 100)
                                    TaskStatus(`SCRIPT_TASK_TURN_PED_TO_FACE_ENTITY`)
    
                                    local data = {
                                        model = carriedModel,
                                    }
    
                                    if isPelt then
                                        data.peltquality = GetCarriableFromEntity(carriedEntity)
                                    else
                                        data.metatag = GetCarcassMetaTag(carriedEntity)
                                        data.outfit = GetPedMetaOutfitHash(carriedEntity)
                                        data.skinned = IsEntityFullyLooted(carriedEntity) and 1 or 0
                                        data.damage = GetPedDamageCleanliness(carriedEntity) and 1 or 0
                                        data.quality = GetPedQuality(carriedEntity) and 1 or 0
                                    end
    
                                    TaskGoStraightToCoord(playerPedId, offset.x, offset.y, offset.z, 3.0, 1000, GetEntityHeading(wagon), 0)
                                    TaskStatus(`SCRIPT_TASK_GO_STRAIGHT_TO_COORD`)
                                    TaskPlaceCarriedEntityAtCoord(playerPedId, carriedEntity, GetEntityCoords(wagon), 1.0, 5)
                                    TaskStatus(`SCRIPT_TASK_PLACE_CARRIED_ENTITY_AT_COORD`)
    
                                    Wait(750)
                                    DeleteEntity(carriedEntity)
                                    TriggerServerEvent('tpz_stables:server:addWagonStowItem', WagonData.id, data)

                                else
                                    SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["CANNOT_CARRY_MORE_STOW_ITEMS"], "error", 4, "wagon", "left")
                                end
                            end

                        else 

                            OpenStowMenu(WagonData.id)

                        end

                    end

                    Wait(2000)
    
                end


                if Citizen.InvokeNative(0xC92AC953F0A982AE, GetWagonRepairPrompt()) then  -- PromptHasStandardModeCompleted
                    
                    local entity = NetworkGetEntityFromNetworkId(WagonData.entity)

                    if DoesEntityExist(entity) then
                        
                        local brokenWheels = GetWagonBrokenWheels(entity)
                        
                        local canRepairWheels = exports.tpz_core:ClientRpcCall().Callback.TriggerAwait("tpz_stables:callbacks:canRepairWheels", { wheels = #brokenWheels } )

                        if canRepairWheels then

                            local playerPedId = PlayerPedId()
        
                            OnAttachedHammer()
    
                            -- Face the ped to the wagon
                            TaskTurnPedToFaceEntity(playerPedId, entity, 1000, 0.0, 0.0, 0.0)
                            Wait(1000)
                        
                            -- Play the animation set
                            TPZ.PlayAnimation(playerPedId, { dict = "amb_work@prop_human_repair_wagon_wheel_on@rear@male_a@idle_a", name = "idle_b", blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 0, playbackRate = true } )
                            Wait(2100)
                            TPZ.PlayAnimation(playerPedId, { dict = "amb_work@prop_human_repair_wagon_wheel_on@rear@male_a@idle_a", name = "idle_c", blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 0, playbackRate = true } )
                            Wait(2900)
                            TPZ.PlayAnimation(playerPedId, { dict = "amb_work@prop_human_repair_wagon_wheel_on@rear@male_a@idle_a",  name = "idle_a", blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 0, playbackRate = true } )
                            TPZ.PlayAnimation(playerPedId, { dict = "amb_work@prop_human_repair_wagon_wheel_on@front@male_a@idle_b", name = "idle_d", blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 0, playbackRate = true } )
                            Wait(2100)
                            TPZ.PlayAnimation(playerPedId, { dict = "amb_work@prop_human_repair_wagon_wheel_on@front@male_a@idle_a", name = "idle_c", blendInSpeed = 1.0, blendOutSpeed = 1.0, duration = -1, flag = 0, playbackRate = true } )
                            Wait(2100)
    
                            local sex = IsPedMale(playerPedId) == 1 and 'MALE' or 'FEMALE'
    
                            PlayAnimation(playerPedId, { 
                                dict = Config.WagonRepairs.RepairingAnimation[sex].Dict, 
                                name = Config.WagonRepairs.RepairingAnimation[sex].Name,
                                blendInSpeed = 1.0,
                                blendOutSpeed = 1.0,
                                duration = -1,
                                flag = Config.WagonRepairs.RepairingAnimation[sex].Flag,
                                playbackRate = 0.0
                            })
    
                            TPZ.DisplayProgressBar(1000 * Config.WagonRepairs.RepairingAnimationDuration, Config.WagonRepairs.RepairingProgressTextDisplay)
    
                            ClearPedTasks(playerPedId)
                            OnAttachedHammer()

                            TriggerServerEvent("tpz_stables:server:updateWagon", WagonData.id, 'REPAIRED')
                        end

                    end 

                    Wait(2000)
    
                end
    
            end

        end
    
    end)

end)

AddEventHandler("tpz_stables:client:whistle_wagon_cooldown", function()

    Citizen.CreateThread(function()

        while WhistleCooldown > 0 do

            Wait(1000)

            WhistleCooldown = WhistleCooldown - 1
        
            if WhistleCooldown <= 0 then
                WhistleCooldown = 0
            end

        end

    end)

end)

AddEventHandler("tpz_stables:client:wagon_distance_tasks", function()

    Citizen.CreateThread(function()

        while GetPlayerData().SpawnedWagonEntity do

            local sleep      = 10000
            local PlayerData = GetPlayerData()
    
            if not PlayerData.IsLoaded or not PlayerData.SpawnedWagonEntity then
                goto END
            end
     
            if PlayerData.IsLoaded and PlayerData.SpawnedWagonEntity then
    
                sleep = 4000 -- 4 seconds to check is more than enough.
    
                -- We flee away the wagon in case player has gone too far by walking away, there is no reason having the wagon spawned.
                if DoesEntityExist(PlayerData.SpawnedWagonEntity) then 
    
                    local coords       = GetEntityCoords(PlayerPedId())
                    local entityCoords = GetEntityCoords(PlayerData.SpawnedWagonEntity)
                    local distance     = #(coords - entityCoords)
    
                    if distance > Config.WagonDespawnDistance then
                        local nearestPlayers = TPZ.GetNearestPlayers(Config.WagonDespawnCheckNearPlayersDistance)
    
                        -- Check if there are players nearby the wagon vehicle, this also checks for a rider.
                        if TPZ.GetTableLength(nearestPlayers) <= 0 then 
                            RemoveOwnedWagonVehicleProperly()
                        end
    
                    end
    
                end
    
            end
    
            ::END::
            Wait(sleep)
        end

    end)
    
 
end)



