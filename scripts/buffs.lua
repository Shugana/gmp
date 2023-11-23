function BuffsLoop()
    for playerid, _playerdata in pairs (PLAYERS) do
        BuffsPlayer(playerid);
    end
end

function BuffsPlayer(playerid)
    if PLAYERS[playerid].buffs == nil then
        return;
    end
    for key, buff in pairs(PLAYERS[playerid].buffs) do
        if PLAYERS[playerid].buffs[key].current ~= nil then
            DestroyTexture(playerid, PLAYERS[playerid].buffs[key].current);
        end
        if PLAYERS[playerid].buffs[key].background ~= nil then
            DestroyTexture(playerid, PLAYERS[playerid].buffs[key].background);
        end
        PLAYERS[playerid].buffs[key].value = PLAYERS[playerid].buffs[key].value+1;
        local goal = math.ceil(PLAYERS[playerid].buffs[key].value / PLAYERS[playerid].buffs[key].target * 100);
        if (goal > 100) then
            PLAYERS[playerid].buffs[key] = nil;
            debug("buff finished");
            return;
        end
        local startx, starty = convertToPixel(800, 300);
        local sizex, sizey = convertToPixel(128, 128);
        
        PLAYERS[playerid].buffs[key].current = CreateTexture(startx+key*sizex, starty, startx+sizex, starty+sizey, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\BUFFS_"..goal..".TGA");
        ShowTexture(playerid, PLAYERS[playerid].buffs[key].current);
        PLAYERS[playerid].buffs[key].background = CreateTexture(startx+key*sizex, starty, startx+sizex, starty+sizey, PLAYERS[playerid].buffs[key].bgtexture);
        ShowTexture(playerid, PLAYERS[playerid].buffs[key].background);
        debug (PLAYERS[playerid].buffs[key].background.." - "..PLAYERS[playerid].buffs[key].current.." - "..PLAYERS[playerid].buffs[key].value.." / "..PLAYERS[playerid].buffs[key].target.." = "..goal);
    end
end

function bufftest(playerid, params)
    local startx, starty = convertToPixel(800, 300);
    local sizex, sizey = convertToPixel(128, 128);
    local newbuff = {
        bgtexture = "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_FLUFF_HUNTERICON.TGA",
        current = nil,
        target = 60*2,
        value = 0
    }
    if (PLAYERS[playerid].buffs == nil) then
        PLAYERS[playerid].buffs = {};
    end

    table.insert(PLAYERS[playerid].buffs, newbuff);
    debug("buff initiated");
end