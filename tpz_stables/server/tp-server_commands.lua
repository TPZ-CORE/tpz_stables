local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Command Registrations ]]--
-----------------------------------------------------------

RegisterCommand(Config.Commands["ADD_HORSE"].Command, function(source, args, rawCommand)
  local _source       = source
	local xPlayer       = TPZ.GetPlayer(source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()

  local hasAcePermissions           = xPlayer.hasPermissionsByAce("tpzcore.stables.addhorse") or xPlayer.hasPermissionsByAce("tpzcore.stables.all")
  local hasAdministratorPermissions = hasAcePermissions

  if not hasAcePermissions then
      hasAdministratorPermissions = xPlayer.hasAdministratorPermissions(Config.Commands["ADD_HORSE"].PermittedGroups, Config.Commands["ADD_HORSE"].PermittedDiscordRoles)
  end

  if hasAcePermissions or hasAdministratorPermissions then
    
    local target, model, sex = args[1], args[2], args[3]

    if target == nil or target == '' or tonumber(target) == nil or model == nil or model == '' or sex == nil or tonumber(sex) = nil then
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

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
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

    local category = GetHorseModelCategory(model)

    local Parameters = { 
      ['identifier']     = targetIdentifier,
      ['charidentifier'] = targetCharIdentifier,
      ['model']          = model,
      ['name']           = 'N/A',
      ['stats']          = json.encode( { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 } ),
      ['components']     = json.encode( { saddle = 0, bags = 0, mask = 0, bed = 0, blank = 0, mane = 0, mus = 0, tail = 0, horn = 0, stir = 0, brid = 0, lantern = 0, holster = 0 }),
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
          identifier     = targetIdentifier,
  				charidentifier = targetCharIdentifier,
  				model          = model,
  				name           = 'N/A',
  				stats          = { health = 200, stamina = 200, shoes_type = 0, shoes_km_left = 0 },
  				components     = { saddle = 0, bags = 0, mask = 0, bed = 0, blank = 0, mane = 0, mus = 0, tail = 0, horn = 0, stir = 0, brid = 0, lantern = 0, holster = 0 },
  				type           = category,
  				age            = randomAge,
  				sex            = sex,
  				date           = date,
        }

        local Horses = GetHorses()

        Horses[result[1].id]    = {}
  			Horses[result[1].id]    = horse_data
  			Horses[result[1].id].id = result[1].id

  			Horses[result[1].id].entity = 0
  			Horses[result[1].id].source = 0

  			SendNotification(_source, Locales['SUCCESSFULLY_GAVE_TARGET_A_HORSE'], "success", 3000 )
        SendNotification(target, Locales["TARGET_RECEIVED_HORSE"], "success", 5000)
		end

	end)

  else
    SendNotification(_source, Locales['NOT_PERMITTED'], "error")
  end

end, false)

RegisterCommand(Config.Commands["ADD_WAGON"].Command, function(source, args, rawCommand)
  local _source       = source
	local xPlayer       = TPZ.GetPlayer(source)
	local identifier     = xPlayer.getIdentifier()
	local charIdentifier = xPlayer.getCharacterIdentifier()

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

    local targetIdentifier     = tPlayer.getIdentifier() 
    local targetCharIdentifier = tPlayer.getCharacterIdentifier()
    local targetGroup          = tPlayer.getGroup()
    local targetJob            = tPlayer.getJob()


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