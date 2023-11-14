NPCS = {};
NPC_ID = 500;
NPCSTATES = {
    idle = 0,
    turn = 1,
    warn = 2,
    follow = 3,
    attack = 4
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
            warnings = 0,
            target = nil,
            turnspeed = response.turnspeed,
            turning = 0,
            aggrorange = response.aggrorange
        };
    end
end

function turnNPCloop()
    local targetPlayer;
    local mindist;
    local distance;
    local aggrorange = 3000;
    for npcid, npcdata in pairs(NPCS) do
        targetPlayer = nil;
        mindist = NPCS[npcid].aggrorange;
        for playerid, playerdata in pairs(PLAYERS) do
            distance = GetDistancePlayers(npcid, playerid);
            if (GetPlayerWorld(npcid) == GetPlayerWorld(playerid)) and (distance < aggrorange) and (distance < mindist) then
                mindist = distance;
                targetPlayer = playerid;
            end
        end
        if (targetPlayer ~= nil) then
            if (turnNPC(npcid, targetPlayer)) then
                warn(npcid); 
            end
        end
    end
end

function turnNPC(npcid, targetid)
    NPCS[npcid].turning = (NPCS[npcid.turning]+1)%NPCS[npcid].turnspeed;
    if NPCS[npcid].turning ~= 0 then
        return false;
    end
    debug("turning "..npcid.." to "..targetid.. "up to "..NPCS[npcid].turnspeed.."°");
    local npcangle = GetPlayerAngle(npcid);
    local targetangle = GetAngleToPlayer(npcid, targetid);
    local turnamount = 0;

    local direction = 1;
    local maxturn = math.max(npcangle, targetangle) - math.min(npcangle, targetangle);

    if (npcangle > targetangle) then
        direction = direction * -1;
    end

    if (maxturn > 180) then
        direction = direction * -1;
    end

    if (maxturn > 0) then
        turnamount = math.min(maxturn, 1)*direction;
        SetPlayerAngle(npcid, (npcangle + direction)%360);
    end
    if (turnamount < NPCS[npcid].turnspeed) then
        return true;
    else
        return false;
    end
end

function warn(npcid)
    debug(npcid.." warning");
    PlayAnimation(npcid, "T_WARN");
    NPCS[npcid].warnings = NPCS[npcid].warnings + 1;
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