
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

function DisplayHorseDetails(category, horseData)

    local HorseData  = horseData
    local PlayerData = GetPlayerData()

    GetPlayerData().HasNUIActive = true

    local label = category .. " - " .. HorseData[2]
    local stats = HorseData[5]
    local speed, stamina, health, acceleration, handling = stats[1], stats[2], stats[3], stats[4], stats[5]

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
