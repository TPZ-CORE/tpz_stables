local TPZInv = exports.tpz_inventory:getInventoryAPI()

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

    SpawnedWagonEntity = 0,
    SpawnedWagonModel  = nil,

    IsLoaded           = false,
    
}

---------------------------------------------------------------
--[[ Local Functions ]]--
---------------------------------------------------------------

local function IsStableOpen(stableConfig)

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

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

-- @GetPlayerData returns PlayerData list with all the available player information.
GetPlayerData = function ()
    return PlayerData
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
    end)
    
end

-- Updates the player job and job grade in case if changes.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    PlayerData.Job = data.job
end)

---------------------------------------------------------------
--[[ General Events ]]--
---------------------------------------------------------------

RegisterNetEvent("tpz_stables:client:sendPlayerData")
AddEventHandler("tpz_stables:client:sendPlayerData", function(horses, wagons, selectedHorseIndex )
    PlayerData.Horses = horses
    PlayerData.Wagons = wagons
    PlayerData.SelectedHorseIndex = selectedHorseIndex

    if PlayerData.SelectedHorseIndex == nil then
        PlayerData.SelectedHorseIndex = 0
    end

    PlayerData.IsLoaded = true

    TriggerServerEvent("tpz_stables:server:addChatSuggestions")

    if Config.Debug then
        print('Stables and Player Data successfully loaded!')
    end
    
end)

RegisterNetEvent("tpz_stables:client:resetSelectedHorseIndex")
AddEventHandler("tpz_stables:client:resetSelectedHorseIndex", function(removeEntity)
    PlayerData.SelectedHorseIndex = 0

    if removeEntity and PlayerData.SpawnedHorseEntity then
        local model = GetHashKey(PlayerData.Horses[PlayerData.SelectedHorseIndex].model )
        RemoveEntityProperly(PlayerData.SpawnedHorseEntity, model)
    end

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

    while true do
        Citizen.Wait(0)

        local sleep        = true

        local player       = PlayerPedId()
        local isPlayerDead = IsEntityDead(player)

        if PlayerData.IsLoaded and not PlayerData.IsBusy and not PlayerData.IsOnMenu and not isPlayerDead then

            local coords = GetEntityCoords(player)
            local hour   = GetClockHours()

            for stableIndex, stableConfig in pairs(Config.Locations) do

                local coordsDist   = vector3(coords.x, coords.y, coords.z)
                local coordsStable = vector3(stableConfig.Coords.x, stableConfig.Coords.y, stableConfig.Coords.z)
                local distance     = #(coordsDist - coordsStable)

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

                if isAllowed then

                    if (distance <= stableConfig.ActionDistance) then
                        sleep = false

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
                            StartStableThreads()
                            
                            TriggerServerEvent('tpz_stables:server:requestAccountInformation')

                            -- request stable
                            Wait(2000)

                            DoScreenFadeIn(2000)
                            OpenStableMenu(stableIndex)
                        end

                    end

                end

            end

        end

        if sleep then
            Citizen.Wait(1000)
        end
    end
end)