local MenuData = {}
TriggerEvent("tpz_menu_base:getData", function(call) MenuData = call end)

local TPZ    = exports.tpz_core:getCoreAPI()
local TPZInv = exports.tpz_inventory:getInventoryAPI()

local LocationIndex      = nil
local StoreEntity        = nil
local StoreEntityModel   = nil

local CATEGORIES_IMAGE_PATH <const>           = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.81vw;' src='nui://tpz_stables/html/img/%s.png'>"
local CATEGORIES_TITLE_STYLE <const>          = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local CATEGORIES_BUY_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local CATEGORIES_BUY_CASH_IMAGE_PATH <const>  = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.25vw;' src='nui://tpz_stables/html/img/%s.png'>"
local CATEGORIES_BUY_CASH_TEXT_PATH <const>   = "<span style='opacity: 0.8; float:left; text-align: left; width: 2.5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"

local NANAGEMENT_TITLE_STYLE <const>          = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local MANAGEMENT_MODEL_TITLE <const>          = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
local MANAGEMENT_NAME_TITLE <const>           = "<span style='opacity: 0.8; float:left; text-align: left; width: 5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"

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
    end

    CloseNUI()

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

-- BUY WAGONS -------------------------------------------------

function OpenBuyWagonsList()
    MenuData.CloseAll()

    if StoreEntity then
        RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))

        StoreEntity        = nil
        StoreEntityModel   = nil

        CloseNUI()
    else

        -- Forcing MenuData Index to always be the first result when opening the categories for first time.
        MenuData.ResetLastSelectedIndex('default', "tpz_stables", "wagons_list")

    end

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for index, category in pairs (Config.Wagons) do 
        table.insert(elements, { 
            label = CATEGORIES_IMAGE_PATH:format("left", category.BackgroundImage) .. CATEGORIES_TITLE_STYLE:format(category.Category), 
            value = index, 
            desc = "" 
        })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'wagons_list',

    {
        title    = Locales['WAGONS_TITLE'],
        subtext  = subtext,
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
        OpenBuyWagonsByCategory(categoryIndex)
        
    end,

    function(data, menu)
        menu.close()
        OnBackToStableMenu()
        OpenStableMenu()
    end)

end

function OpenBuyWagonsByCategory(categoryIndex)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for index, wagon in pairs (Config.Wagons[categoryIndex].Wagons) do 

        local hasRequiredJob = HasRequiredJob(PlayerData.Job, wagon[6])

        if hasRequiredJob then

            local label       = wagon[2]
            local money, gold = wagon[3], wagon[4]
    
            local cashIcon = CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "money")
            local cashText = CATEGORIES_BUY_CASH_TEXT_PATH:format(money)
            local goldIcon = CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "gold")
            local goldText = CATEGORIES_BUY_CASH_TEXT_PATH:format(gold)
            local title    = CATEGORIES_BUY_TITLE_STYLE:format(label)
    
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

    -- Forcing MenuData Index to always be the first result when opening a wagon category.
    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "wagons_list_buy")

    local WagonData = Config.Wagons[categoryIndex].Wagons[1]
    local model = WagonData[1]
    
    LoadModel(model)

    local coords   = StableData.Wagons.SpawnCoords
    local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
    local wagon    = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)

    SetVehicleOnGroundProperly(wagon)
    SetEntityAsMissionEntity(wagon, true, true)
    FreezeEntityPosition(wagon, true)
    SetEntityCollision(wagon, false, true)

    StoreEntity        = wagon
    StoreEntityModel   = model

    SetModelAsNoLongerNeeded(model)

    --DisplayWagonDetails(Config.Wagons[categoryIndex].Category, Config.Wagons[categoryIndex].Wagons[1])

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'wagons_list_buy',

    {
        title    = Config.Wagons[categoryIndex].Category,
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)

        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenBuyWagonsList()
            return
        end

        local description = Locales['BUY_FOR_DOLLARS_AND_GOLD']:format(data.current.money, data.current.gold)

        if data.current.gold <= 0 then
            description = Locales['BUY_FOR_DOLLARS']:format(data.current.money)
        end

        local inputData = {
            title        = data.current.name,
            desc         = description,
            buttonparam1 = Locales['BUY_INPUT_BUY'],
            buttonparam2 = Locales['BUY_INPUT_CANCEL'],
            options      = Locales['INPUT_BUY_CURRENCIES'],
        }

        -- If there is also gold currency, we have an option selector.
        if data.current.gold > 0 then
    
            TriggerEvent("tpz_inputs:getSelectedOptionsInput", inputData, function(cb)

                if cb ~= "DECLINE" and cb ~= Locales['BUY_INPUT_CANCEL'] then
                    TriggerServerEvent("tpz_stables:server:buyWagon", LocationIndex, categoryIndex, data.current.value, cb)
                end
                        
            end)

        else

            TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)

                if (cb == "ACCEPT") or (cb == Locales['BUY_INPUT_BUY']) then
                    TriggerServerEvent("tpz_stables:server:buyWagon", LocationIndex, categoryIndex, data.current.value)
                end

            end) 

        end

    end,

    function(data, menu)
        menu.close()
    end,

    function(data, menu)

        if data.current.value ~= 'back' then

            local WagonData = Config.Wagons[categoryIndex].Wagons[data.current.value]

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
    
            local model = WagonData[1]
    
            LoadModel(model)
    
            local coords   = StableData.Wagons.SpawnCoords
            local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
            local wagon    = CreateVehicle(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)
    
            SetVehicleOnGroundProperly(wagon)
            SetEntityAsMissionEntity(wagon, true, true)
            FreezeEntityPosition(wagon, true)
            SetEntityCollision(wagon, false, true)
    
            StoreEntity        = wagon
            StoreEntityModel   = model

            SetModelAsNoLongerNeeded(model)

            Wait(1000)
            --DisplayWagonDetails(Config.Wagons[categoryIndex].Category, WagonData)

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

