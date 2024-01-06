XPPERLP = 400;
DAILYLP = 4;

LEVELUPSOUND = CreateSound("LEVELUP.WAV");

function teachsimulator(playerid, params)
    local result, lp = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Du musst eine Zahl eingeben");
        return;
    end
    lp = math.max(0, lp);
    
    DB_update("character_stats", {
        mana=0,
        maxmana=0,
        lp=lp,
        str=5,
        dex=5,
        onehanded=0,
        twohanded=0,
        bow=0,
        crossbow=0
    }, "characterid = "..PLAYERS[playerid].character);
    sendINFOMessage(playerid, "Deine Stats wurden zurückgesetzt für den Teach-Simulator. Deine LP wurden auf "..lp.." gesetzt.");
    teachmenu(playerid);
end

function teachmenu(playerid)
    loadStats(playerid);
    setupMenu(playerid, true);
    local size = {x=450, y=50};
    local start = {x=500, y=350};
    local teachcosts = getNextTeachCost(playerid);
    local row = 0;
    for _key, stat in pairs({"str", "dex", "maxmana"}) do
        local cost = teachcosts.stats;
        if(teachcosts[stat] > 98) then
            cost = cost*5;
        elseif (teachcosts[stat] > 58) then
            cost = cost*3;
        elseif (teachcosts[stat] > 28) then
            cost = cost*2;
        end
        if (cost > teachcosts.lp) then
            createButton(playerid, stat.." "..teachcosts[stat].." -> "..(teachcosts[stat]+1).." ("..cost..")", start.x, start.y+row*size.y, size.x, size.y, 196, 30, 58, "clearMenu", {});
        else
            createButton(playerid, stat.." "..teachcosts[stat].." -> "..(teachcosts[stat]+1).." ("..cost..")", start.x, start.y+row*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = stat, cost = cost, lp=teachcosts.lp, oldstat=teachcosts[stat]});
        end
        row = row + 1;
    end
    for _key, weaponskill in pairs({"onehanded", "twohanded", "bow", "crossbow"}) do
        local cost = teachcosts.weapons;
        if (teachcosts[weaponskill] > 58) then
            cost = cost*3;
        elseif (teachcosts[weaponskill] > 28) then
            cost = cost*2;
        end
        if (cost > teachcosts.lp) then
            createButton(playerid, weaponskill.." "..teachcosts[weaponskill].." -> "..(teachcosts[weaponskill]+1).." ("..cost..")", start.x, start.y+row*size.y, size.x, size.y, 196, 30, 58, "clearMenu", {});
        else
            if (teachcosts[weaponskill] > 99) then
                createText(playerid, weaponskill.." auf Maximum (100)", start.x, start.y+row*size.y, size.x, size.y, 196, 30, 58)
            else
                createButton(playerid, weaponskill.." "..teachcosts[weaponskill].." -> "..(teachcosts[weaponskill]+1).." ("..cost..")", start.x, start.y+row*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = weaponskill, cost = cost, lp=teachcosts.lp, oldstat=teachcosts[weaponskill]});
            end
        end
        row = row + 1;
    end
end

function teach(playerid, args)
    DB_update("character_stats", {
        [args.stat]=args.oldstat+1,
        lp = args.lp-args.cost
    }, "characterid = "..PLAYERS[playerid].character);
    PlaySound(playerid, LEVELUPSOUND);
    teachmenu(playerid);
end

function getNextTeachCost(playerid)
    local responses = DB_select("id, (maxmana+str+dex) as stats, (onehanded+twohanded+bow+crossbow) as weapons, lp, str, dex, onehanded, twohanded, bow, crossbow, maxmana","character_stats","characterid = "..PLAYERS[playerid].character);
    for key_, response in pairs(responses) do
        return {
            stats = math.max(1, math.ceil((tonumber(response.stats)-9)/10)),
            weapons = math.max(1, math.ceil(tonumber(response.weapons)/10)),
            str = tonumber(response.str),
            dex = tonumber(response.dex),
            onehanded = tonumber(response.onehanded),
            twohanded = tonumber(response.twohanded),
            bow = tonumber(response.bow),
            crossbow = tonumber(response.crossbow),
            maxmana = tonumber(response.maxmana),
            lp = tonumber(response.lp)
        };
    end
    return {
        cost = 5000,
        str = 5,
        dex = 5,
        onehanded = 0,
        twohanded = 0,
        bow = 0,
        crossbow = 0,
        maxmana = 0,
        lp = 0
    };
end

function PlaySound(playerid, sound)
	local x, y, z = GetPlayerPos(playerid)
	for listener, _ in pairs(PLAYERS) do
		if PLAYERS[listener] then
            if GetDistancePlayers(playerid, listener) < 1000 then
                PlayPlayerSound3D(listener, sound, x, y, z, 1000)
            end
		end
	end
end

function gainLPLoop()
    for playerid, player in pairs(PLAYERS) do
        if (PLAYERS[playerid] ~= nil and PLAYERS[playerid].character ~= nil) then
            gainLP(playerid, 1, false);
        end
    end
end

function gainLP(playerid, lp, free)
    lp = math.max(1, lp);
    if (PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil) then
        return false;
    end
    local characters = DB_select("*", "character_stats", "characterid = "..PLAYERS[playerid].character);
    for _key, character in pairs(characters) do
        local xp = tonumber(character.xp);
        local lpToday = tonumber(character.lptoday);
        local lpExpected = math.max(DAILYLP, math.floor(xp/XPPERLP));
        local dbLP = tonumber(character.lp);
        if (free == true) then
            DB_update("character_stats", {lp=dbLP+lp}, "characterid = "..PLAYERS[playerid].character);
            SetPlayerLearnPoints(playerid, dbLP+lp);
            PlaySound(playerid, LEVELUPSOUND);
            sendINFOMessage(playerid, "Dir wurden "..lp.." geschenkt.Nun hast du "..(dbLP+lp).." Lernpunkte. Dies hat keinen Einfluss auf dein tägliches Limit für heute "..(lpToday).."/"..DAILYLP);
            return true;
        end
        if (lpToday < lpExpected) then
            if (lpToday + lp > DAILYLP) then
                lp = DAILYLP - lpToday;
            end
            DB_update("character_stats", {lptoday=lpToday+lp, lp=dbLP+lp}, "characterid = "..PLAYERS[playerid].character);
            SetPlayerLearnPoints(playerid, dbLP+lp);
            PlaySound(playerid, LEVELUPSOUND);
            sendINFOMessage(playerid, "Du hast einen Lernpunkt erhalten. Nun hast du "..(dbLP+lp).." Lernpunkte. Damit hast du für heute "..(lpToday+lp).."/"..DAILYLP.." Lernpunkte erhalten.");
            return true;
        end
    end
    return true;
end

function resetLPCap()
    debug("LP Daily Reset");
    DB_update("character_stats", {lptoday=0, xp=0}, "1");
end

function gainXP(playerid, xp)
    debug(playerid.." gained "..xp.." XP");
    if (PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil or xp < 1) then
        return;
    end
    local characters = DB_select("*", "character_stats", "characterid = "..PLAYERS[playerid].character);
    for _key, character in pairs(characters) do
        DB_update("player_stats", {xp=tonumber(character.xp)+xp}, "characterid = "..PLAYERS[playerid].character);
        return;
    end
end