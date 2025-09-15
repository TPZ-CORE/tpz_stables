local TPZ = exports.tpz_core:getCoreAPI()
local TPZInv = exports.tpz_inventory:getInventoryAPI()

local MenuData = {}
TriggerEvent("tpz_menu_base:getData", function(call) MenuData = call end) -- USED FOR GETTING MENU STATE.

local PlayerData = { 
    CharIdentifier     = 0,

    Job                = nil,
    IsBusy             = false,

    CameraHandler      = nil,

    Entity             = nil,
	EntityModel        = nil,

    IsOnMenu           = false,

    HasNUIActive       = false,

    Cash               = 0,
    Gold               = 0,

    Horses             = nil,
    Wagons             = nil,

    SelectedHorseIndex = 0,
    SpawnedHorseEntity = nil,

    SelectedWagonIndex = 0,
    SpawnedWagonIndex  = 0,
    SpawnedWagonEntity = nil,

    IsLoaded           = false,
    
}

local hasContainerStorageOpen = false

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

-- @GetPlayerData returns PlayerData list with all the available player information.
GetPlayerData = function ()
    return PlayerData
end

IsStableOpen = function(stableConfig)

    if not stableConfig.Hours.Allowed then
        return true
    end

    local hour = GetClockHours()
    
    if stableConfig.Hours.Opening < stableConfig.Hours.Closing then
        -- Normal hours: Opening and closing on the same day (e.g., 08 to 20)
        if hour < stableConfig.Hours.Opening or hour >= stableConfig.Hours.Closing then
            return false
        end
    else
        -- Overnight hours: Closing time is on the next day (e.g., 21 to 05)
        if hour < stableConfig.Hours.Opening and hour >= stableConfig.Hours.Closing then
            return false
        end
    end

    return true

end

IsPermittedToAccessBag = function(currentJob, requiredJobs)

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

IsPlayerNotBusy = function()
    local PlayerData = GetPlayerData()
    local playerPed  = PlayerPedId()
    return PlayerData.IsLoaded and not PlayerData.IsBusy and not PlayerData.IsOnMenu and not IsEntityDead(playerPed) and not hasContainerStorageOpen and #MenuData.Opened == 0 and not IsPedOnMount(playerPed) and not IsPedInAnyVehicle(playerPed, false)
end

---------------------------------------------------------------
--[[ Base Events ]]--
---------------------------------------------------------------

-- Gets the player job when devmode set to false and character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

    Wait(2000)
    
    local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

    if data == nil then
        return
    end

    PlayerData.CharIdentifier = data.charIdentifier
    PlayerData.Job = data.job

    TriggerServerEvent('tpz_stables:server:requestPlayerData')
    TriggerEvent("tpz_stables:client:horse_trainers_training_task")

    if Config.Taming.Enabled then
        TriggerEvent("tpz_stables:client:start_taming_tasks")
    end

end)

-- Gets the player job when devmode set to true.
if Config.DevMode then

    Citizen.CreateThread(function ()

        Wait(2000)

        local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

        if data == nil then
            return
        end

        PlayerData.CharIdentifier = data.charIdentifier
        PlayerData.Job = data.job

        TriggerServerEvent('tpz_stables:server:requestPlayerData')
        TriggerEvent("tpz_stables:client:horse_trainers_training_task")
    
        if Config.Taming.Enabled then
            TriggerEvent("tpz_stables:client:start_taming_tasks")
        end
    end)
    
end

-- Updates the player job and job grade in case if changes.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    PlayerData.Job = data.job

    TriggerEvent("tpz_stables:client:horse_trainers_training_task")

    if Config.Taming.Enabled then
        TriggerEvent("tpz_stables:client:start_taming_tasks")
    end

end)

---------------------------------------------------------------
--[[ General Events ]]--
---------------------------------------------------------------

AddEventHandler("tpz_inventory:setSecondaryInventoryOpenState", function(cb)
    hasContainerStorageOpen = cb
end)

RegisterNetEvent("tpz_stables:client:sendPlayerData")
AddEventHandler("tpz_stables:client:sendPlayerData", function(horses, wagons, selectedHorseIndex, selectedWagonIndex)
    PlayerData.Horses = horses
    PlayerData.Wagons = wagons
    PlayerData.SelectedHorseIndex = selectedHorseIndex
    PlayerData.SelectedWagonIndex = selectedWagonIndex

    if PlayerData.SelectedHorseIndex == nil then
        PlayerData.SelectedHorseIndex = 0
    end

    if PlayerData.SelectedWagonIndex == nil then
        PlayerData.SelectedWagonIndex = 0
    end

    PlayerData.IsLoaded = true

    TriggerServerEvent("tpz_stables:server:addChatSuggestions")

    if Config.Debug then
        print('Stables and Player Data successfully loaded!')
    end
    
end)