-- BUY HORSES -------------------------------------------------

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
            label = CATEGORIES_IMAGE_PATH:format("left", category.BackgroundImage) .. CATEGORIES_TITLE_STYLE:format(category.Category), 
            value = index, 
            desc = "" 
        })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'horses_list',

    {
        title    = Locales['HORSES_TITLE'],
        subtext  = subtext,
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
    
            local cashIcon = CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "money")
            local cashText = CATEGORIES_BUY_CASH_TEXT_PATH:format(money)
            local goldIcon = CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "gold")
            local goldText = CATEGORIES_BUY_CASH_TEXT_PATH:format(gold)
            local title    = CATEGORIES_BUY_TITLE_STYLE:format(label)
    
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
    local horse    = CreatePed(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)

    Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
    Citizen.InvokeNative(0x9587913B9E772D29, horse, true)

    SetEntityAsMissionEntity(horse, true, true)
    FreezeEntityPosition(horse, true)

    StoreEntity        = horse
    StoreEntityModel   = model

    SetModelAsNoLongerNeeded(model)

    DisplayHorseDetails(Config.Horses[categoryIndex].Category, Config.Horses[categoryIndex].Horses[1], true)

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'horses_list_buy',

    {
        title    = Config.Horses[categoryIndex].Category,
        subtext  = subtext,
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

        local inputData = {
            title        = data.current.name,
            desc         = description,
            buttonparam1 = Locales['BUY_INPUT_BUY'],
            buttonparam2 = Locales['BUY_INPUT_CANCEL'],
            options      = Locales['INPUT_BUY_CURRENCIES'],
        }

        -- If there is also gold currency, we have an option selector.
        if data.current.gold > 0 then
    
            TriggerEvent("tpz_inputs:getSelectedOptionsInput", inputData, function(cb)

                if cb ~= "DECLINE" and cb ~= Locales['BUY_INPUT_CANCEL'] then
                    TriggerServerEvent("tpz_stables:server:buyHorse", LocationIndex, categoryIndex, data.current.value, cb)
                end
                        
            end)

        else

            TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)

                if (cb == "ACCEPT") or (cb == Locales['BUY_INPUT_BUY']) then
                    TriggerServerEvent("tpz_stables:server:buyHorse", LocationIndex, categoryIndex, data.current.value)
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

            SetModelAsNoLongerNeeded(model)

            Wait(1000)
            DisplayHorseDetails(Config.Horses[categoryIndex].Category, HorseData, true)

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

