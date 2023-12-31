function OnPlayerFocus(playerid, focusid)
    local text = nil;
    if (PLAYERS[playerid].focus ~= nil) then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focus);
        PLAYERS[playerid].focus = nil;
    end

    if (PLAYERS[playerid].focushp ~= nil) then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focushp);
        PLAYERS[playerid].focushp = nil;
    end

    if PLAYERS[focusid] == nil and NPCS[focusid] == nil then
        return;
    end

    text = GetPlayerName(focusid).." ("..focusid..")";

    if WORLDMONSTERS[focusid] ~= nil then
        text = text.." {"..WORLDMONSTERS[focusid].."}";
    end
    --local x, y = convertToPixel(30, 923);
    local x, y = convertToPixel(955, 55);
    --PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.sequel, 255, 255, 255);
    PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.sequel, 255, 255, 255, 255, 1);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focus);
    updateFocusHP(playerid, focusid);

end

function updateFocusHP(playerid, focusid)
    if (PLAYERS[playerid].focushp ~= nil) then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focushp);
        PLAYERS[playerid].focushp = nil;
    end
    local x, y = convertToPixel(955, 25);
    local hp = getHP(focusid);
    local maxhp = getMaxHP(focusid);
    local perc = math.ceil(hp/maxhp*100);
    local text = "TOT";
    if (hp > 0) then
        text = hp.."/"..maxhp.." ("..perc.."%)";
    end
    PLAYERS[playerid].focushp = CreatePlayerDraw(playerid, x, y, text, FONTS.sequel, 255, 255, 255, 255, 1);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focushp);
end

function updateFocussingMe(focusid)
    for playerid, _k in pairs(PLAYERS) do
        if GetFocus(playerid) == focusid then
            updateFocusHP(playerid, focusid);
        end
    end
end
