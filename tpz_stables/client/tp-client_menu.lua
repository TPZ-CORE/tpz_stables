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

local MANAGEMENT_MODEL_TITLE <const>          = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
local MANAGEMENT_NAME_TITLE <const>           = "<span style='opacity: 0.8; float:left; text-align: left; width: 5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"

local HORSE_EQUIPMENTS_IMAGE_PATH <const>     = "<img style='max-height:1.7vw;max-width:1.7vw; float:%s; margin-top: -0.50vw;' src='nui://tpz_stables/html/img/%s.png'>"
local HORSE_EQUIPMENTS_TITLE_STYLE <const>    = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

local WAGON_EQUIPMENTS_IMAGE_PATH <const>     = "<img style='max-height:1.7vw;max-width:1.7vw; float:%s; margin-top: -0.50vw;' src='nui://tpz_stables/html/img/%s.png'>"
local WAGON_EQUIPMENTS_TITLE_STYLE <const>    = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"

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
            
            local DIV_STORAGE_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 14vw; font-size: 0.8vw; ' >%s</div>", Locales['WAGON_MANAGEMENT_STORAGE'])
            local DIV_STORAGE_LABEL_DISPLAY = DIV_STORAGE_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", wagon[5] .. 'kg')
        
            table.insert(elements, {
                label = fixedLabel,
                name  = label,
                money = money,
                gold  = gold,
                value = index,
                desc = DIV_STORAGE_LABEL_DISPLAY,
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

-- WAGONS MANAGEMENT

function OpenWagonsManagement()
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

    local currentWagons  = GetPlayerWagons(PlayerData.CharIdentifier)	
    local count          = currentWagons.wagonsIndex

    local elements       = {}

    local ownedWagonsList = {}
    local ownedCount      = 0

    for index, wagon in pairs (PlayerData.Wagons) do 

        if wagon.charidentifier == PlayerData.CharIdentifier then

            ownedCount = ownedCount + 1

            local modelData = GetWagonModelData(wagon.model)

            local model = MANAGEMENT_MODEL_TITLE:format(modelData[2])
            local name  = MANAGEMENT_NAME_TITLE:format(wagon.name)

            table.insert(elements, {
                label = model .. name,
                value = ownedCount,
                desc = "",
            })

            ownedWagonsList[ownedCount] = {}
            ownedWagonsList[ownedCount] = wagon
        end

    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    -- Forcing MenuData Index to always be the first result when opening a wagon category.
    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "wagons_management")

    local model     = ownedWagonsList[1].model
    local modelData = GetWagonModelData(model)

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

    LoadWagonComponents(wagon, ownedWagonsList[1].id)

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'wagons_management',

    {
        title    = Locales['WAGONS_MANAGEMENT'],
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
        OpenWagonManagementById(ownedWagonsList[data.current.value].id)

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
    
            
            local model     = ownedWagonsList[data.current.value].model
            local modelData = GetWagonModelData(model)

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

            LoadWagonComponents(wagon, ownedWagonsList[data.current.value].id)

        end

        if data.current.value == 'back' then 

            if StoreEntity then
                RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))
        
                StoreEntity        = nil
                StoreEntityModel   = nil
            end

        end

    end)

end

