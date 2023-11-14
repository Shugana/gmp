NPCS = {};
NPC_ID = 500;

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
        local npc = CreateNPC(response.name);
        if (npc == -1) then
            sendERRMessage(playerid, "NPC erstellen fehlgeschlagen");
            return;
        end
        
        SetPlayerInstance(npc, response.instance);
        
        SetPlayerLevel(npc, 0);
        SetPlayerStrength(npc, tonumber(response.str));
        SetPlayerDexterity(npc, tonumber(response.dex));
        SetPlayerMaxHealth(npc, tonumber(response.hp));
        SetPlayerHealth(npc, tonumber(response.hp));
        SetPlayerMaxMana(npc, tonumber(response.mana));
        SetPlayerMana(npc, tonumber(response.mana));

        SetPlayerWorld(npc, GetPlayerWorld(playerid));
        SetPlayerPos(npc, GetPlayerPos(playerid));
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