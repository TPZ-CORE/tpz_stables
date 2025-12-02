local PromptGroup, HorsePromptGroup, HorseTrainingPromptGroup  = GetRandomIntInRange(0, 0xffffff), nil, GetRandomIntInRange(0, 0xffffff)
local PromptList,  HorsePromptsList, HorseTrainingPromptsList  = nil, {}, nil

local SearchWagonPrompt
local WardrobeWagonPrompt
local StoreWagonPrompt
local RepairWagonPrompt
local StowWagonPrompt

local WagonPromptList = GetRandomIntInRange(0, 0xffffff)

local TamingStorePrompt
local TamingStoreSetOwned
local TamingStorePromptList = GetRandomIntInRange(0, 0xffffff)
--[[-------------------------------------------------------
 Base Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, PromptGroup) -- UiPromptDelete
    Citizen.InvokeNative(0x00EDE88D4D13CF59, HorsePromptGroup) -- UiPromptDelete
    Citizen.InvokeNative(0x00EDE88D4D13CF59, HorseTrainingPromptGroup) -- UiPromptDelete
    Citizen.InvokeNative(0x00EDE88D4D13CF59, WagonPromptList) -- UiPromptDelete

    if GetPlayerData().IsBusy then
        ClearPedTasksImmediately(PlayerPedId())
        PromptDelete(PromptList)
    end

    for i, v in pairs(Config.Locations) do

        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end

        if v.NPC then
            DeleteEntity(v.NPC)
            DeletePed(v.NPC)
            SetEntityAsNoLongerNeeded(v.NPC)
        end

    end

end)


--[[-------------------------------------------------------
 Prompts
]]---------------------------------------------------------

RegisterActionPrompt = function()
    local str = Locales["PROMPT_TEXT"]
    PromptList = PromptRegisterBegin()
    PromptSetControlAction(PromptList, Config.Keys[Config.PromptAction.Key])
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptList, str)
    PromptSetEnabled(PromptList, 1)
    PromptSetVisible(PromptList, 1)
    PromptSetStandardMode(PromptList, 1)
    PromptSetHoldMode(PromptList, Config.PromptAction.HoldMode)
    PromptSetGroup(PromptList, PromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptList, true)
    PromptRegisterEnd(PromptList)
end

GetPromptData = function ()
    return PromptGroup, PromptList
end

function AddHorsePrompts(entity)
    local group = Citizen.InvokeNative(0xB796970BD125FCE8, entity, Citizen.ResultAsLong()) -- PromptGetGroupIdForTargetEntity

    local str = Locales['HORSE_BRUSH']
    local brushPrompt = PromptRegisterBegin()
    PromptSetControlAction(brushPrompt, 0x63A38F2C)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(brushPrompt, str)
    PromptSetEnabled(brushPrompt, 1)
    PromptSetVisible(brushPrompt, 1)
    PromptSetStandardMode(brushPrompt, 1)
    PromptSetGroup(brushPrompt, group)
    PromptRegisterEnd(brushPrompt)

    local str2 = Locales['HORSE_SADDLEBAG']
    local saddlebagPrompt = PromptRegisterBegin()
    PromptSetControlAction(saddlebagPrompt, 0x0D55A0F0)
    str = CreateVarString(10, 'LITERAL_STRING', str2)
    PromptSetText(saddlebagPrompt, str)
    PromptSetEnabled(saddlebagPrompt, 1)
    PromptSetVisible(saddlebagPrompt, 1)
    PromptSetStandardMode(saddlebagPrompt, 1)
    PromptSetGroup(saddlebagPrompt, group)
    PromptRegisterEnd(saddlebagPrompt)

    HorsePromptsList[entity]              = {}
    HorsePromptsList[entity]['BRUSH']     = brushPrompt
    HorsePromptsList[entity]['SADDLEBAG'] = saddlebagPrompt

    HorsePromptGroup = group
end

function GetHorsePrompts()
    return HorsePromptsList
end

RegisterHorseTrainingActionPrompt = function()
    local str = Config.HorseTrainingPromptAction.Label
    local _prompt = PromptRegisterBegin()
    PromptSetControlAction(_prompt, Config.Keys[Config.HorseTrainingPromptAction.Key])
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(_prompt, str)
    PromptSetEnabled(_prompt, 1)
    PromptSetVisible(_prompt, 1)
    PromptSetStandardMode(_prompt, 1)
    PromptSetHoldMode(_prompt, Config.HorseTrainingPromptAction.HoldMode)
    PromptSetGroup(_prompt, HorseTrainingPromptGroup)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
    PromptRegisterEnd(_prompt)

    HorseTrainingPromptsList = _prompt
end

GetHorseTrainingPromptData = function ()
    return HorseTrainingPromptGroup, HorseTrainingPromptsList
end

