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
            DestroyTexture(PLAYERS[playerid].buffs[key].current);
        end
        if PLAYERS[playerid].buffs[key].background ~= nil then
            DestroyTexture(PLAYERS[playerid].buffs[key].background);
        end
        PLAYERS[playerid].buffs[key].value = PLAYERS[playerid].buffs[key].value+1;
        local goal = math.ceil(PLAYERS[playerid].buffs[key].value / PLAYERS[playerid].buffs[key].target * 100);

        if PLAYERS[playerid].buffs[key].effect ~= nil then
            _G[PLAYERS[playerid].buffs[key].effect.func](playerid, key);
        end

        if (goal > 100) then
            PLAYERS[playerid].buffs[key] = nil;
            return;
        end
        local startx, starty = convertToPixel(1000, 16);
        local sizex, sizey = convertToPixel(64, 64);
        
        PLAYERS[playerid].buffs[key].current = CreateTexture(startx+key*sizex, starty, startx+key*sizex+sizex, starty+sizey, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\BUFFS_"..goal..".TGA");
        ShowTexture(playerid, PLAYERS[playerid].buffs[key].current);
        PLAYERS[playerid].buffs[key].background = CreateTexture(startx+key*sizex, starty, startx+key*sizex+sizex, starty+sizey, PLAYERS[playerid].buffs[key].bgtexture);
        ShowTexture(playerid, PLAYERS[playerid].buffs[key].background);
    end
end

function bufftest(playerid, params)
    local startx, starty = convertToPixel(1000, 50);
    local sizex, sizey = convertToPixel(64, 64);
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
end

function drinkHealPot(playerid, heal, graphic, time)
    local newbuff = {
        bgtexture = graphic,
        current = nil,
        target = time,
        value = 0,
        effect = {
            func = "healOverTime",
            args = {
                targethp = heal,
                healed = 0,
                hp = GetPlayerHealth(playerid)
            }
        }
    }
    if (PLAYERS[playerid].buffs == nil) then
        PLAYERS[playerid].buffs = {};
    end
    table.insert(PLAYERS[playerid].buffs, newbuff);
end

function healOverTime(playerid, buffnumber)
    local maxhp = GetPlayerMaxHealth(playerid);
    --local hp = GetPlayerHealth(playerid);
    local hp = PLAYERS[playerid].buffs[buffnumber].effect.args.hp;

    local healtotal = math.ceil(maxhp * PLAYERS[playerid].buffs[buffnumber].effect.args.targethp / 100);

    local progress = PLAYERS[playerid].buffs[buffnumber].value / PLAYERS[playerid].buffs[buffnumber].target;

    local healestimated = math.ceil(healtotal * progress);
    local healdone = PLAYERS[playerid].buffs[buffnumber].effect.args.healed;

    local thisheal = healestimated - healdone;

    --debug(healtotal..": "..healdone.."/"..healestimated.." ("..progress..") -> +"..thisheal);

    if (thisheal < 1) then
        return;
    end
    updateHP(playerid, thisheal);
    PLAYERS[playerid].buffs[buffnumber].effect.args.hp = math.min(hp+thisheal, maxhp);
    PLAYERS[playerid].buffs[buffnumber].effect.args.healed = healdone + thisheal;
end