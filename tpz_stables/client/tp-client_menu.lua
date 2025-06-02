local MenuData = {}
TriggerEvent("tpz_menu_base:getData", function(call) MenuData = call end)

local TPZ    = exports.tpz_core:getCoreAPI()
local TPZInv = exports.tpz_inventory:getInventoryAPI()

local LocationIndex      = nil
local StoreEntity        = nil
local StoreEntityModel   = nil

local HORSE_CATEGORIES_IMAGE_PATH <const>           = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.81vw;' src='nui://tpz_stables/html/img/%s.png'>"
local HORSE_CATEGORIES_TITLE_STYLE <const>          = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local HORSE_CATEGORIES_BUY_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local HORSE_CATEGORIES_BUY_CASH_IMAGE_PATH <const>  = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.25vw;' src='nui://tpz_stables/html/img/%s.png'>"
local HORSE_CATEGORIES_BUY_CASH_TEXT_PATH <const>   = "<span style='opacity: 0.8; float:left; text-align: left; width: 2.5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"

local HORSE_CATEGORIES_BUY_GOLD_IMAGE_PATH <const>  = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.25vw;' src='nui://tpz_stables/html/img/%s.png'>"
local HORSE_CATEGORIES_BUY_GOLD_TEXT_PATH <const>   = "<span style='opacity: 0.8; float:left; text-align: left; width: 2vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"

---------------------------------------------------------------
--[[ Local Functions ]]--
---------------------------------------------------------------

local OnBackToStableMenu = function()
    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    while not IsScreenFadedOut() do
        Wait(50)
        DoScreenFadeOut(2000)
    end

    if StoreEntity then
        RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))

        StoreEntity        = nil
        StoreEntityModel   = nil

        CloseNUI()
    end

    local cameraCoords = StableData.MainCameraCoords
    local handler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty, cameraCoords.rotz, cameraCoords.fov, false, 2)
    SetCamActive(handler, true)
    RenderScriptCams(true, false, 0, true, true, 0)

    PlayerData.CameraHandler = handler

    Wait(1000)
    DoScreenFadeIn(2000)

end

local HasRequiredJob = function(currentJob, requiredJobs)

    if (not requiredJobs) or (requiredJobs and TPZ.GetTableLength(requiredJobs) <= 0) then
        return true
    end

    for index, job in pairs (requiredJobs) do

        if job == currentJob then
            return true
        end

    end

    return false

end

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

-- BUY HORSES ------------------------------------------------

function OpenBuyHorsesList()
    MenuData.CloseAll()

    if StoreEntity then
        RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))

        StoreEntity        = nil
        StoreEntityModel   = nil

        CloseNUI()
    else

        -- Forcing MenuData Index to always be the first result when opening the categories for first time.
        MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horses_list")

    end

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for index, category in pairs (Config.Horses) do 
        table.insert(elements, { 
            label = HORSE_CATEGORIES_IMAGE_PATH:format("left", category.BackgroundImage) .. HORSE_CATEGORIES_TITLE_STYLE:format(category.Category), 
            value = index, 
            desc = "" 
        })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    MenuData.Open('default', GetCurrentResourceName(), 'horses_list',

    {
        title    = Locales['HORSES_TITLE'],
        subtext  = '',
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OnBackToStableMenu()
            OpenStableMenu()
            return
        end

        local categoryIndex = data.current.value

        menu.close()
        OpenBuyHorsesByCategory(categoryIndex)
        
    end,

    function(data, menu)
        menu.close()
        OnBackToStableMenu()
        OpenStableMenu()
    end)

end

function OpenBuyHorsesByCategory(categoryIndex)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for index, horse in pairs (Config.Horses[categoryIndex].Horses) do 

        local hasRequiredJob = HasRequiredJob(PlayerData.Job, horse[6])

        if hasRequiredJob then

            local label       = horse[2]
            local money, gold = horse[3], horse[4]
    
            local cashIcon = HORSE_CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "money")
            local cashText = HORSE_CATEGORIES_BUY_CASH_TEXT_PATH:format(money)
            local goldIcon = HORSE_CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "gold")
            local goldText = HORSE_CATEGORIES_BUY_CASH_TEXT_PATH:format(gold)
            local title    = HORSE_CATEGORIES_BUY_TITLE_STYLE:format(label)
    
            local fixedLabel = (gold > 0) and (title .. cashIcon .. cashText .. goldIcon .. goldText) or (title .. cashIcon .. cashText)
            
            table.insert(elements, {
                label = fixedLabel,
                name  = label,
                money = money,
                gold  = gold,
                value = index,
                desc = "",
            })

        end

    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    -- Forcing MenuData Index to always be the first result when opening a horse category.
    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horses_list_buy")

    local HorseData = Config.Horses[categoryIndex].Horses[1]
    local model = HorseData[1]
    
    LoadModel(model)

    local coords   = StableData.Horses.SpawnCoords
    local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
    local horse = CreatePed(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)

    Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
    Citizen.InvokeNative(0x9587913B9E772D29, horse, true)

    SetEntityAsMissionEntity(horse, true, true)
    FreezeEntityPosition(horse, true)

    StoreEntity        = horse
    StoreEntityModel   = model

    DisplayHorseDetails(Config.Horses[categoryIndex].Category, Config.Horses[categoryIndex].Horses[1])

    MenuData.Open('default', GetCurrentResourceName(), 'horses_list_buy',

    {
        title    = Config.Horses[categoryIndex].Category,
        subtext  = '',
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)

        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenBuyHorsesList()
            return
        end

        local description = Locales['BUY_FOR_DOLLARS_AND_GOLD']:format(data.current.money, data.current.gold)

        if data.current.gold <= 0 then
            description = Locales['BUY_FOR_DOLLARS']:format(data.current.money)
        end

        local options = {}

        for index, currency in pairs (Locales['INPUT_BUY_CURRENCIES']) do
            table.insert(options, currency.ACCOUNT)
        end

        local inputData = {
            title = data.current.name,
            desc  = description,
            buttonparam1 = "ACCEPT",
            buttonparam2 = "DECLINE",

            options = options,
        }

        -- If there is also gold currency, we have an option selector.
        if data.current.gold > 0 then
    
            TriggerEvent("tpz_inputs:getSelectedOptionsInput", inputData, function(cb)
    
                if cb == "something" then
                      -- do action
                end
                        
            end)

        else

            TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)

                if cb == "ACCEPT" then
                    -- do action
                end

            end) 

        end

    end,

    function(data, menu)
        menu.close()
    end,

    function(data, menu)

        if data.current.value ~= 'back' then

            local HorseData = Config.Horses[categoryIndex].Horses[data.current.value]

            local removedEntity = false
    
            if StoreEntity then
                RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))
    
                StoreEntity        = nil
                StoreEntityModel   = nil
    
                CloseNUI()
                removedEntity      = true

            else
                removedEntity      = true
            end
    
            while not removedEntity do
                Wait(500)
            end
    
            local model = HorseData[1]
    
            LoadModel(model)
    
            local coords   = StableData.Horses.SpawnCoords
            local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
            local horse = CreatePed(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)
    
            Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
            Citizen.InvokeNative(0x9587913B9E772D29, horse, true)
    
            SetEntityAsMissionEntity(horse, true, true)
            FreezeEntityPosition(horse, true)
    
            StoreEntity        = horse
            StoreEntityModel   = model

            Wait(1000)
            DisplayHorseDetails(Config.Horses[categoryIndex].Category, HorseData)

        end

        if data.current.value == 'back' then 

            if StoreEntity then
                RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))
        
                StoreEntity        = nil
                StoreEntityModel   = nil

                CloseNUI()
            end

        end

    end)