function OpenWagonManagementById(selectedWagonId)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local WagonData  = PlayerData.Wagons[selectedWagonId]
    local ModelData  = GetWagonModelData(WagonData.model)

    -- CATEGORY
    local DIV_CATEGORY_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['WAGON_MANAGEMENT_CATEGORY'])
    local DIV_CATEGORY_DISPLAY = DIV_CATEGORY_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", WagonData.type)

    -- MODEL NAME
    local modelName = ModelData[2]

    local DIV_MODEL_NAME_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 6vw; font-size: 0.8vw; ' >%s</div>", Locales['WAGON_MANAGEMENT_MODEL_NAME'])
    local DIV_MODEL_NAME_DISPLAY = DIV_MODEL_NAME_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", modelName)

    -- CONTAINER STORAGE
    
    local DIV_STORAGE_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 14vw; font-size: 0.8vw; ' >%s</div>", Locales['WAGON_MANAGEMENT_STORAGE'])
    local DIV_STORAGE_LABEL_DISPLAY = DIV_STORAGE_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", ModelData[5] .. 'kg')

    -- SELL PRICES

    local SELL_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
    
    local SELL_CASH_IMAGE_PATH <const>  = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.25vw;' src='nui://tpz_stables/html/img/%s.png'>"
    local SELL_CASH_TEXT_PATH <const>   = "<span style='opacity: 0.8; float:left; text-align: left; width: 2.5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"
    local SELL_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
    
    local sellMoney, sellGold = ModelData[7], ModelData[8]
    
    local icon, text

    if WagonData.bought_account == 0 then
        icon = SELL_CASH_IMAGE_PATH:format("left", "money")
        text = SELL_CASH_TEXT_PATH:format(sellMoney)
    
    elseif WagonData.bought_account == 1 then
        icon = SELL_CASH_IMAGE_PATH:format("left", "gold")
        text = SELL_CASH_TEXT_PATH:format(sellGold)

    elseif WagonData.bought_account == -1 then
        icon = ""
        text = SELL_CASH_IMAGE_PATH:format("left", "money") .. SELL_CASH_TEXT_PATH:format(0) .. SELL_CASH_IMAGE_PATH:format("left", "gold") .. SELL_CASH_TEXT_PATH:format(0)
    end

    local title = SELL_TITLE_STYLE:format(Locales['SELL_WAGON_DISPLAY'])
    local SPAN_SELL_TITLE_DISPLAY = title .. icon .. text

    if WagonData.bought_account == -1 then
        SPAN_SELL_TITLE_DISPLAY = title .. text
    end
    
    -- description

    local description = string.format('%s <br><br> %s <br><br> %s <br><br><br><br> %s', DIV_CATEGORY_DISPLAY, DIV_MODEL_NAME_DISPLAY, DIV_STORAGE_LABEL_DISPLAY, SPAN_SELL_TITLE_DISPLAY)

    local elements   = {
        { label = Locales['WAGON_SET_DEFAULT_TITLE'],      value = 'default',    desc = description },
        { label = Locales['WAGON_COMPONENTS_TITLE'],       value = 'components', desc = description },
        { label = Locales['WAGON_RENAME_TITLE'],           value = 'rename',     desc = description },
        { label = Locales['WAGON_TRANSFER_TITLE'],         value = 'transfer',   desc = description },
        { label = Locales['WAGON_SELL_TITLE'],             value = 'sell',       desc = description },
    }

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = description })

    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "wagon_management")

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    if WagonData.name == nil then
        WagonData.name = 'N/A'
    end
    
    MenuData.Open('default', GetCurrentResourceName(), 'wagon_id_management',

    {
        title    = WagonData.name .. " #" .. selectedWagonId,
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenWagonsManagement()
            return
        end

        if (data.current.value == 'default') then 

            PlayerData.Wagons[selectedWagonId].name = cb
    
            if PlayerData.SpawnedWagonEntity then
                
                RemoveEntityProperly(PlayerData.SpawnedWagonEntity, GetHashKey(PlayerData.Wagons[PlayerData.SpawnedWagonIndex].model))
              
                -- SAVE DATA!
                
                PlayerData.SpawnedWagonIndex  = 0
                PlayerData.SpawnedWagonEntity = nil
            end

            PlayerData.SelectedWagonIndex = selectedWagonId
            TriggerServerEvent("tpz_stables:server:updateWagon", selectedWagonId, 'SET_DEFAULT', { })

            SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["WAGON_SET_AS_DEFAULT"], "success", 5, "wagon", "left")

        elseif (data.current.value == 'rename') then

            local inputData = {
                title        = Locales['WAGON_RENAME_TITLE'],
                desc         = Locales['WAGON_RENAME_INPUT_DESC'],
                buttonparam1 = Locales['RENAME_INPUT_ACCEPT'],
                buttonparam2 = Locales['RENAME_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                if cb ~= "DECLINE" and cb ~= Locales['BUY_INPUT_CANCEL'] then
                    TriggerServerEvent("tpz_stables:server:updateWagon", selectedWagonId, 'RENAME', { cb })

                    PlayerData.Wagons[selectedWagonId].name = cb

                    SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales[RENAMED_WAGON"], "success", 3, "wagon", "left")

                    menu.close()
                    OpenWagonManagementById(selectedWagonId)
                end

            end) 

        elseif (data.current.value == 'sell') then

            local sellDescription

            if WagonData.bought_account == 0 then
                sellDescription = string.format(Locales['WAGON_SELL_CASH_DESCRIPTION'], sellMoney)

            elseif WagonData.bought_account == 1 then
                sellDescription = string.format(Locales['WAGON_SELL_GOLD_DESCRIPTION'], sellGold)

            elseif WagonData.bought_account == -1 then
                sellDescription = Locales['WAGON_SELL_NO_EARNINGS_DESCRIPTION']
            end

            local inputData = {
                title        = Locales['WAGON_SELL_TITLE'],
                desc         = sellDescription,
                buttonparam1 = Locales['SELL_INPUT_ACCEPT'],
                buttonparam2 = Locales['SELL_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)
            
                if cb == "ACCEPT" then

                    TriggerServerEvent("tpz_stables:server:sellWagon", selectedWagonId)
                    menu.close()
                    
                    Wait(1500)
                    OnBackToStableMenu()
                    OpenStableMenu()
                end

            end) 

        elseif (data.current.value == 'transfer') then

            local inputData = {
                title        = Locales['WAGON_TRANSFER_TITLE'],
                desc         = Locales['WAGON_TRANSFER_INPUT_DESC'],
                buttonparam1 = Locales['TRANSFER_INPUT_ACCEPT'],
                buttonparam2 = Locales['TRANSFER_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                local inputId = tonumber(cb)

                if inputId == nil and inputId <= 0 then
                    SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["INVALID_INPUT"], "error", 3, "wagon", "left")
                    return
                end

                local nearestPlayers = TPZ.GetNearestPlayers(Config.TransferMaximumDistance)
                local foundPlayer    = false

                for _, targetPlayer in pairs(nearestPlayers) do

                    if inputId == GetPlayerServerId(targetPlayer) then
                       foundPlayer = true
                    end
                end

                if foundPlayer then

                    TriggerServerEvent("tpz_stables:server:transferWagon", selectedWagonId, inputId )

                    menu.close()
                    
                    Wait(1500)
                    OnBackToStableMenu()
                    OpenStableMenu()

                else
                    SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["PLAYER_NOT_FOUND"], "error", 3, "wagon", "left")
                end

            end) 

        elseif (data.current.value == 'components') then

            if not IsStableOpen(StableData) then 
                SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["STABLE_IS_CLOSED"], "error", 3, "wagon", "left")
                return
            end

            if Config.WagonEquipments[WagonData.model] == nil then
                SendNotification(nil, Locales['WAGON_NOTIFY_TITLE'], Locales["WAGON_EQUIPMENTS_DOES_NOT_EXIST"], "error", 5, "wagon", "left")
                return
            end

            menu.close()
            OpenWagonManagementEquipments(selectedWagonId)
        end


    end,

    function(data, menu)
        menu.close()
        OpenWagonsManagement()
    end)

end


function OpenWagonManagementEquipments(selectedWagonId)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local WagonData  = PlayerData.Wagons[selectedWagonId]

    local elements = {}

    for index, equipment in pairs (Config.WagonEquipments[WagonData.model]) do 
        table.insert(elements, { 
            label = WAGON_EQUIPMENTS_IMAGE_PATH:format("left", equipment.BackgroundImage) .. WAGON_EQUIPMENTS_TITLE_STYLE:format(equipment.Category), 
            value = index, 
            desc = "" 
        })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'wagon_management_equipment_list',

    {
        title    = Locales['WAGONS_EQUIPMENTS_TITLE'],
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenWagonManagementById(selectedWagonId)
            TriggerServerEvent("tpz_stables:server:updateWagon", selectedWagonId, 'UPDATE_COMPONENTS', { WagonData.components })
            return
        end

        menu.close()
        OpenWagonManagementEquipmentsByCategory(selectedWagonId, data.current.value)

    end,

    function(data, menu)
        menu.close()
        OpenWagonManagementById(selectedWagonId)
        TriggerServerEvent("tpz_stables:server:updateWagon", selectedWagonId, 'UPDATE_COMPONENTS', { WagonData.components })
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

    LoadHorseComponents(horse, ownedHorsesList[1].id)

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

        local getRealAge = math.floor(ownedHorsesList[data.current.value].age * 1 / 1440)
        local isAgedDead = getRealAge >= modelData[9]

        if not isAgedDead then
            menu.close()
            OpenHorseManagementById(ownedHorsesList[data.current.value].id)
        else
            SendNotification(nil, Locales['NOT_PERMITTED_TO_MANAGE_HORSE'], "error")
        end

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

            LoadHorseComponents(horse, ownedHorsesList[data.current.value].id)

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
    local ModelData  = GetHorseModelData(HorseData.model)

    -- AGE
    local getRealAge = math.floor(HorseData.age * 1 / 1440)
    local DIV_AGE_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw;' >%s</div>", Locales['HORSE_MANAGEMENT_AGE'])
    local DIV_AGE_DISPLAY = DIV_AGE_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; ' >%s</div>", getRealAge .. 'd / ' .. ModelData[9] .. 'd')

    -- RACE
    local DIV_CATEGORY_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_RACE'])
    local DIV_CATEGORY_DISPLAY = DIV_CATEGORY_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", HorseData.type)

    -- MODEL NAME
    local modelName = ModelData[2]

    local DIV_MODEL_NAME_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 6vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_MODEL_NAME'])
    local DIV_MODEL_NAME_DISPLAY = DIV_MODEL_NAME_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", modelName)

    
    -- SEX
    local DIV_SEX_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 4vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_SEX'])

    local sex = HorseData.sex == 0 and "Male" or "Female"
    local DIV_SEX_DISPLAY = DIV_SEX_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", sex)

    -- SHOES
    local DIV_SHOES_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 7vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_SHOES_KM'] .. HorseData.stats.shoes_km_left)

    local shoesType = HorseData.stats.shoes_type == 0 and Locales['HORSE_MANAGEMENT_SHOES_NONE'] or Config.HorseShoes[HorseData.stats.shoes_type].Label
    local DIV_SHOES_DISPLAY = DIV_SHOES_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", shoesType)

    -- TRAINED

    local DIV_TRAINED_LABEL = string.format("<div style='opacity: 0.8; float:left; text-align: left; width: 6vw; font-size: 0.8vw; ' >%s</div>", Locales['HORSE_MANAGEMENT_TRAINED'])

    local trained = HorseData.training_experience == -1 and Locales['HORSE_MANAGEMENT_TRAINED_YES'] or Locales['HORSE_MANAGEMENT_TRAINED_NO']
    local DIV_TRAINED_DISPLAY = DIV_TRAINED_LABEL .. string.format("<div style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw;' >%s</div>", trained)

    -- SELL PRICES

    local SELL_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
    
    local SELL_CASH_IMAGE_PATH <const>  = "<img style='max-height:2.3vw;max-width:2.3vw; float:%s; margin-top: -0.25vw;' src='nui://tpz_stables/html/img/%s.png'>"
    local SELL_CASH_TEXT_PATH <const>   = "<span style='opacity: 0.8; float:left; text-align: left; width: 2.5vw; font-size: 0.8vw; margin-top: -0.20vw; margin-left: 0.25vw;' >%s</span>"
    local SELL_TITLE_STYLE <const>      = "<span style='opacity: 0.8; float:right; text-align: right; font-size: 0.8vw; margin-top: -0.20vw;' >%s</span>"
    
    local sellMoney, sellGold = ModelData[7], ModelData[8]
    
    local icon, text

    if HorseData.bought_account == 0 then
        icon = SELL_CASH_IMAGE_PATH:format("left", "money")
        text = SELL_CASH_TEXT_PATH:format(sellMoney)
    
    elseif HorseData.bought_account == 1 then
        icon = SELL_CASH_IMAGE_PATH:format("left", "gold")
        text = SELL_CASH_TEXT_PATH:format(sellGold)

    elseif HorseData.bought_account == -1 then
        icon = ""
        text = SELL_CASH_IMAGE_PATH:format("left", "money") .. SELL_CASH_TEXT_PATH:format(0) .. SELL_CASH_IMAGE_PATH:format("left", "gold") .. SELL_CASH_TEXT_PATH:format(0)
    end

    local title = SELL_TITLE_STYLE:format(Locales['SELL_HORSE_DISPLAY'])
    local SPAN_SELL_TITLE_DISPLAY = title .. icon .. text

    if HorseData.bought_account == -1 then
        SPAN_SELL_TITLE_DISPLAY = title .. text
    end
    
    -- description

    local description = string.format('%s <br><br> %s <br><br> %s <br><br> %s <br><br> %s <br><br> %s <br><br><br><br> %s',
        DIV_AGE_DISPLAY, 
        DIV_CATEGORY_DISPLAY, 
        DIV_MODEL_NAME_DISPLAY,
        DIV_SEX_DISPLAY, 
        DIV_SHOES_DISPLAY,
        DIV_TRAINED_DISPLAY,
        SPAN_SELL_TITLE_DISPLAY)

    local elements   = {

        { label = Locales['HORSE_SET_DEFAULT_TITLE'],      value = 'default',    desc = description },
        { label = Locales['HORSE_COMPONENTS_TITLE'],       value = 'components', desc = description },
        { label = Locales['HORSE_ADD_HORSE_SHOES_TITLE'],  value = 'horseshoes', desc = description },

        { label = Locales['HORSE_RENAME_TITLE'],           value = 'rename',     desc = description },
        { label = Locales['HORSE_TRANSFER_TITLE'],         value = 'transfer',   desc = description },
        { label = Locales['HORSE_SELL_TITLE'],             value = 'sell',       desc = description },
    }

    if Config.HorseDeath.PayToRevive.Enabled and HorseData.isdead == 1 then
        table.insert(elements, { label = Locales['HORSE_REVIVE_TITLE'], value = 'revive', desc = description })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = description })

    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horse_management")

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    if HorseData.name == nil then
        HorseData.name = 'N/A'
    end
    
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
                buttonparam1 = Locales['RENAME_INPUT_ACCEPT'],
                buttonparam2 = Locales['RENAME_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                if cb ~= "DECLINE" and cb ~= Locales['BUY_INPUT_CANCEL'] then
                    TriggerServerEvent("tpz_stables:server:updateHorse", selectedHorseId, 'RENAME', { cb })

                    PlayerData.Horses[selectedHorseId].name = cb

                    if PlayerData.SpawnedHorseEntity and PlayerData.SelectedHorseIndex == selectedHorseId then
                        SetPedNameDebug(PlayerData.SpawnedHorseEntity, cb)
                        SetPedPromptName(PlayerData.SpawnedHorseEntity, cb)
                    end

                    SendNotification(nil, Locales['RENAMED_HORSE'], 'success')

                    menu.close()
                    OpenHorseManagementById(selectedHorseId)
                end

            end) 

        elseif (data.current.value == 'sell') then

            local sellDescription

            if HorseData.bought_account == 0 then
                sellDescription = string.format(Locales['HORSE_SELL_CASH_DESCRIPTION'], sellMoney)

            elseif HorseData.bought_account == 1 then
                sellDescription = string.format(Locales['HORSE_SELL_GOLD_DESCRIPTION'], sellGold)

            elseif HorseData.bought_account == -1 then
                sellDescription = Locales['HORSE_SELL_NO_EARNINGS_DESCRIPTION']
            end

            local inputData = {
                title        = Locales['HORSE_SELL_TITLE'],
                desc         = sellDescription,
                buttonparam1 = Locales['SELL_INPUT_ACCEPT'],
                buttonparam2 = Locales['SELL_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getButtonInput", inputData, function(cb)
            
                if cb == "ACCEPT" then

                    TriggerServerEvent("tpz_stables:server:sellHorse", selectedHorseId)
                    menu.close()
                    
                    Wait(1500)
                    OnBackToStableMenu()
                    OpenStableMenu()
                end

            end) 

        elseif (data.current.value == 'transfer') then

            local inputData = {
                title        = Locales['HORSE_TRANSFER_TITLE'],
                desc         = Locales['HORSE_TRANSFER_INPUT_DESC'],
                buttonparam1 = Locales['TRANSFER_INPUT_ACCEPT'],
                buttonparam2 = Locales['TRANSFER_INPUT_CANCEL'],
            }
                                        
            TriggerEvent("tpz_inputs:getTextInput", inputData, function(cb)
            
                local inputId = tonumber(cb)

                if inputId == nil and inputId <= 0 then
                    SendNotification(Locales['INVALID_INPUT'], "error")
                    return
                end

                local nearestPlayers = TPZ.GetNearestPlayers(Config.TransferMaximumDistance)
                local foundPlayer    = false

                for _, targetPlayer in pairs(nearestPlayers) do

                    if inputId == GetPlayerServerId(targetPlayer) then
                       foundPlayer = true
                    end
                end

                if foundPlayer then

                    TriggerServerEvent("tpz_stables:server:transferHorse", selectedHorseId, inputId )

                    menu.close()
                    
                    Wait(1500)
                    OnBackToStableMenu()
                    OpenStableMenu()

                else
                    SendNotification(nil, Locales['PLAYER_NOT_FOUND'], "error")
                end

            end) 

        elseif (data.current.value == 'horseshoes') then

            local options = {}

            for index, shoe in pairs (Config.HorseShoes) do
                table.insert(options, shoe.Label)
            end

            local inputData = {
                title        = Locales['HORSE_SELECT_HORSE_SHOES_TITLE'],
                desc         = Locales['HORSE_SELECT_HORSE_SHOES_DESCRIPTION'],
                buttonparam1 = Locales['HORSE_SHOES_INPUT_BUY'],
                buttonparam2 = Locales['HORSE_SHOES_INPUT_CANCEL'],
                options      = options,
            }
    
            TriggerEvent("tpz_inputs:getSelectedOptionsInput", inputData, function(cb)
    
                if cb ~= "DECLINE" then

                    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_stables:callbacks:hasHorseShoes", function(success)

                        if success then

                            menu.close()
                            Wait(150)
                            OpenHorseManagementById(selectedHorseId)
                        end

                    end, { selectedHorseId, cb})

                end
                        
            end)

        elseif (data.current.value == 'components') then

            if not IsStableOpen(StableData) then 
                SendNotification(nil, Locales['STABLE_IS_CLOSED'], 'error')
                return
            end
            
            menu.close()
            OpenHorseManagementEquipments(selectedHorseId)
        end


    end,

    function(data, menu)
        menu.close()
        OpenHorsesManagement()
    end)

