function chat(playerid, text)
    sendChatToArea(playerid, 2000, getPlayerName(playerid)..": "..text, {r=255, g=255, b=255});
end

function sendChatToArea(playerid, range, text, colors);
    if PLAYERS[playerid].character == nil then
        return;
    end
    local hearrange = {};
    local distance;
    colors.rfar = math.floor(colors.r/2);
    colors.gfar = math.floor(colors.g/2);
    colors.bfar = math.floor(colors.b/2);
    for audienceid, _playerdata in pairs PLAYERS do
        if PLAYERS[audienceid] == nil or PLAYERS[audienceid].character == nil or GetPlayerWorld(playerid) ~= GetPlayerWorld(audienceid) then
            break;
        end
        distance = GetDistancePlayers(playerid, audienceid);
        if (distance < range) then
            table.insert(hearrange, getPlayerName(audienceid).."("..PLAYERS[audienceid].character..")");
            if (distance < range/2) then
                SendPlayerMessage(audienceid, colors.r, colors.g, colors.b, text);
            else
                SendPlayerMessage(audienceid, colors.rfar, colors.gfar, colors.bfar, text);
            end
        end
    end
    local listeners = table.concat(hearrange, ", ");
    log("chat", PLAYERS[playerid].character.." ("..listeners..") "..text);
end