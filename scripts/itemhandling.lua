WORLDITEMS = {};

function giveitem(playerid, params)
    local result, recipientid, itemid, amount = sscanf(params, "dsd");
    if (result ~= 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemid> <anzahl>");
        return;
    end
    if (amount < 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemid> <anzahl>");
        return;
    end
    if not(IsPlayerConnected(recipientid)) then
        sendERRMessage(playerid, "Spieler mit id "..recipientid.." ist nicht verbunden.");
        return;
    end
    sendINFOMessage(playerid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemid);
    if (recipientid ~= playerid) then
        sendINFOMessage(recipientid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemid);
    end
    GiveItem(recipientid, itemid, amount);
end

function OnPlayerTakeItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
    if (itemid < 0) then
        sendERRMessage(playerid, "itemid "..itemid.." below 0");
        return;
    end
    DB_update("item_respawns", {respawn=0}, "id="..WORLDITEMS[itemid]);
end

function respawnTick()
    SPAWNTICKS = SPAWNTICKS+1%10;
    if (SPAWNTICKS == 1) then
        local responses = DB_select(
            "items.instance AS instance, item_spawns.id as id, item_spawns.x AS x, item_spawns.y AS y, item_spawns.z AS z, item_spawns.world AS world",
            "items, item_spawns",
            "items.id = item_spawns.itemid AND item_spawns.spawned=0"
        );
        for _key, response in pairs(responses) do
            local itemid = CreateItem(response.instance, 1, response.x, response.y, response.z, response.world);
            WORLDITEMS[itemid] = response.id;
            DB_update("item_spawns", {respawn=1}, "id="..response.id);
        end
    end
end

function spawnOnServerInit()
    local responses = DB_select(
        "items.instance AS instance, item_spawns.id as id, item_spawns.x AS x, item_spawns.y AS y, item_spawns.z AS z, item_spawns.world AS world",
        "items, item_spawns",
        "items.id = item_spawns.itemid AND item_spawns.spawned=1"
    );
    for _key, response in pairs(responses) do
        local itemid = CreateItem(response.instance, 1, response.x, response.y, response.z, response.world);
        WORLDITEMS[itemid] = response.id;
    end
end