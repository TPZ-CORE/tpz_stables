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
--[[ General Events ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_stables:server:buyWagon')
AddEventHandler('tpz_stables:server:buyWagon', function(locationIndex, categoryIndex, modelIndex, account)
	local _source        = source
	local xPlayer        = TPZ.GetPlayer(_source)
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
		SendNotification(_source, notEnoughDisplay, "error", 3000)
		return
	end

	if not isGold then
		xPlayer.removeAccount(0, cost)
	else
		xPlayer.removeAccount(1, cost)
	end

	TriggerClientEvent("tpz_stables:client:updateAccount", _source, { xPlayer.getAccount(0), xPlayer.getAccount(1) })
	
	local date      = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S")
	local randomAge = math.random(Config.Ageing.StartAdultAge.min, Config.Ageing.StartAdultAge.max)
	local randomSex = math.random(0, 1)

	local Parameters = { 
		['identifier']     = identifier,
		['charidentifier'] = charIdentifier,
		['model']          = WagonData[1],
		['name']           = 'N/A',
		['stats']          = json.encode( { body = 1000, wheels = 0 } ),
		['components']     = json.encode( { colors = 0, livery = 0, props = 0, lights = 0 } ),
		['date']           = date,
	}

	exports.ghmattimysql:execute("INSERT INTO `wagons` ( `identifier`, `charidentifier`, `model`, `name`, `components`, `date` ) VALUES ( @identifier, @charidentifier, @model, @name, @components, @date )", Parameters)

	Wait(1500)

	exports["ghmattimysql"]:execute("SELECT `id` FROM `wagons` WHERE `date` = @date", { ["@date"] = date }, function(result)

		if result and result[1] then

			local wagon_data = {
				identifier     = identifier,
				charidentifier = charIdentifier,
				model          = WagonData[1],
				name           = 'N/A',
				stats          = { body = 1000, wheels = 0 },
	           	components     = { colors = 0, livery = 0, props = 0, lights = 0 },
				date           = date,
			}

			local Wagons = GetWagons()

			Wagons[result[1].id]    = {}
			Wagons[result[1].id]    = wagon_data
			Wagons[result[1].id].id = result[1].id

			local WagonModelData = GetWagonModelData(WagonData[1])

			SendNotification(_source, Locales['SUCCESSFULLY_BOUGHT_A_WAGON'], "success", 5000 )

			if WagonModelData[5] > 0 then -- IF WAGON STORAGE CAPACITY IS > 0 WE REGISTER A NEW CONTAINER STORAGE.
				TriggerEvent("tpz_inventory:registerContainerInventory", "wagon_" .. result[1].id, WagonModelData[5], true)

				Wait(2500) -- mandatory wait.
				local containerId = exports.tpz_inventory:getInventoryAPI().getContainerIdByName("wagon_" .. result[1].id)
				Wagons[result[1].id].container = containerId
	
				exports.ghmattimysql:execute("UPDATE `wagons` SET `container` = @container WHERE `id` = @id ", { ['id'] = result[1].id, ['container'] = containerId })
			end

		end

	end)
	
end)