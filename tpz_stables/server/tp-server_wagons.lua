local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function GetWagonModelCategory(model)
    for index, category in pairs (Config.Wagons) do

        for _, wagon in pairs (category.Wagons) do

            if model == wagon[1] then
                return category.Category
            end

        end

    end

    return "N/A"
end

function GetWagonModelData(model)

    for index, category in pairs (Config.Wagons) do

        for _, wagon in pairs (category.Wagons) do

            if model == wagon[1] then
                return wagon
            end

        end

    end

    return nil

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

-- We reset the source and delete a wagon if spawned when player is dropped (disconnected).
AddEventHandler('playerDropped', function (reason)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)

	if not xPlayer.loaded() then 
		return 
	end
	
	local charIdentifier = xPlayer.getCharacterIdentifier()

	local Wagons         = GetWagons()

	if TPZ.GetTableLength(Wagons) > 0 then

		local currentWagons  = GetPlayerWagons(charIdentifier)	

		for _, wagonIndex in pairs (currentWagons.wagonsIndex) do
	
			local WagonData = Wagons[tonumber(wagonIndex)]
	
			if WagonData.entity and WagonData.entity ~= 0 then
	
				local entity = NetworkGetEntityFromNetworkId(WagonData.entity)
                local coords

				if DoesEntityExist(entity) then
                    local tableCoords = GetEntityCoords(entity)
                    coords = vector3(tableCoords.x, tableCoords.y, tableCoords.z)
					DeleteEntity(entity)
				else
                    coords = vector3(0.0, 0.0, 0.0)
                end

                Wagons[tonumber(wagonIndex)].entity = 0
                TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { wagonIndex = tonumber(wagonIndex), action = "NETWORK_ID", data = { 0 } }, coords, 200.0, 500, true, 40)
			end
			
			WagonData.source = 0
	
		end

	end

end)

-----------------------------------------------------------
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:saveWagon')
AddEventHandler('tpz_stables:server:saveWagon', function(wagonIndex, wheelsJson)
	local _source = source
	local Wagons  = GetWagons()

	if Wagons[wagonIndex] == nil then
		return
	end
    local brokenList  = json.decode(wheelsJson)
	local wheelStates = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 }

	for _, idx in ipairs(brokenList) do
		wheelStates[tostring(idx)] = 1
	end

	Wagons[wagonIndex].wheels = wheelStates

	if Wagons[wagonIndex].stow == nil then 
		Wagons[wagonIndex].stow = {}
	end
		
	exports.ghmattimysql:execute("UPDATE `wagons` SET `wheels` = @wheels, `stow` = @stow WHERE `id` = @id ", { 
		['id']     = wagonIndex, 
		['wheels'] = json.encode( Wagons[wagonIndex].wheels ),
		['stow']   = json.encode( Wagons[wagonIndex].stow ),
	})

end)


