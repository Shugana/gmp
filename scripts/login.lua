function OnPlayerConnect(playerid)
    SpawnPlayer(playerid);
    if (playerid > NPC_ID) then
        return;
    end

    SetPlayerEnable_OnPlayerKey(playerid, 1);
    
    SetPlayerWorld(playerid, "NEWWORLD\\ABANDONED.ZEN");
    SetPlayerPos(playerid, 1093, -122, 295);

    PLAYERS[playerid] = {
        adminlevel = ADMINRANKS.Ausgelogged
    };
    tryAutologinAccount(playerid);
    ShowDraw(playerid, SERVERDRAWS.time.id);
    ShowDraw(playerid, SERVERDRAWS.weather.id);
end

function OnPlayerDisconnect(playerid, reason)
    if PLAYERS[playerid] == nil then
        return;
    end
    PLAYERS[playerid] = nil;
    if reason == 0 then     --disconnect
        SendMessageToAll(255, 0, 0, "Player "..GetPlayerName(playerid).." ("..playerid..") disconnected from server.");
    elseif reason == 1 then --lost, crash
        SendMessageToAll(255, 0, 0, "Player "..GetPlayerName(playerid).." ("..playerid..") disconnected from server (gamecrash)");
    elseif reason == 2 then --kick
        SendMessageToAll(255, 0, 0, "Player "..GetPlayerName(playerid).." ("..playerid..") was kicked from server.");
    elseif reason == 3 then --ban
        SendMessageToAll(255, 0, 0, "Player "..GetPlayerName(playerid).." ("..playerid..") was banned from server.");
    end
end