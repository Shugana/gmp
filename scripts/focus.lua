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

    text = "Fokus: "..GetPlayerName(focusid).." ("..focusid..")";

    if WORLDMONSTERS[focusid] ~= nil then
        text = text.." {"..WORLDMONSTERS[focusid].."}";
    end
    local x, y = convertToPixel(30, 923);
    PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.sequel, 255, 255, 255);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focus);

    x, y = convertToPixel(955, 25);
    local hp = getHP(focusid);
    local maxhp = getMaxHP(focusid);
    local perc = math.ceil(hp/maxhp*100);
    PLAYERS[playerid].focushp = CreatePlayerDraw(playerid, x, y, hp.." / "..maxhp.."("..perc..")", FONTS.sequel, 255, 255, 255, 255, 1);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focushp);
end

