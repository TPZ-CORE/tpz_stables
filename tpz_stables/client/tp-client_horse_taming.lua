local TPZ = exports.tpz_core:getCoreAPI()

local TamingHorses = {}
local Loaded       = false

local RIDING_TAMED_HORSE_ID = 0
local IS_TAMING = false
local TAMING_COUNTDOWN = Config.Taming.StartTamingCountdown

local HasThreadStarted = false

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local GetMountedTamedHorseId = function()
    local PlayerData  = GetPlayerData()
    local playerPed   = PlayerPedId()
    local id          = 0
    local entityHorse = GetMount(playerPed)
    local rider       = GetRiderOfMount(entityHorse, true)

    if rider == playerPed and entityHorse ~= PlayerData.SpawnedHorseEntity then

        for index, horse in pairs(TamingHorses) do

            if horse.entity ~= 0 and horse.tamed == 0 then

                local entity = NetworkGetEntityFromNetworkId(horse.entity)

                if entity == entityHorse then
                    id = horse.id
                    break
                end

            end

        end

        
    end

    return id 
    
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

end)

-- Gets the player job when devmode set to false and character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

    if Config.Taming.Enabled then
        TriggerServerEvent('tpz_stables:server:requestTamingHorsesData')
    end

end)

-- Gets the player job when devmode set to true.
if Config.DevMode then

    Citizen.CreateThread(function ()

        if Config.Taming.Enabled then
            TriggerServerEvent('tpz_stables:server:requestTamingHorsesData')
        end

    end)
    
end


-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_stables:client:receiveTamingHorsesData')
AddEventHandler('tpz_stables:client:receiveTamingHorsesData', function(cb)
    TamingHorses = cb
    Loaded       = true
end)

RegisterNetEvent('tpz_stables:client:updateTamingHorse')
AddEventHandler('tpz_stables:client:updateTamingHorse', function(cb)
	local PlayerData = GetPlayerData()
	local horseIndex, action, data = cb.horseIndex, cb.action, cb.data

    horseIndex = tonumber(horseIndex)

    if action == 'COOLDOWN' then

        TamingHorses[horseIndex].cooldown = data[1]
        TamingHorses[horseIndex].tamed    = 0

    elseif action == 'SET_TAMED' then
        TamingHorses[horseIndex].tamed = data[1]

    elseif action == 'NETWORK_ID' then
        TamingHorses[horseIndex].entity = data[1]

    elseif action == 'SOLD' or action == 'RECEIVED' then
        
        TamingHorses[horseIndex].source = 0
        TamingHorses[horseIndex].tamed  = 0
        TamingHorses[horseIndex].entity = 0
        
	end

end)

