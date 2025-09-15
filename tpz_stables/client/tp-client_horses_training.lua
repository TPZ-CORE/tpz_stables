local TPZ = exports.tpz_core:getCoreAPI()

local IsTrainingHorse, IsInTrainingZone, TrainingActionDuration, CancelDuration = false, false, 0, -1
local TrainingZones   = {}

local hasThreadActive = false

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local function LoadTrainingLocations()

    for i, location in pairs(Config.Locations) do
        
        if location.Horses.Training.Enabled then

            local zone = location.Horses.Training

            TrainingZones[i] = {
                zone = PolyZone:Create(zone.Coords, {name = "horsetrainingarea_" .. tostring(i), minZ = zone.MinZ, maxZ = zone.MaxZ+1.0, debugGrid = zone.Debug or false}),
            }

        end

    end

end

-- @return boolean : If player has trainer job / not.
local HasPermittedJob = function(currentJob)

    for index, job in pairs (Config.Trainers.Jobs) do

        if job == currentJob then
            return true
        end

    end

    return false
end

local IsInsideZone = function(coords)

    local PlayerData = GetPlayerData()

    for _, zone in pairs(TrainingZones) do
            
        if zone.zone:isPointInside(coords) then
            return true
        end

    end

    return false
end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function IsPlayerTrainingHorse()
    return IsTrainingHorse
end

function GetTrainingHorseStageType()
    local PlayerData = GetPlayerData()
    return PlayerData.Horses[PlayerData.SelectedHorseIndex].training_stage_type
end

function GetTrainingHorseStageIndex()
    local PlayerData = GetPlayerData()
    return PlayerData.Horses[PlayerData.SelectedHorseIndex].training_stage_index
end

function SetNextTrainingHorseStage()
    local PlayerData = GetPlayerData()
    local HorseData  = PlayerData.Horses[PlayerData.SelectedHorseIndex]
    HorseData.training_experience = HorseData.training_experience + Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Experience

    if HorseData.training_experience < Config.Trainers.HorseTraining.MaxLevelUpExperience then
    
        HorseData.training_stage_index = HorseData.training_stage_index + 1

        if Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index] == nil then
            HorseData.training_stage_index = 1
        end
    
        HorseData.training_stage_type = Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Type
    
        local title_description
    
        if Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Duration then
            TrainingActionDuration = Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Duration
            title_description = string.format(Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Description, TrainingActionDuration)
    
        else 
            title_description = Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Description
        end
    
        local PlayerData = GetPlayerData()
    
        SendNUIMessage({ 
            action = 'updateTrainingCountdown',
            title_description = title_description
        })
    
        SendNUIMessage({ 
            action = 'updateTrainingHorseExperience',
            experience = Locales['TRAINING_EXPERIENCE_TITLE'] .. HorseData.training_experience .. ' / ' .. Config.Trainers.HorseTraining.MaxLevelUpExperience
        })

    else

        -- DISPLAY NUI TRAINED SUCCESS AND CLOSE NUI
        IsTrainingHorse, IsInTrainingZone, TrainingActionDuration, CancelDuration = false, false, 0, -1

        HorseData.training_experience  = -1
        HorseData.training_stage_index = -1
        HorseData.training_stage_type  = 'N/A'

        TriggerServerEvent('tpz_stables:server:saveHorseTrainingExperience', PlayerData.SelectedHorseIndex, -1, -1, 'N/A') -- -1 represents trained horse.

        SendNUIMessage({ action = 'success' })

        Wait(5000)
        CloseNUI()
    end

end

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

