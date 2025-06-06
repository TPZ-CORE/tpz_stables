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
    sex    = tonumber(sex)

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