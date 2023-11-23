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
    for key, stat in pairs({"str", "dex", "maxmana", "onehanded", "twohanded", "bow", "crossbow"}) do
        local cost = teachcosts.cost;
        if(teachcosts[stat] > 98) then
            cost = cost*5;
        elseif (teachcosts[stat] > 58) then
            cost = cost*3;
        elseif (teachcosts[stat] > 28) then
            cost = cost*2;
        end
        if (cost > teachcosts.lp) then
            createButton(playerid, stat.." "..teachcosts[stat].." -> "..(teachcosts[stat]+1).." ("..cost..")", start.x, start.y+0*size.y, size.x, size.y, 196, 30, 58, "clearMenu", {});
        else
            if (teachcosts[stat] > 99 and (stat == "onehanded" or stat == "twohanded" or stat == "bow" or stat == "crossbow")) then
                createText(playerid, stat.." auf Maximum (100)", start.x, start.y+key*size.y, size.x, size.y, 196, 30, 58)
            else
                createButton(playerid, stat.." "..teachcosts[stat].." -> "..(teachcosts[stat]+1).." ("..cost..")", start.x, start.y+key*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = stat, cost = cost, lp=teachcosts.lp, oldstat=teachcosts[stat]});
            end
        end
    end
end


LEVELUPSOUND = CreateSound("LEVELUP.WAV");

function teach(playerid, args)
    DB_update("character_stats", {
        [args.stat]=args.oldstat+1,
        lp = args.lp-args.cost
    }, "characterid = "..PLAYERS[playerid].character);
    PlaySound(playerid, LEVELUPSOUND);
    teachmenu(playerid);
end

function getNextTeachCost(playerid)
    local responses = DB_select("id, (maxmana+str+dex+onehanded+twohanded+bow+crossbow) as totalstats, lp, str, dex, onehanded, twohanded, bow, crossbow, maxmana","character_stats","characterid = "..PLAYERS[playerid].character);
    for key_, response in pairs(responses) do
        return {
            cost = math.max(1, math.ceil((tonumber(response.totalstats)-9)/10)),
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