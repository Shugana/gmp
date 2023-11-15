function CraftingLoop()
    for playerid, playerdata in pairs(PLAYERS) do
        if (playerdata.crafting ~= nil) then
            craftingTick(playerid);
        end
    end
end

function craftingStart(playerid, name, duration, finishFunc, options, animation)
    duration = math.max(duration, 1);
    if not(canWork(playerid)) then
        sendERRMessage(playerid, "Du bist gerade nicht fit genug, um zu arbeiten.");
        return;
    end
    local totalticks = math.ceil(duration/100);
    local totaltime = totalticks/10;
    Player[playerid].working = {
        duration = totalticks,
        progress = 0,
        progressbar = nil,
        finishFunc = finishFunc,
        options = options,
        animation = animation
    };
    ShowTexture(playerid, SERVERDRAWS.craftingbackground.id);
    sendINFOMessage(playerid, "Du hast begonnen mit "..name..", dafür wirst du ca. "..totaltime.." Sekunden brauchen.")
end

function craftingTick(playerid);
    PLAYERS[playerid].working.progress = PLAYERS[playerid].working.progress + 1;
    if (PLAYERS[playerid].working.progressbar ~= nil) then
        DestroyTexture(PLAYERS[playerid].working.progressbar);
    end
    local updatelength = math.floor(PLAYERS[playerid].working.progress/PLAYERS[playerid].working.duration*1000);
    PLAYERS[playerid].working.progressbar = CreateTexture(
        SERVERDRAWS.craftingbar.pos.x,
        SERVERDRAWS.craftingbar.pos.y,
        SERVERDRAWS.craftingbar.size.x+updatelength,
        SERVERDRAWS.craftingbar.size.y,
        SERVERDRAWS.craftingbar.graphic
    );
    if (PLAYERS[playerid].working.animation ~= nil) then
        PlayAnimation(playerid, PLAYERS[playerid].working.animation);
    end
    ShowTexture(playerid, PLAYERS[playerid].working.progressbar);
    if PLAYERS[playerid].working.progress >= PLAYERS[playerid.working.duration] then
        craftingFinish(playerid);
    end
end

function craftingFinish(playerid)
    _G[Player[playerid].working.finishFunc](playerid);
    craftingStop(playerid);
end    

function craftingStop(playerid)
    HideTexture(playerid, SERVERDRAWS.craftingbackground.id);
    if (PLAYERS[playerid].crafting.progressbar ~= nil) then
        DestroyTexture(PLAYERS[playerid].crafting.progressbar);
    end
    PLAYERS[playerid].crafting = nil;
end

function canWork(playerid)
    if (PLAYERS[playerid].working ~= nil) then
        return false;
    end
    return true; -- for now... later: check hunger, check illness, etc.
end

function testWorktimer(playerid, params)
    local result, time = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /testtimer <Zeit in ms> (1000 ms = 1 Sekunde)");
        return;
    end
    craftingStart(playerid, "Test-Timer", time, "testFinishWork", {}, nil);
end

function testFinishWork(playerid);
    sendINFOMessage(playerid, "Test-Timer ist fertig!")
end