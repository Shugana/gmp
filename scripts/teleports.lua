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

    if (PLAYERS[sourceid] == nil and NPCS[sourceid == nil]) or (PLAYERS[targetid] == nil and NPCS[targetid] == nil) then
        sendERRMessage(playerid, "Teleportierender Spieler oder Ziel nicht online oder kein NPC");
        return;
    end
    local x,y,z = GetPlayerPos(targetid);
    local angle = GetPlayerAngle(targetid);
    local x_add, z_add = coords_forward(angle);

    local newx = x + x_add*250;
    local newy = y + 50;
    local newz = z + z_add*250;
    if not(GetPlayerWorld(sourceid) == GetPlayerWorld(targetid)) then
        SetPlayerWorld(sourceid, GetPlayerWorld(targetid));
    end
    SetPlayerPos(sourceid, newx, newy, newz);
    sendINFOMessage(sourceid, sourcename.." ("..sourceid..") teleportiert zu "..targetname.." ("..targetid..")");
    if (playerid ~= sourceid) then
        sendINFOMessage(playerid, sourcename.." ("..sourceid..") teleportiert zu "..targetname.." ("..targetid..")");
    end
    log("tp", sourcename.." ("..PLAYERS[sourceid].character or "NPC"..") teleportiert zu "
        ..targetname.." ("..PLAYERS[targetid].character or "NPC".."). Auslöser: "..GetPlayerName(playerid).." ("..PLAYERS[playerid].character or "NPC"..")");
end

function useGoto(playerid, params)
    local result, place = sscanf(params, "s");
    if result ~= 1 then
        sendERRMessage(playerid, "Du musst einen Ort angeben, zu dem du möchtest.");
        return;
    end
    place = capitalize(place);
    local responses = DB_select("*", "teleports", "name = '"..place.."'");
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
    local placesstring = table.concat(places, ", ");
    sendERRMessage(playerid, "Ort '"..place.."' nicht gefunden. Versuche einen der folgenden Orte: "..placesstring);
end

function createGoto(playerid, params)
    local result, place = sscanf(params, "s");    
    if result ~= 1 then
        sendERRMessage(playerid, "Du musst dem Ort einen Namen geben.");
        return;
    end
    place = capitalize(place);
    local responses = DB_select("*", "teleports", "name = '"..place.."'");
    for _key, response in pairs(responses) do
        sendERRMessage(playerid, "Der Name '"..place.."' ist bereits vergeben. Versuche etwas anderes");
        return;
    end
    local x, y, z = GetPlayerPos(playerid);
    local angle = GetPlayerAngle(playerid);
    local world = GetPlayerWorld(playerid);
    DB_insert("teleports", {name=place, x=x, y=y, z=z, angle=angle, world=world});
    sendINFOMessage(playerid, "Ort gespeichert als '"..place.."', benutze /goto um wieder hierher zu kommen.");
end