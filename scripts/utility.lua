function help(playerid, params)
    for funcname, funcvalues in pairs(COMMANDS) do
        if (PLAYERS[playerid].adminlevel > funcvalues.minadminlevel and (not(funcvalues.adminlevel) or PLAYERS[playerid].adminlevel == funcvalues.adminlevel)) then
            sendINFOMessage(playerid, funcname..": "..funcvalues.help);
        end
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