STATFUNCTIONS = {
    get = {
        str = {"GetPlayerStrength", nil},
        ['stärke'] = {"GetPlayerStrength", nil},
        strength = {"GetPlayerStrength", nil},
        dex = {"GetPlayerDexterity", nil},
        geschick = {"GetPlayerDexterity", nil},
        dexterity = {"GetPlayerDexterity", nil},
        mana = {"getMana", nil},
        maxmana = {"getMaxMana", nil},
        leben = {"getHP", nil},
        hp = {"getHP", nil},
        maxleben = {"getMaxHP", nil},
        maxhp = {"getMaxHP", nil},
        einhand = {"GetPlayerSkillWeapon", SKILL_1H},
        ['1h'] = {"GetPlayerSkillWeapon", SKILL_1H},
        onehanded = {"GetPlayerSkillWeapon", SKILL_1H},
        zweihand = {"GetPlayerSkillWeapon", SKILL_1H},
        ['2h'] = {"GetPlayerSkillWeapon", SKILL_2H},
        twohanded = {"GetPlayerSkillWeapon", SKILL_2H},
        bogen = {"GetPlayerSkillWeapon", SKILL_BOW},
        bow = {"GetPlayerSkillWeapon", SKILL_BOW},
        armbrust = {"GetPlayerSkillWeapon", SKILL_CBOW},
        cbow = {"GetPlayerSkillWeapon", SKILL_CBOW},
        crossbow = {"GetPlayerSkillWeapon", SKILL_CBOW}
    },
    set = {
        str = {"SetPlayerStrength", nil},
        ['stärke'] = {"SetPlayerStrength", nil},
        strength = {"SetPlayerStrength", nil},
        dex = {"SetPlayerDexterity", nil},
        geschick = {"SetPlayerDexterity", nil},
        dexterity = {"SetPlayerDexterity", nil},
        mana = {"setMana", nil},
        maxmana = {"setMaxMana", nil},
        leben = {"setHP", nil},
        hp = {"setHP", nil},
        maxleben = {"setMaxHP", nil},
        maxhp = {"setMaxHP", nil},
        einhand = {"SetPlayerSkillWeapon", SKILL_1H},
        ['1h'] = {"SetPlayerSkillWeapon", SKILL_1H},
        onehanded = {"SetPlayerSkillWeapon", SKILL_1H},
        zweihand = {"SetPlayerSkillWeapon", SKILL_1H},
        ['2h'] = {"SetPlayerSkillWeapon", SKILL_2H},
        twohanded = {"SetPlayerSkillWeapon", SKILL_2H},
        bogen = {"SetPlayerSkillWeapon", SKILL_BOW},
        bow = {"SetPlayerSkillWeapon", SKILL_BOW},
        armbrust = {"SetPlayerSkillWeapon", SKILL_CBOW},
        cbow = {"SetPlayerSkillWeapon", SKILL_CBOW},
        crossbow = {"SetPlayerSkillWeapon", SKILL_CBOW}
    }
}

function statfunction(method, stat)
    method = string.lower(method);
    stat = string.lower(stat);
    if (STATFUNCTIONS[method] == nil or STATFUNCTIONS[method][stat] == nil) then
        return nil;
    end
    return STATFUNCTIONS[method][stat];
end


function getMana(playerid)
    if PLAYERS[playerid] ~= nil then
        return PLAYERS[playerid].stats.mana;
    end
    if NPCS[playerid] ~= nil then
        return NPCS[playerid].stats.mana;
    end
    return 0;
end

function getMaxMana(playerid)
    if PLAYERS[playerid] ~= nil then
        return PLAYERS[playerid].stats.maxmana;
    end
    if NPCS[playerid] ~= nil then
        return NPCS[playerid].stats.maxmana;
    end
    return 0;
end

