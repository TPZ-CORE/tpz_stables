local PromptGroup, HorsePromptGroup  = GetRandomIntInRange(0, 0xffffff), nil
local PromptList,  HorsePromptsList  = nil, {}

--[[-------------------------------------------------------
 Base Events
]]---------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Citizen.InvokeNative(0x00EDE88D4D13CF59, PromptGroup) -- UiPromptDelete
    Citizen.InvokeNative(0x00EDE88D4D13CF59, HorsePromptGroup) -- UiPromptDelete

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

LoadModel = function(inputModel)
    local model = GetHashKey(inputModel)
 
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
