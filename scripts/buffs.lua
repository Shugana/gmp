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
        local startx, starty = convertToPixel(800, 300);
        local sizex, sizey = convertToPixel(128, 128);
        
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

function OnPlayerUseItem(playerid, itemInstance, amount, hand)
    if (itemInstance == "ITPO_HEALTH_01") then
        drinkHealPot(playerid, 25, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_01_3DS.TGA", 1200);
    end
    if (itemInstance == "ITPO_HEALTH_02") then
        drinkHealPot(playerid, 50, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_02_3DS.TGA", 600);
    end
    if (itemInstance == "ITPO_HEALTH_03") then
        drinkHealPot(playerid, 100, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_03_3DS.TGA", 300);
    end
    
end

function drinkHealPot(playerid, heal, graphic, time)
    local startx, starty = convertToPixel(1000, 16);
    local sizex, sizey = convertToPixel(64, 64);
    local newbuff = {
        bgtexture = graphic,
        current = nil,
        target = time,
        value = 0,
        effect = {
            func = "healOverTime",
            args = {
                targethp = heal,
                healed = 0
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
    local hp = GetPlayerHealth(playerid);

    local healtotal = math.ceil(maxhp * PLAYERS[playerid].buffs[buffnumber].effect.args.targethp / 100);

    local progress = PLAYERS[playerid].buffs[buffnumber].value / PLAYERS[playerid].buffs[buffnumber].target;

    local healestimated = math.ceil(healtotal * progress);
    local healdone = PLAYERS[playerid].buffs[buffnumber].effect.args.healed;

    local thisheal = healestimated - healdone;

    if (thisheal < 1) then
        return;
    end
    SetPlayerHealth(playerid, math.min(hp+thisheal, maxhp));
    PLAYERS[playerid].buffs[buffnumber].effect.args.healed = healdone + thisheal;
end