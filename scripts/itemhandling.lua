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

function cheatItemAll(playerid, params)
    local items = DB_select("*", "items", "1");
    for _key, item in pairs(items) do
        sendINFOMessage(playerid, GetPlayerName(playerid).." cheated "..GetPlayerName(playerid).." 1x "..item.name);
        log("cheat", GetPlayerName(playerid).."("..PLAYERS[playerid].character..") cheated "
        ..GetPlayerName(playerid).."("..PLAYERS[playerid].character..") 1x "..item.name.."("..item.id..")");
        GiveItemById(playerid, item.id, 1);
    end
end

function OnPlayerTakeItem(playerid, worlditemid, iteminstance, amount, _x, _y, _z, _worldName)
    if (worlditemid < 0) then
        if worlditemid == ITEM_UNSYNCHRONIZED then
            sendERRMessage(playerid, "Dieses Item war asynchron und wird zerstört.");
            RemoveItem(playerid, iteminstance, amount);
        end
        return;
    end
    RemoveItem(playerid, iteminstance, amount);
    if WORLDITEMS[worlditemid] == nil then
        sendERRMessage(playerid, "Dieses Item war asynchron und wird zerstört.");
        return;
    end
    DB_update("item_spawns", {spawned=0}, "id="..WORLDITEMS[worlditemid].spawnid);
    WORLDITEMS[worlditemid] = nil;
    playerGetsItem(playerid, iteminstance, amount);
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

function ItemRespawnLoop()
    local spawntimers = DB_select("*", "item_spawntimers", "1");
    for _key, spawntimer in pairs(spawntimers) do
        local timeelapsed = tonumber(spawntimer.timeelapsed)+1;
        local nextspawn = tonumber(spawntimer.nextspawn);
        if timeelapsed >= nextspawn then
            respawnTickItem(tonumber(spawntimer.itemid));
            timeelapsed = math.max(0, timeelapsed - nextspawn);
        end
        DB_update("item_spawntimers", {timeelapsed=timeelapsed}, "id="..tonumber(spawntimer.id));
    end
end

function respawnTickItem(itemid)
    local spaws = DB_select("item_spawns.*, items.name, items.instance", "items, item_spawns", "item_spawns.spawned = 0 AND items.id = item_spawns.itemid AND items.id = "..itemid);
    local unspawned = #spaws;
    if (unspawned < 1) then
        return;
    end
    local randomItem = math.random(unspawned);
    local spawn = spaws[randomItem];
    respawnItem(spawn.instance, tonumber(spawn.x), tonumber(spawn.y), tonumber(spawn.z), spawn.world, tonumber(spawn.id), itemid);
end

function respawnItem(iteminstance, x, y, z, world, spawnid, itemid)
    local worlditemid = CreateItem(iteminstance, 1, x, y, z, world);
    WORLDITEMS[worlditemid] = {spawnid=spawnid, itemid=itemid};
    DB_update("item_spawns", {spawned=1}, "id="..spawnid);
end

function spawnItemsOnServerInit()
    local items = DB_select("item_spawns.*, items.id AS itemid, items.name, items.instance", "items, item_spawns", "item_spawns.spawned = 1 AND items.id = item_spawns.itemid");
    for _key, item in pairs(items) do
        local worlditemid = CreateItem(item.instance, 1, item.x, item.y, item.z, item.world);
        WORLDITEMS[worlditemid] = {spawnid=tonumber(item.id), itemid=tonumber(items.itemid)};
    end
end