RegisterNetEvent('tpz_stables:client:spawnTamingHorse')
AddEventHandler('tpz_stables:client:spawnTamingHorse', function(horseIndex)
	local PlayerData = GetPlayerData()
    local HorseData  = TamingHorses[horseIndex]

    LoadModel(HorseData.model)

    local entity = CreatePed(GetHashKey(HorseData.model), vector3(HorseData.coords.x, HorseData.coords.y, HorseData.coords.z), true, true, true, true)

    Citizen.InvokeNative(0x283978A15512B2FE, entity, true) -- SetRandomOutfitVariation
    Citizen.InvokeNative(0xA91E6CF94404E8C9, entity) -- animal fade in when spawning

    local PED_TO_NET = Citizen.InvokeNative(0x0EDEC3C276198689, entity)
    TriggerServerEvent('tpz_stables:server:updateTamingHorse', horseIndex, 'NETWORK_ID', { PED_TO_NET })
end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

if Config.Taming.Enabled then

AddEventHandler('tpz_stables:client:start_taming_tasks', function(cb)
    local PlayerData  = GetPlayerData()
    local canDoTaming = false

    if HasThreadStarted then
        return
    end

    if Config.Taming.Jobs == false then
        canDoTaming = true
    end

    if not canDoTaming and Config.Taming.Jobs and TPZ.GetTableLength(Config.Taming.Jobs) > 0 then
        
        for _, job in pairs (Config.Taming.Jobs) do
            if job == PlayerData.Job then
                canDoTaming = true
                break
            end
        end

    end

    if not canDoTaming then
        return
    end

    HasThreadStarted = true
    
    Citizen.CreateThread(function()

        while true do
            Wait(Config.Taming.CheckEvery * 1000)
     
            if Loaded then
      
                local coords = GetEntityCoords(PlayerPedId())
    
                for index, horse in pairs(TamingHorses) do
     
                    local horseSpawnCoords = vector3(horse.coords.x, horse.coords.y, horse.coords.z)
                    local distance         = #(coords - horseSpawnCoords)
        
                    -- We check if player is on a taming area nearby and the area has no cooldown.
                    if distance <= Config.Taming.SpawnDistance and horse.cooldown == 0 then
                        TriggerServerEvent("tpz_stables:server:updateTamingHorse", horse.id, 'REGISTER_SPAWNED')
                        Wait(2000)
                    end

                end
    
            end
    
        end
     
    end)
 

    Citizen.CreateThread(function()

        while true do

            local sleep      = 1500
            local player     = PlayerPedId()
            local PlayerData = GetPlayerData()

            if not Loaded or IsPedSwimming(player) or IsPedSwimmingUnderWater(player) or IsPedInAnyVehicle(player, false) or PlayerData.IsBusy then 
                sleep = 2500
                goto END
            end

            if IsPedOnMount(player) then

                if GetMountedTamedHorseId() ~= 0 then
                    
                    RIDING_TAMED_HORSE_ID = GetMountedTamedHorseId()

                    local horse = TamingHorses[RIDING_TAMED_HORSE_ID]
                    local entity = NetworkGetEntityFromNetworkId(horse.entity)
    
                    Citizen.InvokeNative(0xAEB97D84CDF3C00B, entity, true) -- -wild horse for taming.
    
                    if not IS_TAMING then
    
                        IS_TAMING = true
    
                        SendNUIMessage({ 
                            action = 'displayTamingCountdown',
                            title = Locales['TAMING_STARTS_TITLE'],
                            title_description = string.format(Locales['TAMING_STARTS_DESCRIPTION'], TAMING_COUNTDOWN),
                        })
                        
                        ToggleUI(true)
    
                    end
    
                    if IS_TAMING then
    
                        TAMING_COUNTDOWN = TAMING_COUNTDOWN - 1
    
                        SendNUIMessage({ 
                            action = 'updateTamingCountdown',
                            title_description = string.format(Locales['TAMING_STARTS_DESCRIPTION'], TAMING_COUNTDOWN),
                        })
    
                        if TAMING_COUNTDOWN <= 0 then
                            
                            Citizen.InvokeNative(0xAEB97D84CDF3C00B, entity, true) -- -wild horse for taming.
    
                            CloseNUI()
    
                            Wait(500)
    
                            local success = false
    
                            for index, difficulty in pairs (horse.difficulties) do
    
                                if exports["tpz_skillcheck"]:skillCheck(difficulty) then
    
                                    Citizen.InvokeNative(0xAEB97D84CDF3C00B, entity, true) -- -wild horse for taming.
                    
                                    if next(horse.difficulties, index) == nil then
                                        success = true
                                    end
    
                                else
    
                                    TaskHorseAction(entity,2, player)
    
                                    Wait(250)
    
                                    local entityCoords = GetEntityCoords(entity)
                                    TaskGoToCoordAnyMeans(entity, entityCoords.x + 20.0, entityCoords.y + 20.0, entityCoords.z, 2.0)
    
                                    Wait(5000)
                                    TriggerServerEvent("tpz_stables:server:updateTamingHorse", horse.id, 'FAILED_TAMING' )
    
                                    local NotifyData = Locales['TAMING_FAILED']
                                    TriggerEvent("tpz_notify:sendNotification", NotifyData.title, NotifyData.message, NotifyData.icon, 'error', NotifyData.duration, NotifyData.align)
                                    break
                                end
    
                                local success_state = success and 1 or 0
                                TriggerServerEvent("tpz_stables:server:updateTamingHorse", horse.id, 'SET_TAMED' , { success_state } )
    
                                if success then
                                    Citizen.InvokeNative(0xAEB97D84CDF3C00B, entity, false) -- -wild horse for taming.
    
                                    local NotifyData = Locales['TAMING_SUCCESS']
                                    TriggerEvent("tpz_notify:sendNotification", NotifyData.title, NotifyData.message, NotifyData.icon, 'success', NotifyData.duration, NotifyData.align)
                                end
    
                                RIDING_TAMED_HORSE_ID = 0
                                IS_TAMING             = false
                                TAMING_COUNTDOWN      = Config.Taming.StartTamingCountdown
                            end
    
                        end
    
                    end

                end

            end

            ::END::
            Wait(sleep)

        end

    end)

end)

end