end

function OpenHorseManagementEquipments(selectedHorseId)
    MenuData.CloseAll()

    local PlayerData = GetPlayerData()
    local StableData = Config.Locations[LocationIndex]

    local HorseData  = PlayerData.Horses[selectedHorseId]

    local elements = {}

    for index, equipment in pairs (Config.Equipments) do 
        table.insert(elements, { 
            label = HORSE_EQUIPMENTS_IMAGE_PATH:format("left", equipment.BackgroundImage) .. HORSE_EQUIPMENTS_TITLE_STYLE:format(equipment.Category), 
            value = index, 
            desc = "" 
        })
    end

    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    MenuData.Open('default', GetCurrentResourceName(), 'horse_management_equipment_list',

    {
        title    = Locales['HORSES_EQUIPMENTS_TITLE'],
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)
        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()
            OpenHorseManagementById(selectedHorseId)
            TriggerServerEvent("tpz_stables:server:updateHorse", selectedHorseId, 'UPDATE_COMPONENTS', { HorseData.components })
            return
        end

        menu.close()
        OpenHorseManagementEquipmentsByCategory(selectedHorseId, data.current.value)

    end,

    function(data, menu)
        menu.close()
        OpenHorseManagementById(selectedHorseId)
        TriggerServerEvent("tpz_stables:server:updateHorse", selectedHorseId, 'UPDATE_COMPONENTS', { HorseData.components })
    end)

