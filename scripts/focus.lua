function OnPlayerFocus(playerid, focusid)
    local text = nil;
    if (PLAYERS[playerid].focus ~= nil)
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focus);
        PLAYERS[playerid].focus = nil;
    end

    if PLAYERS[focusid] == nil and WORLDMONSTERS[focusid] == nil then 
        return;
    end

    text = GetPlayerName(focusid).." ("..focusid..")";
    
    if WORLDMONSTERS[focusid] ~= nil then
        text = text.." ["..WORLDMONSTERS[focusid].."]";
    end
    x, y = convertToPixel(30, 1010);
    PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.standard, 255, 255, 255);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focus);
end

