function OnPlayerHit(playerid, attackerid)
    debug(attackerid.." attacked "..playerid);
    local weaponmode = GetPlayerWeaponMode(attackerid);

    local damage = 0;

    if (weaponmode == WEAPON_NONE or weaponmode == WEAPON_FIST) then
        debug ("Faust default dmg: 5 blunt");
        damage = calculateDamage({blunt=5, edge=0, point=0, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_1H) then
        debug ("1H default dmg: 10 edge");
        damage = calculateDamage({blunt=0, edge=10, point=0, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_2H) then
        debug ("2H default dmg: 25 edge");
        damage = calculateDamage({blunt=0, edge=25, point=0, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_BOW) then
        debug ("Bogen default dmg: 25 point");
        damage = calculateDamage({blunt=0, edge=0, point=25, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_CBOW) then
        debug ("Armbrust default dmg: 10 point");
        damage = calculateDamage({blunt=0, edge=0, point=10, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_MAGIC) then
        debug ("Magie default dmg: 50 fire");
        damage = calculateDamage({blunt=0, edge=0, point=0, fire=50, water=0, earth=0, air=0}, getProtections(playerid));
    end
    debug ("result of "..damage);
    updateHP(playerid, -damage);
end

function OnPlayerSpellSetup(playerid, spellInstance)
    debug("Spell prepared by "..playerid.." -> "..spellInstance);
end

function OnPlayerSpellCast(playerid, spellInstance)
    debug("Spell cast by "..playerid.." -> "..spellInstance);
end

function updateHP(playerid, delta)
    if PLAYERS[playerid] ~= nil then
        PLAYERS[playerid].stats.hp = PLAYERS[playerid].stats.hp + delta;
        SetPlayerHealth(playerid, math.min(math.max(0, PLAYERS[playerid].stats.hp),GetPlayerMaxHealth(playerid)));
    end
    if NPCS[playerid] ~= nil then
        NPCS[playerid].stats.hp = NPCS[playerid].stats.hp + delta;
        SetPlayerHealth(playerid, math.min(math.max(0, NPCS[playerid].stats.hp),GetPlayerMaxHealth(playerid)));
    end
end

function setHP(playerid, amount)
    if PLAYERS[playerid] ~= nil then
        PLAYERS[playerid].stats.hp = amount;
    end
    if NPCS[playerid] ~= nil then
        NPCS[playerid].stats.hp = amount;
    end
    updateHP(playerid, 0);
end

function getHP(playerid)
    if PLAYERS[playerid] ~= nil then
        return PLAYERS[playerid].stats.hp;
    end
    if NPCS[playerid] ~= nil then
        return NPCS[playerid].stats.hp;
    end
    return 0;
end

function getProtections(playerid)
    if PLAYERS[playerid] ~= nil then
        return PLAYERS[playerid].stats.protections;
    end
    if NPCS[playerid] ~= nil then
        return NPCS[playerid].stats.protections;
    end
    return {blunt=0, edge=0, point=0, fire=0, water=0, earth=0, air=0};
end

function calculateDamage(damagesource, armorsource)
    local physicals = {"blunt", "edge", "point"};
    local physdmg = 0;
    local potential = 0;
    for _key, physical in pairs(physicals) do
        physdmg = physdmg + math.max(0, (damagesource[physical] - armorsource[physical]));
        potential = potential + damagesource[physical];
    end
    if (potential > 0) then
        physdmg = math.max(5, physdmg);
    end
    local magics = {"fire", "water", "earth", "air"};
    local magicdmg = 0;
    for _key, magic in pairs(magics) do
        if (armorsource[magic] < 0) then
            magicdmg = magicdmg - damagesource[magic];
        else
            magicdmg = magicdmg + math.max(0, (damagesource[magic] - armorsource[magic]));
        end
    end
    return physdmg + magicdmg;
end

function heal(playerid, params)
    local targetid = playerid;
    local targetname = GetPlayerName(playerid);
    local resultD, targetD = sscanf(params, "d");
    local resultS, targetS = sscanf(params, "s");

    if (resultS == 1) then
        targetname = capitalize(targetS);
        targetid = getPlayerIdByName(targetname);
    end
    if (resultD == 1) then
        targetid = targetD;
        targetname = GetPlayerName(targetid);
    end

    if (PLAYERS[targetid] == nil and NPCS[targetid] == nil) then
        sendERRMessage(playerid, "Ziel nicht online");
        return;
    end

    ressurect(targetid, GetPlayerMaxHealth(targetid));
    sendINFOMessage(playerid, "Du hast "..targetname.." geheilt");
    
    local targetchar = "NPC";
    if (PLAYERS[targetid] ~= nil) then
        targetchar = PLAYERS[targetid].character;
        if (targetid ~= playerid) then
            sendINFOMessage(targetid, "Du wurdest geheilt.");
        end
    end
    
    log("heal", GetPlayerName(playerid).." ("..PLAYERS[playerid].character..") heilt "..targetname.." ("..targetchar..")");
end

function revive(playerid, params)
    local targetid = playerid;
    local targetname = GetPlayerName(playerid);
    local resultD, targetD = sscanf(params, "d");
    local resultS, targetS = sscanf(params, "s");

    local targetid = playerid;
    if (resultS == 1) then
        targetname = capitalize(targetS);
        targetid = getPlayerIdByName(targetname);
    end
    if (resultD == 1) then
        targetid = targetD;
        targetname = GetPlayerName(targetid);
    end

    if (PLAYERS[targetid] == nil and NPCS[targetid] == nil) then
        sendERRMessage(playerid, "Ziel nicht online");
        return;
    end

    if IsDead(targetid) ~= 1 and getHP(targetid) > 0 then
        sendERRMessage(playerid, "Dein Ziel ist nicht tot.");
        return;
    end
    ressurect(targetid, 1);
    sendINFOMessage(playerid, "Du hast "..targetname.." belebt");

    local targetchar = "NPC";
    if (PLAYERS[targetid] ~= nil) then
        targetchar = PLAYERS[targetid].character;
        if (targetid ~= playerid) then
            sendINFOMessage(targetid, "Du wurdest belebt.");
        end
    end

    log("heal", GetPlayerName(playerid).." ("..PLAYERS[playerid].character..") belebt "..targetname.." ("..targetchar..")");
end

function ressurect(playerid, hp);
    setHP(playerid, hp);
    if (PLAYERS[playerid] ~= nil and IsDead(playerid)) then
        saveChar(playerid);
        SpawnPlayer(playerid, GetPlayerPos(playerid));
        loadChar(playerid);
        PlayAnimation(playerid, "T_JUMPB");
        unfreeze(playerid, "dead");
    end
end