
-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

ToggleUI = function(display)

	SetNuiFocus(false,false)

    if not display then
        DisplayingNUI = false

        GetPlayerData().HasNUIActive = false
    end

    SendNUIMessage({ type = "enable", enable = display })
end

-----------------------------------------------------------
--[[ Public Functions ]]--
-----------------------------------------------------------

function DisplayHorseDetails(category, horseData, trained)

    local HorseData  = horseData
    local PlayerData = GetPlayerData()

    GetPlayerData().HasNUIActive = true

    local label = category .. " - " .. HorseData[2]
    local stats = HorseData[5]
    local speed, stamina, health, acceleration, handling = stats[1], stats[2], stats[3], stats[4], stats[5]

    if not trained then
        local DecreaseData = Config.Trainers.UntrainedHorse.DecreaseHorseStatistics
    
        if DecreaseData["speed"].Modify and DecreaseData["speed"].DivideBy > 1 then
            speed = math.floor(speed / DecreaseData["speed"].DivideBy) -- SPEED
        end
    
        if DecreaseData["stamina"].Modify and DecreaseData["stamina"].DivideBy > 1 then
            stamina = math.floor(stamina / DecreaseData["stamina"].DivideBy) -- STAMINA
        end
    
        if DecreaseData["health"].Modify and DecreaseData["health"].DivideBy > 1 then
            health = math.floor(health / DecreaseData["health"].DivideBy) -- HEALTH
        end
    
        if DecreaseData["acceleration"].Modify and DecreaseData["acceleration"].DivideBy > 1 then
            acceleration = math.floor(acceleration / DecreaseData["acceleration"].DivideBy) -- ACCELERATION
        end
    
        if DecreaseData["handling"].Modify and DecreaseData["handling"].DivideBy > 1 then
            handling = math.floor(handling / DecreaseData["handling"].DivideBy) -- HANDLING
        end
    
    end

    SendNUIMessage({ 
        action = 'updateInformation',
        type   = 'HORSE',

        label = label,

        locales = { 
            speed         = Locales['NUI_SPEED_TITLE'], 
            stamina       = Locales['NUI_STAMINA_TITLE'], 
            health        = Locales['NUI_HEALTH_TITLE'], 
            acceleration  = Locales['NUI_ACCELERATION_TITLE'], 
            handling      = Locales['NUI_HANDLING_TITLE'], 
        },

        statistics = {
            speed        = speed, 
            stamina      = stamina,
            health       = health,
            acceleration = acceleration,
            handling     = handling
        },

    })

    ToggleUI(true)

end


function DisplayWagonDetails(category, wagonData)

    local WagonData  = wagonData
    local PlayerData = GetPlayerData()

    PlayerData.HasNUIActive = true

    local label = category .. " - " .. WagonData[2]
    local stats = WagonData[5]
    local speed, stamina, health, acceleration, handling = stats[1], stats[2], stats[3], stats[4], stats[5]

    SendNUIMessage({ 
        action = 'updateInformation',
        type   = 'WAGON',

        label = label,

        locales = { 
            speed         = Locales['NUI_SPEED_TITLE'], 
            stamina       = Locales['NUI_STAMINA_TITLE'], 
            health        = Locales['NUI_HEALTH_TITLE'], 
            acceleration  = Locales['NUI_ACCELERATION_TITLE'], 
            handling      = Locales['NUI_HANDLING_TITLE'], 
        },

        statistics = {
            speed        = speed, 
            stamina      = stamina,
            health       = health,
            acceleration = acceleration,
            handling     = handling
        },

    })

    ToggleUI(true)

end

function CloseNUI()
    SendNUIMessage({action = 'close'})
end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------


-----------------------------------------------------------
--[[ NUI Callbacks  ]]--
-----------------------------------------------------------

RegisterNUICallback('close', function()
	ToggleUI(false)
end)