function createItemSpawn(playerid, params)
    local result, itemname = sscanf(params, "s");
    if (result ~= 1) then
        sendERRMessage(playerid, "Gib einen Itemnamen an");
        return;
    end
    itemname = capitalize(itemname);
    if not(DB_exists("*", "items", "name = '"..itemname.."'")) then
        sendERRMessage(playerid, "Item '"..itemname.."' ist nicht bekannt");
        return;
    end
    local x, y, z = GetPlayerPos(playerid);
    x = math.ceil(x);
    y = math.ceil(y);
    z = math.ceil(z);
    local world = GetPlayerWorld(playerid);
    local items = DB_select("*", "items", "name = '"..itemname.."'");
    for _key, item in pairs(items) do
        local itemid = tonumber(item.id);
        DB_insert("item_spawns", {itemid=itemid, x=x, y=y, z=z, world=world});
        local spawns = DB_select("*", "item_spawns", "itemid="..itemid.." AND x="..x.." AND y="..y.." AND z="..z.." AND world='"..world.."'");
        local spawnid = -1;
        for _key, spawn in pairs(spawns) do
            spawnid = tonumber(spawn.id);
        end
        respawnItem(item.instance, x, y, z, world, spawnid, itemid);
        sendINFOMessage(playerid, "Spawn gesetzt für "..item.name.."("..item.id..") - Spawn-ID: "..spawnid);
        if not(DB_exists("*", "item_spawntimers", "itemid = "..tonumber(item.id))) then
            sendERRMessage(playerid, "Item '"..itemname.."' hat noch keine Spawnzeit in der DB. Setze 60 Sekunden als Standardwert. Dies kann in der DB geändert werden");
            DB_insert("item_spawntimers", {itemid=tonumber(item.id)});
        end
        
    end
end

function showItemSpawns(playerid, params)
    sendINFOMessage(playerid, "In deiner Nähe sind die folgenden Spawns:");
    local x, y, z = GetPlayerPos(playerid);
    local itemspawns = DB_select("item_spawns.*, items.id as itemid, items.name as name", "items, item_spawns", "item_spawns.itemid = items.id");
    for _key, itemspawn in pairs(itemspawns) do
        local distance = GetDistance3D (x, y, z, tonumber(itemspawn.x), tonumber(itemspawn.y), tonumber(itemspawn.z));
        if distance < 2500 then
            sendINFOMessage(playerid, itemspawn.name.." ("..tonumber(itemspawn.itemid)..") - Spawn-ID: "..tonumber(itemspawn.id));
        end
    end
end

function deleteItemSpawn(playerid, params)
    local result, spawnid = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Gib eine Spawn-ID an");
        return;
    end
    if not(DB_exists("item_spawns.*, items.id as itemid, items.name as name", "items, item_spawns", "item_spawns.id = "..spawnid)) then
        sendERRMessage("Item mit der Spawn-ID "..spawnid.." existiert nicht");
        return;
    end
    local itemspawns = DB_select("item_spawns.*, items.id as itemid, items.name as name", "items, item_spawns", "item_spawns.id = "..spawnid);
    for _key, itemspawn in pairs(itemspawns) do
        DB_delete("item_spawns", "id="..tonumber(itemspawn.id));
        if (tonumber(itemspawn.spawned) == 1) then
            for worlditemid, worlditem in pairs(WORLDITEMS) do
                if (worlditem.spawnid == itemspawn.id) then
                    DestroyItem(worlditemid);
                    WORLDITEMS[worlditemid] = nil;
                end
            end
        end
        sendINFOMessage(playerid, itemspawn.name.." ("..tonumber(itemspawn.itemid)..") - Spawn-ID: "..tonumber(itemspawn.id).." - wurde gelöscht.");
        return;
    end
end

function OnPlayerUseItem(playerid, itemInstance, amount, hand)
    debug("Someone used an item playerid="..playerid..", iteminstance="..itemInstance..", amount="..amount..", hand="..hand);
    if (itemInstance == "ITPO_HEALTH_01") then
        drinkHealPot(playerid, 25, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_01_3DS.TGA", 1200);
    end
    if (itemInstance == "ITPO_HEALTH_02") then
        drinkHealPot(playerid, 50, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_02_3DS.TGA", 600);
    end
    if (itemInstance == "ITPO_HEALTH_03") then
        drinkHealPot(playerid, 100, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_ITPO_HEALTH_03_3DS.TGA", 300);
    end
end