function OpenHorsesManagement()
    MenuData.CloseAll()

    if StoreEntity then
        RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))

        StoreEntity        = nil
        StoreEntityModel   = nil

        CloseNUI()
        Wait(500)
    end

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local currentHorses  = GetPlayerHorses(PlayerData.CharIdentifier)	
    local count          = currentHorses.horsesIndex

    local elements       = {}

    local ownedHorsesList = {}
    local ownedCount      = 0

    for index, horse in pairs (PlayerData.Horses) do 

        if horse.charidentifier == PlayerData.CharIdentifier then

            ownedCount = ownedCount + 1

            local modelData = GetHorseModelData(horse.model)

            local model = MANAGEMENT_MODEL_TITLE:format(modelData[2])
            local name  = MANAGEMENT_NAME_TITLE:format(horse.name)

            table.insert(elements, {
                label = model .. name,
                value = ownedCount,
                desc = "",
            })

            ownedHorsesList[ownedCount] = {}
            ownedHorsesList[ownedCount] = horse
        end

    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    -- Forcing MenuData Index to always be the first result when opening a horse category.
    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horses_management")

    local model     = ownedHorsesList[1].model
    local modelData = GetHorseModelData(model)

    LoadModel(model)

    local coords   = StableData.Horses.SpawnCoords
    local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
    local horse    = CreatePed(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)

    if ownedHorsesList[1].sex == 1 then
        Citizen.InvokeNative(0x5653AB26C82938CF, horse, 41611, 1.0)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, horse, 0, 1, 1, 1, 0)
    else
        Citizen.InvokeNative(0x5653AB26C82938CF, horse, 41611, 0.0)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, horse, 0, 1, 1, 1, 0)
    end

    Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
    Citizen.InvokeNative(0x9587913B9E772D29, horse, true)

    SetEntityAsMissionEntity(horse, true, true)
    FreezeEntityPosition(horse, true)


    StoreEntity        = horse
    StoreEntityModel   = model

    SetModelAsNoLongerNeeded(model)

    DisplayHorseDetails(ownedHorsesList[1].type, modelData, ( ownedHorsesList[1].training_experience == -1 ) )

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'horses_management',

    {
        title    = Locales['HORSES_MANAGEMENT'],
        subtext  = subtext,
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

        menu.close()
        OpenHorseManagementById(ownedHorsesList[data.current.value].id)
    end,

    function(data, menu)
        menu.close()
    end,

    function(data, menu)

        if data.current.value ~= 'back' then

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
    
            
            local model     = ownedHorsesList[data.current.value].model
            local modelData = GetHorseModelData(model)

            LoadModel(model)
    
            local coords   = StableData.Horses.SpawnCoords
            local spawnPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3.0, 0.0, 0.0)
            local horse = CreatePed(model, coords.x, coords.y, coords.z, coords.h, false, false, false, false)
    
            if ownedHorsesList[data.current.value].sex == 1 then
                Citizen.InvokeNative(0x5653AB26C82938CF, horse, 41611, 1.0)
                Citizen.InvokeNative(0xCC8CA3E88256E58F, horse, 0, 1, 1, 1, 0)
            else
                Citizen.InvokeNative(0x5653AB26C82938CF, horse, 41611, 0.0)
                Citizen.InvokeNative(0xCC8CA3E88256E58F, horse, 0, 1, 1, 1, 0)
            end
            
            Citizen.InvokeNative(0x283978A15512B2FE, horse, true)
            Citizen.InvokeNative(0x9587913B9E772D29, horse, true)
    
            SetEntityAsMissionEntity(horse, true, true)
            FreezeEntityPosition(horse, true)

            StoreEntity        = horse
            StoreEntityModel   = model

            SetModelAsNoLongerNeeded(model)

            Wait(1000)
            DisplayHorseDetails(ownedHorsesList[data.current.value].type, modelData, (ownedHorsesList[data.current.value].training_experience == -1)  )

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

