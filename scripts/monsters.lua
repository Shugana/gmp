NPCS = {};
NPC_ID = 500;
NPCSTATES = {
    idle = {id=1, func="monsterWarn"},
    [1] = {id=1, func="monsterWarn"},
    approach = {id=2, func="monsterApproach"},
    [2] = {id=2, func="monsterApproach"},
    attack = {id=3, func="monsterAttack"},
    [3] = {id=3, func="monsterAttack"},
    follow = {id=4, func="monsterFollow"},
    [4] = {id=4, func="monsterFollow"}
}

function spawnMonsterOnPlayer(playerid, params)
    local result, tier = sscanf(params, "s");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /spawn <Tiername>");
        return;
    end
    tier = capitalize(tier);
    if not(DB_exists("*", "monsters", "name = '"..tier.."'")) then
        sendERRMessage(playerid, "Tier '"..tier.."' nicht in der Datenbank");
        return;
    end
    local x, y, z = GetPlayerPos(playerid);
    local angle = GetPlayerAngle(playerid);
    local x_add, z_add = coords_forward(angle);
    spawnMonster(tier, GetPlayerWorld(playerid), x-x_add*250, y+50, z+z_add*250);
end

function spawnMonster(instance, world, x, y, z)
    local monsters = DB_select("*", "monsters", "name = '"..instance.."'");
    for _key, monster in pairs(monsters) do
        local npcid = CreateNPC(monster.name);
        if (npcid == -1) then
            return;
        end
        
        SetPlayerInstance(npcid, monster.instance);
        
        SetPlayerLevel(npcid, 0);
        SetPlayerStrength(npcid, tonumber(monster.str));
        SetPlayerDexterity(npcid, tonumber(monster.dex));
        SetPlayerMaxHealth(npcid, tonumber(monster.hp));
        SetPlayerHealth(npcid, tonumber(monster.hp));
        SetPlayerMaxMana(npcid, tonumber(monster.mana));
        SetPlayerMana(npcid, tonumber(monster.mana));

        SetPlayerWorld(npcid, world);
        SetPlayerPos(npcid, x, y, z);

        NPCS[npcid] = {
            state = NPCSTATES.idle.id,
            warnings = 0,
            turnspeed = tonumber(monster.turnspeed),
            aggrorange = tonumber(monster.aggrorange),
            runrange = tonumber(monster.runrange),
            attackrange = tonumber(monster.attackrange),
            warntime = tonumber(monster.warntime),
            lastani = "NULL",
            delay = 0,
            loot = {}
        };
        local loots = DB_select("*", "monster_loot", "monsterid = "..monster.id);
        for _key, loot in pairs(loots) do
            local rnd = math.random(99);
            if (tonumber(loot.chance) > rnd) then
                table.insert(NPCS[npcid].loot, {
                    itemid = tonumber(loot.itemid),
                    trophy = tonumber(loot.trophy), 
                    amount = tonumber(loot.amount)
                });
            end
        end
        return npcid;
    end
    return -1;
end

function NPCloop()
    local distance;
    for npcid, npc in pairs(NPCS) do
        _G[NPCSTATES[npc.state].func](npcid);
    end
end

function monsterAni(npcid, ani)
    if (NPCS[npcid].lastani ~= ani) then
        --debug("Monsterani ("..npcid.."): "..NPCS[npcid].lastani.." --> "..ani);
        PlayAnimation(npcid, ani);
        NPCS[npcid].lastani = ani;
    end
end

function monsterWarn(npcid)
    local targetPlayer = monsterGetClosestAggro(npcid);
    if (targetPlayer ~= nil) then
        NPCS[npcid].warnings = NPCS[npcid].warnings + 1;
        if (NPCS[npcid].warnings >= NPCS[npcid].warntime) then
            NPCS[npcid].state = NPCSTATES.approach.id;
        end
        PlayAnimation(npcid, "T_WARN");
        monsterAni(npcid, "T_WARN");
        monsterTurn(npcid, targetPlayer);
    else
        NPCS[npcid].warnings = math.max(0, NPCS[npcid].warnings - 1);
        if NPCS[npcid].warnings > 0 then
            monsterAni(npcid, "S_FISTRUN");
        else
            monsterAni(npcid, "S_SLEEP");
        end
    end
end

function monsterGetClosestAggro(npcid)
    local distance;
    local mindist = NPCS[npcid].aggrorange;
    local targetPlayer;
    for playerid, _playerdata in pairs(PLAYERS) do
        distance = GetDistancePlayers(npcid, playerid);
        if (GetPlayerHealth(playerid) > 0) and (GetPlayerWorld(npcid) == GetPlayerWorld(playerid)) and (distance < mindist) then
            mindist = distance;
            targetPlayer = playerid;
        end
    end
    return targetPlayer;