RegisterNetEvent("tpz_stables:client:resetSelectedHorseIndex")
AddEventHandler("tpz_stables:client:resetSelectedHorseIndex", function(horseIndex, removeEntity)

    if removeEntity and horseIndex == PlayerData.SelectedHorseIndex and PlayerData.SpawnedHorseEntity then
       
        local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedHorseEntity)

        if hasRequestedControl then
            local model = GetHashKey(PlayerData.Horses[PlayerData.SelectedHorseIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedHorseEntity, model)
        end
        
    end

    PlayerData.SelectedHorseIndex = 0

end)

RegisterNetEvent("tpz_stables:client:resetSelectedWagonIndex")
AddEventHandler("tpz_stables:client:resetSelectedWagonIndex", function(wagonIndex, removeEntity)

    if removeEntity and wagonIndex == PlayerData.SelectedWagonIndex and PlayerData.SpawnedWagonEntity then
    
        local hasRequestedControl = RequestEntityControl(PlayerData.SpawnedWagonEntity)

        if hasRequestedControl then
            local model = GetHashKey(PlayerData.Wagons[PlayerData.SelectedWagonIndex].model )
            RemoveEntityProperly(PlayerData.SpawnedWagonEntity, model)
        end
    end

    PlayerData.SelectedWagonIndex = 0

end)

RegisterNetEvent("tpz_stables:client:updateAccount")
AddEventHandler("tpz_stables:client:updateAccount", function(account)

    PlayerData.Cash = account[1]
    PlayerData.Gold = account[2]

    if PlayerData.IsOnMenu then 
        local subtext = string.format(Locales['CURRENT_ACCOUNT'], account[1], account[2])
        exports.tpz_menu_base:UpdateCurrentSubtextDescription(subtext)
    end
    
end)

---------------------------------------------------------------
--[[ Threads ]]--
---------------------------------------------------------------

Citizen.CreateThread(function()

    RegisterActionPrompt()
    RegisterTamingStableActionPrompt()

    while true do

        local sleep   = 1200
        local player = PlayerPedId()

        -- This also prevents blip updates, but we dont check for riding, because those statements below don't last for long
        -- but it is the best for better performance.
        if not PlayerData.IsLoaded or PlayerData.IsBusy or PlayerData.IsOnMenu or IsEntityDead(player) or hasContainerStorageOpen or #MenuData.Opened ~= 0 then
            goto END
        end

        for stableIndex, stableConfig in pairs(Config.Locations) do

            local coordsStable = vector3(stableConfig.Coords.x, stableConfig.Coords.y, stableConfig.Coords.z)
            local distance     = #(GetEntityCoords(player) - coordsStable)

            local isAllowed = IsStableOpen(stableConfig)

            if stableConfig.BlipData.Allowed then

                local ClosedHoursData = stableConfig.BlipData.DisplayClosedHours

                if isAllowed ~= stableConfig.IsAllowed and stableConfig.BlipHandle then

                    RemoveBlip(stableConfig.BlipHandle)
                    
                    Config.Locations[stableIndex].BlipHandle = nil
                    Config.Locations[stableIndex].IsAllowed = isAllowed

                end

                if (isAllowed and stableConfig.BlipHandle == nil) or (not isAllowed and ClosedHoursData and ClosedHoursData.Enabled and stableConfig.BlipHandle == nil ) then
                    local blipModifier = isAllowed and 'OPEN' or 'CLOSED'
                    AddBlip(stableIndex, blipModifier)

                    Config.Locations[stableIndex].IsAllowed = isAllowed
                end

            end

            if not IsPedOnMount(player) then

                if (distance <= stableConfig.ActionDistance) then
                    sleep = 0

                    local promptGroup, promptList = GetPromptData()

                    local label = CreateVarString(10, 'LITERAL_STRING', stableConfig.Name)
                    PromptSetActiveGroupThisFrame(promptGroup, label)

                    if PromptHasHoldModeCompleted(promptList) then

                        PlayerData.IsOnMenu = true

                        while not IsScreenFadedOut() do
                            Wait(50)
                            DoScreenFadeOut(2000)
                        end
                        
                        TaskStandStill(player, -1)

                        local cameraCoords   = stableConfig.MainCameraCoords
                        local handler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty, cameraCoords.rotz, cameraCoords.fov, false, 2)
                    
                        SetCamActive(handler, true)
                        RenderScriptCams(true, false, 0, true, true, 0)

                        PlayerData.CameraHandler = handler

                        PlayerData.IsOnMenu = true

                        TriggerEvent("tpz_stables:client:menu_tasks")
                        TriggerServerEvent('tpz_stables:server:requestAccountInformation')

                        Wait(2000)

                        DoScreenFadeIn(2000)
                        OpenStableMenu(stableIndex)
                    end

                end

            else 
                sleep = 0

                local promptGroup, promptList = GetTamingStorePromptData()

                local label = CreateVarString(10, 'LITERAL_STRING', stableConfig.Name)
                PromptSetActiveGroupThisFrame(promptList, label)

                if Citizen.InvokeNative(0xC92AC953F0A982AE, promptList) then  -- PromptHasStandardModeCompleted
    
                    print('yes')

                end

            end

        end

        ::END::
        Wait(sleep)
    end
end)