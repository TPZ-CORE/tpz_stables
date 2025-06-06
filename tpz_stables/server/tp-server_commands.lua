local TPZ = exports.tpz_core:getCoreAPI()

-----------------------------------------------------------
--[[ Command Registrations ]]--
-----------------------------------------------------------

RegisterCommand(Config.Commands["ADD_HORSE"].Command, function(source, args, rawCommand)
  local _source = source
	local xPlayer = TPZ.GetPlayer(source)

  local hasAcePermissions           = xPlayer.hasPermissionsByAce("tpzcore.stables.addhorse") or xPlayer.hasPermissionsByAce("tpzcore.stables.all")
  local hasAdministratorPermissions = hasAcePermissions

  if not hasAcePermissions then
      hasAdministratorPermissions = xPlayer.hasAdministratorPermissions(Config.Commands["ADD_HORSE"].PermittedGroups, Config.Commands["ADD_HORSE"].PermittedDiscordRoles)
  end

  if hasAcePermissions or hasAdministratorPermissions then
    

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