AddEventHandler("tpz_stables:client:horse_training_thread", function()
    local PlayerData = GetPlayerData()
    local HorseData  = PlayerData.Horses[PlayerData.SelectedHorseIndex]

    CancelDuration = -1

    if Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index] == nil then
        HorseData.training_stage_index = 1
    end
    
    HorseData.training_stage_type = Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Type

    SendNUIMessage({ 
        action = 'displayTrainingInformation',
        title = Locales['TRAINING_TITLE'],
        title_description = Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Description,
        title_success = Locales['TRAINING_SUCCESS'],
        experience = Locales['TRAINING_EXPERIENCE_TITLE'] .. HorseData.training_experience .. ' / ' .. Config.Trainers.HorseTraining.MaxLevelUpExperience
    })
    

    ToggleUI(true)

    -- The specified thread is used for:
    -- 1. Checking polyzone training positions in case the player is or not inside a zone.
    -- 2. Checking if player is not on horse mount or the mounted horse is not the one that should be trained.
    Citizen.CreateThread(function()

        while true do
            Wait(1000)
    
            local sleep      = true
    
            local player     = PlayerPedId()
            local PlayerData = GetPlayerData()

            if not HasPermittedJob(PlayerData.Job) or not IsTrainingHorse then
                break
            end
    
            IsInTrainingZone = IsInsideZone(GetEntityCoords(player))

            if not IsInTrainingZone or not IsPedOnMount(player) then -- or not validMountedHorse then

                if CancelDuration == -1 then 
                    CancelDuration = Config.Trainers.HorseTraining.CancelDuration
                end

                CancelDuration = CancelDuration - 1

                if CancelDuration <= 0 then

                    IsTrainingHorse, IsInTrainingZone, TrainingActionDuration, CancelDuration = false, false, 0, -1

                    local HorseData  = PlayerData.Horses[PlayerData.SelectedHorseIndex]
                    TriggerServerEvent('tpz_stables:server:saveHorseTrainingExperience', PlayerData.SelectedHorseIndex, HorseData.training_experience, HorseData.training_stage_index, HorseData.training_stage_type)

                    SendNotification(_source, Locales['TRAINING_NOTIFY_TITLE'], Locales['TRAININING_CANCELLED'], "error", 5, "horse", "left")

                end

            end

            if CancelDuration ~= -1 and IsInTrainingZone then --and validMountedHorse then
                CancelDuration = -1
            end

        end
    
    end)

    
    Citizen.CreateThread(function()

        while true do
            Wait(1000)

            local PlayerData = GetPlayerData()
            local HorseData = PlayerData.Horses[PlayerData.SelectedHorseIndex]

            if not IsTrainingHorse then
                break
            end

            if Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Duration ~= 0 and TrainingActionDuration > 0 then

                local player     = PlayerPedId()
                local update     = false

                if HorseData.training_stage_type == 'LEAD' and not IsPedOnMount(player) then -- IsPedLeadingHorse(PlayerData.SpawnedHorseEntity) then

                    if IsPedLeadingHorse(player) and IsPedWalking(player) then
                        local horse = Citizen.InvokeNative(0xED1F514AF4732258, player)

                        if horse == PlayerData.SpawnedHorseEntity then
                            update = true
                        end

                    end

                end

                if HorseData.training_stage_type == 'WALK' and IsPedOnMount(player) then
                    local horse = GetMount(player)

                    if horse == PlayerData.SpawnedHorseEntity then
                    
                        local isPedWalking = not IsPedRunning(horse) and not IsPedSprinting(horse) and IsPedWalking(horse)

                        if isPedWalking then
                            update = true
                        end 

                    end

                end

                if HorseData.training_stage_type == 'RUN' and IsPedOnMount(player) then
                    local horse = GetMount(player)

                    local isPedRunning = IsPedRunning(horse) or IsPedSprinting(horse)

                    if isPedRunning then
                        update = true
                    end

                end

                if update then

                    TrainingActionDuration = TrainingActionDuration - 1

                    SendNUIMessage({ 
                        action = 'updateTrainingCountdown',
                        title_description = string.format(Config.Trainers.HorseTraining.Stages[HorseData.training_stage_index].Description, TrainingActionDuration)
                    })

                    if TrainingActionDuration <= 0 then
                        SetNextTrainingHorseStage()
                    end

                end

            end

        end

    end)

    -- Displaying the duration for cancelling the horse training.
    Citizen.CreateThread(function()

        while true do
            Wait(0)
    
            local sleep      = true
    
            local player     = PlayerPedId()
            local PlayerData = GetPlayerData()

            if not IsTrainingHorse then
                break
            end

            if CancelDuration ~= -1 then
                sleep = false
                DisplayHelp(string.format(Locales['TRAINING_CANCEL_DURATION'], tostring(CancelDuration)), 0.50, 0.90, 0.5, 0.5, true, 255, 0, 0, 255, true)
            end
    
            if sleep then
                Wait(1000)
            end

        end
    
    end)