end


function OpenHorseManagementEquipmentsByCategory(selectedHorseId, categoryIndex)
    MenuData.CloseAll()

    local PlayerData    = GetPlayerData()
    local HorseData     = PlayerData.Horses[selectedHorseId]
    local EquipmentData = Config.Equipments[categoryIndex]

    local elements = {}

    for index, equipment in ipairs (EquipmentData.Types) do 

        local hash, money, label = equipment[1], equipment[2], equipment[3]

        local cashIcon = CATEGORIES_BUY_CASH_IMAGE_PATH:format("left", "money")
        local cashText = CATEGORIES_BUY_CASH_TEXT_PATH:format(money)

        local title    = CATEGORIES_BUY_TITLE_STYLE:format(label)

        table.insert(elements, {
            label = title .. cashIcon .. cashText,
            name  = label,
            money = money,
            value = index,
            desc = "",
        })

    end

    table.insert(elements, { label = EquipmentData.Types[0][3], value = 'reset', desc = '' })
    table.insert(elements, { label = Locales['BACK'], value = 'back', desc = Locales['BACK_DESCRIPTION'] })

    local subtext = string.format(Locales['CURRENT_ACCOUNT'], PlayerData.Cash, PlayerData.Gold)

    local ComponentData = EquipmentData.Types[1]

    local componentHash = tostring(ComponentData[1])
    local model         = GetHashKey(tonumber(componentHash))

    if not HasModelLoaded(model) then
        Citizen.InvokeNative(0xFA28FE3A6246FC30, model)
    end

    Citizen.InvokeNative(0xD3A7B003ED343FD9, StoreEntity, tonumber(componentHash), true, true, true)

    Citizen.InvokeNative(0xCC8CA3E88256E58F, StoreEntity, false, true, true, true, false)
    Citizen.InvokeNative(0xAAB86462966168CE, StoreEntity, true)

    -- Forcing MenuData Index to always be the first result when opening a horse category.
    MenuData.ResetLastSelectedIndex('default', "tpz_stables", "horse_management_equipments_category_list")

    MenuData.Open('default', GetCurrentResourceName(), 'horse_management_equipments_category_list',

    {
        title    = EquipmentData.Category,
        subtext  = subtext,
        align    = "right",
        elements = elements,
        lastmenu = "notMenu"
    },

    function(data, menu)

        if (data.current == "backup" or data.current.value == "back") then 
            menu.close()

            ResetOutfitBasedOnCategory('ALL')
            LoadHorseComponents(StoreEntity, selectedHorseId)

            OpenHorseManagementEquipments(selectedHorseId)
            return
        end

        if (data.current.value == 'reset') then

            ResetOutfitBasedOnCategory(EquipmentData.Type)
            PlayerData.Horses[selectedHorseId].components[EquipmentData.Type] = 0
           
            return
        end

        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_stables:callbacks:canBuyComponent", function(success)

            if success then

                PlayerData.Horses[selectedHorseId].components[EquipmentData.Type] = data.current.value
    
            end

        end, { categoryIndex, data.current.value } )

    end,

    function(data, menu)
        menu.close()
    end,

    function(data, menu)

        if data.current.value ~= 'back' and data.current.value ~= 'reset' then

            local indexType = data.current.value
            local ComponentData = EquipmentData.Types[indexType]

            ResetOutfitBasedOnCategory(EquipmentData.Type)

            local componentHash = tostring(ComponentData[1])
            local model         = GetHashKey(tonumber(componentHash))

            if not HasModelLoaded(model) then
                Citizen.InvokeNative(0xFA28FE3A6246FC30, model)
            end

            Citizen.InvokeNative(0xD3A7B003ED343FD9, StoreEntity, tonumber(componentHash), true, true, true)

            Citizen.InvokeNative(0xCC8CA3E88256E58F, StoreEntity, false, true, true, true, false)
            Citizen.InvokeNative(0xAAB86462966168CE, StoreEntity, true)
        end

    end)

