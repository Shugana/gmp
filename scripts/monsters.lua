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
            turnspeed = 10
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
        mindist = nil;
        for playerid, playerdata in pairs(PLAYERS) do
            distance = GetDistancePlayers(npcid, playerid);
            if (GetPlayerWorld(npcid) == GetPlayerWorld(playerid)) and (distance < aggrorange) and (mindist == nil or distance < mindist) then
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
    debug("turning "..npcid.." to "..targetid.. "up to "..NPCS[npcid].turnspeed.."°");
    local npcangle = GetPlayerAngle(npcid);
    debug("npcangle: "..npcangle);
    local targetangle = GetAngleToPlayer(npcid, targetid);
    debug("targetangle: "..targetangle);

    local flip = false;
    local forwards = true;
    local direction = 1;
    local maxturn = math.max(npcangle, targetangle) - math.min(npcangle, targetangle);
    debug("maxturn: "..maxturn);

    if (npcangle > targetangle) then
        direction = direction * -1;
    end

    if (maxturn > 180) then
        direction = direction * -1;
    end
    local turnamount = math.min(maxturn, NPCS[npcid].turnspeed)*direction;
    debug("turnamount: "..turnamount);
    SetPlayerAngle(npcid, (npcangle + turnamount)%360);

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