RegisterServerEvent('tpz_stables:server:buyWagon')
AddEventHandler('tpz_stables:server:buyWagon', function(locationIndex, categoryIndex, modelIndex, account)
	local _source = source
	local xPlayer = TPZ.GetPlayer(_source)
	
    if xPlayer.hasLostConnection() then 
        print(string.format('A player with the steam name as: %s and online id: %s, attempted to buy a wagon while his connection is lost.', GetPlayerName(_source), _source))
        return 
    end

	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local group          = xPlayer.getGroup()
	local job            = xPlayer.getJob()

	local StableData     = Config.Locations[locationIndex]
	local WagonData      = Config.Wagons[categoryIndex].Wagons[modelIndex]

	local money          = xPlayer.getAccount(0)
	local cost           = WagonData[3]
	local isGold         = false
	local notEnoughDisplay = Locales['NOT_ENOUGH_TO_BUY_WAGON']

	-- If the selected account is gold, we check for gold.
	if account and Locales['INPUT_BUY_CURRENCIES'][2] == account then
		isGold = true

		money = xPlayer.getAccount(1)
		cost  = WagonData[4]
		notEnoughDisplay  = Locales['NOT_ENOUGH_TO_BUY_WAGON_GOLD']
	end

	if money < cost then
        TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, notEnoughDisplay)
		return
	end

	if not isGold then
		xPlayer.removeAccount(0, cost)
	else
		xPlayer.removeAccount(1, cost)
	end

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
	
	local date = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
	local category = GetWagonModelCategory(WagonData[1])
	local boughtAccount = isGold and 1 or 0

	local Parameters = { 
		['identifier']     = identifier,
		['charidentifier'] = charIdentifier,
		['model']          = WagonData[1],
		['name']           = 'N/A',
		['wheels']         = json.encode( { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 } ),
		['components']     = json.encode( { colors = 0, livery = 0, props = 0, lights = 0 } ),
		['type']           = category,
		['bought_account'] = boughtAccount,
		['date']           = date,
	}

	exports.ghmattimysql:execute("INSERT INTO `wagons` ( `identifier`, `charidentifier`, `model`, `name`, `wheels`, `components`, `type`, `bought_account`, `date` ) VALUES ( @identifier, @charidentifier, @model, @name, @wheels, @components, @type, @bought_account, @date )", Parameters)

	Wait(1500)

	exports["ghmattimysql"]:execute("SELECT `id` FROM `wagons` WHERE `date` = @date", { ["@date"] = date }, function(result)

		if result and result[1] then

			local wagon_data = {
				identifier     = identifier,
				charidentifier = charIdentifier,
				model          = WagonData[1],
				name           = 'N/A',
				wheels         = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 },
	           	components     = { colors = 0, livery = 0, props = 0, lights = 0 },
				type           = category,
				bought_account = boughtAccount,
				date           = date,
			}

			local Wagons = GetWagons()

			Wagons[result[1].id]    = {}
			Wagons[result[1].id]    = wagon_data
			Wagons[result[1].id].id = result[1].id

            Wagons[result[1].id].entity = 0
            Wagons[result[1].id].source = _source

			local WagonModelData = GetWagonModelData(WagonData[1])

            SendNotification(_source, Locales['WAGON_NOTIFY_TITLE'], Locales["SUCCESSFULLY_BOUGHT_A_WAGON"], "success", 5, "wagon", "left")

			if WagonModelData[5] > 0 then -- IF WAGON STORAGE CAPACITY IS > 0 WE REGISTER A NEW CONTAINER STORAGE.
				TriggerEvent("tpz_inventory:registerContainerInventory", "wagon_" .. result[1].id, WagonModelData[5], true)

				Wait(2500) -- mandatory wait.
				local containerId = exports.tpz_inventory:getInventoryAPI().getContainerIdByName("wagon_" .. result[1].id)
				Wagons[result[1].id].container = containerId
	
				exports.ghmattimysql:execute("UPDATE `wagons` SET `container` = @container WHERE `id` = @id ", { ['id'] = result[1].id, ['container'] = containerId })
			end

			local ped = GetPlayerPed(_source)
            local playerCoords = GetEntityCoords(ped)

            local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { 
				wagonIndex = result[1].id, 
				action = 'REGISTER', 
				data = { identifier, charIdentifier, WagonData[1], category, boughtAccount, Wagons[result[1].id].container, date} 
			}, coords, 350.0, 1000, true, 40)

		end

	end)
	
end)

RegisterServerEvent('tpz_stables:server:updateWagon')
AddEventHandler('tpz_stables:server:updateWagon', function(wagonIndex, action, data)
	local _source = source
	local Wagons  = GetWagons()

	if Wagons[wagonIndex] == nil then
		return
	end

	local updateActionOnClient = false

	if action == 'NETWORK_ID' then
        Wagons[wagonIndex].entity = data[1]

		updateActionOnClient = true

	elseif action == 'RENAME' then
		Wagons[wagonIndex].name = data[1]

        updateActionOnClient = true

	elseif action == 'SET_DEFAULT' then

		local Parameters = { 
			["charidentifier"]       = Wagons[wagonIndex].charidentifier,
			['selected_wagon_index'] = wagonIndex,
		}

		exports.ghmattimysql:execute("UPDATE `characters` SET `selected_wagon_index` = @selected_wagon_index WHERE `charidentifier` = @charidentifier", Parameters)

        updateActionOnClient = false
		
	elseif action == 'UPDATE_COMPONENTS' then

		Wagons[wagonIndex].components = data[1]

		local Parameters = { 
			["id"]         = wagonIndex,
			['components'] = json.encode(Wagons[wagonIndex].components),
		}

		exports.ghmattimysql:execute("UPDATE `wagons` SET `components` = @components WHERE `id` = @id", Parameters)

		updateActionOnClient = true

	elseif action == 'REPAIRED' then 

		Wagons[wagonIndex].wheels = { ['0'] = 0, ['1'] = 0, ['2'] = 0, ['3'] = 0 }

		exports.ghmattimysql:execute("UPDATE `wagons` SET `wheels` = @wheels WHERE `id` = @id ", { 
			['id']     = wagonIndex, 
			['wheels'] = json.encode( Wagons[wagonIndex].wheels ),
		})
		
		updateActionOnClient = true

	end

	-- We update the modified data on client for all players through async. 
    if updateActionOnClient then

        local coords

        local updated = false

        if Wagons[wagonIndex].entity ~= 0 then
            local entity = NetworkGetEntityFromNetworkId(Wagons[wagonIndex].entity)

            if DoesEntityExist(entity) then

                local tableCoords = GetEntityCoords(entity)
                coords = vector3(tableCoords.x, tableCoords.y, tableCoords.z)
                TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { wagonIndex = wagonIndex, action = action, data = data }, coords, 500.0, 500, true, 40)
                updated = true
            end

        elseif Wagons[wagonIndex].entity == 0 and action == 'NETWORK_ID' then
            TriggerClientEvent("tpz_stables:client:updateWagon", -1, { wagonIndex = wagonIndex, action = 'NETWORK_ID', data = data })
        end

        if not updated then
            local ped = GetPlayerPed(_source)
            local playerCoords = GetEntityCoords(ped)

            coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
            TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { wagonIndex = wagonIndex, action = action, data = data }, coords, 150.0, 1000, true, 40)
            updated = true
        end

    end