function updateMana(playerid, delta)
    if PLAYERS[playerid] ~= nil then
        local newmana = math.min(math.max(0, PLAYERS[playerid].stats.mana+delta),GetPlayerMaxMana(playerid));
        PLAYERS[playerid].stats.mana = newmana;
        SetPlayerMana(playerid, newmana);
    end
    if NPCS[playerid] ~= nil then
        local newmana = math.min(math.max(0, NPCS[playerid].stats.mana+delta),GetPlayerMaxMana(playerid));
        NPCS[playerid].stats.mana = newmana;
        SetPlayerMana(playerid, newmana);
    end
end

function setMana(playerid, amount)
    if PLAYERS[playerid] ~= nil then
        PLAYERS[playerid].stats.mana = amount;
    end
    if NPCS[playerid] ~= nil then
        NPCS[playerid].stats.mana = amount;
    end
    updateMana(playerid, 0);
end

function setMaxMana(playerid, amount)
    if PLAYERS[playerid] ~= nil then
        PLAYERS[playerid].stats.maxmana = amount;
        PLAYERS[playerid].stats.mana = math.min(PLAYERS[playerid].stats.mana, PLAYERS[playerid].stats.maxmana);
    end
    if NPCS[playerid] ~= nil then
        NPCS[playerid].stats.maxmana = amount;
        NPCS[playerid].stats.mana = math.min(NPCS[playerid].stats.mana, NPCS[playerid].stats.maxmana);
    end
    SetPlayerMaxMana(playerid, amount);
    updateMana(playerid, 0);
end

function loadStats(playerid)
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        return;
    end
    local responses = DB_select("*", "character_stats", "characterid = "..PLAYERS[playerid].character);
    for _key, response in pairs(responses) do
        SetPlayerLearnPoints(playerid, tonumber(response.lp));
        SetPlayerLevel(playerid, 0);
        SetPlayerMaxHealth(playerid, tonumber(response.maxhp));
        SetPlayerHealth(playerid, tonumber(response.hp));
        SetPlayerMagicLevel(playerid, tonumber(response.circle))
        SetPlayerMaxMana(playerid, tonumber(response.maxmana));
        SetPlayerMana(playerid, tonumber(response.mana));
        SetPlayerStrength(playerid, tonumber(response.str));
        SetPlayerDexterity(playerid, tonumber(response.dex));
        SetPlayerSkillWeapon (playerid, SKILL_1H, tonumber(response.onehanded));
        SetPlayerSkillWeapon (playerid, SKILL_2H, tonumber(response.twohanded));
        SetPlayerSkillWeapon (playerid, SKILL_BOW, tonumber(response.bow));
        SetPlayerSkillWeapon (playerid, SKILL_CBOW, tonumber(response.crossbow));
        PLAYERS[playerid].stats = {
            hp = tonumber(response.hp),
            maxhp = tonumber(response.maxhp),
            mana = tonumber(response.mana),
            maxmana = tonumber(response.maxmana),
            xp = tonumber(response.xp),
            protections = {
                blunt = 0,
                edge = 0,
                point = 0,
                fire = 0,
                water = 0,
                earth = 0,
                air = 0
            }
        };
        return;
    end
end

function createStats(playerid)    
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        return;
    end
    DB_insert("character_stats", {characterid=PLAYERS[playerid].character});
end

function saveStats(playerid)
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        return;
    end
    DB_update("character_stats", {hp=getHP(playerid), mana=getMana(playerid)}, "characterid = "..PLAYERS[playerid].character);
end

function changeAttribute(playerid, params)
    result, stat, amount = sscanf(params, "sd");
    if result ~= 1 then
        sendERRMessage(playerid, "Du musst Stat und Zahl angeben");
        return;
    end
    if (amount < 1) then
        sendERRMessage(playerid, "Wert darf nicht kleiner sein als 1");
        return;
    end
    local funcvars = statfunction("set", stat);
    if (funcvars == nil) then
        sendERRMessage(playerid, "Stat "..stat.." ist nicht bekannt");
        return;
    end
    local func = funcvars[1];
    local bonus = funcvars[2];
    if (bonus == nil) then
        _G[func](playerid, amount);
    else
        _G[func](playerid, bonus, amount);
    end
    sendINFOMessage(playerid, "Dein "..stat.." wurde auf "..amount.." gesetzt.");
end