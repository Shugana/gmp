XPPERLEVEL = 500;
BASEHP = 400;
HPPERLEVEL = 50;

function loadStats(playerid)
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        return;
    end
    PLAYERS[playerid].stats = {
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
    local responses = DB_select("*", "character_stats", "characterid = "..PLAYERS[playerid].character);
    for _key, response in pairs(responses) do
        local lvl = math.floor(tonumber(response.xp)/XPPERLEVEL);
        SetPlayerLearnPoints(playerid, tonumber(response.lp));
        SetPlayerLevel(playerid, lvl);
        SetPlayerExperience(playerid, tonumber(response.xp)%XPPERLEVEL);
        SetPlayerMaxHealth(playerid, BASEHP+HPPERLEVEL*lvl);
        SetPlayerHealth(playerid, tonumber(response.hp));
        PLAYERS[playerid].stats.hp = tonumber(response.hp);
        SetPlayerMagicLevel(playerid, tonumber(response.circle))
        SetPlayerMaxMana(playerid, tonumber(response.maxmana));
        SetPlayerMana(playerid, tonumber(response.mana));
        PLAYERS[playerid].stats.mana = tonumber(response.mana);
        SetPlayerStrength(playerid, tonumber(response.str));
        SetPlayerDexterity(playerid, tonumber(response.dex));
        SetPlayerSkillWeapon (playerid, SKILL_1H, tonumber(response.onehanded));
        SetPlayerSkillWeapon (playerid, SKILL_2H, tonumber(response.twohanded));
        SetPlayerSkillWeapon (playerid, SKILL_BOW, tonumber(response.bow));
        SetPlayerSkillWeapon (playerid, SKILL_CBOW, tonumber(response.crossbow));
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
    DB_update("character_stats", {hp=PLAYERS[playerid].stats.hp, mana=PLAYERS[playerid].stats.mana}, "characterid = "..PLAYERS[playerid].character);
end