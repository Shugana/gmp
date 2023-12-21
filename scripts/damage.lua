function OnPlayerHit(playerid, attackerid)
    debug(attackerid.." attacked "..playerid);
    local weaponmode = GetPlayerWeaponMode(attackerid);
    debug("Weaponmode of attacker: "..weaponmode);

    if (weaponmode == WEAPON_NONE) then
        debug ("Nicht im Kampf...?!");
    end
    if (weaponmode == WEAPON_FIST) then
        debug ("Faustkampf...?!");
    end
    if (weaponmode == WEAPON_1H) then
        debug ("Einhand...?!");
    end
    if (weaponmode == WEAPON_2H) then
        debug ("Zweihand...?!");
    end
    if (weaponmode == WEAPON_BOW) then
        debug ("Bogen...?!");
    end
    if (weaponmode == WEAPON_CBOW) then
        debug ("Armbrust...?!");
    end
    if (weaponmode == WEAPON_MAGIC) then
        debug ("Magie...?!");
    end
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

    SetPlayerHealth(targetid, GetPlayerMaxHealth(targetid));
    
    if (IsDead(targetid) == 1 and PLAYERS[targetid] ~= nil) then
        saveChar(targetid);
        loadChar(targetid);
    end
    SetPlayerHealth(targetid, GetPlayerMaxHealth(targetid));

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

    if (IsDead(targetid) ~= 1) then
        sendERRMessage(playerid, "Dein Ziel ist nicht tot.");
        return;
    end

    SetPlayerHealth(targetid, 1);

    if (PLAYERS[targetid] ~= nil) then
        saveChar(targetid);
        loadChar(targetid);
    end
    SetPlayerHealth(targetid, 1);

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