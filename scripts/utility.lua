function help(playerid, params)
    for funcname, funcvalues in pairs(COMMANDS) do
        if (PLAYERS[playerid].adminlevel >= funcvalues.minadminlevel and (not(funcvalues.adminlevel) or PLAYERS[playerid].adminlevel == funcvalues.adminlevel)) then
            sendINFOMessage(playerid, "/"..funcname..": "..funcvalues.help);
        end
    end
end

function getLocation(playerid, _params)
    local world = GetPlayerWorld(playerid);
    local x, y, z = GetPlayerPos(playerid);
    sendINFOMessage(playerid, "Du bist in "..world.." bei "..math.ceil(x)..", "..math.ceil(y)..", "..math.ceil(z));
end

function leaveGame(playerid, params)
    saveStats(playerid);
    savePosition(playerid);
    ExitGame(playerid);
end

function capitalize(text)
    return text:sub(1,1):upper()..text:sub(2):lower();
end

function indexOf(tabledata, query)
    for key, value in pairs(tabledata) do
        if (value == query) then
            return key;
        end
    end
    return nil;
end

function math.between(min, value, max)
    return math.max(min, math.min(max, value));
end

function moduloTable(tablename, value)
    if value > #tablename then
        return moduloTable(tablename, value%#tablename)
    end
    if value < 1 then
        return moduloTable(tablename, value+#tablename)
    end
    return value;
end

function sendERRMessage(playerid, text)
    SendPlayerMessage(playerid, 255, 0, 0, text);
end

function sendINFOMessage(playerid, text)
    SendPlayerMessage(playerid, 207, 175, 55, text);
end

function setTime(playerid, params)
    local result, hour, minute = sscanf(params, "dd");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /settime <Stunden> <Minuten>");
        return;
    end
    SetTime (hour, minute);
end

function debug(text)
    SendMessageToAll(255, 0, 0, "Debug - "..text);
end

function showAni(playerid, params)
    if (PLAYERS[playerid].anitoggle ~= nil) then
        PLAYERS[playerid].anitoggle = nil;
    else
        PLAYERS[playerid].anitoggle = true;
        PLAYERS[playerid].lastani = "NULL";
        PLAYERS[playerid].lastanitick = GetTickCount();

    end
end

function AniWatcher()
    for playerid, _value in pairs(PLAYERS) do
        if (PLAYERS[playerid].anitoggle ~= nil) then
            local ani = GetPlayerAnimationName(playerid);
            local tick = GetTickCount();
            if PLAYERS[playerid].lastani ~= ani then
                local duration = 0;
                if (PLAYERS[playerid].lastanitick ~= nil) then
                    duration = tick - PLAYERS[playerid].lastanitick;
                end
                debug("player "..playerid.." switched from ani "..PLAYERS[playerid].lastani.." to "..ani..", previous ani lasted "..duration.."ms");
                if (PLAYERS[playerid].lastani == "T_FALLDN_2_FALL" or PLAYERS[playerid].lastani == "T_FALLDN_2_FALLB") then
                    debug(playerid.." has fallen for "..duration.."ms");
                end
                PLAYERS[playerid].lastanitick = tick;
                PLAYERS[playerid].lastani = ani;
            end
        end
    end
end

function getPlayerIdByName(name)
    for targetid, _data in pairs(PLAYERS) do
        if (GetPlayerName(targetid) == name) then 
            return targetid;
        end
    end
    return -1
end

function freeze(playerid, reason)
    if PLAYERS[playerid].freezes == nil then
        PLAYERS[playerid].freezes = {};
    end
    PLAYERS[playerid].freezes[reason] = true;
    FreezePlayer(playerid, 1);
end

function unfreeze(playerid, reason)
    if PLAYERS[playerid].freezes == nil then
        FreezePlayer(playerid, 0);
        return;
    end
    PLAYERS[playerid].freezes[reason] = nil;
    for key, value in pairs(PLAYERS[playerid].freezes) do
        return;
    end
    FreezePlayer(playerid, 0);
end

function coords_forward(angle)
    local angle_rad = math.rad(angle);
    local x = math.sin(angle_rad);
    local z = math.cos(angle_rad);
    return x, z;
end

function showroom(playerid, params)
    local npcid;
    local range = 150;
    local count = 1;
    local x, y, z = GetPlayerPos(playerid);
    local world = GetPlayerWorld(playerid);
    local angle = GetPlayerAngle(playerid);
    local npcangle = (angle + 90)%360;
    local x_add, z_add = coords_forward(GetPlayerAngle(playerid));
    local items = DB_select("*", "items", "1 ORDER BY instance ASC");
    for _key, item in pairs(items) do
        local prefix = string.sub(item.instance, 1, 4);
        local suffix = string.sub(item.instance, -2);
        if (prefix == "ITAR") then
            npcid = spawnMonster("Puppe", world, x+(x_add*range*count), y+50, z+(z_add*range*count));
            SetPlayerAngle(npcid, npcangle);
            if (suffix == "_F") then
                SetPlayerAdditionalVisual(
                    npcid,
                    "HUM_BODY_BABE0",
                    48,
                    "HUM_HEAD_BABE12",
                    343
                );
            else                
                SetPlayerAdditionalVisual(
                    npcid,
                    "HUM_BODY_NAKED0",
                    78,
                    "HUM_HEAD_FATBALD",
                    370
                );
            end
            GiveItem(npcid, item.instance, 1);
            EquipArmor(npcid, item.instance);
            count = count + 1;
        end
    end
end


function OnPlayerDeath(victimid, unused, killerid, unused2, health)
    victimid = victimid or "NULL";
    unused = unused or "NULL";
    killerid = killerid or "NULL";
    unused2 = unused2 or "NULL";
    health = health or "NULL";

    debug("onplayerdeath, victimid="..victimid..", unused="..unused..", killerid="..killerid..", unused2="..unused2..", health="..health);
end

function cuneiform(playerid, params)
    if PLAYERS[playerid].cuneiform ~= nil then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].cuneiform)
    end
    local startx, starty = convertToPixel(200, 400);
    PLAYERS[playerid].cuneiform = CreatePlayerDraw(playerid, startx, starty, params, FONTS.keil, 240, 240, 240);
    ShowPlayerDraw(playerid, PLAYERS[playerid].cuneiform);