end)

RegisterServerEvent('tpz_stables:server:transferWagon')
AddEventHandler('tpz_stables:server:transferWagon', function(wagonIndex, target)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)

	local Wagons         = GetWagons()

	if Wagons[wagonIndex] == nil then
		return
	end

    target = tonumber(target)

    local targetSteamName = GetPlayerName(target)

	if target == _source then
        TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales["CANNOT_TRANSFER_TO_SELF"])
		return
	end

    if targetSteamName == nil then
        TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales["NOT_ONLINE"])
        return
    end

    local tPlayer = TPZ.GetPlayer(target)

    if not tPlayer.loaded() then
        TriggerClientEvent("tpz_core:sendBottomTipNotification", _source, Locales["PLAYER_IS_ON_SESSION"])
        return
    end

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
    local targetSteamName      = GetPlayerName(target)
    local targetGroup          = tPlayer.getGroup()
    local targetJob            = tPlayer.getJob()

	Wagons[wagonIndex].identifier     = targetIdentifier
	Wagons[wagonIndex].charidentifier = targetCharIdentifier

    SendNotification(_source, Locales['WAGON_NOTIFY_TITLE'], Locales["WAGON_TRANSFERRED"], "success", 5, "wagon", "left")
    SendNotification(target, Locales['WAGON_NOTIFY_TITLE'], Locales["WAGON_TRANSFERRED_TARGET"], "success", 5, "wagon", "left")

	TriggerClientEvent("tpz_stables:client:updateWagon", _source, { wagonIndex = wagonIndex, action = 'TRANSFERRED', data = { targetIdentifier, targetCharIdentifier } } )
	TriggerClientEvent("tpz_stables:client:updateWagon", target, {  wagonIndex = wagonIndex, action = 'TRANSFERRED', data = { targetIdentifier, targetCharIdentifier } } )
	
	if Config.Webhooks['TRANSFERRED'].Enabled then

		local category = GetWagonModelCategory(Wagons[wagonIndex].model)

		local _w, _c      = Config.Webhooks['TRANSFERRED'].Url, Config.Webhooks['TRANSFERRED'].Color
		local title       = "🐎`Player Transferred Wagon`"
		local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has transferred a wagon.\n\n**Wagon Model:** `%s, %s - %s `.\n\n**Target Identifier:** `%s`\n\n**Target Character Identifier:** `%s`.',
		steamName, identifier, charIdentifier, Wagons[wagonIndex].model, category, ModelData[2], targetIdentifier, targetCharIdentifier)

		TPZ.SendToDiscord(_w, title, description, _c)
	end

end)


