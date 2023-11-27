WORLDITEMS = {};

function cheatItem(playerid, params)
    local result, recipientid, itemnameraw, amount = sscanf(params, "dsd");
    if (result ~= 1) then
        result, recipientid, itemnameraw = sscanf(params, "ds");
        amount = 1;
        if (result ~= 1) then
            sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemname> [<anzahl>]");
            return;
        end
    end
    if (amount < 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: Die Anzahl darf nicht negativ sein");
        return;
    end
    if (PLAYERS[recipientid] == nil or PLAYERS[recipientid].character == nil) then
        sendERRMessage(playerid, "Spieler mit id "..recipientid.." ist nicht verbunden.");
        return;
    end
    itemnameraw = capitalize(itemnameraw);
    local itemname = nil;
    local itemid = 0;
    local responses = DB_select("*", "items", "name = '"..itemnameraw.."'");
    for _key, response in pairs(responses) do
        itemname = response.name;
        itemid = tonumber(response.id);
    end
    if (itemname == nil) then
        responses = DB_select("*", "items", "name LIKE '"..itemnameraw.."%'");
        for _key, response in pairs(responses) do
            itemname = response.name;
            itemid = tonumber(response.id);
        end
    end
    if (itemname == nil) then
        sendERRMessage(playerid, "Item '"..itemnameraw.."' nicht in der DB vorhanden.");
        return;
    end

    sendINFOMessage(playerid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemname);
    if (recipientid ~= playerid) then
        sendINFOMessage(recipientid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemname);
    end
    log("cheat", GetPlayerName(playerid).."("..PLAYERS[playerid].character..") cheated "
        ..GetPlayerName(recipientid).."("..PLAYERS[recipientid].character..") "
        ..amount.."x "..itemname.."("..itemid..")");
    GiveItemById(recipientid, itemid, amount);
end

function OnPlayerTakeItem(playerid, itemid, iteminstance, amount, x, y, z, worldName)
    if (itemid < 0) then
        return;
    end
    DB_update("item_spawns", {spawned=0}, "id="..WORLDITEMS[itemid]);
    playerGetsItem(playerid, itemid, amount);
end

function playerGetsItem(playerid, iteminstance, amount)
    local charid = PLAYERS[playerid].character;
    local itemid = nil;
    local itemname = nil;
    local responses = DB_select("*", "items", "instance = '"..iteminstance.."'");
    for _key, response in pairs(responses) do
        itemid = tonumber(response.id);
        itemname = response.name;
    end
    if (itemid == nil) then
        sendERRMessage(playerid, "Item mit der iteminstance '"..iteminstance.."' ist nicht in der DB. Melde dies dem Team");
        return;
    end
    GiveItemById(playerid, itemid, amount);
end

function GiveItemById(playerid, itemid, amount)
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        sendERRMessage(playerid, "Du solltest ein Item bekommen, aber der Server denkt du bist nicht eingelogged. Melde dies mit Datum und Uhrzeit dem Team.")
        log("bugs", "GiveItemById - playerid: "..playerid..", itemid: "..itemid..", amount: "..amount);
        return
    end
    local oldamount = nil;
    local items = DB_select("*", "items", "id = "..itemid);
    for _key, item in pairs(items) do
        local inventories = DB_select("*", "character_inventory", "characterid = "..PLAYERS[playerid].character.." AND itemid = "..itemid);
        for _key, inventory in pairs(inventories) do
            oldamount = tonumber(inventory.amount);
        end
        if oldamount == nil then
            DB_insert("character_inventory", {characterid=PLAYERS[playerid].character, itemid=itemid, amount=amount});
        else
            DB_update("character_inventory", {amount=oldamount+amount}, "characterid = "..PLAYERS[playerid].character.." AND itemid = "..itemid);
        end
        GiveItem(playerid, item.instance, amount);
        sendINFOMessage(playerid, "Du bekommst "..amount.."x "..item.name);
        return;
    end
end

function RemoveItemById(playerid, itemid, amount)
    if PLAYERS[playerid] == nil or PLAYERS[playerid].character == nil then
        sendERRMessage(playerid, "Du solltest ein Item gelöscht bekommen, aber der Server denkt du bist nicht eingelogged. Melde dies mit Datum und Uhrzeit dem Team.")
        log("bugs", "RemoveItemById - playerid: "..playerid..", itemid: "..itemid..", amount: "..amount);
        return
    end
    local oldamount = nil;
    local items = DB_select("*", "items", "id = "..itemid);
    for _key, item in pairs(items) do
        local inventories = DB_select("*", "character_inventory", "characterid = "..PLAYERS[playerid].character.." AND itemid = "..itemid);
        for _key, inventory in pairs(inventories) do
            oldamount = tonumber(inventory.amount);
        end
        DB_update("character_inventory", {amount=oldamount-amount}, "characterid = "..PLAYERS[playerid].character.." AND itemid = "..itemid);
        RemoveItem(playerid, item.instance, amount);
        return;
    end
end

function loadInventory(playerid)
    local responses = DB_select("items.instance, character_inventory.amount",
        "items, character_inventory",
        "items.id = character_inventory.itemid AND character_inventory.amount > 0 AND character_inventory.characterid = "..PLAYERS[playerid].character);
    for _key, response in pairs(responses) do
        GiveItem(playerid, response.instance, tonumber(response.amount));
    end
end

function respawnTickItems()
    SPAWNTICKS.items = (SPAWNTICKS.items+1)%SPAWNTICKS.itemsmax;
    if (SPAWNTICKS.items == 1) then
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

function spawnItemsOnServerInit()
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