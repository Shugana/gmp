function OnPlayerFocus(playerid, focusid)
    debug("focuschange on "..playerid.." to focus "..focusid);
    local text = nil;
    if (PLAYERS[playerid].focus ~= nil) then
        DestroyPlayerDraw(playerid, PLAYERS[playerid].focus);
        PLAYERS[playerid].focus = nil;
        debug("old focus text removed");
    end

    if PLAYERS[focusid] == nil and WORLDMONSTERS[focusid] == nil then
        debug("focus not a player, not a monster, maybe nothing in focus");
        return;
    end

    text = GetPlayerName(focusid).." ("..focusid..")";
    debug(text);
    
    if WORLDMONSTERS[focusid] ~= nil then
        text = text.." ["..WORLDMONSTERS[focusid].."]";
        debug(text);
    end
    x, y = convertToPixel(30, 1010);
    PLAYERS[playerid].focus = CreatePlayerDraw(playerid, x, y, text, FONTS.standard, 255, 255, 255);
    ShowPlayerDraw(playerid, PLAYERS[playerid].focus);
    debug("focus function complete");
end