end

--[[ https://raw.githubusercontent.com/femga/rdr3_discoveries/master/clothes/cloth_hash_names.lua --  ]]

function ResetOutfitBasedOnCategory(clothCategory)

    if clothCategory == 'SADDLE' then

        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xBAA7E618, 0) -- SADDLE REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x5447332, 0)  -- HORNS REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xDA6DADCA, 0) -- STIRRUPS REMOVE

    elseif clothCategory == 'MASK' then

        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xD3500E5D, 0) -- MASK REMOVE

    elseif clothCategory == 'BEDROLL' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xEFB31921, 0) -- BEDROLL REMOVE

    elseif clothCategory == 'BLANKET' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x17CEB41A, 0) -- BLANKET REMOVE

    elseif clothCategory == 'STIRRUP' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xDA6DADCA, 0) -- STIRRUP REMOVE

    elseif clothCategory == 'HORN' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x5447332, 0) -- HORN REMOV

    elseif clothCategory == 'MANE' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xAA0217AB, 0) -- MANE REMOV
        
    elseif clothCategory == 'BAG' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x80451C25, 0) -- SADDLEBAG REMOV

    elseif clothCategory == 'TAIL' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xA63CAE10, 0) -- TAIL REMOVE
        
    elseif clothCategory == 'BRIDLE' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x94B2E3AF, 0) -- BRIDLE REMOVE
        
    elseif clothCategory == 'MUSTACHE' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x30DEFDDF, 0) -- MUSTACHE REMOVE

        
    elseif clothCategory == 'LANTERN' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x1530BE1C, 0) -- LANTERN REMOVE

        
    elseif clothCategory == 'HOLSTER' then
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xAC106B30, 0) -- HOLSTER REMOVE

    else

        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xBAA7E618, 0) -- SADDLE REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xD3500E5D, 0) -- MASK REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xEFB31921, 0) -- BEDROLL REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x17CEB41A, 0) -- BLANKET REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xDA6DADCA, 0) -- STIRRUP REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x5447332, 0) -- HORN REMOV
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xAA0217AB, 0) -- MANE REMOV
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x80451C25, 0) -- SADDLEBAG REMOV
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xA63CAE10, 0) -- TAIL REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x94B2E3AF, 0) -- BRIDLE REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x30DEFDDF, 0) -- MUSTACHE REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0x1530BE1C, 0) -- LANTERN REMOVE
        Citizen.InvokeNative(0xD710A5007C2AC539, StoreEntity, 0xAC106B30, 0) -- HOLSTER REMOVE

    end

    Citizen.InvokeNative(0xCC8CA3E88256E58F, StoreEntity, false, true, true, true, false)

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
        if (data.current == "backup") or (data.current.value == "EXIT") then 
            menu.close()
            CloseMenu()
            return
        end

        local cameraCoords

        if (data.current.value == 'BUY_HORSES' or data.current.value == 'BUY_WAGONS') then 

            if not IsStableOpen(StableData) then 
                SendNotification(nil, Locales['STABLE_IS_CLOSED'], 'error')
                return
            end

        end

        if (data.current.value == 'BUY_HORSES') then
            cameraCoords = StableData.Horses.CameraCoords

        elseif (data.current.value == 'MANAGE_HORSES') then
            cameraCoords = StableData.Horses.CameraCoords

            local currentHorses  = GetPlayerHorses(PlayerData.CharIdentifier)	
            local count          = currentHorses.count

            if count <= 0 then
                SendNotification(nil, Locales['NO_HORSES_AVAILABLE'], "error")
                return
            end

        elseif (data.current.value == 'BUY_WAGONS') then
            cameraCoords = StableData.Wagons.CameraCoords

        elseif (data.current.value == 'MANAGE_WAGONS') then
            cameraCoords = StableData.Wagons.CameraCoords

            local currentHorses  = GetPlayerWagons(PlayerData.CharIdentifier)	
            local count          = currentHorses.count

            if count <= 0 then
                SendNotification(nil, Locales['NO_WAGONS_AVAILABLE'], "error")
                return
            end

        end

        menu.close()
        
        while not IsScreenFadedOut() do
            Wait(50)
            DoScreenFadeOut(2000)
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

            OpenHorsesManagement()

        elseif (data.current.value == 'BUY_WAGONS') then
            OpenBuyWagonsList()

        elseif (data.current.value == 'MANAGE_WAGONS') then
            OpenWagonsManagement()

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

        if StoreEntity then
            RemoveEntityProperly(StoreEntity, GetHashKey(StoreEntityModel))
    
            StoreEntity        = nil
            StoreEntityModel   = nil
        end

        DoScreenFadeIn(1000)
        DestroyAllCams(true)
        TaskStandStill(PlayerPedId(), 1)

    end
        
end)

AddEventHandler("tpz_stables:client:menu_tasks", function()

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
                CloseNUI()
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

end)

