CHATDISTANCES = {
    whisper = 250,
    close = 750,
    normal = 1500,
    far = 4000
}

function chatw(playerid, text)
    sendChatToArea(playerid, "/w", CHATDISTANCES.whisper, GetPlayerName(playerid).." flüstert: "..text, {r=255, g=255, b=255});
end

function chatwme(playerid, text)
    sendChatToArea(playerid, "/wme", CHATDISTANCES.whisper, GetPlayerName(playerid).." "..text, {r=255, g=255, b=255});
end

function chatwms(playerid, text)
    sendChatToArea(playerid, "/wms", CHATDISTANCES.whisper, GetPlayerName(playerid).."s "..text, {r=255, g=255, b=255});
end

function chatwooc(playerid, text)
    sendChatToArea(playerid, "/w/", CHATDISTANCES.whisper, "OOC - "..GetPlayerName(playerid)..": "..text, {r=0, g=255, b=152});
end


function chatu(playerid, text)
    sendChatToArea(playerid, "/u", CHATDISTANCES.close, GetPlayerName(playerid).." sagt: "..text, {r=255, g=255, b=255});
end

function chatume(playerid, text)
    sendChatToArea(playerid, "/ume", CHATDISTANCES.close, GetPlayerName(playerid).." "..text, {r=255, g=255, b=255});
end

function chatums(playerid, text)
    sendChatToArea(playerid, "/ums", CHATDISTANCES.close, GetPlayerName(playerid).."s "..text, {r=255, g=255, b=255});
end

function chatuooc(playerid, text)
    sendChatToArea(playerid, "/u/", CHATDISTANCES.close, "OOC - "..GetPlayerName(playerid)..": "..text, {r=0, g=255, b=152});
end



function chat(playerid, text)
    sendChatToArea(playerid, "", CHATDISTANCES.normal, GetPlayerName(playerid)..": "..text, {r=255, g=255, b=255});
end

function chatme(playerid, text)
    sendChatToArea(playerid, "/me", CHATDISTANCES.normal, GetPlayerName(playerid).." "..text, {r=255, g=255, b=255});
end

function chatms(playerid, text)
    sendChatToArea(playerid, "/ms", CHATDISTANCES.normal, GetPlayerName(playerid).."s "..text, {r=255, g=255, b=255});
end

function chatooc(playerid, text)
    sendChatToArea(playerid, "//", CHATDISTANCES.normal, "OOC - "..GetPlayerName(playerid)..": "..text, {r=0, g=255, b=152});
end


function chatshout(playerid, text)
    sendChatToArea(playerid, "/shout", CHATDISTANCES.far, GetPlayerName(playerid).." ruft: "..text, {r=255, g=255, b=255});
end

function chatshoutme(playerid, text)
    sendChatToArea(playerid, "/shoutme", CHATDISTANCES.far, GetPlayerName(playerid).." "..text, {r=255, g=255, b=255});
end

function chatshoutms(playerid, text)
    sendChatToArea(playerid, "/shoutms", CHATDISTANCES.far, GetPlayerName(playerid).."s "..text, {r=255, g=255, b=255});
end

function chatshoutooc(playerid, text)
    sendChatToArea(playerid, "/shout/", CHATDISTANCES.far, "OOC - "..GetPlayerName(playerid)..": "..text, {r=0, g=255, b=152});
end

function pm(playerid, params)
    local targetid = -1;
    local sender = GetPlayerName(playerid);
    local targetname = "?";
    local msg;
    local result, name, text = sscanf(params, "ss");
    if (result == 1) then
        targetname = capitalize(name);
        msg = text;
        targetid = getPlayerIdByName(playerid, targetname);
    end
    local result, id, text = sscanf(params, "ds");
    if (result == 1) then
        targetid = id;
        msg = text;
        targetname = GetPlayerName(id);
    end
    if PLAYERS[targetid] == nil then
        sendERRMessage(playerid, "Spieler "..targetname.." ("..targetid..") ist nicht online");
        return;
    end
    SendPlayerMessage(playerid, 255, 244, 104, ">> "..targetname.." ("..targetid.."): "..msg);
    SendPlayerMessage(targetid, 255, 244, 104, sender.." ("..playerid.."): "..msg);
end

function report(playerid, text)
    local supportersOnline = {};
    for audienceid, _playerdata in pairs(PLAYERS) do
        if PLAYERS[audienceid] ~= nil and PLAYERS[audienceid].adminlevel >= ADMINRANKS.Support then
            table.insert(supportersOnline, GetPlayerName(audienceid).."("..PLAYERS[audienceid].character..")");
            SendPlayerMessage(audienceid, 135, 136,238, GetPlayerName(playerid).."("..playerid..") meldet: "..text);
        end
    end
    local supporters = table.concat(supportersOnline, ", ");
    local logtext = GetPlayerName(playerid).."("..PLAYERS[playerid].character..") > ("..supporters.."): "..text;
    log("report", logtext);
end


function sendChatToArea(playerid, command, range, text, colors);
    if PLAYERS[playerid].character == nil then
        return;
    end
    local hearrange = {};
    local distance;
    colors.rfar = math.floor(colors.r/2);
    colors.gfar = math.floor(colors.g/2);
    colors.bfar = math.floor(colors.b/2);
    for audienceid, _playerdata in pairs(PLAYERS) do
        if PLAYERS[audienceid] ~= nil and PLAYERS[audienceid].character ~= nil and GetPlayerWorld(playerid) == GetPlayerWorld(audienceid) then
            distance = GetDistancePlayers(playerid, audienceid);
            if (distance < range) then
                table.insert(hearrange, GetPlayerName(audienceid).."("..PLAYERS[audienceid].character..")");
                if (distance < range/2) then
                    SendPlayerMessage(audienceid, colors.r, colors.g, colors.b, text);
                else
                    SendPlayerMessage(audienceid, colors.rfar, colors.gfar, colors.bfar, text);
                end
            end 
        end
    end
    local listeners = table.concat(hearrange, ", ");
    local logtext = GetPlayerName(playerid).."("..PLAYERS[playerid].character..") "..command.." > ("..listeners..") "..text;
    log("chat", logtext);
end

function roll(playerid, params)
    local result, rollamount = sscanf(params, "d");
    if (result ~= 1) then
        rollamount = 20;
    end
    rollamount = math.max(1, rollamount);
    local result = math.random(rollamount);
    sendChatToArea(playerid, "wurf", CHATDISTANCES.far, GetPlayerName(playerid).." würfelt eine "..result.." (W"..rollamount..")", {r=135, g=136, b=238});
end