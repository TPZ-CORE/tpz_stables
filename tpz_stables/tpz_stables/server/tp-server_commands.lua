local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Command Registrations ]]--
-----------------------------------------------------------

RegisterCommand(Config.Commands["ADD_HORSE"].Command, function(source, args, rawCommand)
  local _source        = source
	local xPlayer        = TPZ.GetPlayer(source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
  local steamName      = GetPlayerName(_source)

  local hasAcePermissions           = xPlayer.hasPermissionsByAce("tpzcore.stables.addhorse") or xPlayer.hasPermissionsByAce("tpzcore.stables.all")
  local hasAdministratorPermissions = hasAcePermissions

  if not hasAcePermissions then
      hasAdministratorPermissions = xPlayer.hasAdministratorPermissions(Config.Commands["ADD_HORSE"].PermittedGroups, Config.Commands["ADD_HORSE"].PermittedDiscordRoles)
  end

  if hasAcePermissions or hasAdministratorPermissions then
    
    local target, model, sex = args[1], args[2], args[3]

    if target == nil or target == '' or tonumber(target) == nil or model == nil or model == '' or sex == nil or tonumber(sex) == nil then
      SendNotification(_source,  "~e~ERROR: Use Correct Sintaxis", "error")
      return
    end

    target = tonumber(target)

    local targetSteamName = GetPlayerName(target)

    if targetSteamName == nil then
      SendNotification(_source, Locales['NOT_ONLINE'], "error")
      return
    end

    local tPlayer = TPZ.GetPlayer(target)

    if not tPlayer.loaded() then
      SendNotification(_source, Locales['PLAYER_IS_ON_SESSION'], "error")
      return
    end

    sex = tonumber(sex)

    if sex < 0 or sex > 1 then
      SendNotification(_source, Locales["INVALID_HORSE_SEX_INPUT"], "error")
      return
    end

    local HorseData = GetHorseModelData(string.lower(model))

    if not HorseData then
      SendNotification(_source, Locales["INVALID_HORSE_DOES_NOT_EXIST"], "error")
      return
    end

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
    local targetSteamName      = GetPlayerName(target)
    local targetGroup          = tPlayer.getGroup()
    local targetJob            = tPlayer.getJob()

    local currentHorses       = GetPlayerHorses(targetCharIdentifier)	
    local count               = currentHorses.count
    local maxHorsesLimit      = GetPlayerMaximumHorsesLimit(targetIdentifier, targetGroup, targetJob)

    if count >= maxHorsesLimit then
      SendNotification(_source, Locales['TARGET_REACHED_HORSES_LIMIT'], "error", 3000 )
      return
    end

    local date      = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
    local randomAge = math.random(Config.Ageing.StartAdultAge.min, Config.Ageing.StartAdultAge.max)
    randomAge       = math.floor(randomAge * 1440)
    
    local category = GetHorseModelCategory(model)

    local Parameters = { 
      ['identifier']     = targetIdentifier,
      ['charidentifier'] = targetCharIdentifier,
      ['model']          = model,
      ['name']           = 'N/A',
      ['stats']          = json.encode( { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 } ),
      ['components']     = json.encode( { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 }),
      ['type']           = category,
      ['age']            = randomAge,
      ['sex']            = sex,
      ['date']           = date,
    }

    exports.ghmattimysql:execute("INSERT INTO `horses` ( `identifier`, `charidentifier`, `model`, `name`, `stats`, `components`, `type`, `age`, `sex`, `date` ) VALUES ( @identifier, @charidentifier, @model, @name, @stats, @components, @type, @age, @sex, @date )", Parameters)

    Wait(1500)

    exports["ghmattimysql"]:execute("SELECT `id` FROM `horses` WHERE `date` = @date", { ["@date"] = date }, function(result)

      if result and result[1] then

        local horse_data = {
          identifier          = targetIdentifier,
  				charidentifier      = targetCharIdentifier,
  				model               = model,
  				name                = 'N/A',
  				stats               = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
          components          = { ['SADDLE'] = 0, ['BAG'] = 0, ['MASK'] = 0, ['BEDROLL'] = 0, ['BLANKET'] = 0, ['MANE'] = 0, ['MUSTACHE'] = 0, ['TAIL'] = 0, ['HORN'] = 0, ['STIRRUP'] = 0, ['BRIDLE'] = 0, ['LANTERN'] = 0, ['HOLSTER'] = 0 },
  				type                = category,
  				age                 = randomAge,
  				sex                 = sex,
          training_experience = 0,
          breeding            = 0,
          bought_account      = -1,
          container           = 0,
  				date                = date,
        }

        local Horses = GetHorses()

        Horses[result[1].id]    = {}
  			Horses[result[1].id]    = horse_data
  			Horses[result[1].id].id = result[1].id

  			Horses[result[1].id].entity = 0
  			Horses[result[1].id].source = target

  			SendNotification(_source, Locales['SUCCESSFULLY_GAVE_TARGET_A_HORSE'], "success", 3000 )
        SendNotification(target, Locales["TARGET_RECEIVED_HORSE"], "success", 5000)

        local ped = GetPlayerPed(target)
        local targetPlayerCoords = GetEntityCoords(ped)

        local coords = vector3(targetPlayerCoords.x, targetPlayerCoords.y, targetPlayerCoords.z)

        TPZ.TriggerClientEventAsyncByCoords("tpz_stables:client:updateHorse", { 
          horseIndex = result[1].id, 
          action = 'REGISTER', 
          data = { targetIdentifier, targetCharIdentifier, model, category, randomAge, sex, -1, date} 
        }, coords, 350.0, 1000, true, 40)

        if Config.Webhooks['COMMANDS'].Enabled then

          local _w, _c  = Config.Webhooks['COMMANDS'].Url, Config.Webhooks['COMMANDS'].Color
          local title   = string.format("📋` /%s %s %s %s`", Config.Commands["ADD_HORSE"].Command, target, model, sex)
          local description = string.format("A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`), executed the mentioned command and added (gave) a horse on a players ownership." ..
          "\n\nThe target player steam name (`%s`), identifier (`%s`) and character identifier (`%s`).\n\nThe horse that was given was: `%s - %s`",
          steamName, identifier, charIdentifier, targetSteamName, targetIdentifier, targetCharIdentifier, category, HorseData[2])

          TPZ.SendToDiscord(_w, title, description, _c)
        end

      end

    end)

  else
    SendNotification(_source, Locales['NOT_PERMITTED'], "error")
  end

end, false)

RegisterCommand(Config.Commands["ADD_WAGON"].Command, function(source, args, rawCommand)
  local _source        = source
	local xPlayer        = TPZ.GetPlayer(source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()
  local steamName      = GetPlayerName(_source)

  local hasAcePermissions           = xPlayer.hasPermissionsByAce("tpzcore.stables.addwagon") or xPlayer.hasPermissionsByAce("tpzcore.stables.all")
  local hasAdministratorPermissions = hasAcePermissions

  if not hasAcePermissions then
      hasAdministratorPermissions = xPlayer.hasAdministratorPermissions(Config.Commands["ADD_WAGON"].PermittedGroups, Config.Commands["ADD_WAGON"].PermittedDiscordRoles)
  end

  if hasAcePermissions or hasAdministratorPermissions then
    
    local target, model = args[1], args[2]

    if target == nil or target == '' or tonumber(target) == nil or model == nil or model == '' then
      SendNotification(_source,  "~e~ERROR: Use Correct Sintaxis", "error")
      return
    end

    target = tonumber(target)

    local targetSteamName = GetPlayerName(target)

    if targetSteamName == nil then
      SendNotification(_source, Locales['NOT_ONLINE'], "error")
      return
    end

    local tPlayer = TPZ.GetPlayer(target)

    if not tPlayer.loaded() then
      SendNotification(_source, Locales['PLAYER_IS_ON_SESSION'], "error")
      return
    end

    local WagonData = GetWagonModelData(string.lower(model))

    if not WagonData then
      SendNotification(_source, Locales["INVALID_WAGON_DOES_NOT_EXIST"], "error")
      return
    end

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
    local targetSteamName      = GetPlayerName(target)
    local targetGroup          = tPlayer.getGroup()
    local targetJob            = tPlayer.getJob()

    local date = os.date('%d').. '/' ..os.date('%m').. '/' .. Config.Year .. " " .. os.date('%H') .. ":" .. os.date('%M') .. ":" .. os.date("%S") .. math.random(1,9)
    local category = GetWagonModelCategory(string.lower(model))

    local Parameters = { 
  		['identifier']     = targetIdentifier,
  		['charidentifier'] = targetCharIdentifier,
  		['model']          = model,
  		['name']           = 'N/A',
  		['stats']          = json.encode( { body = 1000, wheels = 0 } ),
  		['components']     = json.encode( { colors = 0, livery = 0, props = 0, lights = 0 } ),
      ['type']           = category,
  		['date']           = date,
    }

    exports.ghmattimysql:execute("INSERT INTO `wagons` ( `identifier`, `charidentifier`, `model`, `name`, `components`, `type`, `date` ) VALUES ( @identifier, @charidentifier, @model, @name, @components, @type, @date )", Parameters)

    Wait(1500)

    exports["ghmattimysql"]:execute("SELECT `id` FROM `wagons` WHERE `date` = @date", { ["@date"] = date }, function(result)

      if result and result[1] then

        local wagon_data = {
  				identifier     = targetIdentifier,
  				charidentifier = targetCharIdentifier,
  				model          = model,
  				name           = 'N/A',
  				stats          = { body = 1000, wheels = 0 },
          components     = { colors = 0, livery = 0, props = 0, lights = 0 },
          type           = category,
          bought_account = -1,
          container      = 0,
          date           = date,
        }

        local Wagons = GetWagons()

        Wagons[result[1].id]    = {}
        Wagons[result[1].id]    = wagon_data
        Wagons[result[1].id].id = result[1].id
        Wagons[result[1].id].source = target
        Wagons[result[1].id].entity = 0
  
        local WagonModelData = GetWagonModelData(model)

        SendNotification(_source, Locales['SUCCESSFULLY_GAVE_TARGET_A_WAGON'], "success", 3000 )
        SendNotification(target, Locales["TARGET_RECEIVED_WAGON"], "success", 5000)
  
        if WagonModelData[5] > 0 then -- IF WAGON STORAGE CAPACITY IS > 0 WE REGISTER A NEW CONTAINER STORAGE.
          TriggerEvent("tpz_inventory:registerContainerInventory", "wagon_" .. result[1].id, WagonModelData[5], true)
  
          Wait(2500) -- mandatory wait.
          local containerId = exports.tpz_inventory:getInventoryAPI().getContainerIdByName("wagon_" .. result[1].id)
          Wagons[result[1].id].container = containerId
    
          exports.ghmattimysql:execute("UPDATE `wagons` SET `container` = @container WHERE `id` = @id ", { ['id'] = result[1].id, ['container'] = containerId })
        end

        if Config.Webhooks['COMMANDS'].Enabled then

          local _w, _c  = Config.Webhooks['COMMANDS'].Url, Config.Webhooks['COMMANDS'].Color
          local title   = string.format("📋` /%s %s %s`", Config.Commands["ADD_WAGON"].Command, target, model)
          local description = string.format("A user with the steam name (`%s`), identifier (`%s`) and character identifier (`%s`), executed the mentioned command and added (gave) a wagon on a players ownership." ..
          "\n\nThe target player steam name (`%s`), identifier (`%s`) and character identifier (`%s`).\n\nThe wagon that was given was: `%s - %s`",
          steamName, identifier, charIdentifier, targetSteamName, targetIdentifier, targetCharIdentifier, category, WagonData[2])

          TPZ.SendToDiscord(_w, title, description, _c)
        end

      end

    end)

  else
    SendNotification(_source, Locales['NOT_PERMITTED'], "error")
  end

end, false)

-----------------------------------------------------------
--[[ Chat Suggestion Registrations ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_stables:server:addChatSuggestions")
AddEventHandler("tpz_stables:server:addChatSuggestions", function()
  local _source = source

  for index, command in pairs (Config.Commands) do

    if command.Command ~= false then 

      local displayTip = command.CommandHelpTips 

      if not displayTip then
        displayTip = {}
      end

      TriggerClientEvent("chat:addSuggestion", _source, "/" .. command.Command, command.Suggestion, command.CommandHelpTips )
    end

  end

end)