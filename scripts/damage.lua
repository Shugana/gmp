function OnPlayerHit(playerid, attackerid)
    local weaponmode = GetPlayerWeaponMode(attackerid);

    local damage = 0;

    if (weaponmode == WEAPON_NONE or weaponmode == WEAPON_FIST) then
        damage = calculateDamage({blunt=5, edge=0, point=0, fire=0, water=0, earth=0, air=0}, getProtections(playerid));
    end
    if (weaponmode == WEAPON_1H or weaponmode == WEAPON_2H) then
        damage = calculateDamage(getWeapon(attackerid, "melee"), getProtections(playerid));
    end
    if (weaponmode == WEAPON_BOW or weaponmode == WEAPON_CBOW) then
        damage = calculateDamage(getWeapon(attackerid, "ranged"), getProtections(playerid));
    end
    if (weaponmode == WEAPON_MAGIC) then
        damage = calculateDamage(getSpelldamage(attackerid), getProtections(playerid));
    end
    debug ("Schaden: "..damage);
    updateHP(playerid, -damage);
end

function OnPlayerSpellSetup(playerid, spellInstance)
    if (spellInstance ~= "NULL") then
        PLAYERS[playerid].spell = spellInstance;
    end
end

function getSpelldamage(playerid)
    local unknownspelldmg = {blunt=0, edge=0, point=0, fire=5, water=5, earth=5, air=5};
    if (PLAYERS[playerid].spell == nil) then
        debug ("Zauber: Unbekannter Zauber");
        return unknownspelldmg;
    end
    local spells = DB_select("spells.*", "spells, items", "items.instance = '"..PLAYERS[playerid].spell.."' AND (spells.runeitemid = items.id OR spells.scrollitemid = items.id)");
    for _key, spell in pairs(spells) do
        debug ("Zauber: "..spell.name);
        return {
            blunt = 0,
            edge = 0,
            point = 0,
            fire = tonumber(spell.fire) * PLAYERS[playerid].stats.maxmana * tonumber(spell.manascaling),
            water = tonumber(spell.water) * PLAYERS[playerid].stats.maxmana * tonumber(spell.manascaling),
            earth = tonumber(spell.earth) * PLAYERS[playerid].stats.maxmana * tonumber(spell.manascaling),
            air = tonumber(spell.air) * PLAYERS[playerid].stats.maxmana * tonumber(spell.manascaling)
        };
    end
    debug ("Zauber: Unbekannt ("..PLAYERS[playerid].spell..")");
    return unknownspelldmg;
end

--function OnPlayerSpellCast(playerid, spellInstance)
--    non damage spells should do something here
--    debug("Spell cast by "..playerid.." -> "..spellInstance);
--end

function HPLoop()
    for playerid, _value in pairs(PLAYERS) do
        if (GetPlayerHealth(playerid) ~= PLAYERS[playerid].stats.hp) then
            SetPlayerHealth(playerid, PLAYERS[playerid].stats.hp);
        end
    end
    for npcid, _value in pairs(NPCS) do
        if (GetPlayerHealth(npcid) ~= NPCS[npcid].stats.hp) then
            SetPlayerHealth(npcid, NPCS[npcid].stats.hp);
        end
    end
end

function updateHP(playerid, delta)
    if PLAYERS[playerid] ~= nil and PLAYERS[playerid].stats ~= nil and PLAYERS[playerid].stats.hp ~= nil then
        local newhp = math.min(math.max(0, PLAYERS[playerid].stats.hp+delta),GetPlayerMaxHealth(playerid));
        PLAYERS[playerid].stats.hp = newhp;
    end
    if NPCS[playerid] ~= nil and NPCS[playerid].stats ~= nil and NPCS[playerid].stats.hp ~= nil then
        local newhp = math.min(math.max(0, NPCS[playerid].stats.hp+delta),GetPlayerMaxHealth(playerid));
        NPCS[playerid].stats.hp = newhp;
        if newhp < 1 then
            monsterAni(playerid, "T_DEAD");
        end
    end
    updateFocussingMe(playerid);
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

function setMaxHP(playerid, amount)
    if PLAYERS[playerid] ~= nil then
        PLAYERS[playerid].stats.maxhp = amount;
        PLAYERS[playerid].stats.hp = math.min(PLAYERS[playerid].stats.hp, PLAYERS[playerid].stats.maxhp);
    end
    if NPCS[playerid] ~= nil then
        NPCS[playerid].stats.maxhp = amount;
        NPCS[playerid].stats.hp = math.min(NPCS[playerid].stats.hp, NPCS[playerid].stats.maxhp);
    end
    SetPlayerMaxHealth(playerid, amount);
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

function getMaxHP(playerid)
    if PLAYERS[playerid] ~= nil then
        return PLAYERS[playerid].stats.maxhp;
    end
    if NPCS[playerid] ~= nil then
        return NPCS[playerid].stats.maxhp;
    end
    return 1;
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

function getWeapon(playerid, slot)
    local weapons = getEquippedWeapons(playerid);
    if weapons[slot] == nil then
        return {blunt=0, edge=0, point=0, fire=0, water=0, earth=0, air=0}
    end
    return weapons[slot];
end

function getEquippedWeapons(playerid)
    local weapons = {
        melee = nil,
        ranged = nil
    };

    local meleeinstance = GetEquippedMeleeWeapon(playerid);
    if (meleeinstance ~= "NULL") then
        local meleeweapons = DB_select("weapons.*", "weapons, items", "items.id = weapons.itemid AND items.instance = '"..meleeinstance.."'");
        for _key, meleeweapon in pairs(meleeweapons) do
            weapons.melee = {
                weapontype = tonumber(meleeweapon.weapontype),
                blunt = tonumber(meleeweapon.blunt),
                edge = tonumber(meleeweapon.edge),
                point = tonumber(meleeweapon.point),
                fire = tonumber(meleeweapon.fire),
                water = tonumber(meleeweapon.water),
                earth = tonumber(meleeweapon.earth),
                air = tonumber(meleeweapon.air)
            };
        end
    end

    local rangedinstance = GetEquippedRangedWeapon(playerid);
    if (rangedinstance ~= "NULL") then
        local rangedweapons = DB_select("weapons.*", "weapons, items", "items.id = weapons.itemid AND items.instance = '"..rangedinstance.."'");
        for _key, rangedweapon in pairs(rangedweapons) do
            weapons.ranged = {
                weapontype = tonumber(rangedweapon.weapontype),
                blunt = tonumber(rangedweapon.blunt),
                edge = tonumber(rangedweapon.edge),
                point = tonumber(rangedweapon.point),
                fire = tonumber(rangedweapon.fire),
                water = tonumber(rangedweapon.water),
                earth = tonumber(rangedweapon.earth),
                air = tonumber(rangedweapon.air)
            };
        end
    end

    return weapons;
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