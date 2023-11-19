function tp(playerid, params)
    local sourceid, targetid, sourcename, targetname;

    local resultDD, sourceDD, targetDD = sscanf(params, "dd");
    local resultD, targetD = sscanf(params, "d");
    local resultSS, sourceSS, targetSS = sscanf(params, "ss");
    local resultS, targetS = sscanf(params, "s");

    if (resultDD ~= 1 and resultD ~= 1 and resultSS ~= 1 and resultS ~= 1) then
        sendERRMessage(playerid, "Benutze: /tp [<Quell-ID>] <Ziel-ID>");
        return;
    end

    if (resultDD == 1) then
        sourceid = sourceDD;
        targetid = targetDD;
        sourcename = GetPlayerName(sourceid);
        targetname = GetPlayerName(targetid);
    elseif (resultD == 1) then
        sourceid = playerid;
        targetid = targetD;
        sourcename = GetPlayerName(sourceid);
        targetname = GetPlayerName(targetid);
    elseif (resultSS == 1) then
        sourceSS = capitalize(sourceSS);
        targetSS = capitalize(targetSS);
        sourceid = getPlayerIdByName(playerid, sourceSS);
        targetid = getPlayerIdByName(playerid, targetSS);
        sourcename = sourceSS;
        targetname = targetSS;
    elseif (resultS == 1) then
        sourceid = playerid;
        targetS = capitalize(targetS);
        targetid = getPlayerIdByName(playerid, targetS);
        sourcename = GetPlayerName(sourceid);
        targetname = targetS;
    end

    if PLAYERS[sourceid] == nil or PLAYERS[targetid] == nil then
        sendERRMessage(playerid, "Teleportierender Spieler oder Ziel nicht online");
        return;
    end
    local x,y,z = GetPlayerPos(targetid);
    if not(GetPlayerWorld(sourceid) == GetPlayerWorld(targetid)) then
        SetPlayerWorld(sourceid, GetPlayerWorld(targetid));
    end
    SetPlayerPos(sourceid, x, y, z);
    sendINFOMessage(sourceid, sourcename.." ("..sourceid..") teleportiert zu "..targetname.." ("..targetid..")");
    sendINFOMessage(playerid, sourcename.." ("..sourceid..") teleportiert zu "..targetname.." ("..targetid..")");
    log("tp", sourcename.." ("..PLAYERS[sourceid].character..") teleportiert zu "
        ..targetname.." ("..PLAYERS[targetid].character.."). Auslöser: "..GetPlayerName(playerid).." ("..PLAYERS[playerid].character..")");
end