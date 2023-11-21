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

function goto(playerid, params)
    local result, place = sscanf(params, "s");
    if result ~= 1 then
        sendERRMessage("Du musst einen Ort angeben, zu dem du möchtest.");
        return;
    end
    place = capitalize(place);
    local responses = DB_select("*", "teleports", "name = "..place);
    for _key, response in pairs(responses) do
        if (GetPlayerWorld(playerid) ~= response.world) then
            SetPlayerWorld(playerid, response.world);
        end
        SetPlayerPos(playerid, response.x, response.y, response.z);
        SetPlayerAngle(playerid, response.angle);
        return;
    end
    local places = {};
    responses = DB_select("*", "teleports", "1");
    for _key, response in pairs(responses) do
        table.insert(places, "'"..response.name.."'");
    end
    local placesstring = places.concat(", ");
    sendERRMessage("Ort '"..place.."' nicht gefunden. Versuche einen der folgenden Orte: "..placesstring);
end

function newgoto(playerid, params)
    local result, place = sscanf(params, "s");    
    if result ~= 1 then
        sendERRMessage("Du musst dem Ort einen Namen geben.");
        return;
    end
    place = capitalize(place);
    local responses = DB_select("*", "teleports", "name = "..place);
    for _key, response in pairs(responses) do
        sendERRMessage(playerid, "Der Name '"..place.."' ist bereits vergeben. Versuche etwas anderes");
        return;
    end
    local x, y, z = GetPlayerPos(playerid);
    local angle = GetPlayerAngle(playerid);
    local world = GetPlayerWorld(playerid);
    DB_insert("teleports", {name=place, x=x, y=y, z=z, angle=angle, world=world});
    sendINFOMessage("Ort gespeichert als '"..place.."', benutze /goto um wieder hierher zu kommen.");
end