RegisterTamingStableActionPrompt = function()

    TamingStorePrompt = PromptRegisterBegin()
    PromptSetControlAction(TamingStorePrompt, Config.Keys[Config.TamingPromptActions['SELL'].Key])
    PromptSetText(TamingStorePrompt, CreateVarString(10, 'LITERAL_STRING', Config.TamingPromptActions['SELL'].Label))
    PromptSetEnabled(TamingStorePrompt, 1)
    PromptSetVisible(TamingStorePrompt, 1)
    PromptSetStandardMode(TamingStorePrompt, 1)
    PromptSetHoldMode(TamingStorePrompt, Config.TamingPromptActions['SELL'].HoldMode)
    PromptSetGroup(TamingStorePrompt, TamingStorePromptList)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, TamingStorePrompt, true)
    PromptRegisterEnd(TamingStorePrompt)

    TamingStoreSetOwned = PromptRegisterBegin()
    PromptSetControlAction(TamingStoreSetOwned, Config.Keys[Config.TamingPromptActions['SET_OWNED'].Key])
    PromptSetText(TamingStoreSetOwned, CreateVarString(10, 'LITERAL_STRING', Config.TamingPromptActions['SET_OWNED'].Label))
    PromptSetEnabled(TamingStoreSetOwned, 1)
    PromptSetVisible(TamingStoreSetOwned, 1)
    PromptSetStandardMode(TamingStoreSetOwned, 1)
    PromptSetHoldMode(TamingStoreSetOwned, Config.TamingPromptActions['SET_OWNED'].HoldMode)
    PromptSetGroup(TamingStoreSetOwned, TamingStorePromptList)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, TamingStoreSetOwned, true)
    PromptRegisterEnd(TamingStoreSetOwned)

end

GetTamingStorePromptData = function ()
    return TamingStorePrompt, TamingStoreSetOwned, TamingStorePromptList
end


RegisterWagonActionPrompts = function()

    local StorageData = Config.WagonStorageSearching

    SearchWagonPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(SearchWagonPrompt, StorageData.Key)
    UiPromptSetText(SearchWagonPrompt, CreateVarString(10, 'LITERAL_STRING', StorageData.PromptDisplay))
    UiPromptSetEnabled(SearchWagonPrompt, true)
    UiPromptSetVisible(SearchWagonPrompt, true) -- storage true for all.
    UiPromptSetStandardMode(SearchWagonPrompt, true)
    UiPromptSetGroup(SearchWagonPrompt, WagonPromptList, 0)
    UiPromptRegisterEnd(SearchWagonPrompt)

    local WardobeData = Config.WagonWardrobeOutfits

    WardrobeWagonPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(WardrobeWagonPrompt, WardobeData.Key)
    UiPromptSetText(WardrobeWagonPrompt, CreateVarString(10, 'LITERAL_STRING', WardobeData.PromptDisplay))
    UiPromptSetEnabled(WardrobeWagonPrompt, false)
    UiPromptSetVisible(WardrobeWagonPrompt, false) -- only for owner.
    UiPromptSetStandardMode(WardrobeWagonPrompt, true)
    UiPromptSetGroup(WardrobeWagonPrompt, WagonPromptList, 0)
    UiPromptRegisterEnd(WardrobeWagonPrompt)

    local StoreData = Config.StoreWagonPrompt

    StoreWagonPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(StoreWagonPrompt, StoreData.Key)
    UiPromptSetText(StoreWagonPrompt, CreateVarString(10, 'LITERAL_STRING', StoreData.PromptDisplay))
    UiPromptSetEnabled(StoreWagonPrompt, false)
    UiPromptSetVisible(StoreWagonPrompt, false) -- only for owner.
    UiPromptSetStandardMode(StoreWagonPrompt, true)
    UiPromptSetGroup(StoreWagonPrompt, WagonPromptList, 0)
    UiPromptRegisterEnd(StoreWagonPrompt)

    local RepairData = Config.WagonRepairs

    RepairWagonPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(RepairWagonPrompt, RepairData.Key)
    UiPromptSetText(RepairWagonPrompt, CreateVarString(10, 'LITERAL_STRING', RepairData.PromptDisplay))
    UiPromptSetEnabled(RepairWagonPrompt, false)
    UiPromptSetVisible(RepairWagonPrompt, false) -- only for required jobs.
    UiPromptSetStandardMode(RepairWagonPrompt, true)
    UiPromptSetGroup(RepairWagonPrompt, WagonPromptList, 0)
    UiPromptRegisterEnd(RepairWagonPrompt)

    local StowData = Config.HuntingWagonPrompts

    StowWagonPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(StowWagonPrompt, StowData.Key)
    UiPromptSetText(StowWagonPrompt, CreateVarString(10, 'LITERAL_STRING', StowData.PromptDisplay))
    UiPromptSetEnabled(StowWagonPrompt, false)
    UiPromptSetVisible(StowWagonPrompt, false) -- only for owner.
    UiPromptSetStandardMode(StowWagonPrompt, true)
    UiPromptSetGroup(StowWagonPrompt, WagonPromptList, 0)
    UiPromptRegisterEnd(StowWagonPrompt)

end

function GetSearchWagonPrompt()
    return SearchWagonPrompt
end

function GetWardrobeWagonPrompt()
    return WardrobeWagonPrompt
end

function GetStowWagonPrompt()
    return StowWagonPrompt
end

function GetStoreWagonPrompt()
    return StoreWagonPrompt
