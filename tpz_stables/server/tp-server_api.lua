
exports('getAPI', function()
    local self = {}

    -- @function returns table form.
    self.GetHorsesList = function()
        return GetHorses()
    end

    -- @function returns table form (.count, .horsesIndex)
    -- @param count : returns an INT with the count of the total owned horses.
    -- @param horsesIndex : returns a TABLE form with all of the owned horse ids (an id is used on GetHorsesList[id] )
    -- [example]: 
    -- local Horses = GetHorsesList()
    -- local HorseData = Horses[id] -- <- the horse id taken from the horsesIndex table.
    self.GetOwnedPlayerHorses = function(charIdentifier)
        return GetPlayerHorses(charIdentifier)
    end

    return self
end)