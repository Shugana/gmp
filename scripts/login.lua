function OnPlayerConnect(playerid)
    SendMessageToAll(255,255,255, playerid.." connected");
    SpawnPlayer(playerid);
    if (playerid > NPC_ID) then
        return;
    end
    
    SetPlayerWorld(playerid, "NEWWORLD\\ABANDONED.ZEN");
    SetPlayerPos(playerid, 1093, -122, 295);

    PLAYERS[playerid] = {
        adminlevel = ADMINRANKS.Ausgelogged
    };
    tryAutologinAccount(playerid);
    ShowDraw(playerid, SERVERDRAWS.time.id);
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