end

function monsterTurn(npcid, targetid)
    if (GetPlayerHealth(npcid) < 1) then
        return;
    end
        
    local npcangle = GetPlayerAngle(npcid);
    local targetangle = GetAngleToPlayer(npcid, targetid);

    local direction = 1;
    local maxturn = math.max(npcangle, targetangle) - math.min(npcangle, targetangle);

    if (npcangle > targetangle) then
        direction = direction * -1;
    end
    if (maxturn > 180) then
        direction = direction * -1;
    end

    local turnamount = direction * math.min(NPCS[npcid].turnspeed, maxturn);

    if (maxturn > 0 and (turnamount*direction) >= (NPCS[npcid].turnspeed/2)) then
        SetPlayerAngle(npcid, (npcangle + turnamount)%360);
    end
end

function monsterApproach(npcid)
    local playerid = monsterGetClosestAggro(npcid);
    if playerid == nil then
        NPCS[npcid].state = NPCSTATES.idle.id;
        return;
    end
    monsterTurn(npcid, playerid);
    
    local distance = GetDistancePlayers(npcid, playerid);
    if distance < NPCS[npcid].attackrange then
        NPCS[npcid].state = NPCSTATES.attack.id;
        NPCS[npcid].target = playerid;
    elseif distance < NPCS[npcid].runrange then
        monsterAni(npcid, "S_FISTRUNL");
    else
        monsterAni(npcid, "S_FISTWALKL");
    end
end

function monsterAttack(npcid)
    monsterTurn(npcid, NPCS[npcid].target);
    NPCS[npcid].delay = (NPCS[npcid].delay+1)%math.ceil(NPCS[npcid].warntime/2);
    if (NPCS[npcid].delay ~= 1) then
        return;
    end
    local distance = GetDistancePlayers(npcid, NPCS[npcid].target);
    if distance > NPCS[npcid].attackrange then
        NPCS[npcid].state = NPCSTATES.approach.id;
        NPCS[npcid].target = nil;
        return;
    end
    local random = math.random(1, 30);
    if (random < 2) then
        monsterAni(npcid, "T_FISTRUNSTRAFEL");
    elseif (random < 3) then
        monsterAni(npcid, "T_FISTRUNSTRAFER");
    elseif (random < 5) then
        monsterAni(npcid, "T_FISTWALKSTRAFEL");
    elseif (random < 7) then
        monsterAni(npcid, "T_FISTWALKSTRAFER");
    elseif (random < 10) then
        monsterAni(npcid, "T_FISTATTACKMOVE");
    elseif (random < 11) then
        monsterAni(npcid, "T_FISTPARADEJUMPB");
    else

        monsterAni(npcid, "S_FISTATTACK");
    end
end

function monsterFollow(npcid)
    monsterTurn(npcid, NPCS[npcid].followid);
    
    local distance = GetDistancePlayers(npcid, NPCS[npcid].followid);
    if distance < NPCS[npcid].attackrange then
        monsterAni(npcid, "S_SLEEP");
    elseif distance < NPCS[npcid].runrange then
        monsterAni(npcid, "S_FISTWALKL");
    else
        monsterAni(npcid, "S_FISTRUNL");
    end
end

function testhit(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /testhit <id>");
        return;
    end
    if HitPlayer(tierid, playerid) == 1 then
        SendPlayerMessage(playerid, 0, 255, 0, "Testhit erfolgreich.")
    else
        SendPlayerMessage(playerid, 255, 0, 0, "Testhit fehlgeschlagenerfolgreich.")
    end
end

function lookAtMe(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /look <id>");
        return;
    end
    SetPlayerAngle(tierid, GetAngleToPlayer(tierid, playerid));
    sendINFOMessage(playerid, "Tier "..tierid.."schaut dich an!")
end

function playAni(playerid, params)
    local result, targetid, animation = sscanf(params, "ds");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /ani <id> <ani>");
        return;
    end
    PlayAnimation(targetid, animation);
end

function follow(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /follow <id>");
        return;
    end
    NPCS[tierid].state = NPCSTATES.follow.id;
    NPCS[tierid].followid = playerid;
end

function unfollow(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /unfollow <id>");
        return;
    end
    NPCS[tierid].state = NPCSTATES.idle.id;
    NPCS[tierid].followid = nil;
end