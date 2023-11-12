function OnPlayerConnect(playerid)
    SetPlayerWorld(playerid, "NEWWORLD\\KHORINIS.ZEN");
    SetPlayerPos(playerid, 0, 0, 0);
    SpawnPlayer(playerid);

    PLAYERS[playerid] = {
        adminlevel = ADMINRANKS.Ausgelogged
    };
    tryAutologinAccount(playerid);
end

function OnPlayerDisconnect(playerid, reason)
    PLAYERS[playerid] = nil;
    if reason == 0 then     --disconnect
        SendMessageToAll(255, 0, 0, "Player disconnected from server.")
    elseif reason == 1 then --lost, crash
        SendMessageToAll(255, 0, 0, "Player disconnected from server because he had crash or lost.")
    elseif reason == 2 then --kick
        SendMessageToAll(255, 0, 0, "Player was kicked from server.")
    elseif reason == 3 then --ban
        SendMessageToAll(255, 0, 0, "Player was banned from server.")
    end
end

function tryAutologinAccount(playerid)
    local mac = GetMacAddress(playerid);
    local responses = DB_select("*", "account_autologins", "mac = "..mac);
    for _key, response in pairs(responses) do
        loginAccountById(playerid, response.accountid);
        return;
    end
end