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

function spawnMonster(playerid, params)
    local result, tier = sscanf(params, "s");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /spawn <Tiername>");
        return;
    end
    tier = capitalize(tier);
    if not(DB_exists("*", "monstertypes", "instance = '"..tier.."'")) then
        sendERRMessage(playerid, "Tier '"..tier.."' nicht in der Datenbank");
        return;
    end
    local responses = DB_select("*", "monstertypes", "instance = '"..tier.."'");
    for _key, response in pairs(responses) do
        local npcid = CreateNPC(response.name);
        if (npcid == -1) then
            sendERRMessage(playerid, "NPC erstellen fehlgeschlagen");
            return;
        end
        
        SetPlayerInstance(npcid, response.instance);
        
        SetPlayerLevel(npcid, 0);
        SetPlayerStrength(npcid, tonumber(response.str));
        SetPlayerDexterity(npcid, tonumber(response.dex));
        SetPlayerMaxHealth(npcid, tonumber(response.hp));
        SetPlayerHealth(npcid, tonumber(response.hp));
        SetPlayerMaxMana(npcid, tonumber(response.mana));
        SetPlayerMana(npcid, tonumber(response.mana));

        SetPlayerWorld(npcid, GetPlayerWorld(playerid));
        SetPlayerPos(npcid, GetPlayerPos(playerid));

        NPCS[npcid] = {
            state = NPCSTATES.idle.id,
            warnings = 0,
            turnspeed = tonumber(response.turnspeed),
            aggrorange = tonumber(response.aggrorange),
            runrange = tonumber(response.runrange),
            attackrange = tonumber(response.attackrange),
            warntime = tonumber(response.warntime)
        };
    end
end

function NPCloop()
    local distance;
    for npcid, npc in pairs(NPCS) do
        _G[NPCSTATES[npc.state].func](npcid);
    end
end

function monsterAni(npcid, ani)
    if (NPCS[npcid].lastani ~= ani) then
        debug("Monsterani ("..npcid.."): "..NPCS[npcid].lastani.. " --> "..ani);
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
        monsterAni(npcid, "T_WARN");
        monsterTurn(npcid, targetPlayer);
    else
        NPCS[npcid].warnings = math.max(0, NPCS[npcid].warnings - 1);
        if NPCS[npcid].warnings > 0 then
            monsterAni(npcid, "S_STAND")
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
    local distance = GetDistancePlayers(npcid, NPCS[npcid].target);
    if distance > NPCS[npcid].attackrange then
        NPCS[npcid].state = NPCSTATES.approach.id;
        NPCS[npcid].target = nil;
        return;
    end
    local random = math.random(1, 20);
    if (random == 1) then
        monsterAni(npcid, "T_FISTRUNSTRAFEL");
    elseif (random == 2) then
        monsterAni(npcid, "T_FISTRUNSTRAFER");
    elseif (random == 3 or random == 4) then
        monsterAni(npcid, "T_FISTWALKSTRAFEL");
    elseif (random == 5 or random == 6) then
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
    monsterTurn(npcid, playerid);
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

function moveMonster(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /move <id>");
        return;
    end
    PlayAnimation(tierid, "S_FISTRUNL");
    sendINFOMessage(playerid, "Tier "..tierid.." sollte sich bewegen!")
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
    NPCS[tierid].follow = playerid;
end

function unfollow(playerid, params)
    local result, tierid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /unfollow <id>");
        return;
    end
    NPCS[tierid].follow = nil;
end

function followPlayer(npcid)
    local distance = {
        current = nil,
        slow = 1250,
        arrived = 250
    };
    local playerid = NPCS[npcid].follow;
    
    SetPlayerAngle(npcid, GetAngleToPlayer(npcid, playerid));
    
    distance.current = GetDistancePlayers(npcid, playerid);
    if distance.current > distance.slow then
        if (GetPlayerAnimationName(npcid)  ~= "S_FISTRUNL") then
            PlayAnimation(npcid, "S_FISTRUNL");
        end
    elseif distance.current > distance.arrived then
        if (GetPlayerAnimationName(npcid)  ~= "S_FISTWALKL") then
            PlayAnimation(npcid, "S_FISTWALKL");
        end
    else
        if (GetPlayerAnimationName(npcid)  ~= "S_SLEEP") then
            PlayAnimation(npcid, "S_SLEEP");
        end
    end
end

function showAni(playerid, params)
    if NPCS[playerid] == nil then
        NPCS[playerid] = {
            anitoggle = true;
            debug("ani observe on");
        };
    else
        NPCS[playerid] = nil;
        debug("ani observe off");
    end
end

function printAni(playerid, params)
    local ani = GetPlayerAnimationName(playerid);
    if ani ~= NPCS[playerid].lastani then
        NPCS[playerid].lastani = ani;
        debug("ani changed to: "..ani or "-");
    end
end