RegisterServerEvent('tpz_stables:server:sellWagon')
AddEventHandler('tpz_stables:server:sellWagon', function(wagonIndex)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
	local steamName      = GetPlayerName(_source)

	local Wagons         = GetWagons()

	if Wagons[wagonIndex] == nil then
		return
	end

	exports["ghmattimysql"]:execute("SELECT `selected_wagon_index` FROM `characters` WHERE `charidentifier` = @charidentifier", { ["@charidentifier"] = charIdentifier }, function(result)

		local WagonData = Wagons[wagonIndex]
		local ModelData = GetWagonModelData(WagonData.model)
		
		local receiveMoney, receiveGold = ModelData[7], ModelData[8]
		
		local sellDescription, receivedDescription
		
		if WagonData.bought_account == 0 then
			sellDescription = string.format(Locales['WAGON_SOLD_CASH'], receiveMoney)
	
			xPlayer.addAccount(0, receiveMoney)
	
			receivedDescription = receiveMoney .. " dollars."
		
		elseif WagonData.bought_account == 1 then
			sellDescription = string.format(Locales['WAGON_SOLD_GOLD'], receiveGold)
	
			xPlayer.addAccount(1, receiveGold)
	
			receivedDescription = receiveGold .. " gold."
	
		elseif WagonData.bought_account == -1 then
			sellDescription = Locales['WAGON_SOLD_NO_EARNINGS']
	
			receivedDescription = "nothing"
		end
	
        SendNotification(_source, Locales['WAGON_NOTIFY_TITLE'], sellDescription, "success", 5, "wagon", "left")
		
		-- We reset the selected wagon index.
		if result and result[1] then

			if tonumber(result[1].selected_wagon_index) == wagonIndex then

				local Parameters = { 
					["charidentifier"]       = charIdentifier,
					['selected_wagon_index'] = 0,
				}
		
				exports.ghmattimysql:execute("UPDATE `characters` SET `selected_wagon_index` = @selected_wagon_index WHERE `charidentifier` = @charidentifier", Parameters)
			
				TriggerClientEvent("tpz_stables:client:resetSelectedWagonIndex", _source, wagonIndex, true)
			end

		end

		if tonumber(WagonData.container) ~= 0 then
			TriggerEvent("tpz_inventory:unregisterCustomContainer", WagonData.container) -- unregister container of the wagon.
		end
	
		exports.ghmattimysql:execute("DELETE FROM `wagons` WHERE `id` = @id", {["@id"] = wagonIndex}) 
		Wagons[wagonIndex] = nil
	
		local ped = GetPlayerPed(_source)
		local playerCoords = GetEntityCoords(ped)
	
		local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
		TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { 
			wagonIndex = wagonIndex, 
			action = 'DELETE', 
			data = {} 
		}, coords, 350.0, 1000, true, 40)
	
		if Config.Webhooks['SOLD'].Enabled then
	
			local category = GetWagonModelCategory(WagonData.model)
	
			local _w, _c      = Config.Webhooks['SOLD'].Url, Config.Webhooks['SOLD'].Color
			local title       = "🐎`Player Sold Wagon`"
			local description = string.format('A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`) has sold a wagon.\n\n**Wagon Model:** `%s, %s - %s `.\n\n **Received:** `%s`.',
			steamName, identifier, charIdentifier, WagonData.model, category, ModelData[2], receivedDescription)
	
			TPZ.SendToDiscord(_w, title, description, _c)
		end

	end)


end)


RegisterServerEvent('tpz_stables:server:addWagonStowItem')
AddEventHandler('tpz_stables:server:addWagonStowItem', function(wagonIndex, data)
	local _source = source
	local Wagons  = GetWagons()
	if Wagons[wagonIndex] == nil then
		return
	end

	if Wagons[wagonIndex].stow == nil then 
		Wagons[wagonIndex].stow = {}
	end

	data.date = os.time()
	data.date = tostring(data.date)

	table.insert(Wagons[wagonIndex].stow, data)

	local ped = GetPlayerPed(_source)
	local playerCoords = GetEntityCoords(ped)

	local coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
	TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateWagon", { wagonIndex = tonumber(wagonIndex), action = "INSERT_STOW_ITEM", data = data }, coords, 200.0, 500, true, 40)
end)


RegisterServerEvent('tpz_stables:server:removeWagonStowItem')
AddEventHandler('tpz_stables:server:removeWagonStowItem', function(wagonIndex, date)
	local _source = source
	local Wagons  = GetWagons()

	if Wagons[wagonIndex] == nil then
		return
	end

	local item_data = {}

	for _, item in pairs (Wagons[wagonIndex].stow) do 

		if tostring(item.date) == tostring(date) then 

			if tostring(item.date) == (date) then 

				item_data = item
				table.remove(Wagons[wagonIndex].stow, _)
				break
			end

		end

	end

	TriggerClientEvent('tpz_stables:client:updateWagon', _source, { wagonIndex = wagonIndex, action = 'DELETE_STOW_ITEM', data = { date = date } })


end)