end

function GetWagonRepairPrompt()
    return RepairWagonPrompt
end

function GetWagonPromptsList()
    return WagonPromptList
end


--GetPromptData = function ()
--    return PromptGroup, PromptList
--end

--[[-------------------------------------------------------
 Blips
]]---------------------------------------------------------

function AddBlip(Stable, StatusType)

    if Config.Locations[Stable].BlipData then

        local BlipData = Config.Locations[Stable].BlipData

        local sprite, blipModifier = BlipData.Sprite, 'BLIP_MODIFIER_MP_COLOR_32'

        if BlipData.OpenBlipModifier then
            blipModifier = BlipData.OpenBlipModifier
        end

        if StatusType == 'CLOSED' then
            sprite = BlipData.DisplayClosedHours.Sprite
            blipModifier = BlipData.DisplayClosedHours.BlipModifier
        end
        
        Config.Locations[Stable].BlipHandle = N_0x554d9d53f696d002(1664425300, Config.Locations[Stable].Coords.x, Config.Locations[Stable].Coords.y, Config.Locations[Stable].Coords.z)

        SetBlipSprite(Config.Locations[Stable].BlipHandle, sprite, 1)
        SetBlipScale(Config.Locations[Stable].BlipHandle, 0.2)

        Citizen.InvokeNative(0x662D364ABF16DE2F, Config.Locations[Stable].BlipHandle, GetHashKey(blipModifier))

        Config.Locations[Stable].BlipHandleModifier = blipModifier

        Citizen.InvokeNative(0x9CB1A1623062F402, Config.Locations[Stable].BlipHandle, BlipData.Name)

    end
end


--[[-------------------------------------------------------
 NPC
]]---------------------------------------------------------


RequestEntityControl = function(entity)

    if not NetworkHasControlOfEntity(entity) then
        NetworkRequestControlOfEntity(entity)

        local timeout = 10000
        local startTime = GetGameTimer()

        while not NetworkHasControlOfEntity(entity) do
            if GetGameTimer() - startTime > timeout then
                print('Failed to get control of the entity.')
                return false
            end
            Wait(10)
        end
    end

    return true
end

LoadModel = function(inputModel)
    local model = GetHashKey(inputModel)
 
    RequestModel(model)
 
    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
end

LoadHashModel = function(model)
    RequestModel(model)
 
    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
end

RemoveEntityProperly = function(entity, objectHash)
	DeleteEntity(entity)
	DeletePed(entity)
	SetEntityAsNoLongerNeeded( entity )

	if objectHash then
		SetModelAsNoLongerNeeded(objectHash)
	end
end

--[[-------------------------------------------------------
 Other
]]---------------------------------------------------------

ShowNotification = function(_message, rgbData, timer)

    if timer == nil or timer == 0 then
        timer = 200
    end
    local r, g, b, a = 161, 3, 0, 255

    if rgbData then
        r, g, b, a = rgbData.r, rgbData.g, rgbData.b, rgbData.a
    end

	while timer > 0 do
		DisplayHelp(_message, 0.50, 0.90, 0.6, 0.6, true, r, g, b, a, true)

		timer = timer - 1
		Citizen.Wait(0)
	end

end

DisplayHelp = function(_message, x, y, w, h, enableShadow, col1, col2, col3, a, centre)

	local str = CreateVarString(10, "LITERAL_STRING", _message, Citizen.ResultAsLong())

	SetTextScale(w, h)
	SetTextColor(col1, col2, col3, a)

	SetTextCentre(centre)

	if enableShadow then
		SetTextDropshadow(1, 0, 0, 0, 255)
	end

	Citizen.InvokeNative(0xADA9255D, 10);

	DisplayText(str, x, y)

end

function ContainsRequiredParameterOnTable(table, element)

    if table == nil then table = {} end

    for k, v in pairs(table) do

        if v == element then
            return true
        end
    end

    return false
end

function PlayAnimation(ped, anim)
	if not DoesAnimDictExist(anim.dict) then
		return false
	end

	RequestAnimDict(anim.dict)

	while not HasAnimDictLoaded(anim.dict) do
		Wait(0)
	end

	TaskPlayAnim(ped, anim.dict, anim.name, anim.blendInSpeed, anim.blendOutSpeed, anim.duration, anim.flag, anim.playbackRate, false, false, false, '', false)

	RemoveAnimDict(anim.dict)

	return true
end

GetNearestVehicles = function(coords, radius, allowlistedVehicleEntity)
	local closestVehicles = {}

    local vehiclePool = GetGamePool('CVehicle') -- Get the list of vehicles (entities) from the pool
    for i = 1, #vehiclePool do -- loop through each vehicle (entity)

        if vehiclePool[i] ~= allowlistedVehicleEntity then

            local targetCoords = GetEntityCoords(vehiclePool[i])
            local coordsDist   = vector3(targetCoords.x, targetCoords.y, targetCoords.z)
    
            local distance     = #(coordsDist - coords)

            if distance < radius then
                table.insert(closestVehicles, vehiclePool[i])
            end

        end

    end

	return closestVehicles
end
