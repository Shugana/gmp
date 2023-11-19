function OnPlayerFocus(playerid, focusid)
    local text = nil;
    if (PLAYERS[playerid].focus ~= nil) then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focus);
        PLAYERS[playerid].focus = nil;
    end

    if PLAYERS[focusid] == nil and NPCS[focusid] == nil then
        return;
    end

    text = "Fokus: "..GetPlayerName(focusid).." ("..focusid..")";
    
    if WORLDMONSTERS[focusid] ~= nil then
        text = text.." {"..WORLDMONSTERS[focusid].."}";
    end
    x, y = convertToPixel(30, 923);
    PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.sequel, 255, 255, 255);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focus);
end

