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
    if (teachcosts.lp >= teachcosts.cost) then
        createButton(playerid, "Stärke "..teachcosts.str.." -> "..(teachcosts.str+1).." ("..teachcosts.cost..")", start.x, start.y+0*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "str", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.str});
        createButton(playerid, "Geschick "..teachcosts.dex.." -> "..(teachcosts.dex+1).." ("..teachcosts.cost..")", start.x, start.y+1*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "dex", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.dex});
        createButton(playerid, "Mana "..teachcosts.maxmana.." -> "..(teachcosts.maxmana+1).." ("..teachcosts.maxmana..")", start.x, start.y+2*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "maxmana", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.maxmana});
        if (teachcosts.onehanded < 100) then
            createButton(playerid, "Einhand "..teachcosts.onehanded.." -> "..(teachcosts.onehanded+1).." ("..teachcosts.cost..")", start.x, start.y+3*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "onehanded", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.onehanded});
        else
            createText(playerid, "Einhand - maximum - 100", start.x, start.y+3*size.y, size.x, size.y, 196, 30, 58);
        end
        if (teachcosts.twohanded < 100) then
            createButton(playerid, "Zweihand "..teachcosts.twohanded.." -> "..(teachcosts.twohanded+1).." ("..teachcosts.cost..")", start.x, start.y+4*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "twohanded", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.twohanded});
        else
            createText(playerid, "Zweihand - maximum - 100", start.x, start.y+4*size.y, size.x, size.y, 196, 30, 58);
        end
        if (teachcosts.bow < 100) then
            createButton(playerid, "Bogen "..teachcosts.bow.." -> "..(teachcosts.bow+1).." ("..teachcosts.cost..")", start.x, start.y+5*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "bow", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.bow});
        else
            createText(playerid, "Bogen - maximum - 100", start.x, start.y+5*size.y, size.x, size.y, 196, 30, 58);
        end
        if (teachcosts.crossbow < 100) then
            createButton(playerid, "Armbrust "..teachcosts.crossbow.." -> "..(teachcosts.crossbow+1).." ("..teachcosts.cost..")", start.x, start.y+6*size.y, size.x, size.y, 0, 255, 152, "teach", {stat = "crossbow", cost = teachcosts.cost, lp=teachcosts.lp, oldstat=teachcosts.crossbow});
        else
            createText(playerid, "Armbrust - maximum - 100", start.x, start.y+6*size.y, size.x, size.y, 196, 30, 58);
        end
    else
        createButton(playerid, "Nicht genügend Lernpunkte.", start.x, start.y+0*size.y, size.x, size.y*7, 196, 30, 58, "clearMenu", {});
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