end


---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

function OpenStableMenu(locationIndex)

    local PlayerData = GetPlayerData()

    if LocationIndex == nil then
        LocationIndex = locationIndex
    end

    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for action, category in pairs (StableData.MenuCategories) do 
        table.insert(elements, { label = category.Title, value = category.Action, desc = category.Description })
    end

    MenuData.Open('default', GetCurrentResourceName(), 'main',

    {
        title    = StableData.Name,
        subtext  = '',
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup") or (data.current.value == "exit") then 
            menu.close()
            CloseMenu()
            return
        end

        menu.close()
        
        while not IsScreenFadedOut() do
            Wait(50)
            DoScreenFadeOut(2000)
        end

        local cameraCoords

        if (data.current.value == 'BUY_HORSES') then
            cameraCoords  = StableData.Horses.CameraCoords
        end

        local handler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty, cameraCoords.rotz, cameraCoords.fov, false, 2)
        SetCamActive(handler, true)
        RenderScriptCams(true, false, 0, true, true, 0)

        PlayerData.CameraHandler = handler

        Wait(1000)
        DoScreenFadeIn(2000)

        if (data.current.value == 'BUY_HORSES') then
            OpenBuyHorsesList()
        end

    end,

    function(data, menu)
        menu.close()
        CloseMenu()
    end)

end

function CloseMenu()
    local PlayerData = GetPlayerData()

    while not IsScreenFadedOut() do
        Wait(50)
        DoScreenFadeOut(2000)
    end

    --DeleteVehicle(LocationData.vehicleHandler)
    --SetEntityAsNoLongerNeeded(LocationData.vehicleHandler )
    --SetModelAsNoLongerNeeded(GetHashKey(WagonData.Model))

    DestroyAllCams(true)
    TaskStandStill(PlayerPedId(), 1)

    Wait(4000)
    DoScreenFadeIn(2000)
    --DisplayRadar(true)
    PlayerData.IsOnMenu = false

    DisplayRadar(true)

    LocationIndex = nil

end
---------------------------------------------------------------
--[[ Base Events ]]--
---------------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local PlayerData = GetPlayerData()

    if PlayerData.IsOnMenu then
        MenuData.CloseAll()

        DoScreenFadeIn(1000)
        DestroyAllCams(true)
        TaskStandStill(PlayerPedId(), 1)

        if StoreEntity then
            RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))
    
            StoreEntity        = nil
            StoreEntityModel   = nil
        end

    end
        
end)

function StartStableThreads()

    Citizen.CreateThread(function()

        while true do
    
            Wait(0)

            local player       = PlayerPedId()
            local isPlayerDead = IsPedDeadOrDying(player, 1)

            local PlayerData   = GetPlayerData()
            local playerId     = PlayerId()

            if not PlayerData.IsOnMenu then

                for _, player in ipairs(GetActivePlayers()) do -- INVISIBILITY.
                    local ped = GetPlayerPed(player)
                    if DoesEntityExist(ped) then
                        SetEntityVisible(ped, true, true) -- Make them invisible
                    end
                end

                break
            end

            DisplayRadar(false) -- forcing no radar.

            if isPlayerDead then
                MenuData.CloseAll()
                CloseMenu()
            end
                
            if TPZInv.isInventoryActive() then -- forcing no inventory opening.
                TPZInv.closeInventory()
            end

            for _, player in ipairs(GetActivePlayers()) do -- INVISIBILITY.
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    SetEntityVisible(ped, false, false) -- Make them invisible
                end
            end

        end
    
    end)

end