function OpenHorseManagementById(selectedHorseId)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local HorseData  = PlayerData.Horses[selectedHorseId]

    -- AGE
    local getRealAge = math.floor(HorseData.age * 1 / 1440)
    local DIV_AGE_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw;' >%s</div>", Locales['HORSE_MANAGEMENT_AGE'])
    local DIV_AGE_DISPLAY = DIV_AGE_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; ' >%s</div>", getRealAge)

    -- RACE
    local DIV_CATEGORY_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_RACE'])
    local DIV_CATEGORY_DISPLAY = DIV_CATEGORY_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", HorseData.type)

    -- SEX
    local DIV_SEX_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_SEX'])

    local sex = HorseData.sex == 0 and "Male" or "Female"
    local DIV_SEX_DISPLAY = DIV_SEX_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", sex)

    -- SHOES
    local DIV_SHOES_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_SHOES_KM'] .. HorseData.stats.shoes_km_left)

    local shoesType = HorseData.stats.shoes_type == 0 and Locales['HORSE_MANAGEMENT_SHOES_NONE'] or Config.HorseShoes[HorseData.stats.shoes_type].Label
    local DIV_SHOES_DISPLAY = DIV_SHOES_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", shoesType)

    -- TRAINED

    local DIV_TRAINED_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 6vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_TRAINED'])

    local trained = HorseData.training_experience == -1 and Locales['HORSE_MANAGEMENT_TRAINED_YES'] or Locales['HORSE_MANAGEMENT_TRAINED_NO']
    local DIV_TRAINED_DISPLAY = DIV_TRAINED_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", trained)

    local description = string.format('%s <br><br> %s <br><br> %s <br><br> %s <br><br> %s', 
        DIV_AGE_DISPLAY, 
        DIV_CATEGORY_DISPLAY, 
        DIV_SEX_DISPLAY, 
        DIV_SHOES_DISPLAY,
        DIV_TRAINED_DISPLAY)

    local elements   = {

        { label = Locales['HORSE_SET_DEFAULT_TITLE'],      value = 'default',     desc = description },
        { label = Locales['HORSE_ADD_HORSE_SHOES_TITLE'],  value = 'horseshoes', desc = description },

        { label = Locales['HORSE_RENAME_TITLE'],           value = 'rename',     desc = description },
        { label = Locales['HORSE_TRANSFER_TITLE'],         value = 'transfer',   desc = description },
    }

    if Config.HorseDeath.PayToRevive.Enabled and HorseData.isdead == 1 then
        table.insert(elements, { label = Locales['HORSE_REVIVE_TITLE'], value = 'revive', desc = description })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = description })

    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horse_management")

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'horse_management',

    {
        title    = HorseData.name .. " #" .. selectedHorseId,
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenHorsesManagement()
            return
        end

        if (data.current.value == 'default') then 

            PlayerData.Horses[selectedHorseId].name = cb

            if PlayerData.SpawnedHorseEntity then
                SetFleeAway()
            end

            PlayerData.SelectedHorseIndex = selectedHorseId
            TriggerServerEvent("tpz_stables:server:updateHorse", selectedHorseId, 'SET_DEFAULT', { })

            SendNotification(nil, Locales['HORSE_SET_AS_DEFAULT'], 'success')

        elseif (data.current.value == 'rename') then

            local inputData = {
                title        = Locales['HORSE_RENAME_TITLE'],
                desc         = Locales['HORSE_RENAME_INPUT_DESC'],
                buttonparam1 = Locales['BUY_INPUT_ACCEPT'],
                buttonparam2 = Locales['BUY_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                if cb ~= "DECLINE" and cb ~= Locales['BUY_INPUT_CANCEL'] then
                    TriggerServerEvent("tpz_stables:server:updateHorse", selectedHorseId, 'RENAME', { cb })

                    PlayerData.Horses[selectedHorseId].name = cb

                    SendNotification(nil, Locales['RENAMED_HORSE'], 'success')
                end

            end) 

        end


    end,

    function(data, menu)
        menu.close()
        OpenHorsesManagement()
    end)

end

---------------------------------------------------------------
--[[ Functions ]]--
---------------------------------------------------------------

function OpenStableMenu(locationIndex)
    CloseNUI()

    local PlayerData = GetPlayerData()

    if LocationIndex == nil then
        LocationIndex = locationIndex
    end

    local StableData = Config.Locations[LocationIndex]

    local elements = {}

    for action, category in pairs (StableData.MenuCategories) do 
        table.insert(elements, { label = category.Title, value = category.Action, desc = category.Description })
    end

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "main")

    MenuData.Open('default', GetCurrentResourceName(), 'main',

    {
        title    = StableData.Name,
        subtext  = subtext,
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
            cameraCoords = StableData.Horses.CameraCoords

        elseif (data.current.value == 'MANAGE_HORSES') then
            cameraCoords = StableData.Horses.CameraCoords

        elseif (data.current.value == 'BUY_WAGONS') then
            cameraCoords = StableData.Wagons.CameraCoords
        end

        local handler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraCoords.x, cameraCoords.y, cameraCoords.z, cameraCoords.rotx, cameraCoords.roty, cameraCoords.rotz, cameraCoords.fov, false, 2)
        SetCamActive(handler, true)
        RenderScriptCams(true, false, 0, true, true, 0)

        PlayerData.CameraHandler = handler

        Wait(1000)
        DoScreenFadeIn(2000)

        if (data.current.value == 'BUY_HORSES') then
            OpenBuyHorsesList()

        elseif (data.current.value == 'MANAGE_HORSES') then

            local currentHorses  = GetPlayerHorses(PlayerData.CharIdentifier)	
            local count          = currentHorses.count

            if count > 0 then
                OpenHorsesManagement()
            else
                SendNotification(nil, Locales['NO_HORSES_AVAILABLE'], "error")
            end

        elseif (data.current.value == 'BUY_WAGONS') then
            OpenBuyWagonsList()
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