end

function callNumpad(playerid, numpadkey)
    local command = "/wurf";
    local macros = DB_select("*", "account_numpadmacros", "accountid="..PLAYERS[playerid].account.." AND numpadkey="..numpadkey);
    for _key, macro in pairs(macros) do
        command = macro.macro;
    end
    OnPlayerText(playerid, command);
end

function setnumpad(playerid, params)
    local result, numpadkey, macro = sscanf(params, "ds");
    if result ~= 1 then
        sendERRMessage(playerid, "Du musst ein Macro in folgender Form speichern /numpadtaste <Zahl> <Macro>");
        return;
    end
    if numpadkey < 0 or numpadkey > 9 then
        sendERRMessage(playerid, "Hast du ein Numpad was gr��er ist als 0 bis 9?");
        return;
    end
    if not (DB_exists("*", "account_numpadmacros", "accountid="..PLAYERS[playerid].account.." AND numpadkey="..numpadkey)) then
        DB_insert("account_numpadmacros", {accountid=PLAYERS[playerid].account, numpadkey=numpadkey, macro=mysql_escape_string(DB.HANDLER, macro)});
    else
        DB_update("account_numpadmacros", {macro=mysql_escape_string(DB.HANDLER, macro)}, "accountid="..PLAYERS[playerid].account.." AND numpadkey="..numpadkey);
    end
    sendINFOMessage(playerid, "Nunmpadtaste "..numpadkey.." l�st nun bei dir folgendes aus: '"..macro.."'");
end

function invis(playerid, PARAMS)
    saveChar(playerid);
    local instance = "PC_GHOST";
    local prefix = "Du bist nun ";
    local infix = "";
    local suffix = "unsichtbar"
    if (PLAYERS[playerid].invis ~= nil) then
        instance = "PC_HERO";
        infix = "nicht mehr ";
        SetPlayerStreamable(playerid, 1);
        PLAYERS[playerid].invis = nil;
    else
        SetPlayerStreamable(playerid, 0);
        PLAYERS[playerid].invis = true;
    end
    loadChar(playerid, instance);
    sendINFOMessage(playerid, prefix..infix..suffix);
end