end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    RegisterHorseTrainingActionPrompt() 
end)

AddEventHandler("tpz_stables:client:horse_trainers_training_task", function()
    local PlayerData   = GetPlayerData()
    local permittedJob = HasPermittedJob(PlayerData.Job)

    if not permittedJob or hasThreadActive then
        return
    end

    hasThreadActive = true

    Citizen.CreateThread(function()

        while true do

            local sleep        = 1000
            local player       = PlayerPedId()
            local coords       = GetEntityCoords(player)
            local isPlayerDead = IsEntityDead(player)
            local PlayerData   = GetPlayerData()

            local permittedJob = HasPermittedJob(PlayerData.Job)

            if not permittedJob then
                hasThreadActive = false
                break
            end

            if isPlayerDead or PlayerData.IsBusy or PlayerData.SelectedHorseIndex == 0 or PlayerData.SpawnedHorseEntity == nil or IsPedInAnyVehicle(player, false) then
                goto END
            end
    
            for _, loc in pairs(Config.Locations) do
    
                if loc.Horses.Training.Enabled then

                    local location   = loc.Horses.Training

                    local coordsLoc  = vector3(location.TrainingCoords.x, location.TrainingCoords.y, location.TrainingCoords.z)
                    local distance   = #(coords - coordsLoc)
    
                    if location.TrainingCoordsMarker.Enabled and distance <= location.TrainingCoordsMarker.Distance then
                        sleep = 0
    
                        local RGBA = location.TrainingCoordsMarker.RGBA
                        Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, location.TrainingCoords.x, location.TrainingCoords.y, location.TrainingCoords.z - 1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 0.7, RGBA.r, RGBA.g, RGBA.b, RGBA.a, false, true, 2, false, false, false, false)
                    end
        
                    if distance <= 2.4 then
                        sleep = 0
    
                        local Prompts, PromptList = GetHorseTrainingPromptData()
    
                        local text  = not IsTrainingHorse and Locales['HORSE_TRAINING_LOCATION_START_PROMPT'] or Locales['HORSE_TRAINING_LOCATION_STOP_PROMPT']
                        local label = CreateVarString(10, 'LITERAL_STRING', text)

                        PromptSetActiveGroupThisFrame(Prompts, label)
                        
                        if PromptHasHoldModeCompleted(PromptList) then
    
                            if PlayerData.SpawnedHorseEntity then

                                local HorseData = PlayerData.Horses[PlayerData.SelectedHorseIndex]

                                if HorseData.training_experience ~= -1 then

                                    IsTrainingHorse = not IsTrainingHorse

                                    if IsTrainingHorse then
                                        TriggerEvent("tpz_stables:client:horse_training_thread")

                                        -- We register training zone (polyzone) only once.
                                        if TPZ.GetTableLength(TrainingZones) <= 0 then
                                            LoadTrainingLocations()
                                        end

                                    else
                                        CloseNUI()
                                        IsInTrainingZone, TrainingActionDuration, CancelDuration = false, 0, -1

                                        TriggerServerEvent('tpz_stables:server:saveHorseTrainingExperience', PlayerData.SelectedHorseIndex, HorseData.training_experience, HorseData.training_stage_index, HorseData.training_stage_type)
                                    end
                                    
                                    local notify = IsTrainingHorse and Locales['TRAINING_STARTED'] or Locales['TRAINING_STOPPED']
                                    SendNotification(_source, Locales['TRAINING_NOTIFY_TITLE'], notify, "success", 5, "horse", "left")

                                else
                                    SendNotification(_source, Locales['TRAINING_NOTIFY_TITLE'], Locales['TRAININING_ALREADY_TRAINED'], "error", 3, "horse", "left")
                                end

                            else

                                SendNotification(_source, Locales['TRAINING_NOTIFY_TITLE'], Locales['TRAININING_NO_HORSE'], "error", 3, "horse", "left")

                            end

                            Wait(2000)
                        end
    
                    end

                end

    
            end

            ::END::
            Wait(sleep)
    
        end
    
    end)
end)