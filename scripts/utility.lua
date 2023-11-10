function help(playerid, params)
    for funcname, funcvalues in pairs(COMMANDS) do
        sendINFOMessage(playerid, funcname..": "..funcvalues.help);
    end
end

function getLocation(playerid, _params)
    local world = GetPlayerWorld(playerid);
    local x, y, z = GetPlayerPos(playerid);
    sendINFOMessage(playerid, "Du bist in "..world.." bei "..math.ceil(x)..", "..math.ceil(y)..", "..math.ceil(z));
end

function leaveGame(playerid, params)
    ExitGame(playerid);
end