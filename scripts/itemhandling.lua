WORLDITEMS = {};

function cheatItem(playerid, params)
    local result, recipientid, itemid, amount = sscanf(params, "dsd");
    if (result ~= 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemid> <anzahl>");
        return;
    end
    if (amount < 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: Die Anzahl darf nicht negativ sein");
        return;
    end
    if (PLAYERS[recipientid] == nil or PLAYERS[recipientid].character == nil) then
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
    DB_update("item_spawns", {spawned=0}, "id="..WORLDITEMS[itemid]);
    playerGetsItem(playerid, iteminstance, amount);
end

function playerGetsItem(playerid, iteminstance, amount)
    local charid = PLAYERS[playerid].character;
    local itemid = nil;
    local itemname = nil;
    local responses = DB_select("*", "items", "instance = "..iteminstance);
    for _key, response in pairs(responses) do
        itemid = tonumber(response.id);
        itemname = response.name;
    end
    if (itemid == nil) then
        sendERRMessage(playerid, "Item mit der iteminstance '"..iteminstance.."' ist nicht in der DB. Melde dies dem Team");
        return;
    end
    if not(DB_exists("*", "character_inventory", "characterid = "..charid.." AND itemid = "..itemid) then
        DB_insert("character_inventory", {characterid=charid, itemid=itemid, amount=0});
    end
    DB_update("character_inventory", {amount="amount"+amount}, "characterid = "..charid.." AND itemid = "..itemid);
    sendINFOMessage(playerid, "Du bekommst "..amount.."x "..itemname);
end

function loadInventory(playerid)
    local responses = DB_select("items.iteminstance, character_inventory.amount",
        "items, character_inventory",
        "items.id = character_inventory.itemid AND character_inventory.charid = "..PLAYERS[playerid].character);
    for _key, response in pairs(responses) do
        GiveItem(playerid, response.instance, tonumber(response.amount));
    end
end

function respawnTick()
    SPAWNTICKS = (SPAWNTICKS+1)%25;
    SendMessageToAll(255,255,255,"SPAWNTICKS: "..SPAWNTICKS);
    if (SPAWNTICKS == 24) then
        local responses = DB_select(
            "items.instance AS instance, item_spawns.id as id, item_spawns.x AS x, item_spawns.y AS y, item_spawns.z AS z, item_spawns.world AS world",
            "items, item_spawns",
            "items.id = item_spawns.itemid AND item_spawns.spawned=0"
        );
        for _key, response in pairs(responses) do
            local itemid = CreateItem(response.instance, 1, response.x, response.y, response.z, response.world);
            WORLDITEMS[itemid] = response.id;
            DB_update("item_spawns", {spawned=1}, "id="..response.id);
            SendMessageToAll(255,255,255,"Spawned: "..response.instance);
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